import {promises as fs} from './fs.ts';
import {compile, fill} from './template.ts';

import type {Scope} from './template.ts';

/**
 * Template compiler that manages a cache of compiled templates.
 */
export default class Compiler {
  #compiled: Map<string, {fill: (scope: Scope) => string}>;

  constructor() {
    this.#compiled = new Map();
  }

  async compile(path: string): Promise<{fill: (scope: Scope) => string}> {
    // Convert potential Path string-like back to primitive.
    path = path.toString();

    const map = this.#compiled;

    if (!map.has(path)) {
      const source = await fs.readFile(path, 'utf8');

      const compiled = compile(source);

      // BUG: too verbose?
      // await log.debug(`Compiled template source:\n\n${compiled}\n`);

      map.set(path, {
        fill(scope) {
          return fill(compiled, scope);
        },
      });
    }

    return map.get(path)!;
  }
}
