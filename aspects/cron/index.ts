import {
  command,
  cron,
  file,
  helpers,
  path,
  resource,
  skip,
  template,
  task,
  variable,
} from 'fig';

const {wincent} = helpers;

// For now, we only have one cron job, and we only want to run it on my personal
// machine.
const scheduleCron = () =>
  variable('identity') === 'wincent' && variable('profile') === 'personal';

task('create ~/Library/Cron', async () => {
  await file({
    path: '~/Library/Cron',
    state: 'directory',
  });
});

task('fill templates', async () => {
  if (scheduleCron()) {
    for (const src of resource.templates('*.erb')) {
      await template({
        mode: '0755',
        path: path('~/Library/Cron').join(src.basename.strip('.erb')),
        src,
      });
    }
  } else {
    skip();
  }
});

task('schedule check-git cron job', async () => {
  if (scheduleCron()) {
    await cron({
      id: 'check-git',
      hour: '8,12,16,20',
      job: '$HOME/Library/Cron/check-git.sh',
      minute: '0',
    });
  } else {
    skip();
  }
});

wincent.task('touch ~/mbox', async () => {
  // Because cron jobs can produce mail.
  await file({path: '~/mbox', state: 'touch'});
});

wincent.task('hide ~/mbox', async () => {
  await command('chflags', ['hidden', '~/mbox']);
});
