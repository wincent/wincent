# `git cipher unlock`

Decrypts encrypted files in the worktree.

## Options

### `--force`

If ciphertext versions of managed files exist in the worktree, `git-cipher unlock` will reset them to their decrypted state. However, if the worktree is "dirty" it will abort.

Use the `--force` switch to proceed with the reset even when the worktree is dirty.

## See also

- [Common options](common-options.md)
