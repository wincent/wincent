import * as os from 'os';

/**
 * Immutable system attributes (read-only).
 */
export default class Attributes {
  #homedir?: string;
  #platform?: 'darwin' | 'linux';
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
        throw new Error(`Unsupported platform ${JSON.stringify(uname)}`);
      }
    }

    return this.#platform;
  }

  get username(): string {
    if (!this.#username) {
      this.#username = os.userInfo().username;
    }

    return this.#username;
  }
}
