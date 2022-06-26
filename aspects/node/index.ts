import {command, file, helpers, path, skip, task} from 'fig';

const {when} = helpers;

const NODE_VERSION = '18.0.0';

const n = path.root.join('vendor/n/bin/n');
const bin = path.home.join(`n/bin`);
const npm = bin.join('npm');

task('make ~/n', async () => {
  await file({path: '~/n', state: 'directory'});
});

task('hide ~/n', when('darwin'), async () => {
  await command('chflags', ['hidden', '~/n']);
});

task(`install Node.js v${NODE_VERSION}`, async () => {
  const env = {
    ...process.env,
    N_PREFIX: path.home.join('n'),
  };

  await command(n, [NODE_VERSION], {
    creates: `~/n/n/versions/node/${NODE_VERSION}/bin/node`,
    env,
  });
});

task('install global packages', async () => {
  const env = {
    ...process.env,
    N_PREFIX: path.home.join('n'),
    PATH: `${bin}:${process.env.PATH}`,
  };

  const packages = [
    'typescript-language-server',
    'neovim',
    'source-map-explorer',
    'typescript',
    'vim-language-server',
    'yarn@1.22.15',
  ];

  for (const name of packages) {
    const result = await command(npm, ['ls', '-g', '--json', name], {
      env,
      failedWhen: () => false,
    });

    if (result && result.status === 0) {
      await skip(`package ${name} (already installed)`);
    } else {
      await command(npm, ['install', '-g', name], {env});
    }
  }
});
