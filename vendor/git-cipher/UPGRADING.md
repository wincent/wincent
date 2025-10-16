# Upgrading from 1.x to 2.x

## Differences between version 1.x and version 2.x

In brief, version 1.x was a Ruby script that used GnuPG for encryption. While it was intended to work in the context of a Git repository, it didn't use any special Git functionality beyond `gitignore`. Version 2.x is a from-scratch rewrite based on Node.js, using a completely distinct cryptographic architecture, and deep integration with Git features such as "smudge" and "clean" filters.

### About 1.x

Version 1.x was a Ruby script that used GnuPG to perform encryption and decryption. Encrypted files were committed to the repository in ["armored" format as seen in this example](https://github.com/wincent/wincent/blob/84bbf3590edb41ffeb8b27b18efe68c64f04a6ec/aspects/ssh/templates/.ssh/.config.erb.encrypted). Encrypted filenames began with a dot, and had an `.encrypted` extension; that is, if the plaintext file was at `foo/bar/baz`, the encrypted version would be stored at `foo/bar/.baz.encrypted`. The plaintext version of the file was added to the repository's `.gitignore` file ([example gitignore entry](https://github.com/wincent/wincent/blob/84bbf3590edb41ffeb8b27b18efe68c64f04a6ec/.gitignore#L21)) to prevent it from being carelessly committed. Additionally, git-cipher 1.x would [set owner-only permissions](https://github.com/wincent/git-cipher/blob/8d602a1a1906bed9de202c935d71e7a276e5e438/bin/git-cipher#L350-L356) on any plaintext files under management in the repository to dissuade snooping by other local users on the same machine[^local].

[^local]: The threat model implied here is that git-cipher is best used on single-user machines. Relying on filesystem permissions to prevent malicious access is at best a weak layer in a defense-in-depth strategy (it is commonly held that once local access is obtained, all bets are off, due to the possibility — or inevitability — of a successful privilege escalation attack). git-cipher 2.x is no different in this respect.

GnuPG uses non-deterministic encryption in the name of security, which means that even if the contents of a file have not changed, encrypting the file will produce a different result every time. This presents problems for storage in a Git repository, where _any_ re-encryption would effectively churn almost the entire contents of the file even when nothing changed in the plaintext (for example, see how [everything but the header and footer in this ciphertext file changes](https://github.com/wincent/wincent/commit/a87a25e51867f125da8d8c6ce0c8c5aac073a40d) in response to a modification and a re-encryption). In order to minimize needless churn, git-cipher 1.x uses modification timestamps as a cue to avoid making unneeded changes. This _is_ only a heuristic, and obviously not an infallible one, but in practice it worked sufficiently well[^autosave].

[^autosave]: Well enough, even, that I could teach my dotfiles to [automatically call `git-cipher encrypt` whenever I saved a plaintext file that had a corresponding ciphertext file](https://github.com/wincent/wincent/blob/fdae884e343acfe025751c5bd78546aa630771e8/aspects/nvim/files/.config/nvim/autoload/wincent/autocmds.vim#L6-L33) in the same directory.

1.x offered features such as `git-cipher log` for viewing changes in encrypted files over time, but it was severely limited because it required the GPG keys corresponding to the entire history to be available. A few GPG "best practices", such as setting expiry dates, rotating keys, and creating separate keys for work and personal identities, operated in direct opposition to the requirement that keys should be available.

In terms of security, git-cipher 1.x leaves all the actual cryptographic work in the hands of GnuPG, and using GnuPG for encryption and decryption is basically "fool-proof". That is, there are no complex initialization parameters to choose, key-lengths to select from, or modes of operation to pick. Encrypting _basically_[^details] boils down to `gpg --recipient <user> --output <outfile> --encrypt <infile>`, and decryption is `gpg --output <outfile> --decrypt <infile>`. As such, git-cipher 1.x doesn't fall prey to the sin of "rolling your own crypto", and the core can be considered as being as secure as GnuPG, because the core _is_ GnuPG, which is to say it is "very secure". The security of plaintext files at rest on the filesystem, of whether a user might accidentally leak them into the repository history by failing to `gitignore` them[^gitignore], and so on, is another question. As such, despite the solid underpinnings of the core, overall, git-cipher is designed only to afford a "reasonable" degree of protection to "low-value" assets. For example, the author has used it to protect files containing "sensitive" information (hostnames, usernames, pathnames and so on), but would not recommend it for critical secrets such as private SSH keys, cryptocurrency credentials, and so on.

[^details]: Some details elided here for clarity, but nothing that with any significant impact on the cryptographic properties of the operation. [The actual encryption call](https://github.com/wincent/git-cipher/blob/8d602a1a1906bed9de202c935d71e7a276e5e438/bin/git-cipher#L160-L170) and [the decryption invocation](https://github.com/wincent/git-cipher/blob/8d602a1a1906bed9de202c935d71e7a276e5e438/bin/git-cipher#L198-L209) can be seen in [the 1.x implementation](https://github.com/wincent/git-cipher/blob/1-x-release/bin/git-cipher).

[^gitignore]: git-cipher does [warn if it sees files that should be ignored](https://github.com/wincent/git-cipher/blob/76aff9a5da6e786f30a7ed73452b32f92bb7a671/bin/git-cipher#L41-L43) but which aren't, but this is purely advisory; there is nothing in the overall architecture which would turn this into un inviolable constraint.

### How 2.x compares

Version 2.x also uses GnuPG, but not to encrypt the files under management in the repository. Instead, random symmetric encryption keys[^keys] are generated and _those_ are committed to the repository at `.git-cipher/secrets.json.asc` after being encrypted by GnuPG. From that point on, files in the repository are encrypted and decrypted using the secret keys with no involvement from GnuPG.

[^keys]: Technically, three secrets are generated: an encryption key (unsurprisingly, used to perform encryption and decryption), an authentication key (used to create and validate HMACs), and a "salt" (used to derive pseudorandom IVs).

In more detail:

- Secrets are created and written to `.git-cipher/secrets.json.asc` as part of `git-cipher init`. These should be committed.
- To make use of those secrets and work with managed files in the repository, the user runs `git-cipher unlock`. This causes a copy of the secrets to be written to `.git/git-cipher/secrets.json` and plaintext copies of the encrypted files in the repository are written to the worktree.
- To "lock" the repository, the user runs `git-cipher lock`, which disposes of the local copy of the secrets at `.git/git-cipher/secrets.json`, and rewrites all of the encrypted files in the worktree to contain their ciphertext contents.

Under the covers, this is using [Node.js's `crypto` module](https://nodejs.org/api/crypto.html), itself a wrapper around [OpenSSL](https://www.openssl.org/) for cryptography, and Git's "clean"/"smudge" filtering to make working with encrypted files _mostly_ transparent. For details of the 2.x protocol, see [PROTOCOL](PROTOCOL.md).

In terms of security, 2.x is using OpenSSL (albeit indirectly). Unlike GnuPG, OpenSSL doesn't really qualify for the "fool-proof" label. There is scope for making a fundamental design or implementation flaw when using OpenSSL which would land squarely within the territory of "mistakes due to rolling your own crypto". This is especially so in the case of git-cipher, which not only uses AES-256 in CBC mode, but which jumps through some additional hoops in order to produce a deterministic encryption result by using an "effectively but not actually random" IV. While there is some precedent for this kind of approach in other projects such as [git-crypt](https://github.com/AGWA/git-crypt) and [transcrypt](https://github.com/elasticdog/transcrypt), the security of the approach is by no means guaranteed.

As such, all of the disclaimers that applied to 1.x in terms of security of secrets at rest and so on _also_ apply to 2.x, with the additional concerns that the implementation in 2.x is considerably more complex, newer, and uses a less heavily-vetted cryptographic construction and supporting scaffolding. Overall, this qualifies 2.x, emphatically, as suitable only for providing a degree of protection for the lowest-value secrets. As the [LICENSE](LICENSE.md) says, this software is provided without warranty of any kind.

## Upgrade procedure

### When using git-cipher from a submodule

In this example, we'll assume that the git-cipher repository is checked out in a submodule at `vendor/git-cipher/`:

1. Ensure plaintext for all files managed by 1.x is currently on disk and up-to-date; using 1.x, this can be done with `vendor/bin/git-cipher status`.
2. Update the git-cipher module to point at the new version.
3. In the superproject, run `vendor/bin/git-cipher init` to generate new secrets.
4. Run `vendor/bin/git-cipher unlock`; you will probably need `--force` here because you most likely have a dirty worktree at this point.
5. If plaintext is available (it should be, given step "1"), remove the corresponding entries from the `.gitignore` file; stage these changes with `git add`.
6. Add the encrypted secrets at `.git-cipher/secrets.json.asc` with `git add`.
7. Start managing plaintext files with `vendor/bin/git-cipher add <file...>`.
8. Remove old encrypted files from 1.x (ie. files with names of the form `.<base>.encrypted`) with `git rm`.
9. Add and commit the results (using `git add` and `git commit`).

If everything is set up correctly, commands like Git should show the plaintext of the protected files when using commands like `git show` and `git log -p`, but this is merely a presentational convenience that applies when you've run `git-cipher unlock`. To confirm that the committed files are _actually_ stored as ciphertext, you can run `git-cipher lock` and then re-run the `git show` or `git log -p` command. Alternatively, you can bypass the presentational aids with `git -c diff.git-cipher.textconv=cat -c diff.git-cipher.binary=false show --no-textconv -- <file>` (or the equivalent, substituting `log -p` for `show`). As a convenience, git-cipher provides `diff`, `log`, and `show` subcommands for streamlining this kind of inspection; invoke these with a `--reveal` switch to show ciphertext as it actually exists in Git object storage.
