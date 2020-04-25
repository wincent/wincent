import * as http from 'http';
import * as https from 'https';
import {join} from 'path';

import {log} from '../../console.js';
import {createWriteStream, promises} from '../../fs.js';
import tempdir from '../../fs/tempdir.js';
import file from './file.js';

export default async function fetch({
    dest,
    group,
    mode,
    owner,
    url,
}: {
    dest: string;
    group?: string;
    mode?: Mode;
    owner?: string;
    url: string;
}): Promise<void> {
    log.debug(`Download \`${url}\` to \`${dest}\``);

    let get: typeof https.get | typeof http.get;

    if (url.startsWith('https:')) {
        get = https.get;
    } else if (url.startsWith('http:')) {
        get = http.get;
    } else {
        throw new Error(`Invalid URL: ${url}`);
    }

    const dir = await tempdir('fetch');
    const download = join(dir, 'download');

    const stream = createWriteStream(download, 'utf8');

    return new Promise((resolve, reject) => {
        get(url, (response) => {
            response.pipe(stream);

            stream.on('finish', async () => {
                stream.close();

                try {
                    const contents = await promises.readFile(download, 'utf8');

                    await file({
                        contents,
                        group,
                        mode,
                        owner,
                        path: dest,
                        state: 'file',
                    });

                    resolve();
                } catch (error) {
                    reject(error);
                }
            });
        }).on('error', (error) => {
            reject(error);
        });
    });
}
