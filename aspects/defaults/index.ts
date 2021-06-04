import {defaults, task} from 'fig';

/**
 * Many of these settings taken (or modified) from:
 *
 *      https://github.com/mathiasbynens/dotfiles/blob/master/.macos
 */

task('Activity Monitor -> View -> Dock Icon -> Show CPU History', async () => {
  await defaults({
    domain: 'com.apple.ActivityMonitor',
    key: 'IconType',
    type: 'int',
    value: 6,
  });
});

task('Siri -> Enable Siri', async () => {
  await defaults({
    domain: 'com.apple.assistant.support',
    key: 'Assistant Enabled',
    type: 'bool',
    value: false,
  });
});

task("Don't create .DS_Store files on network volumes.", async () => {
  await defaults({
    domain: 'com.apple.desktopservices',
    key: 'DSDontWriteNetworkStores',
    type: 'bool',
    value: true,
  });
});

task("Don't create .DS_Store files on external USB drives.", async () => {
  await defaults({
    domain: 'com.apple.desktopservices',
    key: 'DSDontWriteUSBStores',
    type: 'bool',
    value: true,
  });
});

// Last tested: 10.9
task(
  'Automatically quit printer app once the print jobs complete',
  async () => {
    await defaults({
      domain: 'com.apple.print.PrintingPrefs',
      key: 'Quit When Finished',
      type: 'bool',
      value: true,
    });
  }
);

// Last tested: [10.9]
task('Disable auto-correct', async () => {
  await defaults({
    key: 'NSAutomaticSpellingCorrectionEnabled',
    type: 'bool',
    value: false,
  });
});

// Last tested: [10.9]
task(
  'Disable press-and-hold for keys in favor of key repeat Requires logout.',
  async () => {
    await defaults({
      key: 'ApplePressAndHoldEnabled',
      type: 'bool',
      value: false,
    });
  }
);

// Last tested: [10.9]
task('Disable smart quotes, dashes, ellipses', async () => {
  await defaults({
    key: 'NSAutomaticDashSubstitutionEnabled',
    type: 'bool',
    value: false,
  });
});

// Last tested: [10.9]
task('Disable smart quotes, dashes, ellipses', async () => {
  await defaults({
    key: 'NSAutomaticQuoteSubstitutionEnabled',
    type: 'bool',
    value: false,
  });
});

// Last tested: [10.9]
task('Disable the warning when changing a file extension', async () => {
  await defaults({
    domain: 'com.apple.finder',
    key: 'FXEnableExtensionChangeWarning',
    type: 'bool',
    value: false,
  });
});

// Last tested: [10.9]
task("Don't display full POSIX path as Finder window title", async () => {
  await defaults({
    domain: 'com.apple.finder',
    key: '_FXShowPosixPathInTitle',
    type: 'bool',
    value: false,
  });
});

// Last tested: [10.12.6]
task('New Finder windows show $HOME', async () => {
  await defaults({
    domain: 'com.apple.finder',
    key: 'NewWindowTarget',
    type: 'string',
    value: 'PfHm',
  });
});

// Last tested: [10.9]
task('Expand print panel by default', async () => {
  await defaults({
    key: 'PMPrintingExpandedStateForPrint',
    type: 'bool',
    value: true,
  });
});

// Last tested: [10.9]
task('Expand print panel by default', async () => {
  await defaults({
    key: 'PMPrintingExpandedStateForPrint2',
    type: 'bool',
    value: true,
  });
});

// Last tested: [10.9]
task('Expand save panel by default', async () => {
  await defaults({
    key: 'NSNavPanelExpandedStateForSaveMode',
    type: 'bool',
    value: true,
  });
});

// Last tested: [10.9]
task('Expand save panel by default', async () => {
  await defaults({
    key: 'NSNavPanelExpandedStateForSaveMode2',
    type: 'bool',
    value: true,
  });
});

// Last tested: [10.10.2]
task(
  'Finder -> Preferences -> General -> Spring-loaded folders and windows -> Delay (short)',
  async () => {
    await defaults({
      key: 'com.apple.springing.delay',
      type: 'float',
      value: 0,
    });
  }
);

// Last tested: [10.10.2]
task(
  'Finder -> Preferences -> General -> Spring-loaded folders and windows',
  async () => {
    await defaults({
      key: 'com.apple.springing.enabled',
      type: 'bool',
      value: true,
    });
  }
);

