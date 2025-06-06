import Context from '../Context.ts';
import ErrorWithMetadata from '../ErrorWithMetadata.ts';
import {log} from '../console.ts';
import executable from '../executable.ts';
import run from '../run.ts';
import stringify from '../stringify.ts';

type Options = {
  group?: string;
  sudo?: boolean;
  owner?: string;
};

export default async function chown(
  path: string,
  options: Options = {},
): Promise<Error | null> {
  // Run one of:
  //
  //      chown owner path
  //      chown :group path
  //      chown owner:group path
  //
  // With or without `sudo` (although note that, in practice, if
  // we are calling `chown()` at all, it will probably be with
  // `sudo`).
  //

  let ownerAndGroup = options.owner || '';

  if (options.group) {
    ownerAndGroup += `:${options.group}`;
  }

  const args = [ownerAndGroup, path];

  const passphrase = options.sudo ? await Context.sudoPassphrase : undefined;

  await log.debug(`Setting ownership: ${args.join(' ')}`);

  const result = await run(executable('chown'), args, {passphrase});

  if (result.status === 0) {
    return null;
  } else {
    await log.debug(stringify(result));

    return (
      result.error ||
      new ErrorWithMetadata(`\`chown ${args.join(' ')}\` failed`)
    );
  }
}
