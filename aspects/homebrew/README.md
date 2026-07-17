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
5. `bin/format` (the generator emits unwrapped source; this fixes any formatter drift).
6. If `work.ts` or `support/work.json` changed, re-run `bin/encrypt` (do this _after_ formatting, or the ciphertext will lag the formatted plaintext).

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

For non-official taps (anything other than `homebrew/core`/`homebrew/cask`), the generator also emits an idempotent `brew trust` task next to each `brew tap` task, so that Homebrew keeps loading the tap's formulae and casks once tap trust becomes mandatory (see [Tap Trust](https://docs.brew.sh/Tap-Trust)). By default it trusts at the formula/cask level (the recommended granularity) for every item we install from the tap, falling back to whole-tap trust for taps that use a custom remote (Homebrew ignores per-item trust for those). Per-item trust only covers the exact items we install: if one of those items references a _sibling_ formula/cask in the same tap, whether as a dependency (eg. `openai/tools/tart` pulls in `openai/tools/softnet`) or via `conflicts_with` (eg. `dart-lang/dart/dart` conflicts with `dart-lang/dart/dart-beta`), that sibling is **not** trusted, and `brew upgrade` will refuse to load it. Switch such taps to whole-tap trust with an explicit `trust` annotation of `["tap"]`. Likewise, when a tap is only present as a transitive dependency, or when its formula lives in a different profile, there is nothing to derive a target from, so add an explicit `trust` array. Each entry is either `"tap"` (whole-tap trust) or `"<type>:<name>"` where `<type>` is `formula`, `cask`, or `command`:

```json
{
  "name": "dart-lang/dart",
  "url": null,
  "note": "needed by sass/sass/sass; dart conflicts with its sibling dart-beta, so trust the whole tap",
  "trust": ["tap"]
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
