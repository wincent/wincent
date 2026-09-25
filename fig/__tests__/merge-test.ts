import * as assert from 'node:assert';
import {describe, test} from 'node:test';

import merge from '../merge.ts';

describe('merge()', () => {
  test('returns a single object', () => {
    assert.deepStrictEqual(merge({example: 'obj'}), {example: 'obj'});
  });

  test('merges two objects with non-overlapping keys', () => {
    assert.deepStrictEqual(merge({example: 'obj'}, {more: 'stuff'}), {
      example: 'obj',
      more: 'stuff',
    });
  });

  test('merges two objects with overlapping keys', () => {
    assert.deepStrictEqual(
      merge({example: 'obj', more: 'things'}, {more: 'stuff', and: true}),
      {example: 'obj', more: 'stuff', and: true},
    );
  });

  test('overwrites arrays', () => {
    assert.deepStrictEqual(
      merge({list: [1, 2, 3]}, {list: ['a', 'b', 'c', 'd']}),
      {
        list: ['a', 'b', 'c', 'd'],
      },
    );
  });

  test('deep-merges objects', () => {
    assert.deepStrictEqual(
      merge(
        {thing: true, nested: {prop: 'value'}},
        {thing: true, nested: {other: false}},
      ),
      {
        thing: true,
        nested: {
          prop: 'value',
          other: false,
        },
      },
    );
  });
});
