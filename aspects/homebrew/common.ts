/**
 * vim: set nomodifiable :
 *
 * @generated
 */

import {command, handler, task} from 'fig';

//
// Taps.
//

task('tap cirruslabs/cli', async () => {
  await command('brew', ['tap', 'cirruslabs/cli'], {
    creates: '/opt/homebrew/Library/Taps/cirruslabs/homebrew-cli',
  });
});

task('tap oven-sh/bun', async () => {
  await command('brew', ['tap', 'oven-sh/bun'], {
    creates: '/opt/homebrew/Library/Taps/oven-sh/homebrew-bun',
  });
});

task('tap sass/sass', async () => {
  await command('brew', ['tap', 'sass/sass'], {
    creates: '/opt/homebrew/Library/Taps/sass/homebrew-sass',
  });
});

//
// Formulae.
//

// Search tool like grep, but optimized for programmers.
task('install ack formula', async () => {
  await command('brew', ['install', 'ack'], {
    creates: '/opt/homebrew/Cellar/ack',
  });
});

// Simple, modern, secure file encryption.
task('install age formula', async () => {
  await command('brew', ['install', 'age'], {
    creates: '/opt/homebrew/Cellar/age',
  });
});

// Automatic configure script builder.
task('install autoconf formula', async () => {
  await command('brew', ['install', 'autoconf'], {
    creates: '/opt/homebrew/Cellar/autoconf',
  });
});

// Tool for generating GNU Standards-compliant Makefiles.
task('install automake formula', async () => {
  await command('brew', ['install', 'automake'], {
    creates: '/opt/homebrew/Cellar/automake',
  });
});

// Official Amazon AWS command-line interface.
task('install awscli formula', async () => {
  await command('brew', ['install', 'awscli'], {
    creates: '/opt/homebrew/Cellar/awscli',
  });
});

// Garbage collector for C and C++.
task('install bdw-gc formula', async () => {
  await command('brew', ['install', 'bdw-gc'], {
    creates: '/opt/homebrew/Cellar/bdw-gc',
  });
});

// Breadth-first version of find.
task('install bfs formula', async () => {
  await command('brew', ['install', 'bfs'], {
    creates: '/opt/homebrew/Cellar/bfs',
  });
});

// New way to see and navigate directory trees.
task('install broot formula', async () => {
  await command('brew', ['install', 'broot'], {
    creates: '/opt/homebrew/Cellar/broot',
  });
});

// Incredibly fast JavaScript runtime, bundler, transpiler and package manager - all in one.
task('install bun formula', async () => {
  await command('brew', ['install', 'oven-sh/bun/bun'], {
    creates: '/opt/homebrew/Cellar/bun',
  });
});

// Command-line interface for Cabal and Hackage.
task('install cabal-install formula', async () => {
  await command('brew', ['install', 'cabal-install'], {
    creates: '/opt/homebrew/Cellar/cabal-install',
  });
});

// Vector graphics library with cross-device output support.
task('install cairo formula', async () => {
  await command('brew', ['install', 'cairo'], {
    creates: '/opt/homebrew/Cellar/cairo',
  });
});

// Insanely fast image printing in your terminal.
task('install catimg formula', async () => {
  await command('brew', ['install', 'catimg'], {
    creates: '/opt/homebrew/Cellar/catimg',
  });
});

// General purpose syntax highlighter in pure Go.
task('install chroma formula', async () => {
  await command('brew', ['install', 'chroma'], {
    creates: '/opt/homebrew/Cellar/chroma',
  });
});

// Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript.
task('install clang-format formula', async () => {
  await command('brew', ['install', 'clang-format'], {
    creates: '/opt/homebrew/Cellar/clang-format',
  });
});

// ASP system to ground and solve logic programs.
task('install clingo formula', async () => {
  await command('brew', ['install', 'clingo'], {
    creates: '/opt/homebrew/Cellar/clingo',
  });
});

// Share macOS clipboard with tmux and other local and remote apps.
task('install clipper formula', async () => {
  await command('brew', ['install', '--HEAD', 'clipper'], {
    creates: '/opt/homebrew/Cellar/clipper',
    notify: 'restart clipper service',
  });
});

// Statistics utility to count lines of code.
task('install cloc formula', async () => {
  await command('brew', ['install', 'cloc'], {
    creates: '/opt/homebrew/Cellar/cloc',
  });
});

// Generate code for scanning Z-polyhedra.
task('install cloog formula', async () => {
  await command('brew', ['install', 'cloog'], {
    creates: '/opt/homebrew/Cellar/cloog',
  });
});

// Cross-platform make.
task('install cmake formula', async () => {
  await command('brew', ['install', 'cmake'], {
    creates: '/opt/homebrew/Cellar/cmake',
  });
});

