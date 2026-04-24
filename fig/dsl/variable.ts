import * as assert from 'node:assert';

import Context from '../Context.ts';
import {assertJSONArray, assertJSONObject} from '../assert.ts';
import path from '../path.ts';

import type {Path} from '../path.ts';

interface Variable {
  (name: string, fallback?: JSONValue): JSONValue;
  array(name: string, fallback?: Array<JSONValue>): Array<JSONValue>;
  object(
    name: string,
    fallback?: {[key: string]: JSONValue},
  ): {[key: string]: JSONValue};
  path(name: string, fallback?: string): Path;
  paths(name: string, fallback?: Array<string>): Array<Path>;
  string(name: string, fallback?: string): string;
  strings(name: string, fallback?: Array<string>): Array<string>;
}

function variableImpl(name: string, fallback?: JSONValue): JSONValue {
  const variables = Context.currentVariables;

  return variables.hasOwnProperty(name) ? variables[name] : fallback || null;
}

function array(
  name: string,
  fallback?: Array<JSONValue>,
): Array<JSONValue> {
  const value = variable(name, fallback);

  assertJSONArray(value, `Expected variable ${name} to be an array`);

  return value;
}

function object(
  name: string,
  fallback?: {[key: string]: JSONValue},
): {[key: string]: JSONValue} {
  const value = variable(name, fallback);

  assertJSONObject(value, `Expected variable ${name} to be an object`);

  return value;
}

function pathVar(name: string, fallback?: string): Path {
  const value = variable.string(name, fallback);

  return path(value);
}

function paths(name: string, fallback?: Array<string>): Array<Path> {
  const value = variable.array(name, fallback);

  return value.map((v) => {
    assert.ok(
      typeof v === 'string',
      `Expected variable ${name} to be an array of strings but it contained a ${typeof v}`,
    );
    return path(v);
  });
}

function string(name: string, fallback?: string): string {
  const value = variable(name, fallback);

  assert.ok(
    typeof value === 'string',
    `Expected variable ${name} to have type string but it was ${typeof value}`,
  );

  return value;
}

function strings(array: Array<unknown>): array is Array<string> {
  return array.every((v) => typeof v === 'string');
}

function stringsFn(name: string, fallback?: Array<string>): Array<string> {
  const value = variable.array(name, fallback);

  assert.ok(
    strings(value),
    `Expected variable ${name} to be an array of strings but it contained a non-string`,
  );

  return value;
}

const variable: Variable = Object.assign(variableImpl, {
  array,
  object,
  path: pathVar,
  paths,
  string,
  strings: stringsFn,
});

export default variable;