// Last tested: [10.9]
task(
  'Finder -> allow quitting via Command-Q; doing so will also hide desktop icons',
  async () => {
    await defaults({
      domain: 'com.apple.finder',
      key: 'QuitMenuItem',
      type: 'bool',
      value: true,
    });
  }
);

// Last tested: [10.9]
task('Finder -> allow text selection in Quick Look', async () => {
  await defaults({
    domain: 'com.apple.finder',
    key: 'QLEnableTextSelection',
    type: 'bool',
    value: true,
  });
});

// Last tested: [10.9]
task(
  'Finder -> disable window animations and Get Info animations',
  async () => {
    await defaults({
      domain: 'com.apple.finder',
      key: 'DisableAllAnimations',
      type: 'bool',
      value: true,
    });
  }
);

// Last tested: [10.9]
task('Finder -> show all filename extensions', async () => {
  await defaults({
    key: 'AppleShowAllExtensions',
    type: 'bool',
    value: true,
  });
});

// Last tested: [10.9]
task('Finder -> show path bar', async () => {
  await defaults({
    domain: 'com.apple.finder',
    key: 'ShowPathbar',
    type: 'bool',
    value: true,
  });
});

// Last tested: [10.9]
task('Finder -> show status bar', async () => {
  await defaults({
    domain: 'com.apple.finder',
    key: 'ShowStatusBar',
    type: 'bool',
    value: true,
  });
});

task('Finder Preferences -> New Finder windows show', async () => {
  await defaults({
    domain: 'com.apple.finder',
    key: 'NewWindowTargetPath',
    value: 'file:///Users/glh/',
  });
});

task(
  'Finder Preferences -> Open folders in tabs instead of new windows',
  async () => {
    await defaults({
      domain: 'com.apple.finder',
      key: 'FinderSpawnTab',
      type: 'bool',
      value: false,
    });
  }
);

task('Finder Preferences -> Sidebar -> Tags -> Recent Tags', async () => {
  await defaults({
    domain: 'com.apple.finder',
    key: 'ShowRecentTags',
    type: 'bool',
    value: false,
  });
});

task('Hammerspoon preferences -> Keep Console window on top', async () => {
  await defaults({
    domain: 'org.hammerspoon.Hammerspoon',
    key: 'MJKeepConsoleOnTopKey',
    type: 'bool',
    value: true,
  });
});

task('Hammerspoon preferences -> Show dock icon', async () => {
  await defaults({
    domain: 'org.hammerspoon.Hammerspoon',
    key: 'MJShowDockIconKey',
    type: 'bool',
    value: false,
  });
});

// Last tested: [10.10.2]
task('Make sheets drop down (almost) instantly', async () => {
  await defaults({
    key: 'NSWindowResizeTime',
    type: 'float',
    value: 0.001,
  });
});

// Last tested: [10.9]
task(
  'Require password immediately after sleep or screen saver begins',
  async () => {
    await defaults({
      domain: 'com.apple.screensaver',
      key: 'askForPassword',
      type: 'int',
      value: 1,
    });
  }
);

// Last tested: [10.9]
task(
  'Require password immediately after sleep or screen saver begins',
  async () => {
    await defaults({
      domain: 'com.apple.screensaver',
      key: 'askForPasswordDelay',
      type: 'float',
      value: 0,
    });
  }
);

task(
  'System Preferences -> Accessibility -> Zoom -> Use scroll gesture with modifier keys to zoom (Control)',
  async () => {
    await defaults({
      domain: 'com.apple.driver.AppleBluetoothMultitouch.trackpad',
      key: 'HIDScrollZoomModifierMask',
      type: 'int',
      value: 262144,
    });

    await defaults({
      domain: 'com.apple.AppleMultitouchTrackpad',
      key: 'HIDScrollZoomModifierMask',
      type: 'int',
      value: 262144,
    });
  }
);

// Last tested: [10.10.2]
task(
  'System Preferences -> Desktop & Screen Saver -> Screen Saver -> Hot Corners -> [Bottom Left] Start Screen Saver',
  async () => {
    await defaults({
      domain: 'com.apple.dock',
      key: 'wvous-bl-corner',
      type: 'int',
      value: 5,
    });
  }
);

// Last tested: [10.10.2]
task(
  'System Preferences -> Desktop & Screen Saver -> Screen Saver -> Hot Corners -> [Top Right] Disable Screen Saver',
  async () => {
    await defaults({
      domain: 'com.apple.dock',
      key: 'wvous-tr-corner',
      type: 'int',
      value: 6,
    });
  }
);

