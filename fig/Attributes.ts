import * as os from 'os';

import {existsSync} from './fs.js';
import id from './posix/id.js';
import stringify from './stringify.js';
import assertMode from './fs/assertMode.js';
import {spawnSync} from './child_process.js';

/**
 * Immutable system attributes (read-only).
 */
export default class Attributes {
  #arch?: string;
  #distribution?: string;
  #gid?: number;
  #groupNames?: Array<string>;
  #home?: string;
  #platform?: 'darwin' | 'linux';
  #uid?: number;
  #umask?: Mode;
  #username?: string;

  /**
   * Returns a normalized version of the value returned by the `arch`
   * executable (on macOS). Possible values:
   *
   *    Raw value:  arm64 arm64e i386 x86_64 x86_64h
   *    Normalized: arm64 arm64  ia32 x64    x64
   *
   * If using `arch` is not possible, falls back to the value of
   * NodeJS's `os.arch()`. Possible values (not normalized):
   *
   *    arm, arm64, ia32, mips, mipsel, ppc, ppc64, s390, s390x, x32, x64
   */
  get arch(): string {
    if (this.#arch === undefined) {
      if (this.platform === 'darwin') {
        // Although os.arch() supposedly can return `arm64`, it may not
        // (for example, if Node was not compiled for Arm). So, prefer
        // the value returned by the `arch` executable, if we can.
        //
        // See: https://nodejs.org/api/os.html#os_os_arch
        const {error, signal, status, stdout} = spawnSync('arch');

        if (!error && !signal && !status && stdout) {
          // BUG: Doesn't actually work, because `arch` inherits architectural
          // preference from its parent.
          //
          // See: https://news.ycombinator.com/item?id=25134535
          //
          // For example, on this machine:
          //
          //    $ file /opt/homebrew/bin/nvim
          //    /opt/homebrew/bin/nvim: Mach-O 64-bit executable arm64
          //    $ file /Users/wincent/n/bin/node
          //    /Users/wincent/n/bin/node: Mach-O 64-bit executable x86_64
          //
          // Running `arch` in the shell prints "arm64".
          // Spawning it here yields "i386".
          const normalized: string | undefined = (
            {
              arm64: 'arm64',
              arm64e: 'arm64',
              i386: 'ia32',
              x86_64: 'x64',
              x86_64h: 'x64',
            } as {[raw: string]: string}
          )[stdout.toString().trim()];

          if (normalized) {
            this.#arch = normalized;

            return this.#arch;
          }
        }
      }

      this.#arch = os.arch();
    }

    return this.#arch;
  }

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