// Container runtimes on MacOS (and Linux) with minimal setup.
task('install colima formula', async () => {
  await command('brew', ['install', 'colima'], {
    creates: '/opt/homebrew/Cellar/colima',
    notify: 'restart colima service',
  });
});

// GNU File, Shell, and Text utilities.
task('install coreutils formula', async () => {
  await command('brew', ['install', 'coreutils'], {
    creates: '/opt/homebrew/Cellar/coreutils',
  });
});

// Diff that understands syntax.
task('install difftastic formula', async () => {
  await command('brew', ['install', 'difftastic'], {
    creates: '/opt/homebrew/Cellar/difftastic',
  });
});

// Pack, ship and run any application as a lightweight container.
task('install docker formula', async () => {
  await command('brew', ['install', 'docker'], {
    creates: '/opt/homebrew/Cellar/docker',
  });
});

// Docker CLI plugin for extended build capabilities with BuildKit.
task('install docker-buildx formula', async () => {
  await command('brew', ['install', 'docker-buildx'], {
    creates: '/opt/homebrew/Cellar/docker-buildx',
  });
});

// Isolated development environments using Docker.
task('install docker-compose formula', async () => {
  await command('brew', ['install', 'docker-compose'], {
    creates: '/opt/homebrew/Cellar/docker-compose',
  });
});

// Pluggable and configurable code formatting platform written in Rust.
task('install dprint formula', async () => {
  await command('brew', ['install', 'dprint'], {
    creates: '/opt/homebrew/Cellar/dprint',
  });
});

// Select default apps for documents and URL schemes on macOS.
task('install duti formula', async () => {
  await command('brew', ['install', 'duti'], {
    creates: '/opt/homebrew/Cellar/duti',
  });
});

// Simple, fast and user-friendly alternative to find.
task('install fd formula', async () => {
  await command('brew', ['install', 'fd'], {
    creates: '/opt/homebrew/Cellar/fd',
  });
});

// Text mode browser and Gemini, NNTP, FTP, Gopher, Finger, and BitTorrent client.
task('install felinks formula', async () => {
  await command('brew', ['install', 'felinks'], {
    creates: '/opt/homebrew/Cellar/felinks',
  });
});

// Play, record, convert, and stream select audio and video codecs.
task('install ffmpeg formula', async () => {
  await command('brew', ['install', 'ffmpeg'], {
    creates: '/opt/homebrew/Cellar/ffmpeg',
  });
});

// Collection of GNU find, xargs, and locate.
task('install findutils formula', async () => {
  await command('brew', ['install', 'findutils'], {
    creates: '/opt/homebrew/Cellar/findutils',
  });
});

// XML-based font configuration API for X Windows.
task('install fontconfig formula', async () => {
  await command('brew', ['install', 'fontconfig'], {
    creates: '/opt/homebrew/Cellar/fontconfig',
  });
});

// Software library to render fonts.
task('install freetype formula', async () => {
  await command('brew', ['install', 'freetype'], {
    creates: '/opt/homebrew/Cellar/freetype',
  });
});

// Monitor a directory for changes and run a shell command.
task('install fswatch formula', async () => {
  await command('brew', ['install', 'fswatch'], {
    creates: '/opt/homebrew/Cellar/fswatch',
  });
});

// Terminal JSON viewer.
task('install fx formula', async () => {
  await command('brew', ['install', 'fx'], {
    creates: '/opt/homebrew/Cellar/fx',
  });
});

// GNU compiler collection.
task('install gcc formula', async () => {
  await command('brew', ['install', 'gcc'], {
    creates: '/opt/homebrew/Cellar/gcc',
  });
});

// Graphics library to dynamically manipulate images.
task('install gd formula', async () => {
  await command('brew', ['install', 'gd'], {
    creates: '/opt/homebrew/Cellar/gd',
  });
});

// GNU database manager.
task('install gdbm formula', async () => {
  await command('brew', ['install', 'gdbm'], {
    creates: '/opt/homebrew/Cellar/gdbm',
  });
});

// Toolkit for image loading and pixel buffer manipulation.
task('install gdk-pixbuf formula', async () => {
  await command('brew', ['install', 'gdk-pixbuf'], {
    creates: '/opt/homebrew/Cellar/gdk-pixbuf',
  });
});

// GNU internationalization (i18n) and localization (l10n) library.
task('install gettext formula', async () => {
  await command('brew', ['install', 'gettext'], {
    creates: '/opt/homebrew/Cellar/gettext',
  });
});

// Glorious Glasgow Haskell Compilation System.
task('install ghc formula', async () => {
  await command('brew', ['install', 'ghc'], {
    creates: '/opt/homebrew/Cellar/ghc',
  });
});

// GIF image/animation creator/editor.
task('install gifsicle formula', async () => {
  await command('brew', ['install', 'gifsicle'], {
    creates: '/opt/homebrew/Cellar/gifsicle',
  });
});

