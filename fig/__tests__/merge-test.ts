import assert from 'node:assert';
import {test} from 'node:test';

import merge from '../merge.ts';

test('merge() returns an single object', () => {
  assert.deepStrictEqual(merge({example: 'obj'}), {example: 'obj'});
});

test('merge() merges two objects with non-overlapping keys', () => {
  assert.deepStrictEqual(merge({example: 'obj'}, {more: 'stuff'}), {
    example: 'obj',
    more: 'stuff',
  });
});

test('merge() merges two objects with overlapping keys', () => {
  assert.deepStrictEqual(
    merge({example: 'obj', more: 'things'}, {more: 'stuff', and: true}),
    {example: 'obj', more: 'stuff', and: true},
  );
});

test('merge() overwrites arrays', () => {
  assert.deepStrictEqual(
    merge({list: [1, 2, 3]}, {list: ['a', 'b', 'c', 'd']}),
    {
      list: ['a', 'b', 'c', 'd'],
    },
  );
});

test('merge() deep-merges objects', () => {
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
