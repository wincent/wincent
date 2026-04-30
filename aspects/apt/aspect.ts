export default {
  description: 'Installs and updates packages via the apt-get package manager',
  variables: {
    packages: [
      'autoconf', // Configure script generator (for tmux).
      'automake', // Makefile generator (for tmux).
      'bison', // Parser generator (for tmux).
      'build-essential', // C compiler toolchain (for Command-T, treesitter parsers, Neovim).
      'cmake', // Build tool (for Neovim).
      'curl', // URL fetcher.
      'fd-find', // Fast file finder (binary: fdfind; symlinked to fd).
      'gettext', // Internationalization tools (for Neovim).
      'kitty-terminfo', // Terminfo for the Kitty terminal emulator.
      'luajit', // Lua interpreter (for Neovim).
      'libevent-dev', // Event notification library (for tmux).
      'libncurses-dev', // Terminal handling library (for tmux).
      'libssl-dev', // OpenSSL headers (for shellbot).
      'ninja-build', // Build tool (for Neovim).
      'pkg-config', // Build tool (for shellbot).
      'ripgrep', // Grep replacement.
      'ruby', // Object-oriented scripting language.
      'tree', // Displays an indented directory tree.
      'unzip', // Archive extraction (for Neovim).
      'zsh', // Shell.
    ] as const,
  },
};