// Distributed revision control system.
task('install git formula', async () => {
  await command('brew', ['install', 'git'], {
    creates: '/opt/homebrew/Cellar/git',
  });
});

// Syntax-highlighting pager for git and diff output.
task('install git-delta formula', async () => {
  await command('brew', ['install', 'git-delta'], {
    creates: '/opt/homebrew/Cellar/git-delta',
  });
});

// Blazing fast terminal-ui for git written in rust.
task('install gitui formula', async () => {
  await command('brew', ['install', 'gitui'], {
    creates: '/opt/homebrew/Cellar/gitui',
  });
});

// Core application library for C.
task('install glib formula', async () => {
  await command('brew', ['install', 'glib'], {
    creates: '/opt/homebrew/Cellar/glib',
  });
});

// Render markdown on the CLI.
task('install glow formula', async () => {
  await command('brew', ['install', 'glow'], {
    creates: '/opt/homebrew/Cellar/glow',
  });
});

// MIME mail utilities.
task('install gmime formula', async () => {
  await command('brew', ['install', 'gmime'], {
    creates: '/opt/homebrew/Cellar/gmime',
  });
});

// GNU multiple precision arithmetic library.
task('install gmp formula', async () => {
  await command('brew', ['install', 'gmp'], {
    creates: '/opt/homebrew/Cellar/gmp',
  });
});

// GNU implementation of the famous stream editor.
task('install gnu-sed formula', async () => {
  await command('brew', ['install', 'gnu-sed'], {
    creates: '/opt/homebrew/Cellar/gnu-sed',
  });
});

// GNU Privacy Guard (OpenPGP).
task('install gnupg formula', async () => {
  await command('brew', ['install', 'gnupg'], {
    creates: '/opt/homebrew/Cellar/gnupg',
  });
});

// GNU Transport Layer Security (TLS) Library.
task('install gnutls formula', async () => {
  await command('brew', ['install', 'gnutls'], {
    creates: '/opt/homebrew/Cellar/gnutls',
  });
});

// Open source programming language to build simple/reliable/efficient software.
task('install go formula', async () => {
  await command('brew', ['install', 'go'], {
    creates: '/opt/homebrew/Cellar/go',
  });
});

// Graph visualization software from AT&T and Bell Labs.
task('install graphviz formula', async () => {
  await command('brew', ['install', 'graphviz'], {
    creates: '/opt/homebrew/Cellar/graphviz',
  });
});

// GNU grep, egrep and fgrep.
task('install grep formula', async () => {
  await command('brew', ['install', 'grep'], {
    creates: '/opt/homebrew/Cellar/grep',
  });
});

// Convert source code to formatted text with syntax highlighting.
task('install highlight formula', async () => {
  await command('brew', ['install', 'highlight'], {
    creates: '/opt/homebrew/Cellar/highlight',
  });
});

// Improved top (interactive process viewer).
task('install htop formula', async () => {
  await command('brew', ['install', 'htop'], {
    creates: '/opt/homebrew/Cellar/htop',
  });
});

// Ping-like tool for HTTP requests.
task('install httping formula', async () => {
  await command('brew', ['install', 'httping'], {
    creates: '/opt/homebrew/Cellar/httping',
  });
});

// Website copier/offline browser.
task('install httrack formula', async () => {
  await command('brew', ['install', 'httrack'], {
    creates: '/opt/homebrew/Cellar/httrack',
  });
});

// Add GitHub support to git on the command-line.
task('install hub formula', async () => {
  await command('brew', ['install', 'hub'], {
    creates: '/opt/homebrew/Cellar/hub',
  });
});

// Display an interface's bandwidth usage.
task('install iftop formula', async () => {
  await command('brew', ['install', 'iftop'], {
    creates: '/opt/homebrew/Cellar/iftop',
  });
});

// Tools and libraries to manipulate images in select formats.
task('install imagemagick formula', async () => {
  await command('brew', ['install', 'imagemagick'], {
    creates: '/opt/homebrew/Cellar/imagemagick',
  });
});

// Integer Set Library for the polyhedral model.
task('install isl formula', async () => {
  await command('brew', ['install', 'isl'], {
    creates: '/opt/homebrew/Cellar/isl',
  });
});

// Implementation of malloc emphasizing fragmentation avoidance.
task('install jemalloc formula', async () => {
  await command('brew', ['install', 'jemalloc'], {
    creates: '/opt/homebrew/Cellar/jemalloc',
  });
});

// Git-compatible distributed version control system.
task('install jj formula', async () => {
  await command('brew', ['install', 'jj'], {
    creates: '/opt/homebrew/Cellar/jj',
  });
});

// Image manipulation library.
task('install jpeg formula', async () => {
  await command('brew', ['install', 'jpeg'], {
    creates: '/opt/homebrew/Cellar/jpeg',
  });
});

