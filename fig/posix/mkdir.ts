import Context from '../Context.ts';
import ErrorWithMetadata from '../ErrorWithMetadata.ts';
import {log} from '../console.ts';
import executable from '../executable.ts';
import run from '../run.ts';
import stringify from '../stringify.ts';

type Options = {
  intermediate?: boolean;
  mode?: Mode;
  sudo?: boolean;
};

/**
 * Alternative to `fs.mkdir()` with superpowers (like the ability to run with
 * `sudo`).
 */
export default async function mkdir(
  path: string,
  options: Options = {},
): Promise<Error | null> {
  const args = [path];

  if (options.intermediate) {
    args.unshift('-p');
  }

  if (options.mode) {
    args.unshift('-m', options.mode);
  }

  const passphrase = options.sudo ? await Context.sudoPassphrase : undefined;

  await log.debug(`Making directory: ${args.join(' ')}`);

  const result = await run(executable('mkdir'), args, {passphrase});

  if (result.status === 0) {
    return null;
  } else {
    await log.debug(stringify(result));

    return (
      result.error ||
      new ErrorWithMetadata(`\`mkdir ${args.join(' ')}\` failed`)
    );
  }
}
