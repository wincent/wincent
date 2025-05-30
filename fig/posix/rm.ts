import Context from '../Context.js';
import ErrorWithMetadata from '../ErrorWithMetadata.js';
import {log} from '../console.js';
import executable from '../executable.js';
import run from '../run.js';
import stringify from '../stringify.js';

type Options = {
  recurse?: boolean;
  sudo?: boolean;
};

export default async function rm(
  path: string,
  options: Options = {},
): Promise<Error | null> {
  const passphrase = options.sudo ? await Context.sudoPassphrase : undefined;

  const args = ['-f', path];

  if (options.recurse) {
    args.unshift('-r');
  }

  await log.debug(`Removing: ${args.join(' ')}`);

  const result = await run(executable('rm'), args, {passphrase});

  if (result.status === 0) {
    return null;
  } else {
    await log.debug(stringify(result));

    return (
      result.error || new ErrorWithMetadata(`\`rm ${args.join(' ')}\` failed`)
    );
  }
}