// Lightweight and flexible command-line JSON processor.
task('install jq formula', async () => {
  await command('brew', ['install', 'jq'], {
    creates: '/opt/homebrew/Cellar/jq',
  });
});

// High quality MPEG Audio Layer III (MP3) encoder.
task('install lame formula', async () => {
  await command('brew', ['install', 'lame'], {
    creates: '/opt/homebrew/Cellar/lame',
  });
});

// Pager program similar to more.
task('install less formula', async () => {
  await command('brew', ['install', 'less'], {
    creates: '/opt/homebrew/Cellar/less',
  });
});

// Assuan IPC Library.
task('install libassuan formula', async () => {
  await command('brew', ['install', 'libassuan'], {
    creates: '/opt/homebrew/Cellar/libassuan',
  });
});

// Asynchronous event library.
task('install libevent formula', async () => {
  await command('brew', ['install', 'libevent'], {
    creates: '/opt/homebrew/Cellar/libevent',
  });
});

// Portable Foreign Function Interface library.
task('install libffi formula', async () => {
  await command('brew', ['install', 'libffi'], {
    creates: '/opt/homebrew/Cellar/libffi',
  });
});

// Cryptographic library based on the code from GnuPG.
task('install libgcrypt formula', async () => {
  await command('brew', ['install', 'libgcrypt'], {
    creates: '/opt/homebrew/Cellar/libgcrypt',
  });
});

// Common error values for all GnuPG components.
task('install libgpg-error formula', async () => {
  await command('brew', ['install', 'libgpg-error'], {
    creates: '/opt/homebrew/Cellar/libgpg-error',
  });
});

// X.509 and CMS library.
task('install libksba formula', async () => {
  await command('brew', ['install', 'libksba'], {
    creates: '/opt/homebrew/Cellar/libksba',
  });
});

// C library for the arithmetic of high precision complex numbers.
task('install libmpc formula', async () => {
  await command('brew', ['install', 'libmpc'], {
    creates: '/opt/homebrew/Cellar/libmpc',
  });
});

// Library for manipulating PNG images.
task('install libpng formula', async () => {
  await command('brew', ['install', 'libpng'], {
    creates: '/opt/homebrew/Cellar/libpng',
  });
});

// Library to render SVG files using Cairo.
task('install librsvg formula', async () => {
  await command('brew', ['install', 'librsvg'], {
    creates: '/opt/homebrew/Cellar/librsvg',
  });
});

// ASN.1 structure parser library.
task('install libtasn1 formula', async () => {
  await command('brew', ['install', 'libtasn1'], {
    creates: '/opt/homebrew/Cellar/libtasn1',
  });
});

// Library for processing keyboard entry from the terminal.
task('install libtermkey formula', async () => {
  await command('brew', ['install', 'libtermkey'], {
    creates: '/opt/homebrew/Cellar/libtermkey',
  });
});

// TIFF library and utilities.
task('install libtiff formula', async () => {
  await command('brew', ['install', 'libtiff'], {
    creates: '/opt/homebrew/Cellar/libtiff',
  });
});

// Generic library support script.
task('install libtool formula', async () => {
  await command('brew', ['install', 'libtool'], {
    creates: '/opt/homebrew/Cellar/libtool',
  });
});

// Library for USB device access.
task('install libusb formula', async () => {
  await command('brew', ['install', 'libusb'], {
    creates: '/opt/homebrew/Cellar/libusb',
  });
});

// Library for USB device access.
task('install libusb-compat formula', async () => {
  await command('brew', ['install', 'libusb-compat'], {
    creates: '/opt/homebrew/Cellar/libusb-compat',
  });
});

// Multi-platform support library with a focus on asynchronous I/O.
task('install libuv formula', async () => {
  await command('brew', ['install', 'libuv'], {
    creates: '/opt/homebrew/Cellar/libuv',
  });
});

// VisualOn AAC encoder library.
task('install libvo-aacenc formula', async () => {
  await command('brew', ['install', 'libvo-aacenc'], {
    creates: '/opt/homebrew/Cellar/libvo-aacenc',
  });
});

// C99 library which implements a VT220 or xterm terminal emulator.
task('install libvterm formula', async () => {
  await command('brew', ['install', 'libvterm'], {
    creates: '/opt/homebrew/Cellar/libvterm',
  });
});

// YAML Parser.
task('install libyaml formula', async () => {
  await command('brew', ['install', 'libyaml'], {
    creates: '/opt/homebrew/Cellar/libyaml',
  });
});

// Lynx-like WWW browser that supports tables, menus, etc.
task('install links formula', async () => {
  await command('brew', ['install', 'links'], {
    creates: '/opt/homebrew/Cellar/links',
  });
});

// Run cron jobs with overrun protection.
task('install lockrun formula', async () => {
  await command('brew', ['install', 'lockrun'], {
    creates: '/opt/homebrew/Cellar/lockrun',
  });
});

