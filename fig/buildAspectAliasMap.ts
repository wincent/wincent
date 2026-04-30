import ErrorWithMetadata from './ErrorWithMetadata.ts';
import stringify from './stringify.ts';

type AspectEntry = {
  name: string;
  aliases: ReadonlyArray<string>;
};

/**
 * Build a map from alias → canonical aspect name, validating that:
 *
 * - no alias collides with an existing aspect's directory name; and
 * - no alias is claimed by more than one aspect.
 *
 * Throws on collision.
 */
export default function buildAspectAliasMap(
  entries: ReadonlyArray<AspectEntry>,
): Map<string, string> {
  const aspectNames = new Set(entries.map((entry) => entry.name));
  const aliasMap = new Map<string, string>();

  for (const {name, aliases} of entries) {
    for (const alias of aliases) {
      if (aspectNames.has(alias)) {
        throw new ErrorWithMetadata(
          `Alias ${stringify(alias)} on aspect ${
            stringify(name)
          } conflicts with an existing aspect name`,
        );
      }

      const existing = aliasMap.get(alias);

      if (existing !== undefined && existing !== name) {
        throw new ErrorWithMetadata(
          `Alias ${stringify(alias)} is claimed by both ${
            stringify(existing)
          } and ${stringify(name)}`,
        );
      }

      aliasMap.set(alias, name);
    }
  }

  return aliasMap;
}
