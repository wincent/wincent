import {homedir} from 'node:os';
import {
  basename,
  dirname,
  join,
  normalize,
  relative,
  resolve,
  sep,
} from 'node:path';

import Context from './Context.js';
import root from './dsl/root.js';

const INSPECT = Symbol.for('nodejs.util.inspect.custom');
const TAG_NAME = 'fig.Path';
const TAG = Symbol(TAG_NAME);

// TODO: export path module wrappers as well, then I can just use it as a
// drop-in replacement

export type Path = string & {
  basename: Path;
  components: Array<Path>;
  dirname: Path;
  expand: Path;
  join: (...components: Array<string>) => Path;
  last: (count: number) => Array<Path>;
  resolve: Path;
  simplify: Path;
  strip: (extension?: string) => Path;

  // Makes sure value as printed by `console.log()` looks like a string.
  [INSPECT]: () => string;
};

interface path {
  (...components: Array<string>): Path;

  aspect: Path;
  home: Path;
  root: Path;
  sep: string;
}

function path(...components: Array<string>): Path {
  // Unwrap (possible) Path string-like(s) back to primitive string.
  const string = join(...components.map((component) => component.toString()))
    .replace(/\/+/g, '/') // Collapse consecutive slashes.
    .replace(/(.+)\/$/, '$1'); // Remove any trailing (non-leading) slash.

  return Object.defineProperties(new String(string), {
    basename: {
      get() {
        return path(basename(string));
      },
    },

    components: {
      get() {
        return string.split(sep).map((component) => {
          return path(component || sep);
        });
      },
    },

    dirname: {
      get() {
        return path(dirname(string));
      },
    },

    expand: {
      get() {
        if (string === '~') {
          return path(homedir());
        } else if (string.startsWith('~/')) {
          return path(join(homedir(), string.slice(2)));
        } else {
          return path(string);
        }
      },
    },

    join: {
      value: (...components: Array<string>) => {
        return path(
          normalize(join(string, ...components.map((c) => c.toString()))),
        );
      },
    },

    last: {
      value: (count: number) => {
        if (count) {
          return string
            .split(sep)
            .slice(-count)
            .map((component) => path(component));
        } else {
          return [];
        }
      },
    },

    resolve: {
      get() {
        if (string.startsWith('~/')) {
          return path(normalize(join(homedir(), string.slice(2))));
        } else {
          return path(resolve(string));
        }
      },
    },

    simplify: {
      get() {
        const home = homedir();

        if (string.startsWith(home)) {
          return path(join('~', string.slice(home.length)));
        } else {
          return path(relative('', string));
        }
      },
    },

    /**
     * Strips off ".ext" identified by `extension`, if present.
     */
    strip: {
      value: (extension?: string) => {
        return path(join(dirname(string), basename(string, extension)));
      },
    },

    [INSPECT]: {
      value: () => string,
    },

    [TAG]: {
      get() {
        return TAG_NAME;
      },
    },
  }) as Path;
}

Object.defineProperty(path, 'aspect', {
  get() {
    return path(root).join('aspects', Context.currentAspect);
  },
});

export default Object.assign(path, {
  home: path('~').expand,

  root: path(root),

  sep,
}) as path;

export function isPath(value: unknown): value is Path {
  return !!(
    value &&
    typeof value === 'object' &&
    value instanceof String &&
    TAG in value &&
    value[TAG] === TAG_NAME
  );
}
