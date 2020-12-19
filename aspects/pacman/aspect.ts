export default {
    description: 'Installs and updates packages via the pacman package manager',
    variables: {
        packages: [
            'adobe-source-code-pro-fonts', // Monospace programming font.
            'ant', // Java build tool.
            'bluez', // Bluetooth stack.
            'bluez-utils', // Provides `bluetoothctl` CLI tool for pairing etc (see: https://wiki.archlinux.org/index.php/Bluetooth).
            'caja', // File manager from MATE desktop.
            'chafa', // Low-res character-based image previewer.
            'chromium', // Web browser.
            'clang', // Compiler toolchain (eg. used for Neovim LSP).
            'cmake', // Build tool (eg. used to build Neovim).
            'dmenu', // Item selection UI.
            'dunst', // Notification daemon (eg. for clock dropdown in status bar).
            'feh', // Sets desktop background.
            'git', // Version control system.
            'gnome-control-center', // For controlling audio (etc).
            'gnome-icon-theme', // eg. for clock icon in dunst notifications.
            'happy', // Haskell golden testing library (needed for docvim).
            'herbstluftwm', // (Non-default) window manager; will probably remove.
            'htop', // Fancier process monitor.
            'hwinfo', // For querying hardware info.
            'i3', // Window manager.
            'i3blocks', // Status bar.
            'iftop', // Network monitor.
            'iotop', // I/O monitor.
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
            'picom', // X compositor (eg. window transparency etc).
            'pulseaudio-bluetooth',
            'python-neovim', // Support for running Python plugins in Neovim.
            'python-pip', // So we can install commandt.score and redis (for deoplete plugins).
            'ripgrep', // Grep replacement.
            'ruby', // Scripting language.
            'screenkey', // Shows keyboard interactions for screencasting.
            'scrot', // Screenshot tool.
            'skim', // Fuzzy finder.
            'socat', // Netcat replacement with UNIX domain socket (etc) support.
            'stack', // Haskell environment.
            'stress', // CPU (etc) stress tester.
            'sxhkd', // Hotkey daemon for X (eg. open Dmenu with Super+Space).
            'sxiv', // Simple X image viewer.
            'tree', // CLI file hierarchy viewer.
            'unzip', // For extracting and viewing .zip archive contents.
            'vi', // Original vi text editor.
            'vim', // Vim (vi improved) text editor.
            'watchman', // Fast filesystem index (speeds up Command-T).
            'xautolock', // Screen locker with hot-corner support.
            'xclip', // CLI access to X clipboard.
            'xdo', // Window utility for X, used to implement "swallow" functionality.
            'xorg', // Window system.
            'xorg-xinit', // X initializer.
            'xsecurelock', // Secure screen lock from Google.
            'yarn', // JavaScript package manager.
            'zsh', // Shell.
        ],
    },
};
