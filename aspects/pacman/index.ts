import {
  attributes,
  command,
  file,
  handler,
  helpers,
  line,
  path,
  task,
  variable,
} from 'fig';

const {when} = helpers;

task('copy /etc/pacman.conf', when('arch'), async () => {
  await file({
    path: '/etc/pacman.conf',
    src: path.aspect.join('files', 'etc/pacman.conf'),
    state: 'file',
    sudo: true,
  });
});

task('refresh package databases', when('arch'), async () => {
  await command('pacman', ['-Syy'], {sudo: true});
});

task('install packages', when('arch'), async () => {
  // TODO: make this check rather than running unconditionally?
  await command(
    'pacman',
    ['-S', '--noconfirm', ...variable.strings('packages')],
    {
      sudo: true,
    }
  );
});

task('run updatedb', when('arch'), async () => {
  await command('updatedb', [], {sudo: true});
});

// Tweaks: should be moved into separate aspects.
task('configure faillock.conf', when('arch'), async () => {
  await line({
    path: '/etc/security/faillock.conf',
    regexp: /^\s*#?\s*deny\s*=/,
    sudo: true,
    line: 'deny = 10',
  });

  await line({
    path: '/etc/security/faillock.conf',
    regexp: /^\s*#?\s*unlock_time\s*=/,
    sudo: true,
    line: 'unlock_time = 60',
  });
});

// TODO: `sudo npm install -g n`
// TODO: `export N_PREFIX=~`
// TODO: run `n ??.??.??`

task('create suspend hook', when('arch'), async () => {
  await file({
    notify: 'enable suspend hook',
    path: '/etc/systemd/system/suspend@.service',
    src: path.aspect.join('files', 'etc/systemd/system/suspend@.service'),
    state: 'file',
    sudo: true,
  });
});

handler('enable suspend hook', async () => {
  await command('systemctl', ['enable', `suspend@${attributes.username}`], {
    sudo: true,
  });
});

// TODO: set up sensors or something... i'm not getting cpu sensors
// `sudo sensors-detect --auto` hard froze my machine
// `sudo sensors-detect` saying YES to everything but the last question is fine

// TODO: figure out why font seems wrong in i3 status bar as well
