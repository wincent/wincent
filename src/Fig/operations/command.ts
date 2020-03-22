import {log} from '../../console';

export default function command(executable: string, ...args: Array<string>) {
  log(`command: ${[executable, ...args].join(' ')}`);
}
