import {promises as fs} from 'fs';

import {compile, fill} from './template.js';

import type {Scope} from './template.js';

/**
 * Template compiler that manages a cache of compiled templates.
 */
export default class Compiler {
    #compiled: Map<string, {fill: (scope: Scope) => string}>;

    constructor() {
        this.#compiled = new Map();
    }

    async compile(path: string): Promise<{fill: (scope: Scope) => string}> {
        path = path.toString(); // Convert Path string-like back to primitive.

        const map = this.#compiled;

        if (!map.has(path)) {
            const source = await fs.readFile(path, 'utf8');

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
