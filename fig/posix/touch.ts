import Context from '../Context.ts';
import ErrorWithMetadata from '../ErrorWithMetadata.ts';
import {log} from '../console.ts';
import executable from '../executable.ts';
import run from '../run.ts';
import stringify from '../stringify.ts';

type Options = {
  sudo?: boolean;
};

export default async function touch(
  path: string,
  options: Options = {},
): Promise<Error | null> {
  const passphrase = options.sudo ? await Context.sudoPassphrase : undefined;

  // Note: on Linux, the `-f` flag will be ignored.
  const args = ['-f', path];

  await log.debug(`Touching: ${args.join(' ')}`);

  const result = await run(executable('touch'), args, {passphrase});

  if (result.status === 0) {
    return null;
  } else {
    await log.debug(stringify(result));

    return (
      result.error ||
      new ErrorWithMetadata(`\`touch ${args.join(' ')}\` failed`)
    );
  }
}
