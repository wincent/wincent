export default {
  description: 'Installs and updates packages from the Arch User Repository',
  variables: {
    packages: [
      'bfs', // Breadth-first `find` replacement.
      'clipper-git', // Clipboard daemon.
      'google-chrome', // Web browser.
      'it87-dkms-git', // Allows `sensors` to pick up on it8688 chipset.
      'lf', // Command-line file explorer.
      'lua-language-server', // https://github.com/sumneko/lua-language-server
      'obs-studio-git', // Open Broadcaster Software (OBS) for streaming/screen-casting.
      'ttf-symbola', // Font with lots of Unicode glyphs (eg. u276f, for prompt).
      'watchman', // Fast filesystem index (speeds up Command-T).
    ],
  },
};
