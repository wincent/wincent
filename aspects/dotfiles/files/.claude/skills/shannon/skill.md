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

### Examples

**Open a file:**

```bash
nvim --server <addr> --remote-expr 'luaeval("vim.cmd.edit(\"path/to/file\")")'
```

**Jump to a line:**

```bash
nvim --server <addr> --remote-expr 'luaeval("vim.api.nvim_win_set_cursor(0, {LINE, 0})")'
```

**Open a file and jump to a line (combined):**

```bash
nvim --server <addr> --remote-expr 'luaeval("vim.cmd.edit(\"path/to/file\") or vim.api.nvim_win_set_cursor(0, {LINE, 0})")'
```

**Add virtual text annotation below a line:**

```bash
nvim --server <addr> --remote-expr 'luaeval("vim.api.nvim_buf_set_extmark(0, vim.api.nvim_create_namespace(\"shannon\"), LINE_0IDX, 0, {virt_lines = {{  {\"text here\", \"DiagnosticInfo\"} }}})")'
```

Use highlight groups to convey meaning:
- `DiagnosticInfo` — informational annotations (blue)
- `DiagnosticWarn` — warnings (yellow)
- `DiagnosticError` — errors/issues (red)
- `DiagnosticHint` — hints/suggestions (green)

**Clear all Shannon annotations in current buffer:**

```bash
nvim --server <addr> --remote-expr 'luaeval("vim.api.nvim_buf_clear_namespace(0, vim.api.nvim_create_namespace(\"shannon\"), 0, -1)")'
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

## Important notes

- Always use the `shannon` namespace for extmarks so they can be cleared as a group.
- Line numbers in `nvim_buf_set_extmark` and `nvim_buf_get_lines` are 0-indexed; `nvim_win_set_cursor` uses 1-indexed lines.
- When annotating a file that isn't currently open, open it first with `vim.cmd.edit()`.
- When doing a walkthrough across multiple files, pause between files and ask the user to let you know when they are ready to continue. Do not proceed to the next file until the user responds.
- Escape double quotes in Lua strings passed through the shell (nested quoting).
- The `--remote-expr` call is synchronous and blocks until Neovim processes it.
- Always clear previous Shannon annotations before adding new ones to avoid stale marks.
