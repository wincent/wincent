/**
 * @file
 *
 * Generator for the `aspects/homebrew/{common,personal,work}.{json,ts}` files.
 *
 * Reads `brew bundle dump` output from a "personal" and a "work" machine,
 * computes the three-way split (common/personal-only/work-only) and emits:
 *
 *   - JSON metadata files at `aspects/homebrew/support/{profile}.json`,
 *     preserving any human-supplied annotations (`note`, overridden `binary`,
 *     etc.) found in pre-existing JSON files.
 *   - Corresponding generated TypeScript modules at
 *     `aspects/homebrew/{profile}.ts`, each registering one task per item
 *     (tap, formula, cask, crate, Go package).
 *
 * Invoked via `bin/brew-bundle-dump`:
 *
 *   # Normal (regenerate everything from fresh dumps + existing annotations):
 *   bin/brew-bundle-dump --work-dump=<file> --personal-dump=<file>
 *
 *   # Regenerate `.ts` files from the current JSON only (eg. after editing a
 *   # `note` by hand):
 *   bin/brew-bundle-dump
 */

import {execFileSync} from 'node:child_process';
import {existsSync, mkdirSync, readFileSync, writeFileSync} from 'node:fs';
import {dirname, join} from 'node:path';
import {fileURLToPath} from 'node:url';

const HERE = dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = join(HERE, '..');
const ASPECT_DIR = join(REPO_ROOT, 'aspects/homebrew');
const SUPPORT_DIR = join(ASPECT_DIR, 'support');

// `GOPATH` is hard-coded in `aspects/dotfiles/files/.zsh/exports` as
// `~/code/go`, so we can rely on this for the `creates:` check on Go binaries.
const GO_BIN = '~/code/go/bin';

// Taps that used to exist but were merged into `Homebrew/brew` in 4.5.0
// (https://brew.sh/2025/04/29/homebrew-4.5.0/). They may still appear in
// older dumps.
const OBSOLETE_TAPS = new Set(['homebrew/bundle', 'homebrew/services']);

type Profile = 'common' | 'personal' | 'work';

type Tap = {
  name: string;
  url: string | null;
  note: string | null;
};

type Formula = {
  name: string;
  /** Eg. `"homebrew/core"` or `"sass/sass"`. */
  tap: string;
  description: string | null;
  /** Eg. `["HEAD"]`, passed as `--HEAD`. */
  args: Array<string>;
  restartService: boolean;
  note: string | null;
};

type Cask = {
  name: string;
  /** Eg. `"homebrew/cask"` or `"datadog/tap"`. */
  tap: string;
  description: string | null;
  note: string | null;
};

type Crate = {
  name: string;
  /** Eg. `"diesel"` for the `diesel_cli` crate. Defaults to `name`. */
  binary: string;
  description: string | null;
  note: string | null;
};

type GoPackage = {
  name: string;
  /** Eg. `"sprig-cli"` for `github.com/DataDog/sprig-cli`. Defaults to last
   * path component. */
  binary: string;
  description: string | null;
  note: string | null;
};

type Metadata = {
  taps: Array<Tap>;
  formulae: Array<Formula>;
  casks: Array<Cask>;
  crates: Array<Crate>;
  goPackages: Array<GoPackage>;
};

type RawItems = {
  taps: Map<string, Tap>;
  formulae: Map<string, Formula>;
  casks: Map<string, Cask>;
  crates: Map<string, Crate>;
  goPackages: Map<string, GoPackage>;
};

function emptyMetadata(): Metadata {
  return {taps: [], formulae: [], casks: [], crates: [], goPackages: []};
}

function emptyRawItems(): RawItems {
  return {
    taps: new Map(),
    formulae: new Map(),
    casks: new Map(),
    crates: new Map(),
    goPackages: new Map(),
  };
}

/**
 * Parses a Brewfile-format file into a `RawItems` structure keyed by the
 * item's canonical name (ie. the `name` field).
 */
