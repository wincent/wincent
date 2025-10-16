# `git cipher is-encrypted`

Reports whether the supplied arguments are encrypted files.

## Options

### `--exit-code`

When true, causes `is-encrypted` to exit with a 0 status to indicate that all of the files passed as arguments are encrypted. If any file is not encrypted then the exit status will be 1.

When false (the default), the command prints the encryption status for each file.

## See also

- [Common options](common-options.md)
