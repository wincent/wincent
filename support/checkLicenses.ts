import {existsSync, lstatSync, readdirSync, readlinkSync} from 'fs';
import {join, relative, resolve} from 'path';

import {REPO_ROOT, load} from './dependencies.ts';

const LICENSES_DIR = join(REPO_ROOT, 'LICENSES');

// Files in `LICENSES/` that are not third-party licenses and therefore have no
// corresponding entry in `dependencies.json`.
const EXEMPT_LICENSES = new Set(['wincent-LICENSE.md']);

// Dependency prefixes from `dependencies.json` that are allowed to have no
// corresponding license symlink in `LICENSES/`, each mapped to a justification.
// `bin/check-licenses` complains if an exemption becomes unnecessary (i.e., the
// dependency starts shipping a license that we can symlink, or is removed from
// `dependencies.json`) so stale exemptions get cleaned up rather than rotting.
const EXEMPT_PREFIXES = new Map<string, string>([
  [
    'aspects/nvim/files/.config/nvim/pack/bundle/opt/applescript.vim',
    'No license declared anywhere in the distribution.',
  ],
  [
    'aspects/nvim/files/.config/nvim/pack/bundle/opt/cmp-calc',
    'No license declared anywhere in the distribution. Probably MIT like other cmp plugins.',
  ],
  [
    'aspects/nvim/files/.config/nvim/pack/bundle/opt/cmp-emoji',
    'No license declared anywhere in the distribution. Probably MIT like other cmp plugins.',
  ],
  [
    'aspects/nvim/files/.config/nvim/pack/bundle/opt/vim-ansible-yaml',
    'No license declared anywhere in the distribution.',
  ],
  [
    'aspects/nvim/files/.config/nvim/pack/bundle/opt/vim-git',
    'No license declared anywhere in the distribution. Probably Vim-like licensed like other tpope plugins.',
  ],
]);

// Naming convention for symlinks in `LICENSES/`: each symlink's name must
// equal `<identifier>` or start with `<identifier>-`, where `<identifier>` is
// the basename of the dependency's prefix (e.g., "command-t") or, if listed
// in `NAMING_OVERRIDES`, the editorial replacement for that prefix. Add an
// override only when the prefix's path basename is too generic to be a useful
// identifier in `LICENSES/` on its own.
const NAMING_OVERRIDES = new Map<string, string>([
  ['vendor/tinted-theming/schemes', 'tinted-theming-schemes'],
  ['aspects/dotfiles/files/.config/yazi/vendor/plugins', 'yazi-plugins'],
]);

type Issue = {name: string; detail: string};

const state = load();
const prefixes = Object.values(state).map(({prefix}) => prefix);
const prefixSet = new Set(prefixes);

const orphans: Array<Issue> = [];
const broken: Array<Issue> = [];
const misnamed: Array<Issue> = [];
const notSymlinks: Array<Issue> = [];
const matchedPrefixes = new Set<string>();

for (const name of readdirSync(LICENSES_DIR).sort()) {
  if (EXEMPT_LICENSES.has(name)) {
    continue;
  }

  const fullPath = join(LICENSES_DIR, name);
  const stats = lstatSync(fullPath);

  if (!stats.isSymbolicLink()) {
    notSymlinks.push({name, detail: '(not a symlink)'});
    continue;
  }

  const link = readlinkSync(fullPath);
  const absoluteTarget = resolve(LICENSES_DIR, link);
  const relativeTarget = relative(REPO_ROOT, absoluteTarget);

  const matched = prefixes.find(
    (prefix) =>
      relativeTarget === prefix || relativeTarget.startsWith(prefix + '/'),
  );

  if (matched === undefined) {
    orphans.push({name, detail: `-> ${link}`});
  } else {
    matchedPrefixes.add(matched);

    // Naming check: the symlink name must start with an identifier derived
    // from the dependency it covers. Only run this when we found a matching
    // prefix; otherwise the orphan report above already covers the problem.
    const identifier =
      NAMING_OVERRIDES.get(matched) ?? matched.split('/').pop()!;
    if (name !== identifier && !name.startsWith(identifier + '-')) {
      misnamed.push({
        name,
        detail: `(name must start with "${identifier}-")`,
      });
    }
  }

  if (!existsSync(absoluteTarget)) {
    broken.push({name, detail: `-> ${link}`});
  }
}

const missing = prefixes.filter(
  (prefix) => !matchedPrefixes.has(prefix) && !EXEMPT_PREFIXES.has(prefix),
);

// An entry in `EXEMPT_PREFIXES` is stale if the dependency now has a matching
// symlink (the exemption is no longer needed) or has been removed from
// `dependencies.json` (the exemption refers to nothing).
const staleExemptions = [...EXEMPT_PREFIXES.keys()].filter(
  (prefix) => !prefixSet.has(prefix) || matchedPrefixes.has(prefix),
);

let exitCode = 0;

function report(heading: string, issues: ReadonlyArray<Issue | string>): void {
  if (issues.length === 0) {
    return;
  }
  if (exitCode !== 0) {
    console.error('');
  }
  console.error(heading);
  for (const issue of issues) {
    if (typeof issue === 'string') {
      console.error(`  ${issue}`);
    } else {
      console.error(`  ${issue.name} ${issue.detail}`);
    }
  }
  exitCode = 1;
}

report(
  'Files in LICENSES/ that are not symlinks (and not in the exempt list):',
  notSymlinks,
);
report(
  'Symlinks in LICENSES/ with no matching prefix in dependencies.json:',
  orphans,
);
report('Broken symlinks in LICENSES/ (target does not exist):', broken);
report(
  'Symlinks in LICENSES/ whose name does not start with a recognized ' +
    'dependency identifier (see NAMING_OVERRIDES in checkLicenses.ts if ' +
    'an editorial name is intended):',
  misnamed,
);
report(
  'Dependencies in dependencies.json with no matching symlink in LICENSES/:',
  missing,
);
report(
  'Stale entries in EXEMPT_PREFIXES (dependency now has a license symlink, ' +
    'or is no longer in dependencies.json) — remove from checkLicenses.ts:',
  staleExemptions,
);

if (exitCode === 0) {
  console.log(
    `OK: ${prefixes.length} dependencies ` +
      `(${matchedPrefixes.size} with license symlink, ` +
      `${EXEMPT_PREFIXES.size} exempt), ` +
      `${EXEMPT_LICENSES.size} exempt license file` +
      `${EXEMPT_LICENSES.size === 1 ? '' : 's'}.`,
  );
}

process.exit(exitCode);
