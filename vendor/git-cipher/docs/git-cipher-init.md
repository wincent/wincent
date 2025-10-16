# `git-cipher init`

To prepare a repository to use git-cipher for the first time:

```
git-cipher init
```

To prepare a local clone of a previously initialized repository:

```
git-cipher init
```

To check that an existing clone has been appropriately initialized:

```
git-cipher init
```

To keep existing secrets but change the list of recipients that have access to those secrets:

```
git-cipher unlock
git-cipher init --force --recipients <user1>,<user2>
```

(ie. the `unlock` ensures we have a local copy of the secrets, the `--force` allows us to overwrite the in-tree `.git-cipher/secrets.asc.json` file with those secrets, encrypted using the new public keys associated with `--recipients`.)

To generate new secrets (re-encrypting everything) while retaining access to existing managed files:

```
git-cipher unlock
rm .git/git-cipher/secrets.json
git-cipher init --force
```

(ie. the `--unlock` ensures we have local copies of the decrypted plaintext, the `rm` throws away the old secrets, and `--force` overwrites the in-tree `.git-cipher/secrets.asc.json` file with the new secrets.)

## Options

### `--force`

Overwrites any existing secrets at `.git-cipher/secrets.asc.json`.

### `--recipients`

Comma-separated list of recipient email addresses whose GPG keys will be used to encrypt the repository's secrets.

## See also

- [Common options](common-options.md)
