import {execSync} from 'child_process';
import {existsSync, mkdirSync, readFileSync, writeFileSync} from 'fs';
import {dirname, join} from 'path';
import {fileURLToPath} from 'url';

type State = {
  [name: string]: {
    prefix: string;
    url: string;
    branch: string;
    previous: string;
    current: string;
  };
};

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const REPO_ROOT = join(__dirname, '..');
const CACHE_DIR = join(REPO_ROOT, '.cache', 'repos');
const DEPENDENCIES_FILE = join(REPO_ROOT, 'dependencies.json');

class Repo {
  _path: string;

  constructor(path: string) {
    this._path = path;
  }

  get HEAD() {
    return this._capture('rev-parse', ['HEAD']);
  }

  get exists() {
    return existsSync(join(this._path, '.git'));
  }

  checkout(commitish: string): void {
    this._exec('checkout', [commitish]);
  }

  clone(url: string, branch: string): void {
    execSync(`git clone --branch ${branch} ${url} ${this._path}`, {
      stdio: 'inherit',
    });
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
        typeof value.current === 'string'
      );
    })
  ) {
    return;
  }
  throw new Error('Invalid State object');
}

function load(): State {
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

// Extract dependencies list from the state file.
function getDependenciesList(state: State): Array<{
  prefix: string;
  url: string;
  branch: string;
}> {
  return Object.values(state).map(({prefix, url, branch}) => ({
    prefix,
    url,
    branch,
  }));
}

function save(state: State): void {
  writeFileSync(DEPENDENCIES_FILE, JSON.stringify(state, null, 2) + '\n');
}

// Ensure cache directory exists.
mkdirSync(CACHE_DIR, {recursive: true});

// Load previous state
const state = load();
const DEPENDENCIES = getDependenciesList(state);
const changelog: Array<{
  prefix: string;
  cacheName: string;
  previousHead: string;
  currentHead: string;
  log: string;
}> = [];

// Process dependencies in parallel.
async function updateDependency({prefix, url, branch}: {
  prefix: string;
  url: string;
  branch: string;
}) {
  // Derive cache name from repo URL (e.g., github/wincent/command-t)
  const parsedUrl = new URL(url);
  const pathParts = parsedUrl.pathname.replace(/\.git$/, '').split('/').filter(
    Boolean,
  );
  const host = parsedUrl.hostname.split('.')[0]; // e.g., github.com -> github
  const cacheName = join(host, ...pathParts);
  const cachePath = join(CACHE_DIR, cacheName);
  const repo = new Repo(cachePath);

  console.log(`Processing ${prefix}...`);

  // Get previous HEAD if it exists.
  const previousState = state[cacheName] || {};
  const previousHead = previousState.current || null;

  // Clone or update cached repo.
  if (repo.exists) {
    console.log(`  [${prefix}] Updating cached repo...`);
    repo.fetch('origin');
    repo.checkout(branch);
    repo.merge(`origin/${branch}`);
  } else {
    console.log(`  [${prefix}] Cloning to cache...`);
    repo.clone(url, branch);
  }

  const currentHead = repo.HEAD;

  if (previousHead && currentHead && previousHead !== currentHead) {
    // Record new state and emit changelog entry.
    state[cacheName] = {
      prefix,
      url,
      branch,
      previous: previousHead,
      current: currentHead,
    };

    const log = repo.log(previousHead, currentHead);
    if (log) {
      changelog.push({
        prefix,
        cacheName,
        previousHead,
        currentHead,
        log,
      });
    }
  } else {
    // No change. Preserve previous state.
    state[cacheName] = previousState;
  }

  // Sync from cache to target using rsync.
  // Note: Build artifacts for subprojects like Command-T and Shellbot should
  // be built in the `.cache` directory so they get synced over and not deleted
  // due to `--delete`.
  const targetPath = join(REPO_ROOT, prefix);
  console.log(`  [${prefix}] Syncing from cache...`);
  mkdirSync(dirname(targetPath), {recursive: true});
  execSync(
    `rsync -av --delete --delete-excluded --exclude=.git --exclude=.gitmodules "${cachePath}/" "${targetPath}/"`,
    {
      stdio: 'inherit',
    },
  );

  console.log(`  [${prefix}] Done.\n`);
}

// Run updates in batches of 5.
const BATCH_SIZE = 5;
for (let i = 0; i < DEPENDENCIES.length; i += BATCH_SIZE) {
  const batch = DEPENDENCIES.slice(i, i + BATCH_SIZE);
  await Promise.all(batch.map(updateDependency));
}

save(state);

console.log('All dependencies updated successfully.');

// Print changelog.
if (changelog.length > 0) {
  console.log('\n' + '='.repeat(80));
  console.log('CHANGELOG');
  console.log('='.repeat(80) + '\n');

  for (const entry of changelog) {
    const from = entry.previousHead.substring(0, 7);
    const to = entry.currentHead.substring(0, 7);
    const lines = entry.log.split('\n');
    console.log(`* ${entry.prefix} ${from}..${to} (${lines.length}):`);
    console.log();
    // Indent each line of the log
    const indentedLog = lines.map((line) => `  ${line}`).join('\n');
    console.log(indentedLog);
    console.log();
  }

  console.log('='.repeat(80));
  console.log(
    `${changelog.length} ${
      changelog.length === 1 ? 'dependency' : 'dependencies'
    } updated`,
  );
  console.log('='.repeat(80));
} else {
  console.log('\nNo changes detected in any dependencies.');
}
