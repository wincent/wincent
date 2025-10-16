# `git cipher clean`

A Git "clean" filter (see `man gitattributes`) that encrypts file contents for storage in Git's object database. In practice, there is no need to call this directly. When the appropriate `filter.git-cipher.clean` configuration is in effect, Git will call this command with a file path as an argument and the plaintext file contents on standard input; it will emit the ciphertext on standard output.

Use `git-cipher init` to apply this and other necessary configuration items in a repository.

## See also

- [Common options](common-options.md)
