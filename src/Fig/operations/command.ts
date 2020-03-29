import ErrorWithMetadata from '../../ErrorWithMetadata';
import spawn from '../../spawn';
import expand from '../../expand';
import Context from '../Context';

/**
 * Implements basic shell expansion (of ~).
 */
export default function command(executable: string, ...args: Array<string>) {
  const description = [executable, ...args].join(' ');

  try {
    spawn(expand(executable), ...args.map(expand));
    // TODO: decide whether to log full command here
    Context.informChanged(`command \`${description}\``);
  } catch (error) {
    if (error instanceof ErrorWithMetadata) {
      Context.informFailed(error);
    } else {
      Context.informFailed(`command \`${description}\` failed`);
    }
  }
}
