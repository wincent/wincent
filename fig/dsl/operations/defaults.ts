import Context from '../../Context.js';
import ErrorWithMetadata from '../../ErrorWithMetadata.js';
import {log} from '../../console.js';
import run from '../../run.js';

type Type =
    | 'array'
    | 'bool'
    | 'date'
    | 'dict'
    | 'float'
    | 'int'
    | 'string'
    | 'unknown';

export default async function defaults({
    domain = 'NSGlobalDomain',
    host,
    key,
    state = 'present',
    type = 'string', // TODO: actually support all types
    value,
}: {
    domain?: string;
    host?: string;
    key: string;
    state?: 'absent' | 'present';
    type?: Exclude<Type, 'array' | 'date' | 'dict' | 'unknown'>;
    value?: boolean | number | string;
}): Promise<void> {
    if (state === 'present') {
        if (value === undefined) {
            throw new Error('Must provide a value if `state` is "present"');
        }

        if (type === 'bool' && typeof value !== 'boolean') {
            throw new Error('Must provide a boolean value if `type` is "bool"');
        }

        if (type === 'float' && typeof value !== 'number') {
            throw new Error('Must provide a number value if `type` is "float"');
        }

        if (type === 'int' && typeof value !== 'number') {
            throw new Error('Must provide a number value if `type` is "int"');
        }

        if (
            type === 'string' &&
            typeof value !== 'string' &&
            Object.prototype.toString.call(value) !== '[object String]'
        ) {
            throw new Error(
                'Must provide a string value if `type` is "string"'
            );
        }
    }

    const args = [];

    if (host === 'currentHost') {
        args.push('-currentHost');
    } else if (host !== undefined) {
        args.push('-host', host);
    }

    const description = ['defaults', ...args, domain, key].join(' ');

    let currentType: Type | undefined;
    let currentValue: boolean | number | string | undefined;

    let result = await run('defaults', [...args, 'read-type', domain, key]);

    if (result.status !== 0) {
        if (!/does not exist/.test(result.stderr)) {
            throw new ErrorWithMetadata(
                `Unable to read type of ${description}`,
                {
                    ...result,
                    error: result.error?.toString() ?? null,
                }
            );
        }
    } else {
        const match = result.stdout.match(/Type is (?<type>\w+)/);

        if (match) {
            switch (match.groups!.type.toLowerCase()) {
                case 'array':
                    currentType = 'array';
                    break;
                case 'boolean':
                    currentType = 'bool';
                    break;
                case 'date':
                    currentType = 'date';
                    break;
                case 'dictionary':
                    currentType = 'dict';
                    break;
                case 'float':
                    currentType = 'float';
                    break;
                case 'integer':
                    currentType = 'int';
                    break;
                case 'string':
                    currentType = 'string';
                    break;
                default:
                    currentType = 'unknown';
            }
        }
    }

    if (currentType !== undefined) {
        result = await run('defaults', [...args, 'read', domain, key]);

        if (result.status !== 0) {
            // Unlikely to get here (able to read type but not value).
            throw new ErrorWithMetadata(`Unable to read ${description}`, {
                ...result,
                error: result.error?.toString() ?? null,
            });
        }

        if (currentType === 'bool') {
            currentValue = !!parseInt(result.stdout, 10);
        } else if (currentType === 'float') {
            currentValue = parseFloat(result.stdout);
        } else if (currentType === 'int') {
            currentValue = parseInt(result.stdout, 10);
        } else if (currentType === 'string') {
            currentValue = result.stdout.replace(/\r?\n$/, '');
        }
    }

    log.debug(
        `${description} current type = ${
            currentType ?? 'unset'
        }, current value = ${currentValue ?? 'unset'}`
    );

    if (state === 'absent') {
        if (currentType === undefined) {
            Context.informOk(`absent ${description}`);
        } else if (Context.currentOptions?.check) {
            Context.informSkipped(`absent ${description}`);
        } else {
            result = await run('defaults', [...args, 'delete', domain, key]);

            if (result.status !== 0) {
                throw new ErrorWithMetadata(`Unable to delete ${description}`, {
                    ...result,
                    error: result.error?.toString() ?? null,
                });
            }

            Context.informChanged(`removed ${description}`);
        }
    } else {
        if (currentType === type && currentValue === value) {
            Context.informOk(`present ${description} ${value}`);
        } else if (Context.currentOptions?.check) {
            Context.informSkipped(`present ${description}`);
        } else {
            let typeAndValue: Array<string> = [];

            if (type === 'bool') {
                typeAndValue = ['-bool', value!.toString().toUpperCase()];
            } else if (type === 'float') {
                typeAndValue = ['-float', value!.toString()];
            } else if (type === 'int') {
                typeAndValue = ['-int', value!.toString()];
            } else if (type === 'string') {
                typeAndValue = ['-string', String(value)];
            }

            result = await run('defaults', [
                ...args,
                'write',
                domain,
                key,
                ...typeAndValue,
            ]);

            if (result.status !== 0) {
                throw new ErrorWithMetadata(`Unable to delete ${description}`, {
                    ...result,
                    error: result.error?.toString() ?? null,
                });
            }

            Context.informChanged(`set ${description} ${value}`);
        }
    }
}