// Last tested: [10.10.2]
task(
  'System Preferences -> General -> Recent items (Applications)',
  async () => {
    await defaults({
      domain: 'com.apple.recentitems',
      key: 'RecentApplications',
      type: 'dict-add',
      value: {MaxAmount: 50},
    });
  }
);

// Last tested: [10.10.2]
task('System Preferences -> General -> Recent items (Documents)', async () => {
  await defaults({
    domain: 'com.apple.recentitems',
    key: 'RecentDocuments',
    type: 'dict-add',
    value: {MaxAmount: 50},
  });
});

// Last tested: [10.10.2]
task('System Preferences -> General -> Recent items (Servers)', async () => {
  await defaults({
    domain: 'com.apple.recentitems',
    key: 'RecentServers',
    type: 'dict-add',
    value: {MaxAmount: 50},
  });
});

// Last tested: [10.12.1]
task(
  'System Preferences -> Desktop & Screen Saver -> Screen Saver -> Show with clock',
  async () => {
    await defaults({
      domain: 'com.apple.screensaver',
      host: 'currentHost',
      key: 'showClock',
      type: 'bool',
      value: false,
    });
  }
);

// Last tested: [10.10.2]
task(
  'System Preferences -> Desktop & Screen Saver -> Screen Saver -> Start after -> 5 Minutes',
  async () => {
    await defaults({
      domain: 'com.apple.screensaver',
      host: 'currentHost',
      key: 'idleTime',
      type: 'int',
      value: 300,
    });
  }
);

task(
  'System Preferences -> Dock -> Automatically hide and show Dock',
  async () => {
    await defaults({
      domain: 'com.apple.dock',
      key: 'autohide',
      type: 'bool',
      value: true,
    });
  }
);

// Last tested: 10.11
task(
  'System Preferences -> General -> Appearance -> Automatically hide and show the menu bar',
  async () => {
    await defaults({
      key: '_HIHideMenuBar',
      type: 'bool',
      value: true,
    });
  }
);

// Last tested: 10.10
task('System Preferences -> General -> Appearance -> Graphite', async () => {
  await defaults({
    key: 'AppleAquaColorVariant',
    type: 'int',
    value: 6,
  });
});

// Last tested: [10.10.2]
task(
  'System Preferences -> General -> Click in scroll bar to -> Jump to the next page',
  async () => {
    await defaults({
      key: 'AppleScrollerPagingBehavior',
      type: 'int',
      value: 0,
    });
  }
);

// Last tested: [10.10.2]
task(
  'System Preferences -> General -> Show scroll bars -> Automatically based on mouse or trackpad',
  async () => {
    await defaults({
      key: 'AppleShowScrollBars',
      type: 'string',
      value: 'Automatic',
    });
  }
);

// Last tested: [10.10.2]
task(
  'System Preferences -> General -> Sidebar icon size -> Small',
  async () => {
    await defaults({
      key: 'NSTableViewDefaultSizeMode',
      type: 'int',
      value: 1,
    });
  }
);

// Last tested: [10.10.2]
task(
  "System Preferences -> General -> [Don't] Ask to keep changes when closing documents",
  async () => {
    await defaults({
      key: 'NSCloseAlwaysConfirmsChanges',
      type: 'int',
      value: 0,
    });
  }
);

// Last tested: [10.10.2]
task(
  "System Preferences -> General -> [Don't] Close windows when quitting an app",
  async () => {
    await defaults({
      key: 'NSQuitAlwaysKeepsWindows',
      type: 'int',
      value: 0,
    });
  }
);

// Last tested: [10.11.5]
task(
  'System Preferences -> Mission Control -> Displays have separate Spaces',
  async () => {
    await defaults({
      domain: 'com.apple.spaces',
      key: 'spans-displays',
      type: 'bool',
      value: true,
    });
  }
);

// Last tested: [10.10.2]
task(
  'System Preferences -> Sound -> Sound Effects -> Play feedback when volume is changed',
  async () => {
    await defaults({
      key: 'com.apple.sound.beep.feedback',
      type: 'bool',
      value: false,
    });
  }
);

// Last tested: [10.13.3]
task(
  'System Preferences -> Sound -> Sound Effects -> Play user interface sound effects',
  async () => {
    await defaults({
      key: 'com.apple.sound.uiaudio.enabled',
      type: 'int',
      value: 0,
    });
  }
);

