# Pi extensions (dotfiles)

A small set of [Pi](https://github.com/earendil-works/pi/tree/main/packages/coding-agent) extensions that are too dotfiles-specific to live in [`wincent-agent-plugins`](https://github.com/wincent/wincent-agent-plugins). Pi auto-discovers `*.ts` files in `~/.pi/agent/extensions/`; the dotfiles aspect symlinks `~/.pi` at this directory's grandparent, so these extensions get picked up automatically on every machine where the dotfiles are installed.

The general-purpose extensions (`edit-answer`, `jj-guard`, `model-info`, `slack-mcp`, `total-cost`, etc.) live in `wincent-agent-plugins` and are loaded from there via the `extensions` array in [`../settings.json`](../settings.json).

## Extensions

### `notify.ts`

Sends a desktop notification when pi finishes and is waiting for input. Delegates to the `notify` shell dispatcher (see `~/.zsh/bin/notify` in this dotfiles repo), which picks an appropriate backend (`clip-notify`, `terminal-notifier`, or `notify-send`) based on the current environment.

### `web-search.ts`

Registers a `web_search` tool backed by the [Kagi Search API](https://help.kagi.com/kagi/api/search.html) at a cost of $25 per 1,000 queries (ie. 2.5 cents per query). Requires `KAGI_API_TOKEN` in the environment, and throws if unset.

## Type-checking

A `tsconfig.json` sits alongside the extensions so that `tsc` can resolve the platform packages (`@earendil-works/pi-*`, `typebox`, `@types/node`). The matching `.d.ts` stubs live under `node_modules/`, populated on demand by [`bin/install-types`](bin/install-types) (which copies them out of the globally-installed pi). We assume pi is globally installed; pi extensions will use the globally-installed versions of their dependencies[^jiti].

[^jiti]: Pi's loader (see `dist/core/extensions/loader.js` in the global install) loads extensions with jiti, passing a map that rewrites the specifiers to absolute paths before Node's module resolution kicks in. This means that it will always use the globally installed dependencies and won't try to load anything from the local `node_modules` directory.

The stub tree is _not_ committed: each pi release would otherwise produce a thousand-file regeneration diff that buries everything else in the history, and the bulk of the tree (`@types/node`, `typebox`) is third-party content that has no business living in this repo. The `node_modules/` directory itself is tracked, but only to anchor a `.gitignore` that ignores everything underneath it; the stubs themselves are produced locally as needed.

- Run a check from this directory with `bin/typecheck`. If the stubs are missing (fresh checkout, or you wiped them) it will call `bin/install-types` for you automatically before invoking `tsc`.
- Refresh the stubs manually after each pi upgrade with `bin/install-types`. The script does not detect version drift on its own, so a stale tree will type-check against the previous pi's API surface until you rerun it.

`npm install` is intentionally blocked in this directory because the runtime dependency trees of the platform packages, in particular `@earendil-works/pi-ai`, pull in every supported provider SDK (Anthropic, AWS Bedrock, Google, Mistral, OpenAI) and their transitive trees. None of that is needed to type-check a handful of extension files, and at least one transitive dependency (`@mistralai/mistralai`) has been the target of supply chain attacks in the past ([MAL-2026-3432](https://osv.dev/vulnerability/MAL-2026-3432) / [GHSA-3q49-cfcf-g5fm](https://github.com/advisories/GHSA-3q49-cfcf-g5fm)).
