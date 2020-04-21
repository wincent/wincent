import {join} from 'path';

import Context from '../../Context.js';
import {describe, expect, test} from '../../test/harness.js';
import {file, files, template} from '../resource.js';

function withMeta(callback: () => void) {
    return () => {
        try {
            Context.currentAspect = 'meta';
            callback();
        } finally {
            delete Context.currentAspect;
        }
    };
}

const inspect = Symbol.for('nodejs.util.inspect.custom');

describe('file()', () => {
    test(
        'returns a relative path',
        withMeta(() => {
            expect(file('example.txt').toString()).toBe(
                'aspects/meta/files/example.txt'
            );
        })
    );

    test('returns a string-like object', () => {
        const example: any = file('example.txt');

        expect(example instanceof String).toBe(true);
        expect(Object.prototype.toString.call(example)).toBe('[object String]');
        expect(example[inspect]()).toBe('aspects/meta/files/example.txt');
    });

    test('returns a value with a basename property', () => {
        const example: any = file('example.txt');

        expect(example.basename.toString()).toBe('example.txt');
    });

    test('returns a value with a dirname property', () => {
        const example: any = file('example.txt');

        expect(example.dirname.toString()).toBe('aspects/meta/files');
    });

    test('returns a value with a resolve property', () => {
        const example: any = file('example.txt');

        expect(example.resolve.toString()).toBe(
            join(process.cwd(), 'aspects/meta/files/example.txt')
        );
    });

    test('returns a value with a join property', () => {
        const example: any = file('example.txt');

        // Note that normalization (simplification of ".." components) is
        // automatic.
        expect(example.join('..', 'foo').toString()).toBe(
            'aspects/meta/files/foo'
        );
    });

    test('returns a value with chainable helper properties', () => {
        const example: any = file('example.txt');

        expect(example.resolve.dirname.join('other.txt').toString()).toBe(
            join(process.cwd(), 'aspects/meta/files/other.txt')
        );
    });
});

describe('files()', () => {
    test(
        'returns relative paths',
        withMeta(() => {
            expect(files('*').map((f) => f.toString())).toEqual([
                'aspects/meta/files/example.txt',
            ]);
        })
    );
});

describe('template()', () => {
    test(
        'returns a relative path',
        withMeta(() => {
            expect(template('sample.txt.erb').toString()).toBe(
                'aspects/meta/templates/sample.txt.erb'
            );
        })
    );
});
