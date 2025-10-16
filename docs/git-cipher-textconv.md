# `git cipher textconv`

A Git "textconv" filter (see `man gitattributes`) that transforms encrypted blobs for display as plaintext by various Git tools. In practice, there is no need to call this directly. When the appropriate `diff.git-cipher.textconv` configuration is in effect, Git will call this command when appropriate.

Use `git-cipher init` to apply this and other necessary configuration items in a repository.

## See also

- [Common options](common-options.md)
