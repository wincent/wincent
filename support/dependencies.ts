import {execSync} from 'child_process';
import {existsSync, mkdirSync, readFileSync, writeFileSync} from 'fs';
import {dirname, join} from 'path';
import {fileURLToPath} from 'url';

export type State = {
  [name: string]: {
    prefix: string;
    url: string;
    branch: string;
    previous: string;
    current: string;
    build?: string;
  };
};

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

export const REPO_ROOT: string = join(__dirname, '..');
export const CACHE_DIR: string = join(REPO_ROOT, '.cache', 'repos');
export const DEPENDENCIES_FILE: string = join(REPO_ROOT, 'dependencies.json');

export class Repo {
  _path: string;

  static clone(url: string, branch: string, path: string): Repo {
    const repo = new Repo(path);

    if (repo.exists) {
      throw new Error(
        `Cannot clone on top of existing repository at path: ${path}`,
      );
    }

    execSync(`git clone --branch ${branch} ${url} ${path}`, {
      stdio: 'inherit',
    });

    return repo;
  }

  constructor(path: string) {
    this._path = path;
  }

  get HEAD(): string | null {
    return this._capture('rev-parse', ['HEAD']);
  }

  get exists(): boolean {
    return existsSync(join(this._path, '.git'));
  }

  checkout(commitish: string): void {
    this._exec('checkout', [commitish]);
  }

  fetch(refspec: string): void {
    this._exec('fetch', [refspec]);
  }

  log(fromRef: string, toRef: string): string | null {
    return this._capture('log', [
      '--oneline',
      '--no-decorate',
      `${fromRef}..${toRef}`,
    ]);
  }

  merge(commit: string): void {
    return this._exec('merge', [commit]);
  }

  hasCommit(commitish: string): boolean {
    return this._test('rev-parse', [
      '--verify',
      '--quiet',
      `${commitish}^{commit}`,
    ]);
  }

  isAncestor(ancestor: string, descendant: string): boolean {
    return this._test('merge-base', ['--is-ancestor', ancestor, descendant]);
  }

  isDirty(): boolean {
    return !!this._capture('status', ['--porcelain', '--untracked-files=no']);
  }

  /**
   * `args` is trusted input, assumed to not contain any characters that would
   * require escaping.
   */
  _capture(command: string, args: Array<string>): string | null {
    try {
      return execSync(`git ${command} ${args.join(' ')}`, {
        cwd: this._path,
        encoding: 'utf8',
      }).trim();
    } catch (error) {
      return null;
    }
  }

  /**
   * `args` is trusted input, assumed to not contain any characters that would
   * require escaping.
   */
  _exec(command: string, args: Array<string>): void {
    execSync(`git ${command} ${args.join(' ')}`, {
      cwd: this._path,
      stdio: 'inherit',
    });
  }

  /**
   * Runs a command purely for its exit status. `args` is trusted input,
   * assumed to not contain any characters that would require escaping.
   */
  _test(command: string, args: Array<string>): boolean {
    try {
      execSync(`git ${command} ${args.join(' ')}`, {
        cwd: this._path,
        stdio: 'ignore',
      });
      return true;
    } catch {
      return false;
    }
  }
}

function isObject(value: unknown): value is {} {
  return !!(value && typeof value === 'object');
}

function validate(state: unknown): asserts state is State {
  if (
    isObject(state) &&
    Object.values(state).every((value: unknown) => {
      return (
        isObject(value) &&
        ('prefix' in value) &&
        typeof value.prefix === 'string' &&
        ('url' in value) &&
        typeof value.url === 'string' &&
        ('branch' in value) &&
        typeof value.branch === 'string' &&
        ('previous' in value) &&
        typeof value.previous === 'string' &&
        ('current' in value) &&
        typeof value.current === 'string' &&
        (!('build' in value) || typeof value.build === 'string')
      );
    })
  ) {
    return;
  }
  throw new Error('Invalid State object');
}

export function load(): State {
  if (existsSync(DEPENDENCIES_FILE)) {
    try {
      const state = JSON.parse(readFileSync(DEPENDENCIES_FILE, 'utf8'));
      validate(state);
      return state;
    } catch {
      throw new Error('Could not parse dependencies.json');
    }
  }
  return {};
}

export function getDependenciesList(state: State): Array<{
  id: string;
  prefix: string;
  url: string;
  branch: string;
  build?: string;
}> {
  return Object.entries(state).map(([id, {prefix, url, branch, build}]) => ({
    id,
    prefix,
    url,
    branch,
    build,
  }));
}

/**
 * Case-insensitive substring match of `pattern` against a dependency's id (its
 * key in `dependencies.json`, eg. "github/wincent/command-t") and its installed
 * prefix path (eg. "aspects/nvim/.../opt/command-t").
 */
export function matchesPattern(
  id: string,
  prefix: string,
  pattern: string,
): boolean {
  const needle = pattern.toLowerCase();
  return (
    id.toLowerCase().includes(needle) || prefix.toLowerCase().includes(needle)
  );
}

/**
 * Filter `items` down to those matching at least one of `patterns`. With no
 * patterns, `items` is returned unchanged. Otherwise, each pattern that matches
 * nothing warns (and is skipped), and a summary line prefixed with `verb` (eg.
 * "Updating", "Syncing") is printed describing the selection. Returns the
 * filtered list; callers decide what to do when it is empty.
 */
export function selectByPatterns<T>(
  items: Array<T>,
  patterns: Array<string>,
  getKey: (item: T) => {id: string; prefix: string},
  verb: string,
): Array<T> {
  if (patterns.length === 0) {
    return items;
  }

  for (const pattern of patterns) {
    if (
      !items.some((item) => {
        const {id, prefix} = getKey(item);
        return matchesPattern(id, prefix, pattern);
      })
    ) {
      console.warn(`warning: no dependencies matched pattern: ${pattern}`);
    }
  }

  const filtered = items.filter((item) => {
    const {id, prefix} = getKey(item);
    return patterns.some((pattern) => matchesPattern(id, prefix, pattern));
  });

  if (filtered.length > 0) {
    console.log(
      `${verb} ${filtered.length} of ${items.length} ` +
        `${items.length === 1 ? 'dependency' : 'dependencies'} ` +
        `matching: ${patterns.join(', ')}\n`,
    );
  }

  return filtered;
}

export function save(state: State): void {
  writeFileSync(DEPENDENCIES_FILE, JSON.stringify(state, null, 2) + '\n');
}

export function sync(cacheName: string, prefix: string): void {
  const cachePath = join(CACHE_DIR, cacheName);
  const targetPath = join(REPO_ROOT, prefix);
  console.log(`  [${prefix}] Syncing from cache...`);
  mkdirSync(dirname(targetPath), {recursive: true});
  execSync(
    `rsync -av --delete --delete-excluded --exclude=.git --exclude=.gitmodules "${cachePath}/" "${targetPath}/"`,
    {
      stdio: 'inherit',
    },
  );
}

export function build(
  cacheName: string,
  prefix: string,
  command: string,
): void {
  const cachePath = join(CACHE_DIR, cacheName);
  console.log(`  [${prefix}] Building (${command})...`);
  execSync(command, {
    cwd: cachePath,
    stdio: 'inherit',
  });
}
