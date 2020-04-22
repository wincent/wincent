import {command, file, resource, skip, template, task} from 'fig';

import path from 'fig/path.js';

// TODO: set up node before we run these

task('test karabiner.json generator', async () => {
    const test = resource.support('karabiner-test.js');

    await command('node', [test]);
});

let config: string | undefined;

task('prepare karabiner.json', async () => {
    const script = resource.support('karabiner.js');

    const result = await command('node', [script, '--emit-karabiner-config']);

    if (result) {
        config = result.stdout;
    }
});

task('make directories', async () => {
    await file({path: '~/.config', state: 'directory'});
    await file({path: '~/.config/karabiner', state: 'directory'});
});

task('write karabiner.json', async () => {
    const src = path('.config/karabiner/karabiner.json.erb');

    if (!config) {
        return skip('no contents prepared for karabiner.json');
    }

    await template({
        path: path.home.join(src.strip('.erb')),
        src: resource.template(src),
        variables: {config},
    });
});

// This is a bit random having this in here, but it's a dependency of our
// Hammerspoon set-up; should possibly move the related bit of that in here?
task('write karabiner-sudoers', async () => {
    await template({
        path: '/private/etc/sudoers.d/karabiner-sudoers',
        src: resource.template('karabiner-sudoers.erb'),
        sudo: true,
    });
});
