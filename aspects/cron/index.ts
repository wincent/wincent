import {
  command,
  cron,
  file,
  helpers,
  path,
  resource,
  template,
  task,
} from 'fig';

const {when} = helpers;

task('create ~/Library/Cron', when('wincent', 'personal'), async () => {
  await file({
    path: '~/Library/Cron',
    state: 'directory',
  });
});

task('fill templates', when('wincent', 'personal'), async () => {
  for (const src of resource.templates('*.erb')) {
    await template({
      mode: '0755',
      path: path('~/Library/Cron').join(src.basename.strip('.erb')),
      src,
    });
  }
});

task('schedule check-git cron job', when('wincent', 'personal'), async () => {
  await cron({
    id: 'check-git',
    hour: '8,12,16,20',
    job: '$HOME/Library/Cron/check-git.sh',
    minute: '0',
  });
});

task('touch ~/mbox', when('wincent'), async () => {
  // Because cron jobs can produce mail.
  await file({path: '~/mbox', state: 'touch'});
});

task('hide ~/mbox', when('wincent'), async () => {
  await command('chflags', ['hidden', '~/mbox']);
});