function parseDump(content: string): RawItems {
  const items = emptyRawItems();

  for (const rawLine of content.split('\n')) {
    const line = rawLine.replace(/\r$/, '');
    if (!line.trim() || line.trim().startsWith('#')) {
      continue;
    }

    const tapMatch = line.match(
      /^\s*tap\s+"([^"]+)"(?:\s*,\s*"([^"]+)")?/,
    );
    if (tapMatch) {
      const [, name, url] = tapMatch;
      if (OBSOLETE_TAPS.has(name!)) {
        continue;
      }
      items.taps.set(name!, {
        name: name!,
        url: url ?? null,
        note: null,
      });
      continue;
    }

    const brewMatch = line.match(/^\s*brew\s+"([^"]+)"(.*)$/);
    if (brewMatch) {
      const [, qualified, rest] = brewMatch;
      const {tap, name} = splitQualifiedName(qualified!, 'homebrew/core');
      const args = parseHeadArgs(rest ?? '');
      const restartService = /restart_service/.test(rest ?? '');
      items.formulae.set(name, {
        name,
        tap,
        description: null,
        args,
        restartService,
        note: null,
      });
      continue;
    }

    const caskMatch = line.match(/^\s*cask\s+"([^"]+)"/);
    if (caskMatch) {
      const [, qualified] = caskMatch;
      const {tap, name} = splitQualifiedName(qualified!, 'homebrew/cask');
      items.casks.set(name, {
        name,
        tap,
        description: null,
        note: null,
      });
      continue;
    }

    const cargoMatch = line.match(/^\s*cargo\s+"([^"]+)"/);
    if (cargoMatch) {
      const [, name] = cargoMatch;
      items.crates.set(name!, {
        name: name!,
        binary: name!,
        description: null,
        note: null,
      });
      continue;
    }

    const goMatch = line.match(/^\s*go\s+"([^"]+)"/);
    if (goMatch) {
      const [, name] = goMatch;
      const segments = name!.split('/');
      const binary = segments[segments.length - 1]!;
      items.goPackages.set(name!, {
        name: name!,
        binary,
        description: null,
        note: null,
      });
      continue;
    }
  }

  return items;
}

/**
 * Splits a (possibly fully-qualified) `brew`/`cask` name into a `tap` and a
 * local `name`. Defaults to `defaultTap` when only a local name is present.
 */
function splitQualifiedName(
  qualified: string,
  defaultTap: string,
): {tap: string; name: string} {
  const match = qualified.match(/^([^/]+\/[^/]+)\/(.+)$/);
  if (match) {
    return {tap: match[1]!, name: match[2]!};
  }
  return {tap: defaultTap, name: qualified};
}

/**
 * Extracts `args: ["HEAD"]`-style arguments from the "rest" of a `brew` line.
 * (In practice, `HEAD` is the only value we see here.)
 */
function parseHeadArgs(rest: string): Array<string> {
  const match = rest.match(/args\s*:\s*\[([^\]]*)\]/);
  if (!match) {
    return [];
  }
  const args: Array<string> = [];
  for (const token of match[1]!.matchAll(/"([^"]+)"|:(\w+)/g)) {
    args.push((token[1] ?? token[2])!);
  }
  return args;
}

/**
 * Given the parsed work and personal dumps, computes the three-way split.
 * An item is "common" if the key is present in both dumps, otherwise it
 * belongs to whichever dump it appeared in.
 */
function splitMetadata(
  work: RawItems,
  personal: RawItems,
): Record<Profile, RawItems> {
  const out: Record<Profile, RawItems> = {
    common: emptyRawItems(),
    personal: emptyRawItems(),
    work: emptyRawItems(),
  };

  type Category = keyof RawItems;
  const categories: Array<Category> = [
    'taps',
    'formulae',
    'casks',
    'crates',
    'goPackages',
  ];

  for (const category of categories) {
    const workCategory = work[category] as Map<string, unknown>;
    const personalCategory = personal[category] as Map<string, unknown>;

    const allKeys = new Set([
      ...workCategory.keys(),
      ...personalCategory.keys(),
    ]);

    for (const key of allKeys) {
      const inWork = workCategory.has(key);
      const inPersonal = personalCategory.has(key);
      const winner = inWork && inPersonal
        ? 'common'
        : inWork
        ? 'work'
        : 'personal';
      // When an item appears in both dumps we pick the work dump's copy as
      // the source of (non-key) metadata like `restart_service`/`args`. The
      // two dumps should normally agree; if they don't, the user should
      // reconcile the machines (or hand-edit the JSON afterwards).
      const src = winner === 'personal' ? personalCategory : workCategory;
      (out[winner][category] as Map<string, unknown>).set(key, src.get(key)!);
    }
  }

  return out;
}

