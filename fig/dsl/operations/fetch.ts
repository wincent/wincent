import * as crypto from 'node:crypto';
import * as http from 'node:http';
import * as https from 'node:https';
import {join} from 'node:path';

import {log} from '../../console.ts';
import {createWriteStream, promises} from '../../fs.ts';
import tempdir from '../../fs/tempdir.ts';
import file from './file.ts';

const DIGEST_PREFIX = 'sha256:';

export default async function fetch({
  dest,
  checksum,
  encoding,
  group,
  mode,
  notify,
  owner,
  url,
  sudo,
}: {
  dest: string;
  checksum?: string;
  encoding?: BufferEncoding | null;
  group?: string;
  mode?: Mode;
  notify?: Array<string> | string;
  owner?: string;
  sudo?: boolean;
  url: string;
}): Promise<OperationResult> {
  await log.debug(`Download \`${url}\` to \`${dest}\``);

  if (checksum && !checksum.startsWith(DIGEST_PREFIX)) {
    throw new Error(`digests must start with "${DIGEST_PREFIX}" prefix`);
  }
  const sha256 = checksum?.slice(DIGEST_PREFIX.length);

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

  const requestedURLs: Array<string> = [];

  function go(url: string): Promise<OperationResult> {
    requestedURLs.push(url);
    return new Promise((resolve, reject) => {
      get(url, (response) => {
        if (response.statusCode === 301 || response.statusCode === 302) {
          if (requestedURLs.length > 10) {
            reject(
              new Error(
                `fetch(): Too many redirects: ${requestedURLs.join(' → ')}`,
              ),
            );
          } else {
            const location = response.headers.location;
            if (location) {
              go(location).then(resolve, reject);
            } else {
              reject(new Error('fetch(): Cannot redirect without Location'));
            }
          }
        } else {
          response.pipe(stream);

          stream.on('finish', async () => {
            stream.close();

            try {
              const contents = await promises.readFile(
                download,
                encoding === undefined ? 'utf8' : null,
              );

              if (sha256) {
                const hash = crypto.createHash('sha256');
                hash.update(contents);
                const digest = hash.digest('hex');
                if (digest !== sha256) {
                  reject(`digest ${digest} does not match expected ${sha256}`);
                }
              }

              const result = await file({
                contents,
                encoding,
                group,
                mode,
                notify,
                owner,
                path: dest,
                state: 'file',
                sudo,
              });

              resolve(result);
            } catch (error) {
              reject(error);
            }
          });
        }
      }).on('error', (error) => {
        reject(error);
      });
    });
  }

  return go(url);
}
