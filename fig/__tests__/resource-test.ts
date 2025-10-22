import assert from 'node:assert';
import {join} from 'node:path';
import {chdir, cwd} from 'node:process';
import {describe, test} from 'node:test';

import Context from '../Context.ts';
import {file, files, template} from '../dsl/resource.ts';

import type {Path} from '../path.ts';

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
      assert.strictEqual(
        file('example.txt').toString(),
        'aspects/meta/files/example.txt',
      );
    }),
  );

  test(
    'returns a string-like object',
    withMeta(() => {
      const example: any = file('example.txt');

      assert.strictEqual(example instanceof String, true);
      assert.strictEqual(
        Object.prototype.toString.call(example),
        '[object String]',
      );
      assert.strictEqual(example[inspect](), 'aspects/meta/files/example.txt');
    }),
  );

  test(
    'returns a value with a basename property',
    withMeta(() => {
      const example: Path = file('example.txt');

      assert.strictEqual(example.basename.toString(), 'example.txt');
    }),
  );

  test(
    'returns a value with a dirname property',
    withMeta(() => {
      const example: any = file('example.txt');

      assert.strictEqual(example.dirname.toString(), 'aspects/meta/files');
    }),
  );

  test(
    'returns a value with a resolve property',
    withMeta(() => {
      const example: any = file('example.txt');

      assert.strictEqual(
        example.resolve.toString(),
        join(cwd(), 'aspects/meta/files/example.txt'),
      );
    }),
  );

  test(
    'returns a value with a join property',
    withMeta(() => {
      const example: any = file('example.txt');

      // Note that normalization (simplification of ".." components) is
      // automatic.
      assert.strictEqual(
        example.join('..', 'foo').toString(),
        'aspects/meta/files/foo',
      );
    }),
  );

  test(
    'returns a value with chainable helper properties',
    withMeta(() => {
      const example: any = file('example.txt');

      assert.strictEqual(
        example.resolve.dirname.join('other.txt').toString(),
        join(cwd(), 'aspects/meta/files/other.txt'),
      );
    }),
  );
});

describe('files()', () => {
  test(
    'returns relative paths',
    withMeta(() => {
      const previous = cwd();
      try {
        process.chdir('..'); // cd so that glob below can work.
        assert.deepStrictEqual(files('*').map((f) => f.toString()), [
          'aspects/meta/files/example.txt',
        ]);
      } finally {
        chdir(previous);
      }
    }),
  );
});

describe('template()', () => {
  test(
    'returns a relative path',
    withMeta(() => {
      assert.strictEqual(
        template('sample.txt.erb').toString(),
        'aspects/meta/templates/sample.txt.erb',
      );
    }),
  );
});
