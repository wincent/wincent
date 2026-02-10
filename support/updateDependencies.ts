import {execSync} from 'child_process';
import {existsSync, mkdirSync, readFileSync, writeFileSync} from 'fs';
import {dirname, join} from 'path';
import {fileURLToPath} from 'url';

type State = {
  [name: string]: {
    prefix: string;
    repo: string;
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
        ('repo' in value) &&
        typeof value.repo === 'string' &&
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
  repo: string;
  branch: string;
}> {
  return Object.values(state).map(({prefix, repo, branch}) => ({
    prefix,
    repo,
    branch,
  }));
}

function save(state: State): void {
  writeFileSync(DEPENDENCIES_FILE, JSON.stringify(state, null, 2) + '\n');
}

// Get current HEAD hash for a repo.
function getRepoHead(repoPath: string): string | null {
  try {
    return execSync('git rev-parse HEAD', {
      cwd: repoPath,
      encoding: 'utf8',
    }).trim();
  } catch (error) {
    return null;
  }
}

// Get commit log between two refs.
function getCommitLog(
  repoPath: string,
  fromRef: string,
  toRef: string,
): string | null {
  try {
    return execSync(`git log --oneline --no-decorate ${fromRef}..${toRef}`, {
      cwd: repoPath,
      encoding: 'utf8',
    }).trim();
  } catch (error) {
    return null;
  }
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
async function updateDependency({prefix, repo, branch}: {
  prefix: string;
  repo: string;
  branch: string;
}) {
  // Derive cache name from repo URL (e.g., github/wincent/command-t)
  const url = new URL(repo);
  const pathParts = url.pathname.replace(/\.git$/, '').split('/').filter(
    Boolean,
  );
  const host = url.hostname.split('.')[0]; // e.g., github.com -> github
  const cacheName = join(host, ...pathParts);
  const cachePath = join(CACHE_DIR, cacheName);

  console.log(`Processing ${prefix}...`);

  // Get previous HEAD if it exists.
  const previousState = state[cacheName] || {};
  const previousHead = previousState.current || null;

  // Clone or update cached repo.
  if (existsSync(join(cachePath, '.git'))) {
    console.log(`  [${prefix}] Updating cached repo...`);
    execSync(
      `git fetch origin && git checkout ${branch} && git merge origin/${branch}`,
      {
        cwd: cachePath,
        stdio: 'inherit',
      },
    );
  } else {
    console.log(`  [${prefix}] Cloning to cache...`);
    execSync(`git clone --branch ${branch} ${repo} ${cachePath}`, {
      stdio: 'inherit',
    });
  }

  const currentHead = getRepoHead(cachePath);

  if (previousHead && currentHead && previousHead !== currentHead) {
    // Record new state and emit changelog entry.
    state[cacheName] = {
      prefix,
      repo,
      branch,
      previous: previousHead,
      current: currentHead,
    };

    const log = getCommitLog(cachePath, previousHead, currentHead);
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
