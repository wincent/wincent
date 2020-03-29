import spawn from '../../spawn';
import expand from '../../expand';
import Context from '../Context';

/**
 * Implements basic shell expansion (of ~).
 */
export default function command(executable: string, ...args: Array<string>) {
  try {
    spawn(expand(executable), ...args.map(expand));
    // TODO: decide whether to log full command here
    Context.informChanged(`command \`${[executable, ...args].join(' ')}\``);
  } catch (error) {
    // TODO: add proper error message here, maybe metadata too
    Context.informFailed('something went wrong');
  }
}
