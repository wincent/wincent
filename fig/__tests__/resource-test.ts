import {join} from 'node:path';

import Context from '../Context.js';
import {file, files, template} from '../dsl/resource.js';
import {describe, expect, test} from '../test/harness.js';

function withMeta(callback: () => void) {
  return () => {
    try {
      Context.currentAspect = 'meta';
      callback();
    } finally {
      Context.currentAspect = undefined;
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

  test(
    'returns a string-like object',
    withMeta(() => {
      const example: any = file('example.txt');

      expect(example instanceof String).toBe(true);
      expect(Object.prototype.toString.call(example)).toBe('[object String]');
      expect(example[inspect]()).toBe('aspects/meta/files/example.txt');
    })
  );

  test(
    'returns a value with a basename property',
    withMeta(() => {
      const example: any = file('example.txt');

      expect(example.basename.toString()).toBe('example.txt');
    })
  );

  test(
    'returns a value with a dirname property',
    withMeta(() => {
      const example: any = file('example.txt');

      expect(example.dirname.toString()).toBe('aspects/meta/files');
    })
  );

  test(
    'returns a value with a resolve property',
    withMeta(() => {
      const example: any = file('example.txt');

      expect(example.resolve.toString()).toBe(
        join(process.cwd(), 'aspects/meta/files/example.txt')
      );
    })
  );

  test(
    'returns a value with a join property',
    withMeta(() => {
      const example: any = file('example.txt');

      // Note that normalization (simplification of ".." components) is
      // automatic.
      expect(example.join('..', 'foo').toString()).toBe(
        'aspects/meta/files/foo'
      );
    })
  );

  test(
    'returns a value with chainable helper properties',
    withMeta(() => {
      const example: any = file('example.txt');

      expect(example.resolve.dirname.join('other.txt').toString()).toBe(
        join(process.cwd(), 'aspects/meta/files/other.txt')
      );
    })
  );
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
