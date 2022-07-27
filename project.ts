export default {
  platforms: {
    darwin: {
      aspects: [
        'meta',
        'backup',
        'dotfiles',
        'fonts',
        'homebrew',
        'iterm',
        'node',
        'karabiner',
        'launchd',
        'ruby',
        'shell',
        'ssh',
        'tampermonkey',
        'terminfo',
        'nvim',
        'cron',
        'automator',
        'automount',
        'defaults',
      ],
      variables: {},
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
        'terminfo',
        'node',
        'nvim',
      ],
      variables: {
        pinentryProgram: '/usr/bin/pinentry-curses',
      },
    },
    'linux.debian': {
      aspects: [
        'meta',
        ['apt', 'dotfiles', 'shell', 'node'],
        ['nvim', 'ruby', 'codespaces'],
      ],
      variables: {},
    },
  },
  profiles: {
    codespaces: {
      pattern: '/codespaces/i',
      variables: {
        gitMergeConflictStyle: 'diff3',
      },
    },
    personal: {
      pattern: '/^(?:retiro|huertas)(?:\\b|$)/i',
      variables: {
        corpusNotes: '~/Sync/Personal/Corpus',
        pinentryProgram: '/usr/local/bin/pinentry-curses',
      },
    },
    work: {
      pattern: '/^quevedo(?:\\b|$)/i',
      variables: {
        pinentryProgram: '/opt/homebrew/bin/pinentry-curses',
      },
    },
  },
  variables: {
    corpusNotes: '~/Documents/Corpus',
    figManaged:
      'vim: set nomodifiable : DO NOT EDIT - edit template source instead («file») or use `:set modifiable` to force.',
    gitCipherPath: 'vendor/git-cipher/bin/git-cipher',
    gitMergeConflictStyle: 'zdiff3',
    iTermDynamicProfiles: {
      external: [
        {
          path: 'Mutt.json',
          src: '40-Mutt-4K.json',
        },
        {
          path: 'Vim.json',
          src: '70-Vim-4K.json',
        },
        {
          path: 'Wincent.json',
          src: '10-4K.json',
        },
      ],
      retina: [
        {
          path: 'Mutt.json',
          src: '40-Mutt-Retina.json',
        },
        {
          path: 'Vim.json',
          src: '70-Vim-Retina.json',
        },
        {
          path: 'Wincent.json',
          src: '10-Retina.json',
        },
      ],
    },
    pinentryProgram: '/usr/bin/pinentry-curses',
  },
};