/**
 * Loads `<profile>.json` if it exists, otherwise returns empty metadata.
 */
function loadExisting(profile: Profile): Metadata {
  const path = join(SUPPORT_DIR, `${profile}.json`);
  if (!existsSync(path)) {
    return emptyMetadata();
  }
  return JSON.parse(readFileSync(path, 'utf8')) as Metadata;
}

/**
 * Merges `raw` with any existing JSON, preserving human-supplied fields
 * (notably `note`, `binary`, and any `description` we have previously
 * fetched). Items no longer present in `raw` are dropped.
 */
function merge(raw: RawItems, existing: Metadata): Metadata {
  const indexed = {
    taps: new Map(existing.taps.map((t) => [t.name, t])),
    formulae: new Map(existing.formulae.map((f) => [f.name, f])),
    casks: new Map(existing.casks.map((c) => [c.name, c])),
    crates: new Map(existing.crates.map((c) => [c.name, c])),
    goPackages: new Map(existing.goPackages.map((g) => [g.name, g])),
  };

  return {
    taps: sortByName(
      [...raw.taps.values()].map((t) => {
        const prior = indexed.taps.get(t.name);
        return {
          name: t.name,
          url: t.url ?? prior?.url ?? null,
          note: prior?.note ?? null,
        };
      }),
    ),
    formulae: sortByName(
      [...raw.formulae.values()].map((f) => {
        const prior = indexed.formulae.get(f.name);
        return {
          name: f.name,
          tap: f.tap,
          description: prior?.description ?? null,
          args: f.args,
          restartService: f.restartService,
          note: prior?.note ?? null,
        };
      }),
    ),
    casks: sortByName(
      [...raw.casks.values()].map((c) => {
        const prior = indexed.casks.get(c.name);
        return {
          name: c.name,
          tap: c.tap,
          description: prior?.description ?? null,
          note: prior?.note ?? null,
        };
      }),
    ),
    crates: sortByName(
      [...raw.crates.values()].map((c) => {
        const prior = indexed.crates.get(c.name);
        return {
          name: c.name,
          binary: prior?.binary ?? c.binary,
          description: prior?.description ?? null,
          note: prior?.note ?? null,
        };
      }),
    ),
    goPackages: sortByName(
      [...raw.goPackages.values()].map((g) => {
        const prior = indexed.goPackages.get(g.name);
        return {
          name: g.name,
          binary: prior?.binary ?? g.binary,
          description: prior?.description ?? null,
          note: prior?.note ?? null,
        };
      }),
    ),
  };
}

function sortByName<T extends {name: string}>(items: Array<T>): Array<T> {
  const compare = (a: T, b: T) => {
    if (a.name < b.name) {
      return -1;
    }
    if (a.name > b.name) {
      return 1;
    }
    return 0;
  };
  return [...items].sort(compare);
}

/**
 * Fetches formula/cask descriptions from `brew info`, populating items whose
 * `description` is currently `null`. Uses a single bulk query for installed
 * items first, then individual queries for anything still missing.
 */
