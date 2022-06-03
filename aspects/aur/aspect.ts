export default {
  description: 'Installs and updates packages from the Arch User Repository',
  variables: {
    packages: [
      'bfs', // Breadth-first `find` replacement.
      'clipper-git', // Clipboard daemon.
      'glow', // Markdown previewer.
      'gnome-icon-theme', // eg. for clock icon in dunst notifications.
      'google-chrome', // Web browser.
      'it87-dkms-git', // Allows `sensors` to pick up on it8688 chipset.
      'lf', // Command-line file explorer.
      'lua-language-server', // https://github.com/sumneko/lua-language-server
      'microsoft-edge-stable-bin', // Web browser.
      'obs-studio', // Open Broadcaster Software (OBS) for streaming/screen-casting.
      'par', // Paragraph formatter.
      'ttf-symbola', // Font with lots of Unicode glyphs (eg. u276f, for prompt).
      'watchman', // Fast filesystem index (speeds up Command-T).
    ],
  },
};
