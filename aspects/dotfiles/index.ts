import * as fs from 'fig/fs.ts';
import merge from 'fig/merge.ts';

import {
  backup,
  command,
  fail,
  file,
  helpers,
  log,
  path,
  prompt,
  resource,
  task,
  template,
  variable,
  variables,
} from 'fig';

const {is, when} = helpers;

variables(async ({hostHandle, identity, platform, profile}) => {
  // Docker doesn't support "include" files, so roll our own by
  // merging host-specific config (if present) into base config.
  const dockerBase = JSON.parse(
    await fs.promises.readFile(
      resource.file('.docker/config-base.json'),
      'utf8',
    ),
  );
  const dockerHostSpecific = resource.file(
    '.docker/host',
    `${hostHandle}.json`,
  );
  const dockerConfig = fs.existsSync(dockerHostSpecific)
    ? JSON.stringify(
      merge(
        dockerBase,
        JSON.parse(
          await fs.promises.readFile(dockerHostSpecific, 'utf8'),
        ),
      ),
      null,
      2,
    )
    : JSON.stringify(dockerBase, null, 2);

  return {
    dockerConfig,

    // This one is because Kitty defines these names to be the same:
    //
    // - "alt", "opt", "option", "⌥" (ie. the small modifier key next to Control)
    // - "super", "cmd", "command", "⌘" (ie. the large modifier key next to Space)
    //
    // That is, the _documentation_ uses Mac-centric terminology rather than
    // Linux terminology, where the following would apply:
    //
    // - "alt" refers to the large modifier key next to Space.
    // - "super" refers to the small modifier key next to Control.
    //
    // In general I prefer to use the Linux-centric names everywhere, because at
    // least those are partially in common with the names used in Windows:
    //
    // - "alt" refers to the large modifier key next to Space.
    // - "windows" refers to the small modifier key next to Control.
    //
    // (Also, because Apple itself stopped writing the word "alt" on the its
    // "super" key some years ago.)
    //
    // For more info on modifier key names, see: https://wincent.dev/wiki/Modifier_keys
    //
    // Anyway, all this means that if you want to use the "alt" key (ie. the
    // large modifier key) for anything in Kitty and have it work the same way
    // on both platforms, you need to call it "alt" in your Linux config and
    // "cmd" on your macOS one. On Linux, "alt" _does_ refer to the large
    // modifier. On Darwin, only "cmd" does.
    //
    // Kitty's `macos_options_as_alt` setting doesn't help us here because it
    // appears to only affect the behavior of the "option" key (ie. it makes it
    // behave like "alt") but it does not actually _swap_ the functionality of
    // the other key, so the other key ("cmd") continues to behave like "cmd".
    kittyAlt: platform === 'darwin' ? 'cmd' : 'alt',

    gitHostSpecificInclude: `host/${hostHandle}`,

    // These are the personal dotfiles of Greg Hurrell, so only set up
    // "wincent" GitHub handle if identity is "wincent".
    gitHubUsername: identity === 'wincent' ? 'wincent' : '',

    sbVmImage: identity === 'wincent'
      ? 'ghcr.io/wincent/wincent-base:latest'
      : 'ghcr.io/cirruslabs/ubuntu:latest',

    vcsGpgSign: identity === 'wincent' && !is('vm'),

    vcsUserEmail: identity === 'wincent'
      ? profile === 'work' ? 'greg.hurrell@datadoghq.com' : 'greg@hurrell.net'
      : '',
    vcsUserName: identity === 'wincent' ? 'Greg Hurrell' : '',
  };
});

// How to describe each state that `wage status --porcelain` can report, and
// what to do about it.
const CRYPT_STATES: {
  [state: string]: {description: string; remedy: Array<string>};
} = {
  diverged: {
    description: 'plaintext does not match the ciphertext beside it',
    remedy: [
      'Run `bin/decrypt <file>` to replace the plaintext with the committed',
      'ciphertext, or `bin/encrypt <file>` to publish local plaintext edits.',
    ],
  },
  encrypted: {
    description: 'plaintext is missing',
    remedy: ['Run `bin/decrypt <file>` to create it.'],
  },
  unreadable: {
    description: 'ciphertext cannot be decrypted',
    remedy: [
      'Something else is wrong (eg. unresolved conflict markers in',
      'the ciphertext, or a recipient whose identity this machine does not',
      'hold); resolve it by hand.',
    ],
  },
};

