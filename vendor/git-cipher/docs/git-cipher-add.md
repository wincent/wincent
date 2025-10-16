# `git cipher add`

Adds the specified file(s) to the list of files under management by git-cipher. For each file, adds an entry to the `.gitattributes` file in the repository root, instructing Git to use git-cipher's "clean" and "smudge" filters to transparently encrypt file contents before storing them in object storage, and decrypt them when writing them out into the worktree. Additionally, calls `git add` to perform the initial encryption.

## See also

- [Common options](common-options.md)