function fetchDescriptions(metadata: Record<Profile, Metadata>): void {
  // Gather all items needing descriptions across profiles.
  const formulaByFullName = new Map<string, Array<Formula>>();
  const caskByName = new Map<string, Array<Cask>>();

  for (const profile of ['common', 'personal', 'work'] as const) {
    for (const f of metadata[profile].formulae) {
      if (f.description) {
        continue;
      }
      const full = f.tap === 'homebrew/core' ? f.name : `${f.tap}/${f.name}`;
      let list = formulaByFullName.get(full);
      if (!list) {
        list = [];
        formulaByFullName.set(full, list);
      }
      list.push(f);
    }
    for (const c of metadata[profile].casks) {
      if (c.description) {
        continue;
      }
      let list = caskByName.get(c.name);
      if (!list) {
        list = [];
        caskByName.set(c.name, list);
      }
      list.push(c);
    }
  }

  if (formulaByFullName.size === 0 && caskByName.size === 0) {
    return;
  }

  // Bulk query: `brew info --installed` covers any item installed locally.
  try {
    const json = execFileSync(
      'brew',
      ['info', '--json=v2', '--installed'],
      {
        encoding: 'utf8',
        // `brew info --json=v2 --installed` output is several MB on a
        // well-populated machine; default `maxBuffer` is 1 MB.
        maxBuffer: 64 * 1024 * 1024,
        stdio: ['ignore', 'pipe', 'ignore'],
      },
    );
    const parsed = JSON.parse(json) as {
      formulae?: Array<{name: string; full_name?: string; desc?: string}>;
      casks?: Array<{token: string; desc?: string}>;
    };
    for (const f of parsed.formulae ?? []) {
      const desc = f.desc ?? null;
      if (!desc) { continue; }
      const key = f.full_name ?? f.name;
      // Match either fully-qualified or bare name.
      for (const candidate of [key, f.name]) {
        const list = formulaByFullName.get(candidate);
        if (list) {
          for (const item of list) {
            item.description = desc;
          }
        }
      }
    }
    for (const c of parsed.casks ?? []) {
      const list = caskByName.get(c.token);
      if (list && c.desc) {
        for (const item of list) {
          item.description = c.desc;
        }
      }
    }
  } catch {
    // Ignore; fall through to per-item lookups.
  }

  // Individual queries for anything still missing.
  const missingFormulae = [...formulaByFullName.entries()].filter(
    ([, list]) => list.some((item) => !item.description),
  );
  const missingCasks = [...caskByName.entries()].filter(
    ([, list]) => list.some((item) => !item.description),
  );

  if (missingFormulae.length) {
    console.error(
      `Fetching descriptions for ${missingFormulae.length} formula(e)...`,
    );
    for (const [full, list] of missingFormulae) {
      const desc = fetchSingleDescription('formula', full);
      if (desc) {
        for (const item of list) {
          item.description ??= desc;
        }
      }
    }
  }

  if (missingCasks.length) {
    console.error(
      `Fetching descriptions for ${missingCasks.length} cask(s)...`,
    );
    for (const [name, list] of missingCasks) {
      const desc = fetchSingleDescription('cask', name);
      if (desc) {
        for (const item of list) {
          item.description ??= desc;
        }
      }
    }
  }
}

function fetchSingleDescription(
  type: 'formula' | 'cask',
  name: string,
): string | null {
  try {
    const json = execFileSync(
      'brew',
      ['info', '--json=v2', `--${type}`, name],
      {
        encoding: 'utf8',
        maxBuffer: 64 * 1024 * 1024,
        stdio: ['ignore', 'pipe', 'ignore'],
      },
    );
    const parsed = JSON.parse(json) as {
      formulae?: Array<{desc?: string}>;
      casks?: Array<{desc?: string}>;
    };
    const entries = type === 'formula' ? parsed.formulae : parsed.casks;
    return entries?.[0]?.desc ?? null;
  } catch {
    return null;
  }
}