// Powerful, lightweight programming language.
task('install lua formula', async () => {
  await command('brew', ['install', 'lua'], {
    creates: '/opt/homebrew/Cellar/lua',
  });
});

// Language Server for the Lua language.
task('install lua-language-server formula', async () => {
  await command('brew', ['install', 'lua-language-server'], {
    creates: '/opt/homebrew/Cellar/lua-language-server',
  });
});

// Creates dependencies in makefiles.
task('install makedepend formula', async () => {
  await command('brew', ['install', 'makedepend'], {
    creates: '/opt/homebrew/Cellar/makedepend',
  });
});

// C library for multiple-precision floating-point computations.
task('install mpfr formula', async () => {
  await command('brew', ['install', 'mpfr'], {
    creates: '/opt/homebrew/Cellar/mpfr',
  });
});

// Library for a binary-based efficient data interchange format.
task('install msgpack formula', async () => {
  await command('brew', ['install', 'msgpack'], {
    creates: '/opt/homebrew/Cellar/msgpack',
  });
});

// 'traceroute' and 'ping' in a single tool.
task('install mtr formula', async () => {
  await command('brew', ['install', 'mtr'], {
    creates: '/opt/homebrew/Cellar/mtr',
  });
});

// Node version management.
task('install n formula', async () => {
  await command('brew', ['install', 'n'], {
    creates: '/opt/homebrew/Cellar/n',
  });
});

// Ambitious Vim-fork focused on extensibility and agility.
task('install neovim formula', async () => {
  await command('brew', ['install', 'neovim'], {
    creates: '/opt/homebrew/Cellar/neovim',
  });
});

// Low-level cryptographic library.
task('install nettle formula', async () => {
  await command('brew', ['install', 'nettle'], {
    creates: '/opt/homebrew/Cellar/nettle',
  });
});

// Small build system for use with gyp or CMake.
task('install ninja formula', async () => {
  await command('brew', ['install', 'ninja'], {
    creates: '/opt/homebrew/Cellar/ninja',
  });
});

// Cryptography and SSL/TLS Toolkit.
task('install openssl@3 formula', async () => {
  await command('brew', ['install', 'openssl@3'], {
    creates: '/opt/homebrew/Cellar/openssl@3',
  });
});

// PNG file optimizer.
task('install optipng formula', async () => {
  await command('brew', ['install', 'optipng'], {
    creates: '/opt/homebrew/Cellar/optipng',
  });
});

// ISO-C API and CLI for generating UUIDs.
task('install ossp-uuid formula', async () => {
  await command('brew', ['install', 'ossp-uuid'], {
    creates: '/opt/homebrew/Cellar/ossp-uuid',
  });
});

// Swiss-army knife of markup format conversion.
task('install pandoc formula', async () => {
  await command('brew', ['install', 'pandoc'], {
    creates: '/opt/homebrew/Cellar/pandoc',
  });
});

// Paragraph reflow for email.
task('install par formula', async () => {
  await command('brew', ['install', 'par'], {
    creates: '/opt/homebrew/Cellar/par',
  });
});

// Shell command parallelization utility.
task('install parallel formula', async () => {
  await command('brew', ['install', 'parallel'], {
    creates: '/opt/homebrew/Cellar/parallel',
  });
});

// Highly capable, feature-rich programming language.
task('install perl formula', async () => {
  await command('brew', ['install', 'perl'], {
    creates: '/opt/homebrew/Cellar/perl',
  });
});

// Passphrase entry dialog utilizing the Assuan protocol.
task('install pinentry formula', async () => {
  await command('brew', ['install', 'pinentry'], {
    creates: '/opt/homebrew/Cellar/pinentry',
  });
});

// Low-level library for pixel manipulation.
task('install pixman formula', async () => {
  await command('brew', ['install', 'pixman'], {
    creates: '/opt/homebrew/Cellar/pixman',
  });
});

// Package compiler and linker metadata toolkit.
task('install pkgconf formula', async () => {
  await command('brew', ['install', 'pkgconf'], {
    creates: '/opt/homebrew/Cellar/pkgconf',
  });
});

// Optimizer for PNG files.
task('install pngcrush formula', async () => {
  await command('brew', ['install', 'pngcrush'], {
    creates: '/opt/homebrew/Cellar/pngcrush',
  });
});

// PNG image optimizing utility.
task('install pngquant formula', async () => {
  await command('brew', ['install', 'pngquant'], {
    creates: '/opt/homebrew/Cellar/pngquant',
  });
});

// Convert bitmaps to vector graphics.
task('install potrace formula', async () => {
  await command('brew', ['install', 'potrace'], {
    creates: '/opt/homebrew/Cellar/potrace',
  });
});

