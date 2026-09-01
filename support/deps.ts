/**
 * Entry point for `bin/deps`, which manages the non-npm dependencies snapshot
 * in `dependencies.json`. See `bin/deps help` for the available subcommands,
 * and CONTRIBUTING.md for how they fit together.
 */

const COMMANDS: {[name: string]: {module: string; summary: Array<string>}} = {
  fetch: {
    module: './deps/fetch.ts',
    summary: [
      'Update remote-tracking refs in the cache, without changing',
      'the lockfile, the cached checkouts, or the worktree. Follow',
      'with `status` to preview what `update` would do.',
    ],
  },
  help: {
    module: '',
    summary: ['Show this help message'],
  },
  seed: {
    module: './deps/seed.ts',
    summary: ['Clone any dependency that is not cached yet, and stop'],
  },
  status: {
    module: './deps/status.ts',
    summary: [
      'Report how the remote (as of the last fetch), the lockfile,',
      'the cache, and the worktree differ. Offline, read-only.',
    ],
  },
  sync: {
    module: './deps/sync.ts',
    summary: [
      'Copy cached repos into the worktree (mirror mode), or check',
      'out the pinned commits first (`--with-lockfile`)',
    ],
  },
  update: {
    module: './deps/update.ts',
    summary: [
      'Fetch, advance each dependency to its branch tip, build,',
      'sync, and record the result in dependencies.json',
    ],
  },
};

function help(): void {
  const width = 12;

  console.log('Usage: bin/deps <command> [options] [pattern...]\n');
  console.log('Commands:');

  for (const name of Object.keys(COMMANDS).sort()) {
    const [first, ...rest] = COMMANDS[name]!.summary;
    console.log(`  ${name.padEnd(width)}${first}`);
    for (const line of rest) {
      console.log(`  ${''.padEnd(width)}${line}`);
    }
  }

  console.log(`
Most commands accept optional patterns to limit them to a subset of
dependencies; see \`bin/deps <command> --help\` for details.

Typical workflows:
  bin/deps status                     # what needs my attention?
  bin/deps fetch && bin/deps status   # what is available upstream?
  bin/deps update                     # take everything upstream has
  bin/deps sync --with-lockfile       # reproduce the pinned state
`.trimEnd());
}

const [command, ...args] = process.argv.slice(2);

if (
  command == null || command === 'help' || command === '--help' ||
  command === '-h'
) {
  help();
  process.exit(command == null ? 1 : 0);
}

const entry = COMMANDS[command];

if (entry == null) {
  console.error(`error: unknown command: ${command}`);
  console.error("For a list of commands, try 'bin/deps help'");
  process.exit(1);
}

const {run} = await import(entry.module) as {
  run: (args: Array<string>) => void | Promise<void>;
};

await run(args);
