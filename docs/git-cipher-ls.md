# `git cipher ls`

Shows the set of files managed by `git-cipher` in the current repository.

This is effectively provided as a convenience because the same information is available in the ".gitattributes" file, albeit in a less readable format.

By default, shows all managed files. Can be scoped to list specific files by passing additional arguments representing files or directories; for example, to list managed files in the current directory only:

```
git-cipher ls .
```

## Options

### `--verbose`

In addition to listing the paths, show current status information for each file. For each of "index" and "worktree", the following statuses may apply:

- encrypted
- empty
- error
- decrypted

Sample output:

```
examples/empty-file (index=empty, worktree=empty)
examples/file (index=encrypted, worktree=decrypted)
```

Note that a status of "index=decrypted" is always a problem, because it indicates that plaintext was staged in the index and may be committed. The `git-cipher ls` subcommand will print such lines using bold, red highlighting.

## See also

- [Common options](common-options.md)
