## Commands

```sh
bin/yarn clean                # Removes built files from "lib/".
bin/yarn format:check         # Checks formatting.
bin/yarn format               # Fixes formatting (with Prettier).
bin/yarn version --prerelease # (Or similar): Bumps version number.
bin/yarn compile              # Typecheck only.
bin/yarn build                # Generates "lib/main.mjs".
```

### `yarn version` variants

As [documented here](https://classic.yarnpkg.com/lang/en/docs/cli/version/):

```sh
bin/yarn version              # Prompts interactively for new version.
bin/yarn version --prerelease # Bumps prerelease number (eg. v2.0.0-pre.3 → v2.0.0.pre.4).
bin/yarn version --patch      # Bumps patch number (eg. v2.0.0 → v2.0.1).
bin/yarn version --minor      # Bumps minor version number (eg. v2.0.0 → v2.1.0).
bin/yarn version --major      # Bumps major version number (eg. v2.0.0 → v3.0.0).

# Bumps major version number and labels as first "pre" prerelasee (eg. v2.0.0 → v3.0.0-pre.0):
bin/yarn version --major --preid pre
```

## Publishing releases

After updating the [CHANGELOG](./CHANGELOG.md):

```sh
bin/yarn compile
bin/yarn version
bin/yarn build
git push --follow-tags origin next
npm login # May be required one time only, in order for `publish` to work in the next step.
npm publish
```

**NOTE:** We're using `npm publish` and not `yarn publish` because the latter appears to have different heuristics fo determining what is included in the published tarball (specifically, it includes `.gitignore` files even in directories not listed under the "files" property of the `package.json` (ie. `vendor/node/.gitignore`).
