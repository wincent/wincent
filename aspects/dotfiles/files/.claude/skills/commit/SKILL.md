---
name: commit
description: Create a Git commit
---

# Create a Git commit

## Instructions

1. Run `command git diff` to see changes that will be committed (or `command git diff --staged` if they have already been staged).
2. Create a commit message with:

- A subject of 72 characters or less in Conventional Commits format (eg. "docs: add migration notes" or "fix: avoid double-render in list component").
- A blank line.
- A detailed description, wrapped to 72 characters, using basic Markdown syntax.
- At the bottom, include the full text of **all** prompts that were used while preparing the changes that led to the commit; **never** omit any prompts.

## Best practices

- Subjects MUST start with a Conventional Commits type (eg. "docs", "fix", "feat", "chore" etc; see the table below for a full list) followed by a statement beginning with a verb (eg. "add", "remove", "rename" etc). The subject describes _what_ the commit does.
- The body should explain the motivation for the change, and why the solution was chosen.
- Note alternatives which were considered but not implemented.
- Include references to previous commits or other artifacts (documentation, PRs) that are relevant.

## Conventional Commits types

| Type     | When to use                                                                                        |
| -------- | -------------------------------------------------------------------------------------------------- |
| fix      | Bug fixes                                                                                          |
| feat     | New features                                                                                       |
| chore    | Content                                                                                            |
| refactor | Code improvements (eg. for better readability, easier maintenance etc) which don't change behavior |
| docs     | Documentation changes (including changes to code comments)                                         |
| test     | Changing or adding/removing tests                                                                  |
| perf     | Performance improvements                                                                           |
| style    | Formatting changes, automated lint fixes                                                           |

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

Agent prompts used in preparing this commit:

> Search the codebase and confirm that the `recurse` setting isn't used
> anywhere outside of the benchmarks, where it is hardcoded to `true`.
> Once you've confirmed that, remove all traces of the setting. Run the
> benchmarks to see they still work, and the tests to see they still pass.
```
