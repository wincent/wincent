import {backup, command, file, helpers, path, task, variable} from 'fig';

const {when} = helpers;

task('make directories', when('wincent', 'arch'), async () => {
  await file({path: '~/.bitcoin', state: 'directory'});
  await file({path: '~/.config', state: 'directory'});
});

task('move originals to ~/.backups', when('wincent', 'arch'), async () => {
  const files = variable.paths('files');

  for (const src of files) {
    await backup({src});
  }
});

task('create symlinks', when('wincent', 'arch'), async () => {
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

// TODO: fix smell here (implicit dependency on "aur" aspect to install yay)
task('install packages', when('wincent', 'arch'), async () => {
  // TODO: consider running `yay -Qi $package` to see whether already installed
  await command('yay', ['-S', '--noconfirm', ...variable.strings('packages')]);
});

// TODO: consider auto-starting `systemctl start bitcoind`
// TODO: dbcache=10000 in /etc/bitcoin/bitcoin.conf
// see: https://bitcoin.stackexchange.com/questions/102803/what-are-the-maximum-useful-memory-limits-for-a-bitcoind-full-node
