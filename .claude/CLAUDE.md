# wincent/wincent

Dotfiles and system configuration repo, managed by a custom configuration framework called "Fig" (under `fig/`). Configuration is organized into "aspects" (under `aspects/`), each of which manages a specific concern (e.g., `dotfiles`, `nvim`, `shell`, `homebrew`).

Uses TypeScript (with `@typescript/native-preview` ie. `tsgo`).

## Running scripts

Use the scripts under `bin/` for pre-commit checks:

- `bin/check-format` — check formatting (dprint)
- `bin/format` — fix formatting problems
- `bin/test` — run tests
- `bin/tsgo` — run the TypeScript type check

## Making commits

This repo uses [Jujutsu](https://jj-vcs.github.io/) (`jj`) instead of `git` for version control.

### Commit message format

Use [Conventional Commits](https://www.conventionalcommits.org/) formatting:

- Start the subject line with a type prefix: `docs:`, `fix:`, `chore:`, `test:`, `refactor:`, `feat:`, etc.
- Optionally scope the prefix (e.g., `refactor(fig):`, `fix(nvim):`).
- The rest of the subject line should start with a verb in the imperative form; ie. "add", "teach", "fix" etc.
- Keep subject lines under 72 columns.
- In the commit body, hard-wrap to 80 columns.
- Use Markdown formatting for _bold_, _italics_, `code`, and fenced code blocks.
- Describe _what_ changed as concisely as possible; fit it in the subject if you can, but feel free to continue concisely in the body if fitting it all in the subject is not possible.
- Use the body to explain the motivation for the change was made and why the particular approach was chosen; you should include info on the alternatives considered, and why they were not chosen.

## Markdown

When writing Markdown, do not hard-wrap long lines.
