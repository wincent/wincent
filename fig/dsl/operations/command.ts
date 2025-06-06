import Context from '../../Context.ts';
import ErrorWithMetadata from '../../ErrorWithMetadata.ts';
import {log} from '../../console.ts';
import stat from '../../fs/stat.ts';
import path from '../../path.ts';
import run from '../../run.ts';
import stringify from '../../stringify.ts';

import type {Result} from '../../run.ts';

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
    notify?: Array<string> | string;
    raw?: boolean;
    sudo?: boolean;
  } = {},
): Promise<Result | null> {
  const description = [executable, ...args].join(' ');

  if (options.creates) {
    const stats = await stat(path(options.creates).expand);

    if (stats instanceof Error) {
      throw stats;
    }

    if (stats !== null) {
      await Context.informSkipped(`command \`${description}\``);

      return null;
    }
  }

  try {
    await log.debug(
      `Run command \`${description}\` with options: ${stringify(options)}`,
    );

    if (Context.options.check) {
      await Context.informSkipped(`command \`${description}\``);

      return null;
    } else {
      const result = await run(
        path(executable).expand,
        args.map((arg) => (options.raw ? arg : path(arg).expand)),
        {
          chdir: options.chdir ? path(options.chdir).expand : undefined,
          env: options.env,
          passphrase: options.sudo ? await Context.sudoPassphrase : undefined,
        },
      );

      if (
        options.failedWhen ? options.failedWhen(result) : result.status !== 0
      ) {
        throw new ErrorWithMetadata(`command \`${description}\` failed`, {
          ...result,
          error: result.error?.toString() ?? null,
        });
      }

      await Context.informChanged(`command \`${description}\``, options.notify);

      return result;
    }
  } catch (error) {
    if (error instanceof ErrorWithMetadata) {
      Context.informFailed(error);
    } else {
      await log.debug(String(error));
      Context.informFailed(`command \`${description}\` failed`);
    }
  }

  return null;
}
