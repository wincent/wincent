# Markdown formatting

**NEVER** hard-wrap Markdown in ".md" files. That is, a paragraph or a list item should be a single long line rather than many 80-character lines broken with newlines.

# Em dashes and en dashes

**Never** use em dashes or en dashes for any purpose: not in commit messages, not in code comments, not in documentation — nowhere!

# Showing file paths

**ALWAYS** render file paths as Markdown links when displaying them in chat output, so that pi's TUI emits OSC 8 hyperlink escape sequences and the user's terminal (kitty) renders them as clickable links. This applies to absolute paths, relative paths, and `path:line` / `path:line:col` references in prose, lists, tables, and inline code spans.

## How to emit

Use standard Markdown link syntax with a `file://` URI as the target:

```
[foo.c:42](file:///abs/path/to/foo.c#42)
```

The fragment is a bare line number (`#42`), matching the convention used by `rg --hyperlink-format=kitty`. This lets a single click handler service both pi's output and ripgrep's output without special-casing.

Do **not** attempt to emit raw OSC 8 escape sequences (`\x1b]8;…\x1b\\`) directly in your output. Pi's renderer parses assistant messages as Markdown and converts `[text](url)` link tokens to OSC 8 at render time. Raw escape bytes embedded in your text will be stripped or rendered as visible garbage.

## Rules

- **URI scheme**: always use `file://<absolute-path>` for the URI. Resolve relative paths against the current working directory before emitting. Percent-encode characters that are not URI-safe (spaces become `%20`, etc.).
- **Line/column references**: when the path includes a line (and optionally column) reference like `foo.c:42` or `foo.c:42:7`, encode the line number as a bare-number fragment: `file:///abs/path/foo.c#42`. For column references, append the column with a colon: `file:///abs/path/foo.c#42:7`. Keep the visible link text as the human-readable form (`foo.c:42` or `foo.c:42:7`), not the absolute URI.
- **Visible text**: preserve exactly what the user would expect to read — do not substitute the absolute path for a relative one in the visible portion. The URI is for the click target; the visible text is for the human. If you want the path to look like inline code, wrap the visible text in backticks _inside_ the link: ``[`foo.c:42`](file:///abs/path/foo.c#42)``.
- **Fenced code blocks**: do **not** put Markdown links inside fenced code blocks (`` ``` ``). Code blocks are typically copy-pasted verbatim, and link syntax there would be visible noise. Paths mentioned in surrounding prose should still be linked.
- **Non-paths**: do not link things that merely look like paths but aren't, e.g. URLs (`http://...`), package names (`@scope/name`), or identifiers containing slashes. Only link when the target is a real filesystem path the user could open.
- **Uncertainty**: if you are not sure a path exists or cannot resolve it to an absolute location, emit it as plain text rather than as a broken link.

## Rationale

The user's terminal (kitty inside tmux, with `*:hyperlinks` enabled in tmux's `terminal-features`) renders OSC 8 sequences as clickable links, routed to a custom handler that opens files in the right Neovim instance. Pi-tui's Markdown renderer is the bridge: it converts Markdown links to OSC 8 at the rendering stage. Using Markdown link syntax consistently makes every path the assistant mentions directly actionable.

# Searching and finding files

**Prefer `rg` (ripgrep) over `grep`** for searching file contents. It is faster, respects `.gitignore` by default, and has better defaults for code search.

`rg` can also replace many uses of `find`. To list files, use `rg --files` (optionally with `-g '<glob>'` to filter by name or path pattern) instead of `find . -name '...'`. Reach for `find` only when you need predicates `rg` does not cover, such as filtering by mtime, size, or file type beyond simple globs.

# Git worktree layout

Some repositories here use a "bare-in-.git" worktree layout: the container directory holds a _bare_ `.git` (`core.bare=true`) plus sibling worktree directories (`main/`, `feature/`, and so on). There is deliberately no `.bare` directory and no `.git` gitlink file. **Do not try to "repair" this.** Running git from the container root reports a bare repository, and `git status` there fails with "must be run in a work tree": that is expected, not a problem. Operate inside a worktree directory.

The canonical tool for this layout is `git wt` (run `git wt help` for the authoritative usage). Its subcommand names mirror `git worktree`, with `clone` and `migrate` added, and any unrecognized subcommand passes straight through to `git worktree`. When asked to set up a repository in this layout, use `git wt clone`; **never** hand-roll `git clone --bare`, which leaves local branches with no upstream and configures no `origin/*` refs, so worktrees cannot track upstream.

Worktrees are siblings, so to move to another worktree just `cd ../<name>`. There is **no** `git wt switch`; do not invent one or build an interactive picker.

The `subagent` extension's `worker` worktrees are a separate, automatic mechanism: the harness provisions them with plain `git worktree` under a `<repo>-subagent-worktrees/` directory and prunes them afterward. They are unrelated to `git wt`; do not manage them with `git wt`.
