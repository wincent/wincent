import * as http from 'http';
import * as https from 'https';
import {join} from 'path';

import {log} from '../../console.js';
import {createWriteStream, promises} from '../../fs.js';
import tempdir from '../../fs/tempdir.js';
import file from './file.js';

export default async function fetch({
  dest,
  encoding,
  group,
  mode,
  notify,
  owner,
  url,
}: {
  dest: string;
  encoding?: BufferEncoding | null;
  group?: string;
  mode?: Mode;
  notify?: string;
  owner?: string;
  url: string;
}): Promise<OperationResult> {
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
          const contents = await promises.readFile(
            download,
            encoding === undefined ? 'utf8' : null
          );

          const result = await file({
            contents,
            encoding,
            group,
            mode,
            notify,
            owner,
            path: dest,
            state: 'file',
          });

          resolve(result);
        } catch (error) {
          reject(error);
        }
      });
    }).on('error', (error) => {
      reject(error);
    });
  });
}