// Protocol buffers (Google's data interchange format).
task('install protobuf formula', async () => {
  await command('brew', ['install', 'protobuf'], {
    creates: '/opt/homebrew/Cellar/protobuf',
  });
});

// Show ps output as a tree.
task('install pstree formula', async () => {
  await command('brew', ['install', 'pstree'], {
    creates: '/opt/homebrew/Cellar/pstree',
  });
});

// GNU Portable THreads.
task('install pth formula', async () => {
  await command('brew', ['install', 'pth'], {
    creates: '/opt/homebrew/Cellar/pth',
  });
});

// Password generator.
task('install pwgen formula', async () => {
  await command('brew', ['install', 'pwgen'], {
    creates: '/opt/homebrew/Cellar/pwgen',
  });
});

// Interpreted, interactive, object-oriented programming language.
task('install python@3.11 formula', async () => {
  await command('brew', ['install', 'python@3.11'], {
    creates: '/opt/homebrew/Cellar/python@3.11',
  });
});

// Interpreted, interactive, object-oriented programming language.
task('install python@3.12 formula', async () => {
  await command('brew', ['install', 'python@3.12'], {
    creates: '/opt/homebrew/Cellar/python@3.12',
  });
});

// Generic machine emulator and virtualizer.
task('install qemu formula', async () => {
  await command('brew', ['install', 'qemu'], {
    creates: '/opt/homebrew/Cellar/qemu',
  });
});

// Cross-platform application and UI framework.
task('install qt formula', async () => {
  await command('brew', ['install', 'qt'], {
    creates: '/opt/homebrew/Cellar/qt',
  });
});

// Library for command-line editing.
task('install readline formula', async () => {
  await command('brew', ['install', 'readline'], {
    creates: '/opt/homebrew/Cellar/readline',
  });
});

// JavaScript engine.
task('install rhino formula', async () => {
  await command('brew', ['install', 'rhino'], {
    creates: '/opt/homebrew/Cellar/rhino',
  });
});

// Search tool like grep and The Silver Searcher.
task('install ripgrep formula', async () => {
  await command('brew', ['install', 'ripgrep'], {
    creates: '/opt/homebrew/Cellar/ripgrep',
  });
});

// Readline wrapper: adds readline support to tools that lack it.
task('install rlwrap formula', async () => {
  await command('brew', ['install', 'rlwrap'], {
    creates: '/opt/homebrew/Cellar/rlwrap',
  });
});

// Safe, concurrent, practical language.
task('install rust formula', async () => {
  await command('brew', ['install', 'rust'], {
    creates: '/opt/homebrew/Cellar/rust',
  });
});

// Experimental Rust compiler front-end for IDEs.
task('install rust-analyzer formula', async () => {
  await command('brew', ['install', 'rust-analyzer'], {
    creates: '/opt/homebrew/Cellar/rust-analyzer',
  });
});

// Database of common MIME types.
task('install shared-mime-info formula', async () => {
  await command('brew', ['install', 'shared-mime-info'], {
    creates: '/opt/homebrew/Cellar/shared-mime-info',
  });
});

// Static analysis and lint tool, for (ba)sh scripts.
task('install shellcheck formula', async () => {
  await command('brew', ['install', 'shellcheck'], {
    creates: '/opt/homebrew/Cellar/shellcheck',
  });
});

// Fuzzy Finder in rust!.
task('install sk formula', async () => {
  await command('brew', ['install', 'sk'], {
    creates: '/opt/homebrew/Cellar/sk',
  });
});

// Command-line interface for SQLite.
task('install sqlite formula', async () => {
  await command('brew', ['install', 'sqlite'], {
    creates: '/opt/homebrew/Cellar/sqlite',
  });
});

// Non-interactive SSH password auth.
task('install sshpass formula', async () => {
  await command('brew', ['install', 'sshpass'], {
    creates: '/opt/homebrew/Cellar/sshpass',
  });
});

// Opinionated Lua code formatter.
task('install stylua formula', async () => {
  await command('brew', ['install', 'stylua'], {
    creates: '/opt/homebrew/Cellar/stylua',
  });
});

// Hierarchical, reference-counted memory pool with destructors.
task('install talloc formula', async () => {
  await command('brew', ['install', 'talloc'], {
    creates: '/opt/homebrew/Cellar/talloc',
  });
});

// Run macOS and Linux VMs on Apple Hardware.
task('install tart formula', async () => {
  await command('brew', ['install', 'cirruslabs/cli/tart'], {
    creates: '/opt/homebrew/Cellar/tart',
  });
});

// User interface to the TELNET protocol.
task('install telnet formula', async () => {
  await command('brew', ['install', 'telnet'], {
    creates: '/opt/homebrew/Cellar/telnet',
  });
});

// Send macOS User Notifications from the command-line.
task('install terminal-notifier formula', async () => {
  await command('brew', ['install', 'terminal-notifier'], {
    creates: '/opt/homebrew/Cellar/terminal-notifier',
  });
});

