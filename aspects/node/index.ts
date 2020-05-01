import {command, file, task} from 'fig';
import path from 'fig/path.js';

const env = {
    ...process.env,
    N_PREFIX: path.home.join('n'),
};

const n = path.root.join('vendor/n/bin/n');

task('make ~/n', async () => {
    await file({path: '~/n', state: 'directory'});
});

task('hide ~/n', async () => {
    await command('chflags', ['hidden', '~/n']);
});

task('install Node.js v10.16.0', async () => {
    await command(n, ['10.16.0'], {
        creates: '~/n/n/versions/node/10.16.0/bin/node',
        env,
    });
});

// TODO install global packages
// - bs-platform
// - flow-bin
// - flow-typed
// - gatsby-cli
// - javascript-typescript-langserver
// - neovim
// - ocaml-language-server
// - reason-cli
// - source-map-explorer
// - typescript
