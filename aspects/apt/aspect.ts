export default {
  description: 'Installs and updates packages via the apt-get package manager',
  variables: {
    packages: [
      'build-essential', // C compiler toolchain (for Command-T, treesitter parsers, Neovim).
      'cargo', // Rust package manager (for shellbot).
      'cmake', // Build tool (for Neovim).
      'curl', // URL fetcher.
      'gettext', // Internationalization tools (for Neovim).
      'luajit', // Lua interpreter (for Neovim).
      'libssl-dev', // OpenSSL headers (for shellbot).
      'ninja-build', // Build tool (for Neovim).
      'pkg-config', // Build tool (for shellbot).
      'ripgrep', // Grep replacement.
      'ruby', // Object-oriented scripting language.
      'tree', // Displays an indented directory tree.
      'unzip', // Archive extraction (for Neovim).
      'zsh', // Shell.
    ],
  },
};
