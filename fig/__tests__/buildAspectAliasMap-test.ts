import * as assert from 'node:assert';
import {describe, test} from 'node:test';

import ErrorWithMetadata from '../ErrorWithMetadata.ts';
import buildAspectAliasMap from '../buildAspectAliasMap.ts';

describe('buildAspectAliasMap()', () => {
  test('returns an empty map when no aliases are declared', () => {
    const map = buildAspectAliasMap([{name: 'homebrew', aliases: []}, {
      name: 'apt',
      aliases: [],
    }]);

    assert.strictEqual(map.size, 0);
  });

  test('maps each alias to its canonical aspect name', () => {
    const map = buildAspectAliasMap([{name: 'homebrew', aliases: ['brew']}, {
      name: 'apt',
      aliases: ['apt-get', 'aptitude'],
    }, {name: 'nvim', aliases: []}]);

    assert.strictEqual(map.get('brew'), 'homebrew');
    assert.strictEqual(map.get('apt-get'), 'apt');
    assert.strictEqual(map.get('aptitude'), 'apt');
    assert.strictEqual(map.size, 3);
  });

  test('rejects an alias that collides with an aspect name', () => {
    assert.throws(
      () =>
        buildAspectAliasMap([{name: 'homebrew', aliases: []}, {
          name: 'apt',
          aliases: ['homebrew'],
        }]),
      (error) => {
        return error instanceof ErrorWithMetadata &&
          error.message.includes('conflicts with an existing aspect name');
      },
    );
  });

  test('rejects an alias claimed by two aspects', () => {
    assert.throws(
      () =>
        buildAspectAliasMap([{name: 'homebrew', aliases: ['pkg']}, {
          name: 'apt',
          aliases: ['pkg'],
        }]),
      (error) => {
        return error instanceof ErrorWithMetadata &&
          error.message.includes('claimed by both');
      },
    );
  });
});
