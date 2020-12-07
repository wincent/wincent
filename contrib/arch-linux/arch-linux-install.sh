#!/bin/bash

# loadkeys colemak -- (ie. "iyasefjr cyifmae" typing colemak-style on qwerty)
# iwctl device list
# iwctl station wlan0 scan
# iwctl station wlan0 get-networks
# iwctl station wlan0 connect $SSID
# curl -O https://wincent.com/link/arch-linux-install.sh
# bash arch-linux-install.sh

set -e

function log {
  local LINE="[arch-linux-install] $*"
  echo "$LINE"
  echo "${LINE//?/-}"
}

function ask {
  read -p "$1> "
  eval "export $2=\$REPLY"
}

log "Setup questions:"
ask 'User passphrase' __PASSPHRASE__
ask 'Wireless SSID' __SSID__
ask 'Wireless passphrase' __WIFI_PASSPHRASE__

log "Checking network reachability"
ping -c 3 google.com

log "Setting up NTP"
timedatectl set-ntp true

log "Refreshing packages"
pacman -Syy

log "Partitioning disk"
cat << HERE | sfdisk /dev/nvme0n1
label: gpt
device: /dev/nvme0n1

/dev/nvme0n1p1: size=500MiB, type=uefi
/dev/nvme0n1p2: size=50GiB, type=linux
/dev/nvme0n1p3: type=linux
HERE

log "Formatting partitions"
mkfs.fat -F32 /dev/nvme0n1p1 # /boot/EFI
mkfs.ext4 /dev/nvme0n1p2 # /
mkfs.ext4 -O encrypt -b 4096 /dev/nvme0n1p3 # /home

log "Mounting /dev/nvme0n1p2 at /"
mount /dev/nvme0n1p2 /mnt

log "Mounting /dev/nvme0n1p3 at /home"
mkdir /mnt/home
mount /dev/nvme0n1p3 /mnt/home

log "Creating /etc/fstab"
mkdir /mnt/etc
genfstab -U -p /mnt >> /mnt/etc/fstab

log "Installing base packages"
pacstrap /mnt base base-devel

cat << HERE > /mnt/arch-install-chroot.sh
set -e

function log {
  local LINE="[arch-linux-install] \$*"
  echo "\$LINE"
  echo "\${LINE//?/-}"
}

log "Setting up database for 'pacman -F filename' searching"
pacman -Fy

log "Installing kernel and other packages"
pacman -S --noconfirm linux linux-lts linux-headers linux-lts-headers

log "Installing other packages you want"
pacman -S --noconfirm man-db

log "Preparing ramdisks for kernel boot"
# Note: this might be redundant; pacman already did it?
mkinitcpio -p linux
mkinitcpio -p linux-lts

log "Setting up locale"
sed -i \
  -e 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' \
  -e 's/^#en_AU.UTF-8 UTF-8/en_AU.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

log "Setting up users"
echo "root:\$__PASSPHRASE__" | chpasswd
useradd -m -g users -G wheel glh
echo "glh:\$__PASSPHRASE__" | chpasswd
echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel

log "Setting up boot"
pacman -S --noconfirm grub efibootmgr dosfstools os-prober mtools
mkdir -p /boot/EFI
mount /dev/nvme0n1p1 /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
grub-mkconfig -o /boot/grub/grub.cfg

log "Setting up swap"
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
echo -e '\n/swapfile none swap sw 0 0' >> /etc/fstab

log "Setting up encryption for /home"
pacman -S --noconfirm fscrypt
fscrypt setup
fscrypt setup /home
echo "auth optional pam_fscrypt.so" >> /etc/pam.d/system-login
echo "session optional pam_fscrypt.so drop_caches lock_policies" >> /etc/pam.d/system-login
echo "password optional pam_fscrypt.so" >> /etc/pam.d/passwd

log "Installing other dependencies"
pacman -S --noconfirm git neovim ruby tmux vi vim xorg-server

pacman -S --noconfirm inetutils # for hostname
pacman -S --noconfirm apcupsd # for auto-shutdown when UPS battery runs low
systemctl enable apcupsd

log "Installing gfx stuff"
pacman -S --noconfirm libva-mesa-driver linux-firmware mesa-vdpau vulkan-radeon xf86-video-amdgpu

log "Installing network support"
pacman -S --noconfirm wpa_supplicant wireless_tools netctl dhcpcd
pacman -S --noconfirm dialog # for wifi-menu, although we're not using it here

NETCTL_PROFILE=\$(echo "\$__SSID__" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
NETCTL_KEY=\$(wpa_passphrase "\$__SSID__" "\$__WIFI_PASSPHRASE__" | grep psk= | grep -v '#' | cut -d = -f 2)
NETCTL_CONFIG=/etc/netctl/\$NETCTL_PROFILE
NETCTL_SSID=\$(echo "\$__SSID__" | sed 's/ /\\\\ /g')
touch \$NETCTL_CONFIG
chmod 600 \$NETCTL_CONFIG
echo "Description='\$NETCTL_PROFILE'" >> "\$NETCTL_CONFIG"
echo "Interface=wlp4s0" >> "\$NETCTL_CONFIG"
echo "Connection=wireless" >> "\$NETCTL_CONFIG"
echo "Security=wpa" >> "\$NETCTL_CONFIG"
echo "ESSID=\$NETCTL_SSID" >> "\$NETCTL_CONFIG"
echo "IP=dhcp" >> "\$NETCTL_CONFIG"
echo "Key=\\\\\"\$NETCTL_KEY" >> "\$NETCTL_CONFIG"
netctl enable "\$NETCTL_PROFILE"

log "Applying other settings"
pacman -S --noconfirm terminus-font # for 4K display, instead of `setfont -d`
echo FONT=ter-132n >> /etc/vconsole.conf
echo KEYMAP=colemak >> /etc/vconsole.conf

ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc

log "Cloning dotfiles"
sudo -u glh mkdir -p /home/glh/code
sudo -u glh git clone --recursive https://github.com/wincent/wincent.git /home/glh/code/wincent

log "Setting up /etc/motd"
echo "Suggested actions:" >> /etc/motd
echo "  sudo -s" >> /etc/motd
echo "  mkdir /home/glh_" >> /etc/motd
echo "  chown glh:users /home/glh_" >> /etc/motd
echo "  fscrypt encrypt /home/glh_ --user=glh" >> /etc/motd
echo "  exit" >> /etc/motd
echo "  cp -a -T /home/glh /home/glh_" >> /etc/motd
echo "  sudo reboot" >> /etc/motd
echo "" >> /etc/motd
echo "After rebooting:" >> /etc/motd
echo "" >> /etc/motd
echo "  fscrypt status /home/glh_" >> /etc/motd
echo "  sudo mv /home/glh /home/glh_plaintext" >> /etc/motd
echo "  sudo mv /home/glh_ /home/glh" >> /etc/motd
echo "  sudo reboot" >> /etc/motd
echo "" >> /etc/motd
echo "And finally:" >> /etc/motd
echo "" >> /etc/motd
echo "  find /home/glh_plaintext -type f -print0 | xargs -0 shred -n1 --remove=unlink" >> /etc/motd
echo "  sudo rm -rf /home/glh_plaintext" >> /etc/motd
echo "  echo -n | sudo tee /etc/motd" >> /etc/motd

exit
HERE

log "Entering chroot environment"
arch-chroot /mnt /bin/bash arch-install-chroot.sh

log "Finished: rebooting"
rm /mnt/arch-install-chroot.sh

# Ignoring errors about unmounting...
set +e
umount -a

reboot
