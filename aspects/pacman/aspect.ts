export default {
  description: 'Installs and updates packages via the pacman package manager',
  variables: {
    packages: [
      'adobe-source-code-pro-fonts', // Monospace programming font.
      'ant', // Java build tool.
      'avahi', // zeroconf ("Bonjour") networking.
      'bluez', // Bluetooth stack.
      'bluez-utils', // Provides `bluetoothctl` CLI tool for pairing etc (see: https://wiki.archlinux.org/index.php/Bluetooth).
      'caja', // File manager from MATE desktop.
      'chafa', // Low-res character-based image previewer.
      'clang', // Compiler toolchain (eg. used for Neovim LSP).
      'cmake', // Build tool (eg. used to build Neovim).
      'dmenu', // Item selection UI.
      'dnsutils', // For `host`, `nslookup` and friends.
      'dunst', // Notification daemon (eg. for clock dropdown in status bar).
      'feh', // Sets desktop background.
      'git', // Version control system.
      'gnome-control-center', // For controlling audio (etc).
      'gnome-icon-theme', // eg. for clock icon in dunst notifications.
      'happy', // Haskell golden testing library (needed for docvim).
      'htop', // Fancier process monitor.
      'hwinfo', // For querying hardware info.
      'i3', // Window manager.
      'i3blocks', // Status bar.
      'iftop', // Network monitor.
      'interception-dual-function-keys', // Substitute for some key (ha!) Karabiner-Elements functionality.
      'iotop', // I/O monitor.
      'irssi', // IRC client.
      'jdk8-openjdk', // Java.
      'jq', // JSON parser.
      'kitty', // Terminal emulator.
      'mariadb', // Drop-in replacemend for (and default Arch) MySQL package.
      'mlocate', // Find files by name with `locate`.
      'netcat', // For piping over network connectison (see also `socat` below).
      'nodejs', // JavaScript engine.
      'npm', // Node package manager.
      'openssh', // SSH tools.
      'otf-font-awesome', // Icon font (eg. for status bar).
      'pcmanfm', // File manager from LXDE desktop (lightweight).
      'picom', // X compositor (eg. window transparency etc).
      'pulseaudio-bluetooth',
      'python-neovim', // Support for running Python plugins in Neovim.
      'python-pip', // So we can install commandt.score and redis (for deoplete plugins).
      'ripgrep', // Grep replacement.
      'ruby', // Scripting language.
      'screenkey', // Shows keyboard interactions for screencasting.
      'scrot', // Screenshot tool.
      'skim', // Fuzzy finder.
      'slop', // For selecting screen regions (eg. with screenkey).
      'socat', // Netcat replacement with UNIX domain socket (etc) support.
      'stack', // Haskell environment.
      'stress', // CPU (etc) stress tester.
      'sxhkd', // Hotkey daemon for X (eg. open Dmenu with Super+Space).
      'sxiv', // Simple X image viewer.
      'tree', // CLI file hierarchy viewer.
      'unzip', // For extracting and viewing .zip archive contents.
      'vi', // Original vi text editor.
      'vim', // Vim (vi improved) text editor.
      'vlc', // Media player.
      'wget', // `curl` alternative.
      'xautolock', // Screen locker with hot-corner support.
      'xclip', // CLI access to X clipboard.
      'xdo', // Window utility for X, used to implement "swallow" functionality.
      'xdotool', // Another X utility, used to send per-application key strokes.
      'xorg', // Window system.
      'xorg-xinit', // X initializer.
      'xsecurelock', // Secure screen lock from Google.
      'yarn', // JavaScript package manager.
      'zsh', // Shell.
    ],
  },
};
