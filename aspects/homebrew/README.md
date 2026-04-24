Configures [Homebrew](https://brew.sh).

## Adding a formula, cask, or tap

You can run `brew install` as normal and later regenerate the task lists as described in the section below or you can do an incremental update as follows; for example, adding the "orion" cask:

```shell
# Confirm the cask exists and copy its description.
brew info orion

# Add the cask to the appropriate manifest.
vim aspects/homebrew/support/common.json

# Update generated files; running with no options updates the ".ts" task lists from the ".json" manifests.
bin/brew-bundle-dump

# Check the resulting diff.
jj diff

# Confirm the task works by running it.
./install homebrew --start orion --step
```

## Regenerating the common, personal, and work task lists

The per-profile task modules (`common.ts`, `personal.ts`, `work.ts`) and their corresponding metadata files (`support/common.json`, `support/personal.json`, `support/work.json`) are generated from `brew bundle dump` output.

To regenerate after installing/removing packages:

1. On the work machine: `brew bundle dump --file=- > /tmp/work.dump`
2. On the personal machine: `brew bundle dump --file=- > /tmp/personal.dump`
3. Copy both dumps onto a single machine, then:

   ```sh
   bin/brew-bundle-dump \
     --work-dump=/tmp/work.dump \
     --personal-dump=/tmp/personal.dump
   ```

4. Review the regenerated files (any human-supplied `note` annotations and `binary` overrides in the `support/*.json` files are preserved).
5. If `work.ts` or `support/work.json` changed, re-run `bin/encrypt`.
6. `bin/format` (to catch any formatter drift).

If you only want to regenerate the `.ts` files from the current JSON metadata (eg. after hand-editing a `note` or adding a package as described previously), run `bin/brew-bundle-dump` with no arguments.

## Annotations

The `support/*.json` files are the source of truth. Each item may carry an optional `note` field that will appear as a comment next to the generated task. For example, to record why a dependency tap is needed:

```json
{
  "name": "dart-lang/dart",
  "url": null,
  "note": "Dependency of the `sass` formula"
}
```

For cargo crates where the binary name differs from the crate name (eg. `diesel_cli` installs a binary called `diesel`), edit the `binary` field:

```json
{
  "name": "diesel_cli",
  "binary": "diesel",
  "description": null,
  "note": null
}
```

Annotations are preserved across regeneration (keyed on `name`).
