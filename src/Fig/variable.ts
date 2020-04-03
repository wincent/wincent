import assert from '../assert';
import Context from './Context';

export default function variable(
    name: string,
    fallback?: JSONValue
): JSONValue {
    const variables = Context.currentVariables;

    return variables.hasOwnProperty(name) ? variables[name] : fallback || null;
}

variable.string = (name: string, fallback?: JSONValue): string => {
    const value = variable(name, fallback);

    assert(
        typeof value === 'string',
        `Expected variable ${name} to have type string but it was ${typeof value}`
    );

    return value;
};
