---
name: jujutsu
description: How to use `jj`, the Jujutsu version control system
---

# Jujutsu (`jj`)

Jujutsu (or, simply, `jj`) is a Git-compatible version control system that is usually used in "colocated" form (that is, alongside the `.git` directory in the repository, there will also be a `.jj` directory; the presence of the latter can be used to infer that you are in a `jj` repository). When in a `jj` repository, you can still use Git commands to examine objects in the repository (for example, commands like `git show`, `git log`, and `git grep`) but when creating commits you should use `jj` commands.

Jujutsu's most distinctive feature is that it does not have a staging area. Any time you run a `jj` command, it will automatically create a snapshot of the working directory. `jj` respects `.gitignore` files and will not include them in snapshots. To stop tracking a file that was unintentionally included in a snapshot, modify `.gitignore` then use `jj file untrack <file>...`.

## Common commands

| Command     | Description                                               |
| ----------- | --------------------------------------------------------- |
| `jj st`     | Show summary of working copy changes                      |
| `jj diff`   | Show diff of working copy changes                         |
| `jj log`    | Show graph of commits (by default, only unpushed commits) |
| `jj evolog` | Show previous states (analogous to `git reflog`)          |
| `jj op log` | Show previous operations                                  |

## Specifying revisions

| Revset   | Header                              |
| -------- | ----------------------------------- |
| `@`      | Current revision (working copy)     |
| `@-`     | Parent of current revision          |
| `a-`     | Parent(s) of `a`                    |
| `a--`    | Grandparent(s) of `a`               |
| `a+`     | Child(ren) of `a`                   |
| `::a`    | Ancestors of `a` (including `a`)    |
| `a::`    | Descendents of `a` (including `a`)  |
| `a..b`   | Reachable from `b` but not from `a` |
| `a \| b` | Union of `a` and `b`                |
| `a & b`  | Intersection of `a` and `b`         |
| `~a`     | Not in `a`                          |

## Creating commits

For specific details on selecting which changes to include in a commit, and how to craft commit messages, see the `/commit` skill.

Note that you will never run `jj commit` without file arguments unless your user instructs you to do so; instead pass explicit files to be included.

| Command               | Description                                                          |
| --------------------- | -------------------------------------------------------------------- |
| `jj commit <file>...` | Create a commit containing specific changes                          |
| `jj split <file>...`  | Create a commit containing specific changes (also updates bookmarks) |

## Interacting with Git remotes

| Command                         | Description               |
| ------------------------------- | ------------------------- |
| `jj git fetch`                  | Fetch from default remote |
| `jj git fetch --all-remotes`    | Fetch from all remotes    |
| `jj git push`                   | Push to default remote    |
| `jj git push --remote <remote>` | Push to a named remote    |

## Custom aliases and commands

Your user has defined a number of useful aliases and commands in `~/.config/jj/config.toml`, including:

| Alias or command | Description                                                      |
| ---------------- | ---------------------------------------------------------------- |
| `jj gr`          | Roughly equivalent to `git log --oneline --graph`                |
| `jj o`           | Roughly equivalent to `git log --oneline`                        |
| `jj oo`          | Roughly equivalent to `git log --oneline -10`                    |
| `jj last`        | Show latest non-empty change with a non-empty description        |
| `jj tug`         | Fast-forward closest bookmark to point at recent pushable change |
