import Context from 'fig/Context.ts';
import * as fs from 'fig/fs.ts';
import merge from 'fig/merge.ts';

import {
  backup,
  command,
  fail,
  file,
  helpers,
  log,
  options,
  path,
  prompt,
  resource,
  skip,
  task,
  template,
  variable,
  variables,
} from 'fig';
import {
  readAtlassianMetadata,
  shouldPreserveProfile,
} from './support/atlassian-metadata.ts';
import {
  phantomEnvExports,
  sharedEnvExports,
  stripJsoncLineComments,
} from './support/nono-proxy.ts';

const {is, isDecrypted, not, when} = helpers;

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

task('check encryption status', when('wincent', not('vm')), async () => {
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
  await file({path: '~/.docker', state: 'directory'});
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

// Render rather than symlink: private metadata stays out of the checkout,
// and source changes need an explicit install before affecting the sandbox.
// This is separate from `fill templates` because metadata may be unavailable.
task('install ~/.config/nono/profiles/pi.jsonc', when(not('vm')), async () => {
  const destination = path.home.join('.config/nono/profiles/pi.jsonc');
  const result = await readAtlassianMetadata({
    enabled: !options.check,
  });

  if (result.status !== 'available') {
    await log.warn(
      `Atlassian metadata ${result.status}; configure 1Password CLI and the ` +
        'CLI/atlassian-api-key site/email fields, then rerun ./install dotfiles. ' +
        'Dry runs and VMs do not query 1Password.',
    );
  }

  if (shouldPreserveProfile(result, fs.existsSync(destination))) {
    await skip(
      'preserving installed nono profile; private metadata was not refreshed',
    );
    return;
  }

  await template({
    mode: '0600',
    path: destination.toString(),
    src: resource.template('.config/nono/profiles/pi.jsonc.erb'),
    variables: {
      ...Context.currentVariables,
      atlassianSite: result.metadata?.site ?? '',
      atlassianEmail: result.metadata?.email ?? '',
    },
  });
});

// CA, password, bundle, and phantom env for the unsandboxed
// credential proxy. The process itself is started by ~/.zsh/bin/nono-proxy
// from the user session (1Password CLI cannot run under launchd).
task('set up nono-proxy state', when('darwin'), async () => {
  const stateDir = path.home.join('.local/state/nono-proxy');
  const caCert = stateDir.join('ca.crt');
  const caKey = stateDir.join('ca.key');
  const bundle = stateDir.join('bundle.crt');
  const passFile = stateDir.join('pass');

  await file({
    mode: '0700',
    path: stateDir.toString(),
    state: 'directory',
  });

  const caPresent = fs.existsSync(caCert) && fs.existsSync(caKey);
  const caCheck = caPresent
    ? await command(
      'openssl',
      ['x509', '-in', caCert.toString(), '-checkend', '0'],
      {failedWhen: () => false},
    )
    : null;
  // `command` returns null in check mode: treat an on-disk CA as valid so we
  // do not pretend we are about to regenerate it.
  const caValid = caPresent && (caCheck === null || caCheck.status === 0);

  if (!caValid) {
    if (caPresent) {
      await log.warn('nono-proxy CA expired; regenerating');
      await command('rm', ['-f', caCert.toString(), caKey.toString()]);
    } else {
      await log.info(`generating nono-proxy CA in ${stateDir}`);
    }

    // Must be EC (P-256) in PKCS#8: nono rejects RSA with WrongAlgorithm.
    await command('openssl', [
      'req',
      '-x509',
      '-newkey',
      'ec',
      '-pkeyopt',
      'ec_paramgen_curve:prime256v1',
      '-nodes',
      '-keyout',
      caKey.toString(),
      '-out',
      caCert.toString(),
      '-days',
      '365',
      '-subj',
      '/CN=nono proxy (local)',
      '-addext',
      'basicConstraints=critical,CA:TRUE',
    ]);
    await command('chmod', ['600', caKey.toString()]);
  }

  if (!fs.existsSync(caCert) || !fs.existsSync(caKey)) {
    await skip('nono-proxy CA not present');
    return;
  }

  // macOS has no PEM bundle of the system roots. Export them from the
  // SystemRootCertificates keychain.
  const result = await command('security', [
    'find-certificate',
    '-a',
    '-p',
    '/System/Library/Keychains/SystemRootCertificates.keychain',
  ]);

  if (!result) {
    await skip('could not read system TLS roots');
    return;
  }

  const roots = result.stdout;
  const caPem = await fs.promises.readFile(caCert, 'utf8');
  const rootsWithNl = roots.endsWith('\n') ? roots : `${roots}\n`;

  await file({
    contents: `${rootsWithNl}${caPem}`,
    path: bundle.toString(),
    state: 'file',
  });

  if (!fs.existsSync(passFile)) {
    const rand = await command('openssl', ['rand', '-hex', '16']);

    if (rand) {
      await file({
        contents: `${rand.stdout.trim()}\n`,
        mode: '0600',
        path: passFile.toString(),
        state: 'file',
      });
    }
  }

  if (!fs.existsSync(passFile)) {
    await skip('nono-proxy password not present');
    return;
  }

  // Always derive exports from the installed effective profile, including
  // when a failed metadata refresh preserved the previous profile.
  const installedProfile = path.home.join('.config/nono/profiles/pi.jsonc');
  if (!fs.existsSync(installedProfile)) {
    await skip('nono profile not present (first-run check mode)');
    return;
  }
  const profileText = await fs.promises.readFile(installedProfile, 'utf8');
  const setVars =
    JSON.parse(stripJsoncLineComments(profileText)).environment?.set_vars ?? {};

  // Explicitly share only portable, nonsecret metadata.
  const sharedNames = ['ATLASSIAN_SITE', 'ATLASSIAN_EMAIL'];
  const sharedEnv = sharedEnvExports(
    profileText,
    sharedNames.filter((name) => Object.hasOwn(setVars, name)),
  );

  await file({
    contents: sharedEnv,
    path: stateDir.join('shared.env').toString(),
    state: 'file',
  });

  await file({
    contents: phantomEnvExports(profileText),
    path: stateDir.join('phantoms.env').toString(),
    state: 'file',
  });
});

task('install ~/.npmrc', async () => {
  await file({
    path: '~/.npmrc',
    src: resource.file('.npmrc'),
    state: 'file',
  });
});

task('install ~/.docker/host/*', async () => {
  const hostHandle = variable.string('hostHandle');
  const src = resource.file('.docker/host', `${hostHandle}.json`);

  if (!(await isDecrypted(src))) {
    await skip(`no per-host Docker config for ${hostHandle}`);
    return;
  }

  await file({path: '~/.docker/host', state: 'directory'});
  await file({
    path: path.home.join('.docker/host', `${hostHandle}.json`),
    src,
    state: 'file',
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
    path: '~/dd',
    state: 'directory',
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
