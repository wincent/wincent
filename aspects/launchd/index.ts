import {path, template, task} from '../../src/Fig';

task('configure (global) LaunchDaemons', () => {
  [
    {
      dest: '/Library/LaunchDaemons/limit.maxfiles.plist',
      variables: {
        arguments: ['limit', 'maxfiles', 65536, 65536],
      },
    },
    {
      dest: '/Library/LaunchDaemons/limit.maxproc.plist',
      variables: {
        arguments: ['limit', 'maxproc', 2048, 2048],
      },
    },
  ].forEach(({dest, variables}) => {
    template({
      group: 'wheel',
      mode: '0644',
      owner: 'root',
      path: dest,
      src: path.template('run.plist.erb'),
      variables,
    });
  });
});

task('configure (local) LaunchAgents', () => {});

/*
# @see http://unix.stackexchange.com/questions/108174/how-to-persist-ulimit-settings-in-osx-mavericks
- name: launchd | configure (global) LaunchDaemons
  template: group=wheel
            mode=0644
            owner=root
            dest=/Library/LaunchDaemons/{{ item.label }}.plist
            src=run.plist
  loop:
    - label: limit.maxproc
      args: ['limit', 'maxproc', 2048, 2048]
    - label: limit.maxfiles
      args: ['limit', 'maxfiles', 65536, 65536]
  loop_control:
    label: '{{item.label}}'
  become: !!bool yes

- name: launchd | configure (local) LaunchAgents
  template: mode=0644
            dest=~/Library/LaunchAgents/{{ item.label }}.plist
            src=run.plist
  loop:
    - label: setenv.lang
      args: ['setenv', 'LANG', 'en_US.UTF-8']
    - label: setenv.lc_time
      args: ['setenv', 'LC_TIME', 'en_AU.UTF-8']
  loop_control:
    label: '{{item.label}}'
*/
