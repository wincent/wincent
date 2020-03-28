import {log} from '../../console';

// TODO (probably) implement autoexpand of ~
export default function command(executable: string, ...args: Array<string>) {
  log(`command: ${[executable, ...args].join(' ')}`);
}
