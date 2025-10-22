import assert from 'node:assert';
import {homedir} from 'node:os';
import {join, relative, sep} from 'node:path';
import {cwd} from 'node:process';
import {describe, test} from 'node:test';

import {default as path, isPath} from '../path.ts';

describe('path()', () => {
  test('returns a Path instance', () => {
    assert.strictEqual(isPath(path('/foo/bar/baz')), true);
    assert.strictEqual(isPath('/foo/bar/baz'), false);
  });

  test('accepts a single path string', () => {
    assert.strictEqual(path('/foo/bar/baz').toString(), '/foo/bar/baz');
    assert.strictEqual(path('foo/bar/baz').toString(), 'foo/bar/baz');
    assert.strictEqual(path('foo').toString(), 'foo');
  });

  test('accepts multiple path strings', () => {
    assert.strictEqual(path('foo', 'bar', 'baz').toString(), 'foo/bar/baz');
  });

  test('normalizes redundant separators', () => {
    assert.strictEqual(path('///foo').toString(), '/foo');
    assert.strictEqual(path('/foo//bar').toString(), '/foo/bar');
    assert.strictEqual(path('foo//bar').toString(), 'foo/bar');
  });

  describe('basename', () => {
    test('returns a Path', () => {
      assert.strictEqual(isPath(path('foo').basename), true);
    });

    test('returns the basename', () => {
      assert.strictEqual(path('/foo/bar/baz').basename.toString(), 'baz');
      assert.strictEqual(path('/foo').basename.toString(), 'foo');
      assert.strictEqual(path('foo').basename.toString(), 'foo');
      assert.strictEqual(path('foo').basename.toString(), 'foo');
    });
  });

  describe('components', () => {
    test('returns an array of Paths', () => {
      const components = path('foo').components;
      assert.strictEqual(Array.isArray(components), true);
      assert.strictEqual(components.length, 1);
      assert.strictEqual(isPath(components[0]), true);
    });

    test('returns the components', () => {
      assert.deepStrictEqual(path('/foo/bar/baz').components.map(String), [
        '/',
        'foo',
        'bar',
        'baz',
      ]);
      assert.deepStrictEqual(path('foo/bar/baz').components.map(String), [
        'foo',
        'bar',
        'baz',
      ]);
      assert.deepStrictEqual(path('foo').components.map(String), ['foo']);
      assert.deepStrictEqual(path('~/foo').components.map(String), [
        '~',
        'foo',
      ]);
    });
  });

  describe('dirname', () => {
    test('returns a Path', () => {
      assert.strictEqual(isPath(path('foo').dirname), true);
    });

    test('returns the dirname', () => {
      assert.strictEqual(path('/foo/bar/baz').dirname.toString(), '/foo/bar');
      assert.strictEqual(path('/foo').dirname.toString(), '/');
      assert.strictEqual(path('foo').dirname.toString(), '.');
    });
  });

  describe('expand', () => {
    test('returns a Path', () => {
      assert.strictEqual(isPath(path('~').expand), true);
    });

    test('expands "~"', () => {
      assert.strictEqual(path('~').expand.toString(), homedir());
      assert.strictEqual(
        path('~/foo').expand.toString(),
        join(homedir(), 'foo'),
      );
      assert.strictEqual(path('/foo/bar').expand.toString(), '/foo/bar');
    });
  });

  describe('join', () => {
    test('returns a Path', () => {
      assert.strictEqual(isPath(path('foo').join('bar')), true);
    });

    test('appends components', () => {
      assert.strictEqual(path('foo').join('bar').toString(), 'foo/bar');
      assert.strictEqual(
        path('foo').join('bar', 'baz').toString(),
        'foo/bar/baz',
      );
    });

    test('ignores empty components', () => {
      assert.strictEqual(
        path('foo').join('bar', '', '', 'baz', '').toString(),
        'foo/bar/baz',
      );
    });

    test('ignores excess separator components', () => {
      assert.strictEqual(path('foo').join('/').toString(), 'foo');
      assert.strictEqual(
        path('foo').join('/', 'bar', '/', '/', 'baz').toString(),
        'foo/bar/baz',
      );
      assert.strictEqual(
        path('foo').join('/', 'bar', '/', '/', 'baz', '/').toString(),
        'foo/bar/baz',
      );
    });
  });

  describe('last', () => {
    test('returns an array of Paths', () => {
      const components = path('foo/bar').last(1);
      assert.strictEqual(Array.isArray(components), true);
      assert.strictEqual(components.length, 1);
      assert.strictEqual(isPath(components[0]), true);
    });

    test('returns trailing components', () => {
      assert.deepStrictEqual(path('foo/bar/baz/qux').last(0), []);

      // Positive numbers count from end of array of path components.
      assert.deepStrictEqual(path('foo/bar/baz/qux').last(1).map(String), [
        'qux',
      ]);
      assert.deepStrictEqual(path('foo/bar/baz/qux').last(2).map(String), [
        'baz',
        'qux',
      ]);
      assert.deepStrictEqual(path('foo/bar/baz/qux').last(3).map(String), [
        'bar',
        'baz',
        'qux',
      ]);
      assert.deepStrictEqual(path('foo/bar/baz/qux').last(4).map(String), [
        'foo',
        'bar',
        'baz',
        'qux',
      ]);
      assert.deepStrictEqual(path('foo/bar/baz/qux').last(5).map(String), [
        'foo',
        'bar',
        'baz',
        'qux',
      ]);

      // Negative numbers count from start of array of path components.
      assert.deepStrictEqual(path('foo/bar/baz/qux').last(-1).map(String), [
        'bar',
        'baz',
        'qux',
      ]);
      assert.deepStrictEqual(path('foo/bar/baz/qux').last(-2).map(String), [
        'baz',
        'qux',
      ]);
      assert.deepStrictEqual(path('foo/bar/baz/qux').last(-3).map(String), [
        'qux',
      ]);
      assert.deepStrictEqual(path('foo/bar/baz/qux').last(-4).map(String), []);
      assert.deepStrictEqual(path('foo/bar/baz/qux').last(-5).map(String), []);
    });
  });

  describe('resolve', () => {
    test('returns a Path', () => {
      assert.strictEqual(isPath(path('foo').resolve), true);
    });

    test('converts relative paths to absolute ones', () => {
      assert.strictEqual(
        path('bin/update-bundle').resolve.toString(),
        join(cwd(), 'bin/update-bundle'),
      );
    });

    test('expands "~"', () => {
      assert.strictEqual(
        path('~/foo').resolve.toString(),
        join(homedir(), 'foo'),
      );
    });
  });

  describe('sep', () => {
    test('returns the path separator', () => {
      assert.strictEqual(path.sep, sep);
    });
  });

  describe('simplify', () => {
    test('returns a Path', () => {
      assert.strictEqual(isPath(path('foo').simplify), true);
    });

    test('abbreviates to "~" if possible', () => {
      assert.strictEqual(
        path(join(homedir(), 'foo')).simplify.toString(),
        '~/foo',
      );
    });

    test('makes a path relative to the current directory', () => {
      const toRoot = relative(cwd(), '/');
      assert.strictEqual(
        path('/foo/bar').simplify.toString(),
        join(toRoot, 'foo/bar'),
      );
      assert.strictEqual(path('foo/bar').simplify.toString(), 'foo/bar');
      assert.strictEqual(path('foo').simplify.toString(), 'foo');
    });
  });

  describe('strip', () => {
    test('returns a Path', () => {
      assert.strictEqual(isPath(path('foo/bar.ext').strip('.ext')), true);
    });

    test('strips off any matching extension', () => {
      assert.strictEqual(
        path('foo/bar.ext').strip('.ext').toString(),
        'foo/bar',
      );
      assert.strictEqual(
        path('foo/bar.ext').strip('.not').toString(),
        'foo/bar.ext',
      );
    });
  });
});
