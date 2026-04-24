/**
 * vim: set nomodifiable :
 *
 * @generated
 */

import {command, handler, helpers, task} from 'fig';

const {when} = helpers;

//
// Formulae.
//

// Collection of portable C++ source libraries.
task('install boost formula', when('personal'), async () => {
  await command('brew', ['install', 'boost'], {
    creates: '/opt/homebrew/Cellar/boost',
  });
});

// JavaScript optimizing compiler.
task('install closure-compiler formula', when('personal'), async () => {
  await command('brew', ['install', 'closure-compiler'], {
    creates: '/opt/homebrew/Cellar/closure-compiler',
  });
});

// Image previews for lf file manager.
task('install ctpv formula', when('personal'), async () => {
  await command('brew', ['install', 'ctpv'], {
    creates: '/opt/homebrew/Cellar/ctpv',
  });
});

// Shared library for Watchman and Eden projects.
task('install edencommon formula', when('personal'), async () => {
  await command('brew', ['install', 'edencommon'], {
    creates: '/opt/homebrew/Cellar/edencommon',
  });
});

// Interpreter for PostScript and PDF.
task('install ghostscript formula', when('personal'), async () => {
  await command('brew', ['install', 'ghostscript'], {
    creates: '/opt/homebrew/Cellar/ghostscript',
  });
});

// Subtitle renderer for the ASS/SSA subtitle format.
task('install libass formula', when('personal'), async () => {
  await command('brew', ['install', 'libass'], {
    creates: '/opt/homebrew/Cellar/libass',
  });
});

// Next-gen compiler infrastructure.
task('install llvm formula', when('personal'), async () => {
  await command('brew', ['install', 'llvm'], {
    creates: '/opt/homebrew/Cellar/llvm',
  });
});

// Drop-in replacement for MySQL.
task('install mariadb formula', when('personal'), async () => {
  await command('brew', ['install', 'mariadb'], {
    creates: '/opt/homebrew/Cellar/mariadb',
  });
});

// High performance, distributed memory object caching system.
task('install memcached formula', when('personal'), async () => {
  await command('brew', ['install', 'memcached'], {
    creates: '/opt/homebrew/Cellar/memcached',
    notify: 'restart memcached service',
  });
});

// Development kit for the Java programming language.
task('install openjdk@21 formula', when('personal'), async () => {
  await command('brew', ['install', 'openjdk@21'], {
    creates: '/opt/homebrew/Cellar/openjdk@21',
  });
});

// Persistent key-value database, with built-in net interface.
task('install redis formula', when('personal'), async () => {
  await command('brew', ['install', 'redis'], {
    creates: '/opt/homebrew/Cellar/redis',
    notify: 'restart redis service',
  });
});

// Utility that provides fast incremental file transfer.
task('install rsync formula', when('personal'), async () => {
  await command('brew', ['install', 'rsync'], {
    creates: '/opt/homebrew/Cellar/rsync',
  });
});

// Command-line tool for the Amazon S3 service.
task('install s3cmd formula', when('personal'), async () => {
  await command('brew', ['install', 's3cmd'], {
    creates: '/opt/homebrew/Cellar/s3cmd',
  });
});

// Formatting technology for Swift source code.
task('install swift-format formula', when('personal'), async () => {
  await command('brew', ['install', 'swift-format'], {
    creates: '/opt/homebrew/Cellar/swift-format',
  });
});

// Maintained ctags implementation.
task('install universal-ctags formula', when('personal'), async () => {
  await command('brew', ['install', 'universal-ctags'], {
    creates: '/opt/homebrew/Cellar/universal-ctags',
  });
});

//
// Casks.
//

// Password manager that keeps all passwords secure behind one password.
task('install 1password cask', when('personal'), async () => {
  await command('brew', ['install', '--cask', '1password'], {
    creates: '/opt/homebrew/Caskroom/1password',
  });
});

// Multi-cloud backup application.
task('install arq cask', when('personal'), async () => {
  await command('brew', ['install', '--cask', 'arq'], {
    creates: '/opt/homebrew/Caskroom/arq',
  });
});

// Web browser.
task('install google-chrome cask', when('personal'), async () => {
  await command('brew', ['install', '--cask', 'google-chrome'], {
    creates: '/opt/homebrew/Caskroom/google-chrome',
  });
});

// Multi-platform web browser.
task('install microsoft-edge cask', when('personal'), async () => {
  await command('brew', ['install', '--cask', 'microsoft-edge'], {
    creates: '/opt/homebrew/Caskroom/microsoft-edge',
  });
});

// Scheduling application focusing on organisation.
task('install omnifocus cask', when('personal'), async () => {
  await command('brew', ['install', '--cask', 'omnifocus'], {
    creates: '/opt/homebrew/Caskroom/omnifocus',
  });
});

// File sync and share software.
task('install resilio-sync cask', when('personal'), async () => {
  await command('brew', ['install', '--cask', 'resilio-sync'], {
    creates: '/opt/homebrew/Caskroom/resilio-sync',
  });
});

// Instant messaging application focusing on security.
task('install signal cask', when('personal'), async () => {
  await command('brew', ['install', '--cask', 'signal'], {
    creates: '/opt/homebrew/Caskroom/signal',
  });
});

// Video game digital distribution service.
task('install steam cask', when('personal'), async () => {
  await command('brew', ['install', '--cask', 'steam'], {
    creates: '/opt/homebrew/Caskroom/steam',
  });
});

// Backup, recovery and cloning software.
task('install superduper cask', when('personal'), async () => {
  await command('brew', ['install', '--cask', 'superduper'], {
    creates: '/opt/homebrew/Caskroom/superduper',
  });
});

//
// Cargo crates.
//

task('install cargo-machete crate', when('personal'), async () => {
  await command('cargo', ['install', 'cargo-machete'], {
    creates: '~/.cargo/bin/cargo-machete',
  });
});

task('install cargo-outdated crate', when('personal'), async () => {
  await command('cargo', ['install', 'cargo-outdated'], {
    creates: '~/.cargo/bin/cargo-outdated',
  });
});

task('install cargo-udeps crate', when('personal'), async () => {
  await command('cargo', ['install', 'cargo-udeps'], {
    creates: '~/.cargo/bin/cargo-udeps',
  });
});

task('install cargo-upgrades crate', when('personal'), async () => {
  await command('cargo', ['install', 'cargo-upgrades'], {
    creates: '~/.cargo/bin/cargo-upgrades',
  });
});

task('install diesel_cli crate', when('personal'), async () => {
  await command('cargo', ['install', 'diesel_cli'], {
    creates: '~/.cargo/bin/diesel',
  });
});

//
// Handlers.
//

handler('restart memcached service', async () => {
  await command('brew', ['services', 'restart', 'memcached']);
});

handler('restart redis service', async () => {
  await command('brew', ['services', 'restart', 'redis']);
});
