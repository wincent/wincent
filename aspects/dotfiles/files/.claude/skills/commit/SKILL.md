---
name: commit
description: Create a commit in a repository
---

# Create a commit in a repository

## Creating Git commits

The most common case will be creating a commit in a Git repository. Usually, you will include all changes in the working directory in the commit (that is, you should run `command git diff` to see what the changes are, and/or `command git diff --staged` to see what has already been staged). Generally, if your user wants you to commit only a subset of the changes in the working directory, he will instruct you to do so.

## Creating Jujutsu commits

Less frequently, you will find yourself in a Jujutsu repository (which you can determine via the presence of a `.jj` directory in the repository root). Jujutsu does not have a concept of a staging area like Git, and running any `jj` command will cause a snapshot of the working directory (including untracked files) to be made; you should therefore interactively prompt your user to indicate which changed files should be included in the change. In the most common case, you can use `jj st` to see which files are in the current snapshot, and `jj show` to see the diff, then `jj split <file>...` to indicate which specific files to be included in the commit (passing your commit message using the `-m` option.

In general, because of the lack of staging area, you should be careful with _any_ `jj` command that creates or modifies a change. For example, if you user asks you to squash some changes into the last commit using `jj squash`, you should prompt the user to indicate _which_ files' changes they want squashed (and invoke `jj squash <file>...` accordingly).

For more information on Jujutsu, see the `/jujutsu` skill.

## Common instructions

1.  Run the appropriate Git-specific or Jujutsu-specific commands to see what should be included in the commit.
2.  Create a commit message with:
    - A subject of 72 characters or less in Conventional Commits format (eg. "docs: add migration notes" or "fix: avoid double-render in list component").
    - A blank line.
    - A detailed description, wrapped to 72 characters, using basic Markdown syntax.
    - At the bottom, include the full text of **all** prompts that were used while preparing the changes that led to the commit; **never** omit any prompts.
    - If you were involved in the preparation of the changes, include a commit trailer of the form: "Co-Authored-By: Claude <noreply@anthropic.com>" (after "Claude", include the actual model name and version if it is available to you from the system prompt).

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
