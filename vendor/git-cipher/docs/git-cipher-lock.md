# `git cipher lock`

If plaintext versions of managed files exist in the worktree, `git-cipher lock` will reset them to their encrypted state. However, if the worktree is "dirty" it will abort.

Use the `--force` switch to proceed with the reset even when the worktree is dirty.

## See also

- [Common options](common-options.md)
