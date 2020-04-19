import assert from '../assert.js';
import Context from './Context.js';

export default function variable(
    name: string,
    fallback?: JSONValue
): JSONValue {
    const variables = Context.currentVariables;

    return variables.hasOwnProperty(name) ? variables[name] : fallback || null;
}

variable.array = (
    name: string,
    fallback?: Array<JSONValue>
): Array<JSONValue> => {
    const value = variable(name, fallback);

    assert(Array.isArray(value), `Expected variable ${name} to be an array`);

    return value;
};

variable.string = (name: string, fallback?: JSONValue): string => {
    const value = variable(name, fallback);

    assert(
        typeof value === 'string',
        `Expected variable ${name} to have type string but it was ${typeof value}`
    );

    return value;
};
