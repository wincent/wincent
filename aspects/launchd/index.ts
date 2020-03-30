import {resource, template, task} from '../../src/Fig';

task('configure (global) LaunchDaemons', async () => {
  const items = [
    {
      path: '/Library/LaunchDaemons/limit.maxfiles.plist',
      variables: {
        arguments: ['limit', 'maxfiles', 65536, 65536],
        label: 'limit.maxfiles',
      },
    },
    {
      path: '/Library/LaunchDaemons/limit.maxproc.plist',
      variables: {
        arguments: ['limit', 'maxproc', 2048, 2048],
        label: 'limit.maxproc',
      },
    },
  ];

  for (const {path, variables} of items) {
    await template({
      group: 'wheel',
      mode: '0644',
      owner: 'root',
      path,
      src: resource.template('run.plist.erb'),
      variables,
    });
  }
});

task('configure (local) LaunchAgents', async () => {
  const items = [
    {
      path: '~/Library/LaunchAgents/setenv.lang.plist',
      variables: {
        arguments: ['setenv', 'LANG', 'en_US.UTF-8'],
        label: 'setenv.lang',
      },
    },
    {
      path: '~/Library/LaunchAgents/setenv.lc_time.plist',
      variables: {
        arguments: ['setenv', 'LC_TIME', 'en_AU.UTF-8'],
        label: 'setenv.lc_time',
      },
    },
  ];

  for (const {path, variables} of items) {
    await template({
      mode: '0644',
      path,
      src: resource.template('run.plist.erb'),
      variables,
    });
  }
});
