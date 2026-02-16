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
  };
};

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

export const REPO_ROOT = join(__dirname, '..');
export const CACHE_DIR = join(REPO_ROOT, '.cache', 'repos');
export const DEPENDENCIES_FILE = join(REPO_ROOT, 'dependencies.json');

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

  get HEAD() {
    return this._capture('rev-parse', ['HEAD']);
  }

  get exists() {
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
