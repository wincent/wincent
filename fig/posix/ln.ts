import Context from '../Context.ts';
import ErrorWithMetadata from '../ErrorWithMetadata.ts';
import {log} from '../console.ts';
import executable from '../executable.ts';
import run from '../run.ts';
import stringify from '../stringify.ts';

type Options = {
  force?: boolean;
  sudo?: boolean;
  // TODO: consider adding support for hardlinks too
};

export default async function ln(
  source: string,
  target: string,
  options: Options = {},
): Promise<Error | null> {
  const passphrase = options.sudo ? await Context.sudoPassphrase : undefined;

  const args = [options.force ? '-sfn' : '-sn', source, target];

  await log.debug(`Linking: ${args.join(' ')}`);

  const result = await run(executable('ln'), args, {passphrase});

  if (result.status === 0) {
    return null;
  } else {
    await log.debug(stringify(result));

    return (
      result.error || new ErrorWithMetadata(`\`ln ${args.join(' ')}\` failed`)
    );
  }
}
