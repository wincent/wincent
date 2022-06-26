import {command, file, handler, helpers, path, skip, task, variable} from 'fig';

const {when} = helpers;

task('set up hostname', when('arch'), async () => {
  // Note that "hostname" is the variable configured in the aspect.json, which
  // overwrites the "hostname" that comes in from the Attributes class (via
  // Node's `os.hostname()`).
  const hostname = variable.string('hostname');
  const result = await command('hostname', []);

  if (
    variable('identity') === 'wincent' &&
    result!.stdout.trim() !== hostname
  ) {
    await command('hostnamectl', ['set-hostname', hostname], {sudo: true});
  } else {
    await skip();
  }
});

task('create ~/.config/systemd/user', when('arch'), async () => {
  // TODO: I am doing something similar with a `for` loop in the "aur" aspect;
  // maybe I should add `recurse: true` support to the `file` DSL.
  await file({path: '~/.config', state: 'directory'});
  await file({path: '~/.config/systemd', state: 'directory'});
  await file({path: '~/.config/systemd/user', state: 'directory'});
});

task(
  'set up ~/.config/systemd/user/pulseaudio-null-sink.service',
  when('arch'),
  async () => {
    const unit = '.config/systemd/user/pulseaudio-null-sink.service';
    await file({
      force: true,
      notify: ['systemd daemon-reload', 'enable pulseaudio-null-sink.service'],
      path: path.home.join(unit),
      src: path.aspect.join('files', unit),
      state: 'link',
    });
  }
);

task(
  'set up ~/.config/systemd/user/ssh-agent.service',
  when('arch'),
  async () => {
    const unit = '.config/systemd/user/ssh-agent.service';
    await file({
      force: true,
      notify: ['systemd daemon-reload', 'enable ssh-agent.service'],
      path: path.home.join(unit),
      src: path.aspect.join('files', unit),
      state: 'link',
    });
  }
);

handler('systemd daemon-reload', async () => {
  await command('systemctl', ['--user', 'daemon-reload']);
});

handler('enable pulseaudio-null-sink.service', async () => {
  await command('systemctl', [
    '--user',
    'enable',
    'pulseaudio-null-sink.service',
    '--now',
  ]);
});

handler('enable ssh-agent.service', async () => {
  await command('systemctl', [
    '--user',
    'enable',
    'ssh-agent.service',
    '--now',
  ]);
});
