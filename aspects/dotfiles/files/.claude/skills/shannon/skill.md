---
name: shannon
description: Interact with Neovim via RPC to annotate code, navigate files, and do walkthroughs
allowed-tools:
  - Bash
  - Read
  - Glob
  - Grep
---

# Shannon: Neovim RPC interaction

When a prompt arrives from Shannon (indicated by a footer like `(Shannon prompt via Neovim server <addr>)`), you have the ability to interact with the user's Neovim session via RPC.

## Finding the Neovim server

There are two ways to obtain the Neovim server address:

1. **From a Shannon prompt** — Shannon prompts include a footer of the form:

   ```
   (Shannon prompt via Neovim server /path/to/socket)
   ```

   Extract the server address from this footer.

2. **Auto-discovery** — if no Shannon prompt has been received yet, run the discovery script:

   ```bash
   ~/.claude/skills/shannon/scripts/shannon-find-nvim
   ```

   This finds the Neovim instance running in a sibling tmux pane and prints its server socket path. It exits non-zero if no Neovim is found.

## Sending RPC commands to Neovim

Use `nvim --server <addr> --remote-expr '<expr>'` to execute Vimscript or Lua in the user's Neovim. For Lua, wrap with `luaeval("...")`.

The Shannon plugin exposes private helper functions as individual modules for use by this skill. Each returns a single function. Prefer these over raw Neovim API calls.

### Private functions

**Open a file** (with optional 1-indexed line number):

```bash
nvim --server <addr> --remote-expr 'luaeval("require(\"wincent.shannon.private.open\")(\"path/to/file\")")'
nvim --server <addr> --remote-expr 'luaeval("require(\"wincent.shannon.private.open\")(\"path/to/file\", 42)")'
```

**Jump to a line** (1-indexed) in the current buffer:

```bash
nvim --server <addr> --remote-expr 'luaeval("require(\"wincent.shannon.private.jump\")(42)")'
```

**Add virtual text annotation below a line** (1-indexed):

```bash
nvim --server <addr> --remote-expr 'luaeval("require(\"wincent.shannon.private.annotate\")(42, \"text here\", \"DiagnosticInfo\")")'
```

The third argument is a highlight group. Use these to convey meaning:

- `DiagnosticInfo` — informational annotations (blue)
- `DiagnosticWarn` — warnings (yellow)
- `DiagnosticError` — errors/issues (red)
- `DiagnosticHint` — hints/suggestions (green)

If omitted, defaults to `DiagnosticInfo`.

**Clear all Shannon annotations in current buffer:**

```bash
nvim --server <addr> --remote-expr 'luaeval("vim.cmd.ShannonClearMarks()")'
```

**Show a message in Neovim's command area:**

```bash
nvim --server <addr> --remote-expr 'luaeval("vim.api.nvim_echo({{\"message\", \"WarningMsg\"}}, true, {})")'
```

## When to use RPC

Use RPC when:

- The user instructs you to show something "in Vim" or "in Neovim" (e.g., they use the words "in Neovim" in their prompt).
- Their prompt came in from Shannon (i.e., they are in Neovim) and they say something like "show me where we should add error handling in this file".
- They explicitly ask for an editor-based workflow like one of the following:
  - **Annotated code review**: add virtual text under lines with issues.
  - **Guided walkthroughs**: open files and jump to relevant lines as you explain code.
  - **Highlighting results**: after a search or analysis, navigate to the most relevant location.
  - **Error markers**: annotate lines with diagnostic-style warnings or errors.

## Shannon commands

The Shannon plugin provides the following commands, which can be invoked via RPC:

- `:ShannonNextMark` — jump to the next Shannon extmark in the current buffer (wraps around).
- `:ShannonPreviousMark` — jump to the previous Shannon extmark (wraps around).
- `:ShannonClearMarks` — clear all Shannon extmarks in the current buffer.

After adding annotations, tell the user they can navigate between marks with `:ShannonNextMark` / `:ShannonPreviousMark` (or their configured mappings). When you are done with an annotation session and the user has finished reviewing, clear the marks via RPC:

```bash
nvim --server <addr> --remote-expr 'luaeval("vim.cmd.ShannonClearMarks()")'
```

## Important notes

- All line numbers passed to private functions are 1-indexed.
- When annotating a file that isn't currently open, use `private.open` first.
- When doing a walkthrough across multiple files, pause between files and ask the user to let you know when they are ready to continue. Do not proceed to the next file until the user responds.
- Escape double quotes in Lua strings passed through the shell (nested quoting).
- The `--remote-expr` call is synchronous and blocks until Neovim processes it.
- Always clear previous Shannon annotations before adding new ones to avoid stale marks.
