import {homedir} from 'node:os';
import {join, relative, sep} from 'node:path';
import {cwd} from 'node:process';
import {default as path, isPath} from '../path.ts';
import {describe, expect, test} from '../test/harness.ts';

describe('path()', () => {
  test('returns a Path instance', () => {
    expect(isPath(path('/foo/bar/baz'))).toBe(true);
    expect(isPath('/foo/bar/baz')).toBe(false);
  });

  test('accepts a single path string', () => {
    expect(path('/foo/bar/baz').toString()).toBe('/foo/bar/baz');
    expect(path('foo/bar/baz').toString()).toBe('foo/bar/baz');
    expect(path('foo').toString()).toBe('foo');
  });

  test('accepts multiple path strings', () => {
    expect(path('foo', 'bar', 'baz').toString()).toBe('foo/bar/baz');
  });

  test('normalizes redundant separators', () => {
    expect(path('///foo').toString()).toBe('/foo');
    expect(path('/foo//bar').toString()).toBe('/foo/bar');
    expect(path('foo//bar').toString()).toBe('foo/bar');
  });

  describe('basename', () => {
    test('returns a Path', () => {
      expect(isPath(path('foo').basename)).toBe(true);
    });

    test('returns the basename', () => {
      expect(path('/foo/bar/baz').basename.toString()).toBe('baz');
      expect(path('/foo').basename.toString()).toBe('foo');
      expect(path('foo').basename.toString()).toBe('foo');
      expect(path('foo').basename.toString()).toBe('foo');
    });
  });

  describe('components', () => {
    test('returns an array of Paths', () => {
      const components = path('foo').components;
      expect(Array.isArray(components)).toBe(true);
      expect(components.length).toBe(1);
      expect(isPath(components[0])).toBe(true);
    });

    test('returns the components', () => {
      expect(path('/foo/bar/baz').components.map(String)).toEqual([
        '/',
        'foo',
        'bar',
        'baz',
      ]);
      expect(path('foo/bar/baz').components.map(String)).toEqual([
        'foo',
        'bar',
        'baz',
      ]);
      expect(path('foo').components.map(String)).toEqual(['foo']);
      expect(path('~/foo').components.map(String)).toEqual(['~', 'foo']);
    });
  });

  describe('dirname', () => {
    test('returns a Path', () => {
      expect(isPath(path('foo').dirname)).toBe(true);
    });

    test('returns the dirname', () => {
      expect(path('/foo/bar/baz').dirname.toString()).toBe('/foo/bar');
      expect(path('/foo').dirname.toString()).toBe('/');
      expect(path('foo').dirname.toString()).toBe('.');
    });
  });

  describe('expand', () => {
    test('returns a Path', () => {
      expect(isPath(path('~').expand)).toBe(true);
    });

    test('expands "~"', () => {
      expect(path('~').expand.toString()).toBe(homedir());
      expect(path('~/foo').expand.toString()).toBe(join(homedir(), 'foo'));
      expect(path('/foo/bar').expand.toString()).toBe('/foo/bar');
    });
  });

  describe('join', () => {
    test('returns a Path', () => {
      expect(isPath(path('foo').join('bar'))).toBe(true);
    });

    test('appends components', () => {
      expect(path('foo').join('bar').toString()).toBe('foo/bar');
      expect(path('foo').join('bar', 'baz').toString()).toBe('foo/bar/baz');
    });

    test('ignores empty components', () => {
      expect(path('foo').join('bar', '', '', 'baz', '').toString()).toBe(
        'foo/bar/baz',
      );
    });

    test('ignores excess separator components', () => {
      expect(path('foo').join('/').toString()).toBe('foo');
      expect(path('foo').join('/', 'bar', '/', '/', 'baz').toString()).toBe(
        'foo/bar/baz',
      );
      expect(path('foo').join('/', 'bar', '/', '/', 'baz', '/').toString())
        .toBe('foo/bar/baz');
    });
  });

  describe('last', () => {
    test('returns an array of Paths', () => {
      const components = path('foo/bar').last(1);
      expect(Array.isArray(components)).toBe(true);
      expect(components.length).toBe(1);
      expect(isPath(components[0])).toBe(true);
    });

    test('returns trailing components', () => {
      expect(path('foo/bar/baz/qux').last(0)).toEqual([]);

      // Positive numbers count from end of array of path components.
      expect(path('foo/bar/baz/qux').last(1).map(String)).toEqual(['qux']);
      expect(path('foo/bar/baz/qux').last(2).map(String)).toEqual([
        'baz',
        'qux',
      ]);
      expect(path('foo/bar/baz/qux').last(3).map(String)).toEqual([
        'bar',
        'baz',
        'qux',
      ]);
      expect(path('foo/bar/baz/qux').last(4).map(String)).toEqual([
        'foo',
        'bar',
        'baz',
        'qux',
      ]);
      expect(path('foo/bar/baz/qux').last(5).map(String)).toEqual([
        'foo',
        'bar',
        'baz',
        'qux',
      ]);

      // Negative numbers count from start of array of path components.
      expect(path('foo/bar/baz/qux').last(-1).map(String)).toEqual([
        'bar',
        'baz',
        'qux',
      ]);
      expect(path('foo/bar/baz/qux').last(-2).map(String)).toEqual([
        'baz',
        'qux',
      ]);
      expect(path('foo/bar/baz/qux').last(-3).map(String)).toEqual(['qux']);
      expect(path('foo/bar/baz/qux').last(-4).map(String)).toEqual([]);
      expect(path('foo/bar/baz/qux').last(-5).map(String)).toEqual([]);
    });
  });

  describe('resolve', () => {
    test('returns a Path', () => {
      expect(isPath(path('foo').resolve)).toBe(true);
    });

    test('converts relative paths to absolute ones', () => {
      expect(path('bin/update-bundle').resolve.toString()).toBe(
        join(cwd(), 'bin/update-bundle'),
      );
    });

    test('expands "~"', () => {
      expect(path('~/foo').resolve.toString()).toBe(join(homedir(), 'foo'));
    });
  });

  describe('sep', () => {
    test('returns the path separator', () => {
      expect(path.sep).toBe(sep);
    });
  });

  describe('simplify', () => {
    test('returns a Path', () => {
      expect(isPath(path('foo').simplify)).toBe(true);
    });

    test('abbreviates to "~" if possible', () => {
      expect(path(join(homedir(), 'foo')).simplify.toString()).toBe('~/foo');
    });

    test('makes a path relative to the current directory', () => {
      const toRoot = relative(cwd(), '/');
      expect(path('/foo/bar').simplify.toString()).toBe(
        join(toRoot, 'foo/bar'),
      );
      expect(path('foo/bar').simplify.toString()).toBe('foo/bar');
      expect(path('foo').simplify.toString()).toBe('foo');
    });
  });

  describe('strip', () => {
    test('returns a Path', () => {
      expect(isPath(path('foo/bar.ext').strip('.ext'))).toBe(true);
    });

    test('strips off any matching extension', () => {
      expect(path('foo/bar.ext').strip('.ext').toString()).toBe('foo/bar');
      expect(path('foo/bar.ext').strip('.not').toString()).toBe('foo/bar.ext');
    });
  });
});
