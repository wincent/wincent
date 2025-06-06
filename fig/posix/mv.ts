import Context from '../Context.ts';
import ErrorWithMetadata from '../ErrorWithMetadata.ts';
import {log} from '../console.ts';
import executable from '../executable.ts';
import run from '../run.ts';
import stringify from '../stringify.ts';

type Options = {
  sudo?: boolean;
};

export default async function mv(
  source: string,
  target: string,
  options: Options = {},
): Promise<Error | null> {
  const passphrase = options.sudo ? await Context.sudoPassphrase : undefined;

  await log.debug(`Moving: ${source} ${target}`);

  // TODO: consider passing -f here
  const result = await run(executable('mv'), [source, target], {passphrase});

  if (result.status === 0) {
    return null;
  } else {
    await log.debug(stringify(result));

    return (
      result.error || new ErrorWithMetadata(`\`mv ${source} ${target}\` failed`)
    );
  }
}
