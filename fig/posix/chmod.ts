import Context from '../Context.ts';
import ErrorWithMetadata from '../ErrorWithMetadata.ts';
import {log} from '../console.ts';
import executable from '../executable.ts';
import run from '../run.ts';
import stringify from '../stringify.ts';

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
