import {attributes, command, file, line, resource, task, template} from 'fig';
import path from 'fig/path.js';

task('make ~/Sites/UserScripts/*', async () => {
    const base = path('~/Sites/UserScripts');

    await file({path: '~/Sites', state: 'directory'});
    await file({path: base, state: 'directory'});

    for (const directory of resource.templates('UserScripts/*')) {
        await file({path: base.join(directory.basename), state: 'directory'});
    }
});

task('fill templates', async () => {
    for (const src of resource.templates('UserScripts/*/*.js')) {
        await template({
            path: path('~/Sites/UserScripts').join(
                ...src.last(2)
            ),
            src,
        });
    }
});

task('configure Apache', async () => {
    await template({
        group: 'wheel',
        owner: 'root',
        path: path('/private/etc/apache2/users').join(`${attributes.username}.conf`),
        src: resource.template('apache2/users/user.conf.erb'),
        sudo: true,
    });

    await line({
        path: '/etc/apache2/extra/httpd-userdir.conf',
        regexp: /^\s*#?\s*Include\s+\/private\/etc\/apache2\/users\/\*\.conf\b/,
        sudo: true,
        line: 'Include /private/etc/apache2/users/*.conf',
    });

    await line({
        path: '/private/etc/apache2/httpd.conf',
        regexp: /^\s*#?\s*LoadModule\s+userdir_module\s+libexec\/apache2\/mod_userdir\.so\b/,
        sudo: true,
        line: 'LoadModule userdir_module libexec/apache2/mod_userdir.so'
    });

    await line({
        path: '/private/etc/apache2/httpd.conf',
        regexp: /^\s*#?\s*Include\s+\/private\/etc\/apache2\/extra\/httpd-userdir\.conf\b/,
        sudo: true,
        line: 'Include /private/etc/apache2/extra/httpd-userdir.conf'
    });
});

task('start Apache', async () => {
    await command('launchctl',  ['load', '-w', '/System/Library/LaunchDaemons/org.apache.httpd.plist'], {sudo: true});
});

// TODO: only do this if we changed something
task('reload Apache', async () => {
    await command('apachectl', ['restart'], {sudo: true});
});
