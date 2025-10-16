## Options

### `--reveal`

This switch passes a number of other arguments to the underlying `git` command; namely:

- `-c diff.git-cipher.binary=false`: prevents Git from showing encrypted files as binary (possible, because the encrypted files are formatted in ASCII text).

- `--no-textconv`: stops Git from passing "binary" files through text conversion filters (of interest here, `git-cipher textconv`).

Together, these arguments cause Git to show the ciphertext as it actually exists within Git object storage.