// Code-search similar to ack.
task('install the_silver_searcher formula', async () => {
  await command('brew', ['install', 'the_silver_searcher'], {
    creates: '/opt/homebrew/Cellar/the_silver_searcher',
  });
});

// Text interface for Git repositories.
task('install tig formula', async () => {
  await command('brew', ['install', 'tig'], {
    creates: '/opt/homebrew/Cellar/tig',
  });
});

// Terminal multiplexer.
task('install tmux formula', async () => {
  await command('brew', ['install', '--HEAD', 'tmux'], {
    creates: '/opt/homebrew/Cellar/tmux',
  });
});

// Lightweight database library.
task('install tokyo-cabinet formula', async () => {
  await command('brew', ['install', 'tokyo-cabinet'], {
    creates: '/opt/homebrew/Cellar/tokyo-cabinet',
  });
});

// Display directories as trees (with optional color/HTML output).
task('install tree formula', async () => {
  await command('brew', ['install', 'tree'], {
    creates: '/opt/homebrew/Cellar/tree',
  });
});

// Incremental parsing library.
task('install tree-sitter formula', async () => {
  await command('brew', ['install', 'tree-sitter'], {
    creates: '/opt/homebrew/Cellar/tree-sitter',
  });
});

// Parser generator tool.
task('install tree-sitter-cli formula', async () => {
  await command('brew', ['install', 'tree-sitter-cli'], {
    creates: '/opt/homebrew/Cellar/tree-sitter-cli',
  });
});

// Command-line unarchiving tools supporting multiple formats.
task('install unar formula', async () => {
  await command('brew', ['install', 'unar'], {
    creates: '/opt/homebrew/Cellar/unar',
  });
});

// Very basic terminfo library.
task('install unibilium formula', async () => {
  await command('brew', ['install', 'unibilium'], {
    creates: '/opt/homebrew/Cellar/unibilium',
  });
});

// Clean C library for processing UTF-8 Unicode data.
task('install utf8proc formula', async () => {
  await command('brew', ['install', 'utf8proc'], {
    creates: '/opt/homebrew/Cellar/utf8proc',
  });
});

// Google's JavaScript engine.
task('install v8 formula', async () => {
  await command('brew', ['install', 'v8'], {
    creates: '/opt/homebrew/Cellar/v8',
  });
});

// Vi 'workalike' with many additional features.
task('install vim formula', async () => {
  await command('brew', ['install', 'vim'], {
    creates: '/opt/homebrew/Cellar/vim',
  });
});

// Executes a program periodically, showing output fullscreen.
task('install watch formula', async () => {
  await command('brew', ['install', 'watch'], {
    creates: '/opt/homebrew/Cellar/watch',
  });
});

// Watch files and take action when they change.
task('install watchman formula', async () => {
  await command('brew', ['install', 'watchman'], {
    creates: '/opt/homebrew/Cellar/watchman',
  });
});

// Image format providing lossless and lossy compression for web images.
task('install webp formula', async () => {
  await command('brew', ['install', 'webp'], {
    creates: '/opt/homebrew/Cellar/webp',
  });
});

// Internet file retriever.
task('install wget formula', async () => {
  await command('brew', ['install', 'wget'], {
    creates: '/opt/homebrew/Cellar/wget',
  });
});

// H.264/AVC encoder.
task('install x264 formula', async () => {
  await command('brew', ['install', 'x264'], {
    creates: '/opt/homebrew/Cellar/x264',
  });
});

// C++ search engine library.
task('install xapian formula', async () => {
  await command('brew', ['install', 'xapian'], {
    creates: '/opt/homebrew/Cellar/xapian',
  });
});

// High-performance, high-quality MPEG-4 video library.
task('install xvid formula', async () => {
  await command('brew', ['install', 'xvid'], {
    creates: '/opt/homebrew/Cellar/xvid',
  });
});

// General-purpose data compression with high compression ratio.
task('install xz formula', async () => {
  await command('brew', ['install', 'xz'], {
    creates: '/opt/homebrew/Cellar/xz',
  });
});

// Blazing fast terminal file manager written in Rust, based on async I/O.
task('install yazi formula', async () => {
  await command('brew', ['install', 'yazi'], {
    creates: '/opt/homebrew/Cellar/yazi',
  });
});

// UNIX shell (command interpreter).
task('install zsh formula', async () => {
  await command('brew', ['install', 'zsh'], {
    creates: '/opt/homebrew/Cellar/zsh',
  });
});

//
// Casks.
//

// Command-line interface for 1Password.
task('install 1password-cli cask', async () => {
  await command('brew', ['install', '--cask', '1password-cli'], {
    creates: '/opt/homebrew/Caskroom/1password-cli',
  });
});