task('check encryption status', when('wincent'), async () => {
  if (is('vm')) {
    return;
  }

  const result = await command('bin/crypt-status', ['--porcelain'], {
    failedWhen: () => false,
  });

  if (result === null) {
    return;
  }

  // `wage status` exits 1 when at least one file needs attention, so a non-zero
  // status is expected here. It reserves 2 for "couldn't get far enough to
  // tell" (eg. the identity is unreachable), which is the only case where there
  // is nothing per-file to report.
  if (result.status !== 0 && result.status !== 1) {
    log.warn('Unable to determine encryption status of any file.\n');

    if (!(await prompt.confirm('Continue anyway'))) {
      fail('encryption status check failed');
    }

    return;
  }

  // One "STATE<TAB>PATH" line per file needing attention; group by state so
  // that each group can be reported along with its remedy.
  const grouped = new Map<string, Array<string>>();

  for (const line of result.stdout.split(/\n/)) {
    const match = line.match(/^(\S+)\t(.+)$/);

    if (match) {
      const [, state, file] = match;
      const files = grouped.get(state);

      if (files) {
        files.push(file);
      } else {
        grouped.set(state, [file]);
      }
    }
  }

  if (grouped.size) {
    const sections = [...grouped.entries()].map(([state, files]) => {
      const info = CRYPT_STATES[state];

      return [
        info ? `${state} (${info.description}):` : `${state}:`,
        '',
        ...files.map((file) => `  ${file}`),
        ...(info ? ['', ...info.remedy.map((line) => `  ${line}`)] : []),
      ].join('\n');
    });

    log.warn(
      `Encrypted files needing attention:\n\n${sections.join('\n\n')}\n`,
    );

    if (!(await prompt.confirm('Continue anyway'))) {
      fail('encryption status check failed');
    }
  }
});

task('make directories', async () => {
  await file({path: '~/.backups', state: 'directory'});
  await file({path: '~/.bitcoin', state: 'directory'});
  await file({
    path: '~/.config/nono/profiles',
    recurse: true,
    state: 'directory',
  });
  await file({
    path: '~/.config/shadowfax',
    recurse: true,
    state: 'directory',
  });
  await file({mode: '0700', path: '~/.gnupg', state: 'directory'});
  await file({path: '~/.irssi', state: 'directory'});
  await file({path: '~/.mail', state: 'directory'});
});

task('move originals to ~/.backups', async () => {
  const files = [...variable.paths('files'), ...variable.paths('templates')];

  for (const file of files) {
    const src = file.strip('.erb');

    await backup({src});
  }
});

task('create symlinks', async () => {
  const files = variable.paths('files');

  for (const src of files) {
    await file({
      force: true,
      path: path.home.join(src),
      src: path.aspect.join('files', src),
      state: 'link',
    });
  }
});

task('fill templates', async () => {
  const templates = variable.paths('templates');

  for (const src of templates) {
    const executable = src.endsWith('.sh.erb') || src.includes('/bin/');
    await template({
      mode: executable ? '0755' : '0644',
      path: path.home.join(src.strip('.erb')),
      src: path.aspect.join('templates', src),
    });
  }
});

task('install ~/.pi/agent/auth.json', when('wincent', 'personal'), async () => {
  await file({
    path: '~/.pi/agent',
    state: 'directory',
  });
  await template({
    path: path.home.join('.pi/agent/auth.json'),
    src: path.aspect.join('templates/.pi/agent/auth.json.erb'),
  });
});

task('zcompile shell files', async () => {
  const script = resource.support('compile-zwc');

  await command('zsh', [script]);
});

task('create ~/code/.editorconfig', when('wincent'), async () => {
  await file({path: '~/code', state: 'directory'});
  await template({
    path: '~/code/.editorconfig',
    src: resource.template('code/.editorconfig'),
  });
});

task('create ~/dd', when('wincent', 'work'), async () => {
  await file({
    path: '~/go/src/github.com/DataDog',
    recurse: true,
    state: 'directory',
  });
  await file({
    path: '~/dd',
    src: '~/go/src/github.com/DataDog',
    state: 'link',
  });
});

task('create ~/dd/.editorconfig', when('wincent', 'work'), async () => {
  await template({
    path: '~/dd/.editorconfig',
    src: resource.template('dd/.editorconfig'),
  });
});

task('install glow.yml', when('darwin'), async () => {
  // On other platforms, Glow will read from ~/.config/glow/glow.yml.
  await file({
    path: '~/Library/Preferences/glow',
    state: 'directory',
  });

  await file({
    force: true,
    path: '~/Library/Preferences/glow/glow.yml',
    src: path.aspect.join('files/Library/Preferences/glow/glow.yml'),
    state: 'link',
  });
});
