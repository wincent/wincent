import * as os from 'os';

import stringify from './stringify.js';

/**
 * Immutable system attributes (read-only).
 */
export default class Attributes {
    #homedir?: string;
    #platform?: 'darwin' | 'linux';
    #uid?: number;
    #username?: string;

    get homedir(): string {
        if (!this.#homedir) {
            this.#homedir = os.homedir();
        }

        return this.#homedir;
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
