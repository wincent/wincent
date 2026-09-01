import {execSync} from 'child_process';
import {existsSync, mkdirSync, readFileSync, statSync, writeFileSync} from 'fs';
import {dirname, join} from 'path';
import {fileURLToPath} from 'url';

export type Entry = {
  prefix: string;
  url: string;
  branch: string;
  previous: string;
  current: string;
  build?: string;
};

export type State = {
  [name: string]: Entry;
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

  /**
   * Point in time that the locally known remote-tracking refs describe, ie.
   * how out of date `bin/deps status`'s remote column may be.
   *
   * Normally this is the mtime of `.git/FETCH_HEAD`, which git rewrites on
   * every fetch whether or not anything new arrived. A repo that was cloned but
   * never fetched has no `FETCH_HEAD`, yet still has meaningful remote refs, so
   * fall back to those (reporting "never" there would be misleading).
   */
  get fetchedAt(): Date | null {
    for (
      const candidate of ['FETCH_HEAD', 'refs/remotes/origin', 'packed-refs']
    ) {
      try {
        return statSync(join(this._path, '.git', candidate)).mtime;
      } catch {
        continue;
      }
    }

    return null;
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

  /**
   * Number of commits in `fromRef..toRef`, or `null` if either ref is
   * unresolvable.
   */
  countCommits(fromRef: string, toRef: string): number | null {
    const output = this._capture('rev-list', [
      '--count',
      `${fromRef}..${toRef}`,
    ]);
    if (output == null) {
      return null;
    }
    const count = Number.parseInt(output, 10);
    return Number.isNaN(count) ? null : count;
  }

  /**
   * Locally known tip of `origin/<branch>`, as of the last fetch. Does not
   * touch the network.
   */
  remoteHead(branch: string): string | null {
    return this._capture('rev-parse', [
      '--verify',
      '--quiet',
      `refs/remotes/origin/${branch}`,
    ]);
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

/**
 * Options shared by the real sync and the dry run used by `bin/deps status`,
 * so that the latter is an accurate preview of the former.
 */
const RSYNC_OPTIONS: Array<string> = [
  '--archive',
  '--delete',
  '--delete-excluded',
  '--exclude=.git',
  '--exclude=.gitmodules',
];

function rsyncCommand(
  cachePath: string,
  targetPath: string,
  extraOptions: Array<string>,
): string {
  return [
    'rsync',
    ...RSYNC_OPTIONS,
    ...extraOptions,
    `"${cachePath}/"`,
    `"${targetPath}/"`,
  ].join(' ');
}

export function sync(cacheName: string, prefix: string): void {
  const cachePath = join(CACHE_DIR, cacheName);
  const targetPath = join(REPO_ROOT, prefix);
  console.log(`  [${prefix}] Syncing from cache...`);
  mkdirSync(dirname(targetPath), {recursive: true});
  execSync(rsyncCommand(cachePath, targetPath, ['--verbose']), {
    stdio: 'inherit',
  });
}

export type WorktreeDiff = {
  updated: number;
  deleted: number;
  /**
   * Of the above, how many are files that git ignores, eg. `*.zwc` files that
   * zsh compiles in place. A sync churns these (deleting them, after which
   * they are regenerated on demand), but since they are invisible to version
   * control they are not drift worth reporting as needing attention.
   */
  ignored: number;
};

type Changes = {
  deletions: Array<string>;
  updates: Array<string>;
  /**
   * Files whose mtime differs but whose size does not. Without checksums rsync
   * cannot tell these apart from genuine same-size edits, so their presence
   * means the result needs confirming with a second, more expensive pass.
   */
  ambiguous: number;
};

/**
 * Parses `rsync --itemize-changes` output, whose lines are an 11 character
 * flags field, a space, then the path. See the `--itemize-changes` section of
 * rsync(1) for the flag positions used below.
 */
function parseChanges(output: string): Changes {
  const changes: Changes = {ambiguous: 0, deletions: [], updates: []};

  for (const line of output.split('\n')) {
    // A leading "." means no transfer, ie. attributes alone differ.
    if (!line.trim() || line.startsWith('.')) {
      continue;
    }

    const space = line.indexOf(' ');
    const path = space === -1 ? '' : line.slice(space + 1).trimStart();

    if (!path || path === './') {
      continue;
    } else if (line.startsWith('*deleting')) {
      changes.deletions.push(path);
      continue;
    }

    const flags = line.slice(0, space);

    if (flags.includes('+') || flags[2] === 'c' || flags[3] === 's') {
      // New file, differing checksum, or differing size: definitely content.
      changes.updates.push(path);
    } else if (flags[4] === 't' || flags[4] === 'T') {
      changes.ambiguous++;
    }
  }

  return changes;
}

function itemize(
  cachePath: string,
  targetPath: string,
  extraOptions: Array<string>,
): string | null {
  try {
    return execSync(
      rsyncCommand(cachePath, targetPath, [
        '--dry-run',
        '--itemize-changes',
        ...extraOptions,
      ]),
      {
        encoding: 'utf8',
        maxBuffer: 64 * 1024 * 1024,
        stdio: ['ignore', 'pipe', 'ignore'],
      },
    );
  } catch {
    return null;
  }
}

/**
 * Counts the changes that a mirror-mode sync would make to the worktree, by
 * running the same rsync with `--dry-run --itemize-changes`.
 *
 * Runs in two phases. The first uses rsync's default quick check (size and
 * mtime), which is cheap but cannot distinguish a file that was merely touched
 * from one that was edited without changing size. Only when such ambiguous
 * files turn up do we pay for a second `--checksum` pass, which compares
 * content directly. In practice that keeps the common case fast while still
 * reporting only real differences.
 *
 * Returns `null` if the target path does not exist yet.
 */
export function diffWorktree(
  cacheName: string,
  prefix: string,
): WorktreeDiff | null {
  const cachePath = join(CACHE_DIR, cacheName);
  const targetPath = join(REPO_ROOT, prefix);

  if (!existsSync(targetPath)) {
    return null;
  }

  const quick = itemize(cachePath, targetPath, []);

  if (quick == null) {
    return null;
  }

  let changes = parseChanges(quick);

  if (changes.ambiguous > 0) {
    const checked = itemize(cachePath, targetPath, ['--checksum']);
    if (checked != null) {
      changes = parseChanges(checked);
    }
  }

  const {deletions, updates} = changes;

  return {
    deleted: deletions.length,
    ignored: countIgnored(targetPath, [...updates, ...deletions]),
    updated: updates.length,
  };
}

/**
 * How many of `paths` (relative to `cwd`) git considers ignored. Uses git's own
 * ignore logic, which correctly accounts for the `.gitignore` files that
 * dependencies ship and that we rsync into the worktree alongside their
 * sources.
 */
function countIgnored(cwd: string, paths: Array<string>): number {
  if (paths.length === 0) {
    return 0;
  }

  const count = (output: string | undefined) =>
    (output ?? '').split('\n').filter((line) => line.trim()).length;

  try {
    return count(execSync('git check-ignore --stdin', {
      cwd,
      encoding: 'utf8',
      input: paths.join('\n'),
      stdio: ['pipe', 'pipe', 'ignore'],
    }));
  } catch (error) {
    // `git check-ignore` exits 1 when nothing matched, which is not an error.
    return count((error as {stdout?: string}).stdout);
  }
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

/**
 * State of a cached repo relative to the commit pinned in `dependencies.json`.
 *
 * - `missing`: nothing cloned under `.cache/repos` yet.
 * - `absent`: cloned, but the pinned commit is not present (needs a fetch).
 * - `clean`: checked out exactly at the pinned commit.
 * - `ahead`: checked out at a descendant of the pinned commit (local work).
 * - `behind`: checked out at an ancestor of the pinned commit.
 * - `diverged`: neither an ancestor nor a descendant.
 * - `unknown`: `HEAD` could not be resolved.
 */
export type CacheState =
  | 'absent'
  | 'ahead'
  | 'behind'
  | 'clean'
  | 'diverged'
  | 'missing'
  | 'unknown';

/**
 * State of `origin/<branch>` relative to the pinned commit, as of the last
 * fetch. Never reflects the network directly: run `bin/deps fetch` to refresh.
 *
 * - `unfetched`: no `origin/<branch>` ref known locally.
 * - `current`: the remote tip is the pinned commit.
 * - `available`: the remote tip is ahead; `bin/deps update` would advance.
 * - `rewound`: the remote tip is behind or has diverged (eg. a force push).
 */
export type RemoteState = 'available' | 'current' | 'rewound' | 'unfetched';

/**
 * State of the worktree copy relative to the cached checkout.
 *
 * - `clean`: identical.
 * - `churn`: differs only in files git ignores (a sync would touch them, but
 *   nothing version-controlled would change).
 * - `drift`: differs in content that is under version control.
 * - `missing`: not present in the worktree at all.
 */
export type WorktreeState = 'churn' | 'clean' | 'drift' | 'missing';

const EMPTY_DIFF: WorktreeDiff = {deleted: 0, ignored: 0, updated: 0};

/**
 * Number of changes in `diff` that are visible to version control.
 */
export function meaningfulChanges(diff: WorktreeDiff): number {
  return Math.max(0, diff.updated + diff.deleted - diff.ignored);
}

function classifyWorktree(diff: WorktreeDiff | null): WorktreeState {
  if (diff == null) {
    return 'missing';
  } else if (meaningfulChanges(diff) > 0) {
    return 'drift';
  } else if (diff.ignored > 0) {
    return 'churn';
  }

  return 'clean';
}

export type Status = {
  id: string;
  prefix: string;
  branch: string;
  /** The commit pinned in `dependencies.json`. */
  pinned: string;
  cacheHead: string | null;
  remoteHead: string | null;
  cache: CacheState;
  /** Whether the cached repo has uncommitted changes to tracked files. */
  dirty: boolean;
  remote: RemoteState;
  /** Commits in `pinned..origin/<branch>`; 0 unless `remote` is `available`. */
  pending: number;
  worktree: WorktreeState;
  diff: WorktreeDiff;
  fetchedAt: Date | null;
};

/**
 * Compares a cached repo against the pinned commit. Shared by `bin/deps
 * status`, `bin/deps sync` and `bin/deps update` so that all three agree on
 * what "ahead" and "diverged" mean.
 */
export function classifyCache(
  repo: Repo,
  pinned: string,
): {state: CacheState; head: string | null} {
  if (!repo.exists) {
    return {state: 'missing', head: null};
  }

  const head = repo.HEAD;

  if (head == null) {
    return {state: 'unknown', head: null};
  } else if (head === pinned) {
    return {state: 'clean', head};
  } else if (!repo.hasCommit(pinned)) {
    return {state: 'absent', head};
  } else if (repo.isAncestor(pinned, head)) {
    return {state: 'ahead', head};
  } else if (repo.isAncestor(head, pinned)) {
    return {state: 'behind', head};
  }

  return {state: 'diverged', head};
}

/**
 * Gathers the full local picture for one dependency, comparing all of:
 * `origin/<branch>` (as last fetched), `dependencies.json`, `.cache/repos` and
 * the worktree. Performs no network access and writes nothing.
 *
 * The worktree comparison is the expensive part (one rsync dry run per
 * dependency), so it can be skipped with `worktree: false`.
 */
export function classify(
  id: string,
  entry: Entry,
  {worktree = true}: {worktree?: boolean} = {},
): Status {
  const {branch, current: pinned, prefix} = entry;
  const repo = new Repo(join(CACHE_DIR, id));

  const {head: cacheHead, state: cache} = classifyCache(repo, pinned);
  const dirty = cache !== 'missing' && repo.isDirty();
  const remoteHead = repo.exists ? repo.remoteHead(branch) : null;

  let remote: RemoteState = 'unfetched';
  let pending = 0;

  if (remoteHead != null) {
    if (remoteHead === pinned) {
      remote = 'current';
    } else if (repo.hasCommit(pinned) && repo.isAncestor(pinned, remoteHead)) {
      remote = 'available';
      pending = repo.countCommits(pinned, remoteHead) ?? 0;
    } else {
      remote = 'rewound';
    }
  }

  const diff = worktree ? diffWorktree(id, prefix) : null;

  // Even when skipping the (expensive) content comparison, checking for a
  // wholly absent worktree copy is free, and worth not missing.
  const state = worktree
    ? classifyWorktree(diff)
    : existsSync(join(REPO_ROOT, prefix))
    ? 'clean'
    : 'missing';

  return {
    branch,
    cache,
    cacheHead,
    diff: diff ?? EMPTY_DIFF,
    dirty,
    fetchedAt: repo.fetchedAt,
    id,
    pending,
    pinned,
    prefix,
    remote,
    remoteHead,
    worktree: state,
  };
}

/**
 * Whether a dependency's local tiers (lockfile, cache, worktree) disagree, ie.
 * something needs your attention.
 *
 * Deliberately ignores `remote`, so that upstream simply moving on does not
 * read as a problem, and ignores `churn`, so that regenerable artifacts git
 * does not track do not either. Without both exclusions this would be true
 * almost always, and would stop meaning anything.
 */
export function hasLocalDrift(status: Status): boolean {
  return (
    status.cache !== 'clean' ||
    status.dirty ||
    status.worktree === 'drift' ||
    status.worktree === 'missing'
  );
}

export function shortHash(hash: string | null): string {
  return hash == null ? '-------' : hash.substring(0, 7);
}

/**
 * Coarse human-readable age, eg. "3d ago". Deliberately low-resolution: the
 * only question it needs to answer is "is my fetch data stale enough to
 * distrust?".
 */
export function formatAge(date: Date | null): string {
  if (date == null) {
    return 'never';
  }

  const seconds = Math.max(0, (Date.now() - date.getTime()) / 1000);
  const units: Array<[limit: number, size: number, suffix: string]> = [
    [60, 1, 's'],
    [60 * 60, 60, 'm'],
    [60 * 60 * 24, 60 * 60, 'h'],
    [60 * 60 * 24 * 7, 60 * 60 * 24, 'd'],
    [Infinity, 60 * 60 * 24 * 7, 'w'],
  ];

  for (const [limit, size, suffix] of units) {
    if (seconds < limit) {
      return `${Math.floor(seconds / size)}${suffix} ago`;
    }
  }

  return 'never';
}
