export default {
    description: 'Installs and updates packages from the Arch User Repository',
    variables: {
        packages: [
            'bfs', // Breadth-first `find` replacement.
            'clipper-git', // Clipboard daemon.
            'interception-dual-function-keys', // Substitute for some key (ha!) Karabiner-Elements functionality.
            'it87-dkms-git', // Allows `sensors` to pick up on it8688 chipset.
            'lf', // Command-line file explorer.
            'neovim-nightly', // Nightnly Neovim for access to latest LSP goodness.
            'ttf-symbola', // Font with lots of Unicode glyphs (eg. u276f, for prompt).
            'xkeysnail', // Per-application keyboard overrides.
        ],
    },
};
