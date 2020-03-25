import capture from './capture';

export default class Attributes {
  #platform?: 'darwin' | 'linux';

  async getPlatform(): Promise<'darwin' | 'linux'> {
    if (!this.#platform) {
      const uname = await capture('uname', '-s');

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
}
