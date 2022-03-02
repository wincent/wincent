import ErrorWithMetadata from '../../ErrorWithMetadata.js';
import Scanner from '../../Scanner.js';
import {log} from '../../console.js';
import {promises as fs} from '../../fs.js';
import stat from '../../fs/stat.js';
import path from '../../path.js';
import file from './file.js';

/**
 * @see https://docs.ansible.com/ansible/latest/modules/lineinfile_module.html
 */
export default async function line({
  path: dest,
  group,
  line,
  mode,
  notify,
  owner,
  regexp,
  state = 'present',
  sudo,
}: {
  path: string;
  group?: string;
  line: string;
  mode?: Mode;
  notify?: Array<string> | string;
  owner?: string;
  regexp?: RegExp | string;
  state?: 'absent' | 'present';
  sudo?: boolean;
}): Promise<OperationResult> {
  log.debug(`Line \`${line}\` in \`${path}\``);

  const normalized = `${line.trimEnd()}\n`;

  const target = path(dest).resolve;

  const stats = await stat(target);

  let contents = state === 'present' ? normalized : '';

  if (stats instanceof Error) {
    throw stats;
  } else if (stats !== null) {
    if (stats.type !== 'file') {
      // TODO: make this work with symlinks (problem with file)
      throw new ErrorWithMetadata(
        `Cannot replace line in ${dest} because its type is ${stats.type}`
      );
    }

    // TODO: deal with potential permission issue here (eg. file only readable by root)
    const scanner = new Scanner(await fs.readFile(dest, 'utf8'));

    contents = '';

    let found = false;

    while (!scanner.atEnd()) {
      const current = scanner.scan(/[^\r\n]*/);

      if (
        (regexp &&
          typeof current === 'string' &&
          (typeof regexp === 'string'
            ? current.includes(regexp)
            : regexp.test(current))) ||
        (!regexp && current === line)
      ) {
        found = true;

        if (state === 'present') {
          contents += line;
        } else {
          // Slurp unwanted line, plus the following newline.
          scanner.scan(/\r?\n/);
          continue;
        }
      } else {
        contents += current || '';
      }

      contents += scanner.scan(/[\r\n]+/) || '';
    }

    if (!found && state === 'present') {
      contents = contents.replace(/(\r?\n|)$/, `\n${normalized}`);
    }
  }

  return await file({
    contents,
    group,
    mode,
    notify,
    owner,
    path: target,
    state: 'file',
    sudo,
  });
}
