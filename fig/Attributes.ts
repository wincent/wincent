import * as os from 'os';

import {existsSync} from './fs.js';
import id from './posix/id.js';
import stringify from './stringify.js';
import assertMode from './fs/assertMode.js';

/**
 * Immutable system attributes (read-only).
 */
export default class Attributes {
  #distribution?: string;
  #gid?: number;
  #groupNames?: Array<string>;
  #home?: string;
  #platform?: 'darwin' | 'linux';
  #uid?: number;
  #umask?: Mode;
  #username?: string;

  get distribution(): string {
    if (this.#distribution === undefined) {
      if (existsSync('/etc/arch-release')) {
        this.#distribution = 'arch';
      } else {
        this.#distribution = '';
      }
    }

    return this.#distribution;
  }

  get gid(): number {
    if (typeof this.#gid !== 'number') {
      this.#gid = process.getgid();
    }

    return this.#gid;
  }

  get group(): string {
    return this.groupNames[0];
  }

  get groupNames(): Array<string> {
    if (!this.#groupNames) {
      this.#groupNames = id();
    }

    return this.#groupNames;
  }

  get home(): string {
    if (!this.#home) {
      this.#home = os.homedir();
    }

    return this.#home;
  }

  get platform(): 'darwin' | 'linux' {
    if (!this.#platform) {
      const uname = os.type();

      if (uname === 'Darwin') {
        this.#platform = 'darwin';
      } else if (uname === 'Linux') {
        this.#platform = 'linux';
      } else {
        throw new Error(`Unsupported platform ${stringify(uname)}`);
      }
    }

    return this.#platform;
  }

  get uid(): number {
    if (typeof this.#uid !== 'number') {
      this.#uid = typeof process.getuid === 'function' ? process.getuid() : -1;
    }

    return this.#uid;
  }

  get umask(): Mode {
    if (!this.#umask) {
      // Can't just read this, have to set it and restore it.
      //
      // https://nodejs.org/api/process.html#process_process_umask_mask
      const umask = process.umask(0o022);

      process.umask(umask);

      const paddedUmask = umask.toString(8).padStart(4, '0');

      assertMode(paddedUmask);

      this.#umask = paddedUmask;
    }

    return this.#umask;
  }

  get username(): string {
    if (!this.#username) {
      this.#username = os.userInfo().username;
    }

    return this.#username;
  }
}
