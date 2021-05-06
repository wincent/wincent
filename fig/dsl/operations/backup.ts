import Context from '../../Context.js';
import stat from '../../fs/stat.js';
import path from '../../path.js';
import mkdir from '../../posix/mkdir.js';
import command from './command.js';

export default async function backup({
  src,
  path: dest = '~/.backups',
  relative = '~',
}: {
  src: string;
  path?: string;
  relative?: string;
}): Promise<void> {
  if (Context.currentOptions.check) {
    Context.informSkipped(`file ${src}`);
  } else {
    const source = path(relative).join(src).expand;
    const target = path(dest).join(src).expand;

    const stats = await stat(source);

    if (stats instanceof Error) {
      throw stats;
    } else if (!stats) {
      // Doesn't exist; nothing to backup.
      return;
    } else if (stats.type === 'directory' || stats.type === 'file') {
      // Create parent directories if necessary.
      const result = await mkdir(target.dirname, {
        intermediate: true,
      });

      if (result instanceof Error) {
        throw result;
      }

      await command('mv', ['-f', source, target], {
        creates: target,
      });
    }
  }
}
