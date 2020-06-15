import {
    command,
    cron,
    file,
    path,
    resource,
    skip,
    template,
    task,
    variable,
} from 'fig';

task('create ~/Library/Cron', async () => {
    await file({
        path: '~/Library/Cron',
        state: 'directory',
    });
});

task('fill templates', async () => {
    if (variable('identity') === 'wincent') {
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
    if (variable('identity') === 'wincent') {
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

task('schedule liferay-frontend-sync cron job', async () => {
    if (variable('identity') === 'wincent') {
        await cron({
            id: 'liferay-frontend-sync',
            job: '$HOME/Library/Cron/liferay-frontend-sync.sh',
            minute: '*',
        });
    } else {
        skip();
    }
});

task('touch ~/mbox', async () => {
    if (variable('identity') === 'wincent') {
        // Because cron jobs can produce mail.
        await file({path: '~/mbox', state: 'touch'});
    } else {
        skip();
    }
});

task('hide ~/mbox', async () => {
    if (variable('identity') === 'wincent') {
        await command('chflags', ['hidden', '~/mbox']);
    } else {
        skip();
    }
});
