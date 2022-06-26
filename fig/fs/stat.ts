import Context from '../Context.js';
import ErrorWithMetadata from '../ErrorWithMetadata.js';
import assert from '../assert.js';
import {default as toPath} from '../path.js';
import run from '../run.js';

type Stats = {
  group: string;
  mode: Mode;
  target?: string;
  type: 'directory' | 'file' | 'link' | 'socket' | 'special' | 'unknown';
  owner: string;
};

const TYPE_MAP = {
  'character device': 'special',
  'character special file': 'special',
  directory: 'directory',
  'regular empty file': 'file',
  'regular file': 'file',
  socket: 'socket',
  'symbolic link': 'link',
} as const;

/**
 * Wrapper for "stat" command.
 *
 * Ideally, we'd just use `fs.stat`, but the trouble with that is we can't rely
 * on it to stat root-owned files; we need to be able to run a separate too,
 * with `sudo` if necessary.
 */
export default async function stat(
  path: string
): Promise<Error | Stats | null> {
  const target = toPath(path).expand;

  const args = [];

  if (Context.attributes.platform === 'darwin') {
    const formats = {
      group: '%Sg',
      mode: '%Lp',
      newline: '%n',
      target: '%Y',
      type: '%HT',
      owner: '%Su',
    };

    const formatString = [
      formats.mode,
      formats.type,
      formats.owner,
      formats.group,
      formats.target,
    ].join(formats.newline);

    args.push('-f', formatString, target);
  } else if (Context.attributes.platform === 'linux') {
    // GNU: command stat --printf '%a\n%F\n%G\n%U\n'
    // a = mode
    // F = type
    // G = group name
    // U = owner name
    // maybe %N (link target): prints 'src' -> 'target'
    // 644, 1777
    // regular file, directory, symbolic link, character special file
    const formats = {
      group: '%G',
      mode: '%a',
      newline: '\n',
      target: '%N',
      type: '%F',
      owner: '%U',
    };

    const formatString =
      [
        formats.mode,
        formats.type,
        formats.owner,
        formats.group,
        formats.target,
      ].join(formats.newline) + '\n';

    args.push('-c', formatString, target);
  }

  // Try without sudo, then with.
  for (const sudo of [false, true]) {
    const options = sudo
      ? {passphrase: await Context.sudoPassphrase}
      : undefined;

    const {status, stderr, stdout} = await run('stat', args, options);

    if (status === 0) {
      const [mode, type, owner, group, target] = stdout.split('\n');

      const paddedMode = mode.padStart(4, '0');

      assert.mode(paddedMode);

      let parsedTarget: string | undefined = undefined;

      if (target) {
        if (Context.attributes.platform === 'darwin') {
          parsedTarget = target;
        } else if (Context.attributes.platform === 'linux') {
          parsedTarget = target.split(' -> ')[1];

          if (parsedTarget) {
            parsedTarget = parsedTarget
              .replace(/^'/, '')
              .replace(/'$/, '')
              .replace(/\\'/, "'")
              .replace(/\\\\'/, '\\');
          }
        }
      }

      return {
        group,
        mode: paddedMode,
        target: parsedTarget,
        type: (TYPE_MAP as any)[type.toLowerCase()] || 'unknown',
        owner,
      };
    }

    if (/no such file/i.test(stderr)) {
      return null;
    } else if (!/permission denied/i.test(stderr)) {
      // Give up...
      break;
    }
  }

  return new ErrorWithMetadata(`Unable to stat ${path}`);
}
