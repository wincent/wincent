import Context from '../../Context.js';
import ErrorWithMetadata from '../../ErrorWithMetadata.js';
import {debug, log} from '../../console.js';
import stat from '../../fs/stat.js';
import path from '../../path.js';
import run from '../../run.js';
import stringify from '../../stringify.js';

import type {Result} from '../../run.js';

/**
 * Implements basic shell expansion (of ~).
 */
export default async function command(
  executable: string,
  args: Array<string>,
  options: {
    chdir?: string;
    creates?: string;
    env?: NodeJS.ProcessEnv;
    failedWhen?: (result: Result | null) => boolean;
    notify?: string;
    raw?: boolean;
    sudo?: boolean;
  } = {}
): Promise<Result | null> {
  const description = [executable, ...args].join(' ');

  if (options.creates) {
    const stats = await stat(path(options.creates).expand);

    if (stats instanceof Error) {
      throw stats;
    }

    if (stats !== null) {
      Context.informSkipped(`command \`${description}\``);

      return null;
    }
  }

  try {
    log.debug(
      `Run command \`${description}\` with options: ${stringify(options)}`
    );

    if (Context.currentOptions?.check) {
      Context.informSkipped(`command \`${description}\``);

      return null;
    } else {
      const result = await run(
        path(executable).expand,
        args.map((arg) => (options.raw ? arg : path(arg).expand)),
        {
          chdir: options.chdir ? path(options.chdir).expand : undefined,
          env: options.env,
          passphrase: options.sudo ? await Context.sudoPassphrase : undefined,
        }
      );

      if (
        options.failedWhen ? options.failedWhen(result) : result.status !== 0
      ) {
        throw new ErrorWithMetadata(`command \`${description}\` failed`, {
          ...result,
          error: result.error?.toString() ?? null,
        });
      }

      Context.informChanged(`command \`${description}\``, options.notify);

      return result;
    }
  } catch (error) {
    if (error instanceof ErrorWithMetadata) {
      Context.informFailed(error);
    } else {
      debug(() => console.log(error));
      Context.informFailed(`command \`${description}\` failed`);
    }
  }

  return null;
}
