import {
  backup,
  command,
  file,
  helpers,
  path,
  skip,
  variable,
} from 'fig';

const {arch} = helpers;

arch.task('make directories', async () => {
  if (variable('identity') === 'wincent') {
    await file({path: '~/.bitcoin', state: 'directory'});
    await file({path: '~/.config', state: 'directory'});
  } else {
    skip('identity not "wincent"');
  }
});

arch.task('move originals to ~/.backups', async () => {
  if (variable('identity') === 'wincent') {
    const files = variable.paths('files');

    for (const src of files) {
      await backup({src});
    }
  } else {
    skip('identity not "wincent"');
  }
});

arch.task('create symlinks', async () => {
  if (variable('identity') === 'wincent') {
    const files = variable.paths('files');

    for (const src of files) {
      await file({
        force: true,
        path: path.home.join(src),
        src: path.aspect.join('files', src),
        state: 'link',
      });
    }
  } else {
    skip('identity not "wincent"');
  }
});

// TODO: fix smell here (implicit dependency on "aur" aspect to install yay)
arch.task('install packages', async () => {
  if (variable('identity') === 'wincent') {
    // TODO: consider running `yay -Qi $package` to see whether already installed
    await command('yay', ['-S', '--noconfirm', ...variable.strings('packages')]);
  } else {
    skip('identity not "wincent"');
  }
});

// TODO: consider auto-starting `systemctl start bitcoind`
// TODO: dbcache=10000 in /etc/bitcoin/bitcoin.conf
// see: https://bitcoin.stackexchange.com/questions/102803/what-are-the-maximum-useful-memory-limits-for-a-bitcoind-full-node
