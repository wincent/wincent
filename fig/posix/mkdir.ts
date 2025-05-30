import Context from '../Context.js';
import ErrorWithMetadata from '../ErrorWithMetadata.js';
import {log} from '../console.js';
import executable from '../executable.js';
import run from '../run.js';
import stringify from '../stringify.js';

type Options = {
  intermediate?: boolean;
  mode?: Mode;
  sudo?: boolean;
};

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
