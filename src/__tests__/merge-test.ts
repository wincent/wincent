import {expect, test} from '../test/harness';
import merge from '../merge';

test('merge() returns an single object', () => {
    expect(merge({example: 'obj'})).toEqual({example: 'obj'});
});

test('merge() merges two objects with non-overlapping keys', () => {
    expect(merge({example: 'obj'}, {more: 'stuff'})).toEqual({
        example: 'obj',
        more: 'stuff',
    });
});

test('merge() merges two objects with overlapping keys', () => {
    expect(
        merge({example: 'obj', more: 'things'}, {more: 'stuff', and: true})
    ).toEqual({example: 'obj', more: 'stuff', and: true});
});

test('merge() overwrites arrays', () => {
    expect(merge({list: [1, 2, 3]}, {list: ['a', 'b', 'c', 'd']})).toEqual({
        list: ['a', 'b', 'c', 'd'],
    });
});

test('merge() deep-merges objects', () => {
    expect(
        merge(
            {thing: true, nested: {prop: 'value'}},
            {thing: true, nested: {other: false}}
        )
    ).toEqual({
        thing: true,
        nested: {
            prop: 'value',
            other: false,
        },
    });
});