// Utility to dim background/inactive content in the screen.
task('install blurred cask', async () => {
  await command('brew', ['install', '--cask', 'blurred'], {
    creates: '/opt/homebrew/Caskroom/blurred',
  });
});

// Screen capturing tool.
task('install cleanshot cask', async () => {
  await command('brew', ['install', '--cask', 'cleanshot'], {
    creates: '/opt/homebrew/Caskroom/cleanshot',
  });
});

// Web browser.
task('install firefox cask', async () => {
  await command('brew', ['install', '--cask', 'firefox'], {
    creates: '/opt/homebrew/Caskroom/firefox',
  });
});

// Terminal emulator that uses platform-native UI and GPU acceleration.
task('install ghostty cask', async () => {
  await command('brew', ['install', '--cask', 'ghostty'], {
    creates: '/opt/homebrew/Caskroom/ghostty',
  });
});

// Free and open-source image editor.
task('install gimp cask', async () => {
  await command('brew', ['install', '--cask', 'gimp'], {
    creates: '/opt/homebrew/Caskroom/gimp',
  });
});

// Keyboard-focused todo manager.
task('install godspeed cask', async () => {
  await command('brew', ['install', '--cask', 'godspeed'], {
    creates: '/opt/homebrew/Caskroom/godspeed',
  });
});

// Desktop automation application.
task('install hammerspoon cask', async () => {
  await command('brew', ['install', '--cask', 'hammerspoon'], {
    creates: '/opt/homebrew/Caskroom/hammerspoon',
  });
});

// Hex editor focussing on speed.
task('install hex-fiend cask', async () => {
  await command('brew', ['install', '--cask', 'hex-fiend'], {
    creates: '/opt/homebrew/Caskroom/hex-fiend',
  });
});

// System monitoring app.
task('install istat-menus cask', async () => {
  await command('brew', ['install', '--cask', 'istat-menus'], {
    creates: '/opt/homebrew/Caskroom/istat-menus',
  });
});

// Menu bar manager.
task('install jordanbaird-ice cask', async () => {
  await command('brew', ['install', '--cask', 'jordanbaird-ice'], {
    creates: '/opt/homebrew/Caskroom/jordanbaird-ice',
  });
});

// Keyboard customiser.
task('install karabiner-elements cask', async () => {
  await command('brew', ['install', '--cask', 'karabiner-elements'], {
    creates: '/opt/homebrew/Caskroom/karabiner-elements',
  });
});

// Open-source keystroke visualiser.
task('install keycastr cask', async () => {
  await command('brew', ['install', '--cask', 'keycastr'], {
    creates: '/opt/homebrew/Caskroom/keycastr',
  });
});

// GPU-based terminal emulator.
task('install kitty cask', async () => {
  await command('brew', ['install', '--cask', 'kitty'], {
    creates: '/opt/homebrew/Caskroom/kitty',
  });
});

// Finds large, unwanted files and deletes them.
task('install omnidisksweeper cask', async () => {
  await command('brew', ['install', '--cask', 'omnidisksweeper'], {
    creates: '/opt/homebrew/Caskroom/omnidisksweeper',
  });
});

// WebKit based web browser.
task('install orion cask', async () => {
  await command('brew', ['install', '--cask', 'orion'], {
    creates: '/opt/homebrew/Caskroom/orion',
  });
});

// Control your tools with a few keystrokes.
task('install raycast cask', async () => {
  await command('brew', ['install', '--cask', 'raycast'], {
    creates: '/opt/homebrew/Caskroom/raycast',
  });
});

// Screen recording and video editing software.
task('install screenflow cask', async () => {
  await command('brew', ['install', '--cask', 'screenflow'], {
    creates: '/opt/homebrew/Caskroom/screenflow',
  });
});

// Music streaming service.
task('install spotify cask', async () => {
  await command('brew', ['install', '--cask', 'spotify'], {
    creates: '/opt/homebrew/Caskroom/spotify',
  });
});

// Multimedia player.
task('install vlc cask', async () => {
  await command('brew', ['install', '--cask', 'vlc'], {
    creates: '/opt/homebrew/Caskroom/vlc',
  });
});

// Open-source version of the X.Org X Window System.
task('install xquartz cask', async () => {
  await command('brew', ['install', '--cask', 'xquartz'], {
    creates: '/opt/homebrew/Caskroom/xquartz',
  });
});

// Tools for measuring, inspecting & testing on-screen graphics and layouts.
task('install xscope cask', async () => {
  await command('brew', ['install', '--cask', 'xscope'], {
    creates: '/opt/homebrew/Caskroom/xscope',
  });
});

//
// Handlers.
//

handler('restart clipper service', async () => {
  await command('brew', ['services', 'restart', 'clipper']);
});

handler('restart colima service', async () => {
  await command('brew', ['services', 'restart', 'colima']);
});
