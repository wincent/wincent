# `git cipher merge`

A Git merge driver (see `man gitattributes`) for resolving conflicts in files that are managed by git-cipher. In practice, there is no need to call this directly. When the appropriate `merge.git-cipher.driver` configuration is in effect, Git will call the driver upon encountering a conflict. The driver will attempt to decrypt the "ours", "theirs", and "ancestor" versions of the conflicted blobs, perform the merge, and encrypt the result. If the merge cannot be performed cleanly, the user will have to resolve the conflict manually.

Use `git-cipher init` to apply this and other necessary configuration items in a repository.

## See also

- [Common options](common-options.md)
