import {
  attributes,
  command,
  file,
  handler,
  helpers,
  line,
  path,
  resource,
  task,
  template,
} from 'fig';

const {when} = helpers;

task('make ~/Sites/UserScripts/*', when('wincent'), async () => {
  const base = path('~/Sites/UserScripts');

  await file({path: '~/Sites', state: 'directory'});
  await file({path: base, state: 'directory'});

  for (const directory of resource.templates('UserScripts/*')) {
    await file({
      path: base.join(directory.basename),
      state: 'directory',
    });
  }
});

task('fill templates', when('wincent'), async () => {
  for (const src of resource.templates('UserScripts/*/*.js')) {
    await template({
      path: path('~/Sites/UserScripts').join(...src.last(2)),
      src,
    });
  }
});

task('configure Apache', when('wincent'), async () => {
  await template({
    group: 'wheel',
    owner: 'root',
    notify: 'restart Apache',
    path: path('/private/etc/apache2/users').join(
      `${attributes.username}.conf`
    ),
    src: resource.template('apache2/users/user.conf.erb'),
    sudo: true,
  });

  await line({
    notify: 'restart Apache',
    path: '/etc/apache2/extra/httpd-userdir.conf',
    regexp: /^\s*#?\s*Include\s+\/private\/etc\/apache2\/users\/\*\.conf\b/,
    sudo: true,
    line: 'Include /private/etc/apache2/users/*.conf',
  });

  await line({
    notify: 'restart Apache',
    path: '/private/etc/apache2/httpd.conf',
    regexp:
      /^\s*#?\s*LoadModule\s+userdir_module\s+libexec\/apache2\/mod_userdir\.so\b/,
    sudo: true,
    line: 'LoadModule userdir_module libexec/apache2/mod_userdir.so',
  });

  await line({
    notify: 'restart Apache',
    path: '/private/etc/apache2/httpd.conf',
    regexp:
      /^\s*#?\s*Include\s+\/private\/etc\/apache2\/extra\/httpd-userdir\.conf\b/,
    sudo: true,
    line: 'Include /private/etc/apache2/extra/httpd-userdir.conf',
  });
});

handler('restart Apache', async () => {
  await command(
    'launchctl',
    ['load', '-w', '/System/Library/LaunchDaemons/org.apache.httpd.plist'],
    {sudo: true}
  );

  await command('apachectl', ['restart'], {sudo: true});
});
