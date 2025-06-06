import * as path from 'node:path';
import * as url from 'node:url';

import {log} from './console.ts';
import {promises as fs} from './fs.ts';
import {run} from './test/harness.ts';

export default async function test() {
  const __dirname = path.dirname(url.fileURLToPath(import.meta.url));

  for await (const file of walk(__dirname)) {
    if (file.endsWith('-test.ts')) {
      try {
        await import(file);
      } catch (error) {
        if (error instanceof Error) {
          await log.error(error.toString());
        } else {
          await log.error(Object.prototype.toString.call(error));
        }
      }
    }
  }

  await run();
}

// TODO: move into separate module
async function* walk(directory: string): AsyncGenerator<string> {
  const entries = await fs.readdir(directory, {withFileTypes: true});

  for (const entry of entries) {
    if (entry.isDirectory()) {
      yield* walk(path.join(directory, entry.name.toString()));
    } else {
      yield path.join(directory, entry.name.toString());
    }
  }
}
