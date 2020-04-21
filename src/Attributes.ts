import * as os from 'os';

import id from './posix/id.js';
import stringify from './stringify.js';

/**
 * Immutable system attributes (read-only).
 */
export default class Attributes {
    #gid?: number;
    #groupNames?: Array<string>;
    #home?: string;
    #platform?: 'darwin' | 'linux';
    #uid?: number;
    #username?: string;

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
            this.#uid =
                typeof process.getuid === 'function' ? process.getuid() : -1;
        }

        return this.#uid;
    }

    get username(): string {
        if (!this.#username) {
            this.#username = os.userInfo().username;
        }

        return this.#username;
    }
}
