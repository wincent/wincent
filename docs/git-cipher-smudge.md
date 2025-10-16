# `git cipher smudge`

A Git "smudge" filter (see `man gitattributes`) that decrypts file contents from Git's object database so that they can be written out as plaintext in the worktree. In practice, there is no need to call this directly. When the appropriate `filter.git-cipher.smudge` configuration is in effect, Git will call this command with a file path as an argument and the ciphetext file contents on standard input; it will emit the plaintext on standard output.

Use `git-cipher init` to apply this and other necessary configuration items in a repository.

## See also

- [Common options](common-options.md)
