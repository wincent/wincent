export default {
  platforms: {
    darwin: {
      aspects: [
        'meta',
        'backup',
        'dotfiles',
        'fonts',
        'nix',
        'homebrew',
        'node',
        'karabiner',
        'launchd',
        'ruby',
        'shell',
        'ssh',
        'violentmonkey',
        'nvim',
        'cron',
        'automator',
        'automount',
        'defaults',
      ],
      variables: {
        pinentryProgram: '/opt/homebrew/bin/pinentry-curses',
      },
    },
    linux: {
      aspects: [
        'meta',
        'dotfiles',
        'locale',
        'pacman',
        'aur',
        'bitcoin',
        'avahi',
        'shell',
        'sshd',
        'systemd',
        'interception',
        'node',
        'nvim',
      ],
      variables: {},
    },
  },
  profiles: {
    personal: {
      pattern: '/^(?:latina|huertas)(?:\\b|$)/i',
      variables: {},
    },
    work: {
      pattern: '/^COMP-KTW7Q4C5JH/i',
      variables: {},
    },
  },
  variables: {
    figManaged:
      'vim: set nomodifiable : DO NOT EDIT - edit template source instead («file») or use `:set modifiable` to force.',
    gitCipherPath: 'vendor/git-cipher/bin/git-cipher',
    pinentryProgram: '/usr/bin/pinentry-curses',
  },
};
