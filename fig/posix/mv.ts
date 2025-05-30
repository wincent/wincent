import Context from '../Context.js';
import ErrorWithMetadata from '../ErrorWithMetadata.js';
import {log} from '../console.js';
import executable from '../executable.js';
import run from '../run.js';
import stringify from '../stringify.js';

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