task(
  'System Preferences -> Users & Groups -> Login Options -> Show fast user switching menu as "Icon"',
  async () => {
    await defaults({
      key: 'userMenuExtraStyle',
      type: 'int',
      value: 2,
    });
  }
);

// Last tested: 10.9
task(
  'Tweak subpixel font rendering (https://wincent.com/wiki/AppleFontSmoothing)',
  async () => {
    await defaults({
      host: 'currentHost',
      key: 'AppleFontSmoothing',
      type: 'int',
      value: 1,
    });
  }
);

// Last tested: [10.9]
task('Use plain text mode for new TextEdit documents', async () => {
  await defaults({
    domain: 'com.apple.TextEdit',
    key: 'RichText',
    type: 'int',
    value: 0,
  });
});

// Last tested: 3.1.3
task(
  'iTerm2 -> Preferences -> Advanced -> Windows -> Terminal windows resize smoothly',
  async () => {
    await defaults({
      domain: 'com.googlecode.iterm2',
      key: 'DisableWindowSizeSnap',
      type: 'bool',
      value: true,
    });
  }
);

// Last tested: 2.9.20150224-nightly
task(
  'iTerm2 -> Preferences -> Advanced -> Tabs -> Preferred tab width',
  async () => {
    await defaults({
      domain: 'com.googlecode.iterm2',
      key: 'OptimumTabWidth',
      type: 'int',
      value: 275,
    });
  }
);

// Last tested: 2.9.20150224-nightly
task('iTerm2 -> Preferences -> Appearance -> Hide scrollbars', async () => {
  await defaults({
    domain: 'com.googlecode.iterm2',
    key: 'HideScrollbar',
    type: 'bool',
    value: true,
  });
});

// Last tested: 2.9.20150224-nightly
task(
  'iTerm2 -> Preferences -> Appearance -> Hide tab activity indicator',
  async () => {
    await defaults({
      domain: 'com.googlecode.iterm2',
      key: 'HideActivityIndicator',
      type: 'bool',
      value: true,
    });
  }
);

// Last tested: 3.1.3 (they still show on mouseover)
task(
  'iTerm2 -> Preferences -> Appearance -> Show tab close buttons',
  async () => {
    await defaults({
      domain: 'com.googlecode.iterm2',
      key: 'HideTabCloseButton',
      type: 'bool',
      value: true,
    });
  }
);

// Last tested: 2.9.20150224-nightly
task(
  'iTerm2 -> Preferences -> General -> Adjust window when changing font size',
  async () => {
    await defaults({
      domain: 'com.googlecode.iterm2',
      key: 'AdjustWindowForFontSizeChange',
      type: 'bool',
      value: false,
    });
  }
);

// Last tested: 3.1.3
task(
  'iTerm2 -> Preferences -> Appearance -> Stretch tabs to fill bar',
  async () => {
    await defaults({
      domain: 'com.googlecode.iterm2',
      key: 'StretchTabsToFillBar',
      type: 'bool',
      value: true,
    });
  }
);

// Last tested: 3.3.20190114-nightly (default: 1)
task('iTerm2 -> Preferences -> Appearance -> Theme -> Dark', async () => {
  await defaults({
    domain: 'com.googlecode.iterm2',
    key: 'TabStyleWithAutomaticOption',
    type: 'int',
    value: 1,
  });
});

// Last tested: 3.1.3 (default: 5)
task(
  'iTerm2 -> Preferences -> Advanced -> General -> Width of left and right margins in terminal panes',
  async () => {
    await defaults({
      domain: 'com.googlecode.iterm2',
      key: 'TerminalMargin',
      type: 'int',
      value: 1,
    });
  }
);

// Last tested: 3.2.20180604-nightly (default: ?)
task(
  'iTerm2 -> Preferences -> Advanced -> General -> Width of left and right margins in terminal panes',
  async () => {
    await defaults({
      domain: 'com.googlecode.iterm2',
      key: 'TerminalVMargin',
      type: 'int',
      value: 2,
    });
  }
);

// Last tested: 2.9.20150224-nightly
task(
  'iTerm2 -> Preferences -> General -> Native full screen windows',
  async () => {
    await defaults({
      domain: 'com.googlecode.iterm2',
      key: 'UseLionStyleFullscreen',
      type: 'bool',
      value: false,
    });
  }
);
