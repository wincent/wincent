import {readFile as readFileAsync} from 'fs';
import {promisify} from 'util';

import {compile, fill} from './template';

import type {Scope} from './template';

const readFile = promisify(readFileAsync);

/**
 * Template compiler that manages a cache of compiled templates.
 */
export default class Compiler {
    #compiled: Map<string, {fill: (scope: Scope) => string}>;

    constructor() {
        this.#compiled = new Map();
    }

    async compile(path: string): Promise<{fill: (scope: Scope) => string}> {
        const map = this.#compiled;

        if (!map.has(path)) {
            const source = await readFile(path, 'utf8');

            const compiled = compile(source);

            map.set(path, {
                fill(scope) {
                    return fill(compiled, scope);
                },
            });
        }

        return map.get(path)!;
    }
}
