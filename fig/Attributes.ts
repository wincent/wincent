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
  #distribution?: 'arch' | 'debian' | '';
  #gid?: number;
  #groupNames?: Array<string>;
  #home?: string;
  #hostname?: string;
  #platform?: 'darwin' | 'linux';
  #uid?: number;
  #umask?: Mode;
  #username?: string;

  /**
   * Returns the value returned by `uname -m`.
   *
   * Likely values include "arm64", "x86_64" etc.
   */
  get arch(): string {
    if (this.#arch === undefined) {
      if (this.platform === 'darwin') {
        // Buckle in.
        //
        // Although os.arch() supposedly _can_ return `arm64` (possible values
        // listed in the docs[0] are arm, arm64, ia32, mips, mipsel, ppc, ppc64,
        // s390, s390x, x32, and x64), it may not.
        //
        // As noted here[1], `arch` (and `uname -m`, etc) inherit architectural
        // preference from the parent. So, if Node was not compiled for Apple
        // Silicon, you'll get "i386" if you run `arch` from inside Node.
        // Similarly, you"ll get "x86_64' if you run `uname -m` from inside.
        // In both cases, you get "arm64" outside.
        //
        // Now, /bin/zsh ships as a universal binary with "x86_64" and "arm64e"
        // variants. If you install a Homebrew Zsh into /opt/homebrew/bin/zsh
        // you'll see (via `file`) that it is purely "arm64".
        //
        // The "solution" we take to detect what kind of machine we're really
        // running on is to run `arch -arm64 uname -m`. This will error on
        // non-Arm machines, so we fall back to whatever `uname -m` tells us.
        //
        // If nothing works, we report that `arch` is an empty string.
        //
        // [0]: https://nodejs.org/api/os.html#os_os_arch
        // [1]: https://news.ycombinator.com/item?id=25134535
        const {error, signal, status, stdout} = spawnSync('arch', [
          '-arm64',
          'uname',
          '-m',
        ]);

        if (!error && !signal && !status && stdout) {
          const normalized = stdout.toString().trim();

          if (normalized) {
            this.#arch = normalized;

            return this.#arch;
          }
        }
      }

      const {error, signal, status, stdout} = spawnSync('uname', ['-m']);

      if (!error && !signal && !status && stdout) {
        this.#arch = stdout.toString().trim();
      } else {
        this.#arch = '';
      }
    }

    return this.#arch;
  }

  get distribution(): 'arch' | 'debian' | '' {
    if (this.#distribution === undefined) {
      if (existsSync('/etc/arch-release')) {
        this.#distribution = 'arch';
      } else if (existsSync('/etc/debian_version')) {
        this.#distribution = 'debian';
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

  get hostname(): string {
    if (this.#hostname === undefined) {
      this.#hostname = os.hostname();
    }

    return this.#hostname;
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
