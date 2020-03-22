import * as fs from 'fs';
import * as path from 'path';
import {promisify} from 'util';

import {log} from '../console';
import {run} from './harness';

const readdir = promisify(fs.readdir);

export default async function test() {
  for await (const file of walk(path.join(__dirname, '..'))) {
    if (file.endsWith('-test.js')) {
      try {
        require(file);
      } catch (error) {
        log.error(error);
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
