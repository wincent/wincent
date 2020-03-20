import * as fs from 'fs';
import * as path from 'path';
import {promisify} from 'util';

import {run} from './harness';

const readdir = promisify(fs.readdir);

export default async function test() {
  // TODO: log start here, maybe show timing
  for await (const file of walk(__dirname)) {
    if (file.endsWith('-test.js')) {
      try {
        require(file);
      } catch (error) {
        console.log('caught', error);
      }
    }
  }

  await run();
}

// TODO: move into separate module
async function* walk(directory: string): AsyncGenerator<string> {
  const entries = await readdir(directory, {withFileTypes: true});

  for (const entry of entries) {
    if (entry.isDirectory()) {
      yield* walk(path.join(directory, entry.name.toString()));
    } else {
      yield path.join(directory, entry.name.toString());
    }
  }
}
