import {join} from 'path';

import {resource, task, template} from '../../src/Fig';
import tempdir from '../../src/fs/tempdir';

task('template a file', async () => {
    await template({
        path: join(await tempdir('meta'), 'sample.txt'),
        src: resource.template('sample.txt.erb'),
        variables: {
            greeting: 'Hello',
            names: ['Bob', 'Jane'],
        },
    });
});
