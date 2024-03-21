import {command, fetch, task} from 'fig';

const INSTALL = 'vendor/nix/install';

task('download install script to support directory', async () => {
  await fetch({
    dest: INSTALL,
    mode: '0755',
    url: 'https://nixos.org/nix/install',
  });
});
