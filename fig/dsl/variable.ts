import Context from '../Context.ts';
import assert from '../assert.ts';
import path from '../path.ts';

import type {Path} from '../path.ts';

export default function variable(
  name: string,
  fallback?: JSONValue,
): JSONValue {
  const variables = Context.currentVariables;

  return variables.hasOwnProperty(name) ? variables[name] : fallback || null;
}

variable.array = (
  name: string,
  fallback?: Array<JSONValue>,
): Array<JSONValue> => {
  const value = variable(name, fallback);

  assert.JSONArray(value, `Expected variable ${name} to be an array`);

  return value;
};

variable.object = (
  name: string,
  fallback?: {[key: string]: JSONValue},
): {[key: string]: JSONValue} => {
  const value = variable(name, fallback);

  assert.JSONObject(value, `Expected variable ${name} to be an object`);

  return value;
};

variable.path = (name: string, fallback?: string): Path => {
  const value = variable.string(name, fallback);

  return path(value);
};

variable.paths = (name: string, fallback?: Array<string>): Array<Path> => {
  const value = variable.array(name, fallback);

  return value.map((v) => {
    assert(
      typeof v === 'string',
      `Expected variable ${name} to be an array of strings but it contained a ${typeof v}`,
    );
    return path(v);
  });
};

variable.string = (name: string, fallback?: string): string => {
  const value = variable(name, fallback);

  assert(
    typeof value === 'string',
    `Expected variable ${name} to have type string but it was ${typeof value}`,
  );

  return value;
};

function strings(array: Array<unknown>): array is Array<string> {
  return array.every((v) => typeof v === 'string');
}

variable.strings = (name: string, fallback?: Array<string>): Array<string> => {
  const value = variable.array(name, fallback);

  assert(
    strings(value),
    `Expected variable ${name} to be an array of strings but it contained a non-string`,
  );

  return value;
};
