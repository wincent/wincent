---
name: generating-commit-messages
description: Generates clear commit messages from Git diffs. Use when writing commit messages or reviewing staged changes.
---

# Generating Commit Messages

## Instructions

1. Run `command git diff` to see changes that will be committed (or `command git diff --staged` if they have already been staged).
2. Suggest a commit message with:

- A subject of 72 characters or less in Conventional Commits format (eg. "docs: add migration notes" or "fix: avoid double-render in list component").
- A detailed description, wrapped to 72 characters, using basic Markdown syntax.
- At the bottom, include the full text of all prompts that were used while preparing the changes that led to the commit.

## Best practices

- Subjects should start with a type (eg. "docs", "fix", "feat", "chore" etc) following by a statement beginning with a verb (eg. "add", "remove", "rename" etc). The subject describes _what_ the commit does.
- The body should explain the motivation for the change, and why the solution was chosen.
- Note alternatives which were considered but not implemented.
- Include references to previous commits or other artifacts (documentation, PRs) that are relevant.

## Example

```
refactor: remove unused `recurse` setting

We were never exposing a user-accessible setting here. It is always `true`
in practice, except in the benchmarks where we offered an override via the
environment.

If there is ever a call for this in the future, we can resurrect it, but
for now, leaving it out presents us with an opportunity to simplify.
It may even be a tiny bit faster (1.3% better CPU time, and 2.4%
better wall time), with reasonable confidence, due to saving us some
conditional checks.

Claude prompts used in preparing this commit:

> Search the codebased and confirm that the `recurse` setting isn't used
> anywhere outside of the benchmarks, where it is hardcoded to `true`.
> Once you've confirmed that, remove all traces of the setting. Run the
> benchmarks to see they still work, and the tests to see they still pass.
```
