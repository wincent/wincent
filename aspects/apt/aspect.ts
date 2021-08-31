export default {
  description: 'Installs and updates packages via the apt-get package manager',
  variables: {
    packages: [
      'autoconf', // To build Neovim from source.
      'automake', // To build Neovim from source.
      'cmake', // To build Neovim from source.
      'g++', // To build Neovim from source.
      'gettext', // To build Neovim from source.
      'libtool', // To build Neovim from source.
      'libtool-bin', // To build Neovim from source.
      'neovim', // Editor.
      'netcat', // Needed by Clipper (if you use a TCP port).
      'par', // For wrapping text in Vim.
      'socat', // Actually (if you use a UNIX socket).
      'ninja-build', // To build Neovim from source.
      'pkg-config', // To build Neovim from source.
      'ripgrep', // Fast file finder.
      'ruby-dev', // To build Command-T.
      'tree', // Outputs tree view of filesystem.
      'unzip', // To build Neovim from source.
    ],
  },
};
