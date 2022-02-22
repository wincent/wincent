export default {
  description: 'Installs and updates packages via the pacman package manager',
  variables: {
    packages: [
      'adobe-source-code-pro-fonts', // Monospace programming font.
      'audacious', // Media player for playing music in streams.
      'avahi', // zeroconf ("Bonjour") networking.
      'bluez', // Bluetooth stack.
      'bluez-utils', // Provides `bluetoothctl` CLI tool for pairing etc (see: https://wiki.archlinux.org/index.php/Bluetooth).
      'chafa', // Low-res character-based image previewer.
      'clang', // Compiler toolchain (eg. used for Neovim LSP).
      'cmake', // Build tool (eg. used to build Neovim).
      'dmenu', // Item selection UI.
      'dnsutils', // For `host`, `nslookup` and friends.
      'dunst', // Notification daemon (eg. for clock dropdown in status bar).
      'feh', // Sets desktop background.
      'git', // Version control system.
      'gnome-icon-theme', // eg. for clock icon in dunst notifications.
      'graphviz', // Generating images of graphs from DOT language descriptions.
      'happy', // Haskell golden testing library (needed for docvim).
      'htop', // Fancier process monitor.
      'hwinfo', // For querying hardware info.
      'i3', // Window manager.
      'i3blocks', // Status bar.
      'iftop', // Network monitor.
      'interception-dual-function-keys', // Substitute for some key (ha!) Karabiner-Elements functionality.
      'iotop', // I/O monitor.
      'irssi', // IRC client.
      'jq', // JSON parser.
      'kitty', // Terminal emulator.
      'man-pages', // Linux man pages (eg. `man 3 strlen` etc).
      'mariadb', // Drop-in replacement for (and default Arch) MySQL package.
      'mlocate', // Find files by name with `locate`.
      'mtr', // `traceroute` + `ping` rolled into a single tool.
      'namcap', // For testing AUR package PKGBUILD files.
      'neovim', // $EDITOR.
      'netcat', // For piping over network connectison (see also `socat` below).
      'nodejs', // JavaScript engine.
      'npm', // Node package manager.
      'openssh', // SSH tools.
      'otf-font-awesome', // Icon font (eg. for status bar).
      'pacman-contrib', // For `updpkgsums` (updating checksums in AUR package PKGBUILD files).
      'pavucontrol', // Simple PulseAudio configuration UI.
      'pcmanfm', // File manager from LXDE desktop (lightweight).
      'perl-anyevent-i3', // Dependency of `i3-save-tree` command.
      'picom', // X compositor (eg. window transparency etc).
      'pipewire', // Audio/video layer.
      'pipewire-docs', // Docs for PipeWire.
      'pipewire-pulse', // Compatibility layer for PulseAudio + Bluetooth.
      'python-neovim', // Support for running Python plugins in Neovim.
      'python-pip', // So we can update pynvim.
      'ripgrep', // Grep replacement.
      'ruby', // Scripting language.
      'rust-analyzer', // LSP services for Rust language.
      'screenkey', // Shows keyboard interactions for screencasting.
      'scrot', // Screenshot tool.
      'skim', // Fuzzy finder.
      'slop', // For selecting screen regions (eg. with screenkey).
      'socat', // Netcat replacement with UNIX domain socket (etc) support.
      'stack', // Haskell environment.
      'steam', // Ya know, for important stuff, like Factorio.
      'strace', // For observing process activity.
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