function escapeJS(value: string): string {
  return value
    .replace(/\\/g, '\\\\')
    .replace(/'/g, "\\'")
    .replace(/\n/g, '\\n')
    .replace(/\r/g, '\\r');
}

/**
 * Collapses newlines/carriage returns to spaces so that a single-line `//`
 * comment remains well-formed when the source description/note happens to be
 * multi-line.
 */
function flattenForComment(text: string): string {
  return text.replace(/[\r\n]+/g, ' ').trim();
}

function formatComment(desc: string | null, note: string | null): string {
  const lines: Array<string> = [];
  if (desc) {
    const d = flattenForComment(desc);
    lines.push(d.endsWith('.') ? d : `${d}.`);
  }
  if (note) {
    const n = flattenForComment(note);
    lines.push(n.endsWith('.') ? n : `${n}.`);
  }
  if (!lines.length) {
    return '';
  }
  return lines.map((l) => `// ${l}`).join('\n') + '\n';
}

/**
 * Renders a generated `.ts` module for the given profile.
 */
function render(profile: Profile, metadata: Metadata): string {
  const guard = profile === 'common' ? null : profile;
  const hasItems = metadata.taps.length > 0
    || metadata.formulae.length > 0
    || metadata.casks.length > 0
    || metadata.crates.length > 0
    || metadata.goPackages.length > 0;
  const needsHandler = metadata.formulae.some((f) => f.restartService);

  const body: Array<string> = [];

  body.push('/**');
  body.push(' * vim: set nomodifiable :');
  body.push(' *');
  body.push(' * @generated');
  body.push(' */');
  body.push('');

  if (!hasItems) {
    // Emit a self-explanatory placeholder module rather than unused imports
    // (which would break `noUnusedLocals`).
    body.push(`// No ${profile}-only Homebrew items.`);
    body.push('');
    body.push('export {};');
    body.push('');
    return body.join('\n');
  }

  const imports: Array<string> = ['command', 'task'];
  if (needsHandler) {
    imports.push('handler');
  }
  if (guard) {
    imports.push('helpers');
  }

  body.push(`import {${imports.sort().join(', ')}} from 'fig';`);
  if (guard) {
    body.push('');
    body.push('const {when} = helpers;');
  }
  body.push('');

  const guardArg = guard ? `when('${guard}'), ` : '';

  // --- Taps ---
  if (metadata.taps.length) {
    body.push('//');
    body.push('// Taps.');
    body.push('//');
    body.push('');
    for (const tap of metadata.taps) {
      const [org, name] = tap.name.split('/');
      const creates = `/opt/homebrew/Library/Taps/${org}/homebrew-${name}`;
      const comment = formatComment(null, tap.note);
      const args = [`'${escapeJS(tap.name)}'`];
      if (tap.url) {
        args.push(`'${escapeJS(tap.url)}'`);
      }
      body.push(
        `${comment}task('tap ${escapeJS(tap.name)}', ${guardArg}async () => {`,
      );
      body.push(`  await command('brew', ['tap', ${args.join(', ')}], {`);
      body.push(`    creates: '${creates}',`);
      body.push(`  });`);
      body.push(`});`);
      body.push('');
    }
  }

  // --- Formulae ---
  if (metadata.formulae.length) {
    body.push('//');
    body.push('// Formulae.');
    body.push('//');
    body.push('');
    for (const formula of metadata.formulae) {
      const qualified = formula.tap === 'homebrew/core'
        ? formula.name
        : `${formula.tap}/${formula.name}`;
      const creates = `/opt/homebrew/Cellar/${formula.name}`;
      const comment = formatComment(formula.description, formula.note);
      const brewArgs = ["'install'"];
      for (const arg of formula.args) {
        brewArgs.push(`'--${escapeJS(arg)}'`);
      }
      brewArgs.push(`'${escapeJS(qualified)}'`);

      const options: Array<string> = [`creates: '${creates}',`];
      if (formula.restartService) {
        options.push(`notify: 'restart ${escapeJS(formula.name)} service',`);
      }

      body.push(
        `${comment}task('install ${
          escapeJS(formula.name)
        } formula', ${guardArg}async () => {`,
      );
      body.push(`  await command('brew', [${brewArgs.join(', ')}], {`);
      for (const opt of options) {
        body.push(`    ${opt}`);
      }
      body.push(`  });`);
      body.push(`});`);
      body.push('');
    }
  }

  // --- Casks ---
  if (metadata.casks.length) {
    body.push('//');
    body.push('// Casks.');
    body.push('//');
    body.push('');
    for (const cask of metadata.casks) {
      const qualified = cask.tap === 'homebrew/cask'
        ? cask.name
        : `${cask.tap}/${cask.name}`;
      const creates = `/opt/homebrew/Caskroom/${cask.name}`;
      const comment = formatComment(cask.description, cask.note);
      body.push(
        `${comment}task('install ${
          escapeJS(cask.name)
        } cask', ${guardArg}async () => {`,
      );
      body.push(
        `  await command('brew', ['install', '--cask', '${
          escapeJS(qualified)
        }'], {`,
      );
      body.push(`    creates: '${creates}',`);
      body.push(`  });`);
      body.push(`});`);
      body.push('');
    }
  }

  // --- Crates ---
  if (metadata.crates.length) {
    body.push('//');
    body.push('// Cargo crates.');
    body.push('//');
    body.push('');
    for (const crate of metadata.crates) {
      const comment = formatComment(crate.description, crate.note);
      body.push(
        `${comment}task('install ${
          escapeJS(crate.name)
        } crate', ${guardArg}async () => {`,
      );
      body.push(
        `  await command('cargo', ['install', '${escapeJS(crate.name)}'], {`,
      );
      body.push(`    creates: '~/.cargo/bin/${escapeJS(crate.binary)}',`);
      body.push(`  });`);
      body.push(`});`);
      body.push('');
    }
  }

  // --- Go packages ---
  if (metadata.goPackages.length) {
    body.push('//');
    body.push('// Go packages.');
    body.push('//');
    body.push('');
    for (const pkg of metadata.goPackages) {
      const comment = formatComment(pkg.description, pkg.note);
      body.push(
        `${comment}task('install ${
          escapeJS(pkg.binary)
        } Go package', ${guardArg}async () => {`,
      );
      body.push(
        `  await command('go', ['install', '${escapeJS(pkg.name)}@latest'], {`,
      );
      body.push(`    creates: '${GO_BIN}/${escapeJS(pkg.binary)}',`);
      body.push(`  });`);
      body.push(`});`);
      body.push('');
    }
  }

  // --- Handlers for restart_service ---
  if (needsHandler) {
    body.push('//');
    body.push('// Handlers.');
    body.push('//');
    body.push('');
    for (const formula of metadata.formulae) {
      if (!formula.restartService) {
        continue;
      }
      body.push(
        `handler('restart ${escapeJS(formula.name)} service', async () => {`,
      );
      body.push(
        `  await command('brew', ['services', 'restart', '${
          escapeJS(formula.name)
        }']);`,
      );
      body.push(`});`);
      body.push('');
    }
  }

  return body.join('\n');
}

function parseArgs(argv: Array<string>): {
  workDump: string | null;
  personalDump: string | null;
} {
  let workDump: string | null = null;
  let personalDump: string | null = null;

  for (const arg of argv) {
    if (arg.startsWith('--work-dump=')) {
      workDump = arg.slice('--work-dump='.length);
    } else if (arg.startsWith('--personal-dump=')) {
      personalDump = arg.slice('--personal-dump='.length);
    } else if (arg === '-h' || arg === '--help') {
      console.log(
        'Usage: bin/brew-bundle-dump [--work-dump=<file> --personal-dump=<file>]',
      );
      process.exit(0);
    } else {
      console.error(`error: unknown argument: ${arg}`);
      process.exit(1);
    }
  }

  if ((workDump === null) !== (personalDump === null)) {
    console.error(
      'error: --work-dump and --personal-dump must be supplied together',
    );
    process.exit(1);
  }

  return {workDump, personalDump};
}

function main(): void {
  const {workDump, personalDump} = parseArgs(process.argv.slice(2));

  mkdirSync(SUPPORT_DIR, {recursive: true});

  let metadata: Record<Profile, Metadata>;

  if (workDump && personalDump) {
    if (!existsSync(workDump)) {
      console.error(`error: file not found: ${workDump}`);
      process.exit(1);
    }
    if (!existsSync(personalDump)) {
      console.error(`error: file not found: ${personalDump}`);
      process.exit(1);
    }

    console.error('Parsing dumps...');
    const workItems = parseDump(readFileSync(workDump, 'utf8'));
    const personalItems = parseDump(readFileSync(personalDump, 'utf8'));

    const split = splitMetadata(workItems, personalItems);

    metadata = {
      common: merge(split.common, loadExisting('common')),
      personal: merge(split.personal, loadExisting('personal')),
      work: merge(split.work, loadExisting('work')),
    };

    fetchDescriptions(metadata);

    for (const profile of ['common', 'personal', 'work'] as const) {
      const path = join(SUPPORT_DIR, `${profile}.json`);
      writeFileSync(path, JSON.stringify(metadata[profile], null, 2) + '\n');
      console.error(`  wrote ${relativeToRepo(path)}`);
    }
  } else {
    // No dumps supplied: regenerate only the `.ts` files from the existing
    // JSON metadata.
    metadata = {
      common: loadExisting('common'),
      personal: loadExisting('personal'),
      work: loadExisting('work'),
    };
  }

  for (const profile of ['common', 'personal', 'work'] as const) {
    const path = join(ASPECT_DIR, `${profile}.ts`);
    writeFileSync(path, render(profile, metadata[profile]));
    console.error(`  wrote ${relativeToRepo(path)}`);
  }

  console.error('Done.');
}

function relativeToRepo(path: string): string {
  return path.startsWith(REPO_ROOT + '/')
    ? path.slice(REPO_ROOT.length + 1)
    : path;
}

main();
