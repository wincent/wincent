import Context from '../Context.js';
import ErrorWithMetadata from '../ErrorWithMetadata.js';
import {log} from '../console.js';
import executable from '../executable.js';
import run from '../run.js';
import stringify from '../stringify.js';

type Options = {
  sudo?: boolean;
};

export default async function chmod(
  mode: Mode,
  path: string,
  options: Options = {},
): Promise<Error | null> {
  const passphrase = options.sudo ? await Context.sudoPassphrase : undefined;

  const args = [mode, path];

  await log.debug(`Setting mode: ${args.join(' ')}`);

  const result = await run(executable('chmod'), args, {passphrase});

  if (result.status === 0) {
    return null;
  } else {
    await log.debug(stringify(result));

    return (
      result.error ||
      new ErrorWithMetadata(`\`chmod ${args.join(' ')}\` failed`)
    );
  }
}
