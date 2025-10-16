# Version

This document describes version 2 of the git-cipher protocol. See "History" for differences from the prior version.

# History

- Version 1 (2022-08-07): Initial version.
- Version 2 (2024-07-02): The "magic" string was updated from `com.wincent.git-cipher` to `dev.wincent.git-cipher`, and the "version" was bumped from `1` to `2`. This is a cosmetic change because these fields are currently just descriptive metadata, and don't affect the cryptographic properties of the protocol.

# Implementations

- High-level cryptographic functionality (public-key encryption/decryption) is provided by the `gpg` executable from [GnuPG](https://gnupg.org/).
- Lower-level cryptographic primitives (random number generation, key derivation, HMAC digests, symmetric encryption/decryption etc) are provided by the [Node.js `crypto` module](https://nodejs.org/api/crypto.html), itself a wrapper around [OpenSSL](https://www.openssl.org/).

> ⚠️Note that the use of these lower-level primitives means that this project is wilfully ignoring the maxim to "never roll your own crypto". It is not suitable for protecting high-value secrets! Use it at your own risk. For reference, the author is using this project to obfuscate "sensitive" data such as hostnames in Git repositories; he is not using it to protect actually valuable things like Bitcoin private keys.

# Overall architecture

Git "filter" attributes (see `man gitattributes`) are used to transparently decrypt encrypted files when they are checked out, and re-encrypt them when they are committed. A "diff" attribute makes it so that diffs (`git diff`, `git show`, `git log -p` etc) can show the difference in the plaintext using the "textconv" facility. A "merge" attribute and corresponding merge driver assists with merges by decrypting files to be merged, attempting the merge, and then re-encrypting them if they merged successfully.

In order to encrypt or decrypt files, these filters must have access to a set of secrets; in the absence of those secrets, the user can still use the repo, but they will only ever see ciphertext in their local checkout.

For speed and simplicity, the encryption is performed using a symmetric cipher, and the keys are committed to the repo in encrypted form using `gpg`. That is, `gpg` is responsible for protecting the secrets that are in turn used to protect the contents of the files in the repo.

This layer of indirection has a couple of benefits. Firstly, one is free to do things like rotate one's GPG key without re-encrypting the entire repository. One needs only re-encrypt the stored secret for the new key; things like `git log` will continue to work across such rotations. Secondly, it is easy to grant access to the secrets to multiple parties using GPG's multi-recipient functionality; the author uses this, for example, to grant access to encrypted files to both work machines (one GPG key) and personal machines (a different GPG key).

# Threat model

While every effort has been made to produce a correct and robust implementation, as noted above, git-cipher is not intended to safeguard high-value secrets. While it is possible to generate new secrets and then use them to re-encrypt the contents of the repo, the immutable nature of Git means that anybody who had access to the prior history of the repo will continue to have access to that portion of it, provided they've retained their private keys (either their GPG key, to access the old secrets, or an existing checkout with a copy of the old secrets still on disk). As such, git-cipher is not really intended to support team access patterns in which members come and go, and have their access revoked when they leave.

In typical usage, git-cipher is used by a trusted developer to protect their own files in repos that they alone can write to. Encryption only happens in an unlocked repo (ie. it depends on the presence of secrets) and in response to explicit developer actions (ie. the decision to add a file to the list of files managed by git-cipher, and the subsequent decision to commit the contents using `git commit`). This means that:

- We don't need to grant more than passing consideration to [chosen plaintext attacks](https://en.wikipedia.org/wiki/Chosen-plaintext_attack) (only the developer ever chooses plaintext, in the absence of some esoteric workflow that has them accepting snippets of plaintext for encryption).
- Under some circumstances, we may have to consider [known plaintext attacks](https://en.wikipedia.org/wiki/Known-plaintext_attack), wherein the attacker can guess or otherwise obtain the contents of an encrypted file; in practical terms, the feasibility of such attacks depends very much on usage. Given that filenames are public, attackers may be able to infer something about at least part of the possible contents of a ciphertext: for example, an encrypted file named `.netrc` may very well contain substrings such as `login` and `password`.
- If we trust the core primitives provided by OpenSSL, we need not worry so much about [ciphertext-only attacks](https://en.wikipedia.org/wiki/Ciphertext-only_attack) (principally, [brute-force attacks](https://en.wikipedia.org/wiki/Brute-force_attack)), but rather weaknesses introduced by implementation decisions made at higher levels, so [side-channel attacks](https://en.wikipedia.org/wiki/Side-channel_attack) are likely to be of special interest (although several flavors of those, such as [timing attacks](https://en.wikipedia.org/wiki/Timing_attack), are unlikely to be or relevance to the typical git-cipher user, who will be operating on a private, single-user machine, without carrying out any cryptographic operations in a way that can be directly observed while underway).
- There are of course, [many others](https://en.wikipedia.org/wiki/Category:Cryptographic_attacks) (more than we can realistically cover in this document).

## Attacking the IV

The IV is non-secret (and must be non-secret in order to decrypt the ciphertext[^iv]). The IV is derived from three inputs: the plaintext (potentially guessable), the filename (public), and a salt (secret). So, if you can guess the plaintext, you can attempt to obtain the salt via brute-force guessing. This is costly (equivalent to guessing a 256-bit number), contingent upon you guessing the contents of the plaintext, and of questionable value, because knowing the salt doesn't tell you anything about the encryption or authentication keys.

If you know the salt, you can predict what IVs will be generated for a given filename and plaintext contents. You can use this to confirm guesses about the plaintext that corresponds to a given ciphertext. This document makes the contention that possession of the salt isn't very useful even if you can do it, because it requires you to have guessed the plaintext anyway.

Due to this weakness, it is commonly held that IVs should be cryptographically random, leading to non-deterministic encryption. A random IV means that attackers can't detect common message prefixes just comparing the prefixes of the ciphertexts.

In this protocol we trade off some of the benefits of random IVs in exchange for a deterministic output that works effectively within the Git "clean"/"smudge" model. Note that even though the IV is not random, it still _appears_ to be random because we derive it using an HMAC. This means that attackers cannot detect common message prefixes by inspecting the ciphertext.

[^iv]: Strictly speaking, the IV is only _required_ to decrypt the first block of the ciphertext. Because we're using CBC mode, the ciphertext of the block prior to any given block is used as an input into the encryption/decryption process for that block. The IV itself is therefore only used and only needed for the very first block, because by definition it has no preceding block. Phrased another way, in order to decrypt block `N`, you need the ciphertext of blocks `N` and `N-1`. Some variants of the CBC mode prepend a random block which is disregarded when decrypting; these variants do not require the IV to be included with the message.

## Attacking the HMAC

The HMAC is produced from an authentication key (secret), the filename (public), the IV used to encrypt (public), and the ciphertext (public). You can guess the key via brute force, but that will be hard (the key is 256-bits, randomly generated), and doing so tells you nothing about the encryption key, which is a different secret. As such, you will have gained the ability to create HMACs and therefore launch malleability attacks (ie. create ciphertexts that decrypt to plaintexts and appear valid), but this won't assist you in decrypting the ciphertext because that is encrypted with a different key. This is not considered a serious threat given the size of the keys involved.

## Attacking the ciphertext

To decrypt the ciphertext you are given the text (public), the IV (public), and must determine the encryption key. This key is 256-bits, which is beyond the realms of feasibility for a brute force attack, given that it is effectively random, having come from a CSPRNG[^csprng].

[^csprng]: [Cryptographically secure pseudorandom number generator](https://en.wikipedia.org/wiki/Cryptographically_secure_pseudorandom_number_generator).

As noted previously, using a fixed IV here is necessary in order to provide deterministic encryption, but that is a departure from the way CBC modes are normally used. Using an HMAC to generate the IV means that it _does_ effectively vary in a way that is indistinguishable from random whenever the filename or file contents change. That is, the IV is fixed only when the filename and contents are fixed, which are the conditions under which we want it to be fixed anyway.

Note that two files with the same contents but different names will produce distinct HMACs. More precisely, even if the same contents exist with the same name at different locations within the repository, the HMACs will be distinct because the "name" is actually the path relative to the repository root.

A minor improvement is made by not actually encrypting empty files. 0-byte files remain 0-byte files even when managed by git-cipher. As the 0-byte file is a trivial case that could be included in any attack involving guessable plaintext, we can simply exclude such files from management by the system (although this is all academic, because there is no real reason to want to encrypt an empty file in the first place).

There are a couple of example files at [git-cipher-example/single-byte](https://github.com/wincent/git-cipher-example/blob/main/single-byte) and [git-cipher-example/fifteen-bytes](https://github.com/wincent/git-cipher-example/blob/main/fifteen-bytes) showing what happens when extremely small payloads are encrypted. Both of these produce 32 hex digits of ciphertext, equivalent to 16 bytes (128 bits), which is the block size used by the AES cipher (irrespective of key size, which in this case is 256 bits). OpenSSL applies padding as required to fill out any partial block. Although there is unlikely any practical justification for wanting to encrypt a file containing a single byte, an attacker suspecting that such a file exists knows that it must be one of 256 possible values. However, the fact that [IVs are unpredictable](https://crypto.stackexchange.com/questions/3883/why-is-cbc-with-predictable-iv-considered-insecure-against-chosen-plaintext-atta), along with the fact that plaintexts anywhere between 1 and 15 bytes all produce the same size ciphertext, means that even these small payloads aren't particularly susceptible to attack.[^small]

[^small]: For some other notes on encrypting small files, see [crypto.stackexchange.com/questions/11113](https://crypto.stackexchange.com/questions/11113/encryption-of-small-messages).

## General observations about the security model

git-cipher attempts to make operations on the managed files in an unlocked repository relatively "transparent" to the user. That is, the user should be able to run commands like `git diff` and have them show them the plaintext of their encrypted files. But note that, because all of this is built on top of entries in the `.gitattributes` file, anything that moves a managed file from its original location will require an update to the attributes. The `hook` subcommand tries to avoid any unintentional commit of decrypted plaintext, but it's ability to do so depends on managed files actually being listed in the attributes file, and at the right locations.

- If a user runs `git mv folder/secret other/secret`, then the attributes applying to the file at the old location will cease to apply in the new location (unless the user has manually manipulated the attributes file to instead specify a glob-based pattern — in this case, something like `secret` would suffice).
- Likewise, if the user creates a symlink to a decrypted file, or copies it elsewhere within, or out of, the repo, then it in some sense escapes git-cipher's control. (Related to this, it should be noted that if you symlink to a managed file, then the contents of the file will be affected by `lock` and `unlock` operations made within the repo.)

# Operations

## `git-cipher init`

This is the procedure followed to prepare a repository for working with git-cipher. What "prepare" means depends on the context; it may mean, for example:

- If git-cipher has _never_ been used in a repository: `git-cipher init` generates secrets that should be committed. Additionally it sets up "clean" and "smudge" filter commands, "diff"/"textconv" settings, a merge driver, and a "pre-commit" hook to detect accidental attempts to commit plaintext of files that are under management by git-cipher.
- If git-cipher secrets have previously been committed to the repository's history, but the user has not yet used git-cipher locally in this specific clone: `git-cipher init` sets up the aforementioned "clean"/"smudge" filters and related support. As such, `git-cipher init` is idempotent and can be run as a check that a given repository is correctly configured.

1. Abort if the current working directory is not part of a (non-bare) Git repository.
2. Create a `.git-cipher` folder at the repository root, if it does not exist already.
3. If secrets already exist at `.git/git-cipher/secrets.json` (ie. because the user has run `git-cipher unlock`), use those; otherwise, perform steps 4 through 8.
4. Generate a 256-bit (32-byte) encryption passphrase using a CSPRNG.
5. Generate a 512-bit (64-byte) salt using a CSPRNG.
6. Derive a 256-bit (32-byte) encryption key from the passphrase and salt using the `scrypt` derivation function and default parameters[^scrypt]. At this point the passphrase and salt are discarded.
7. Repeat steps 2 through 4 to produce a 256-bit (32-byte) authentication key.
8. Generate a 256-bit (32-byte) salt using a CSPRNG.
9. If we're performing this set-up for the first time, we will produce a file containing the new secrets. If we already have secrets but are wishing to re-encrypt them in order to change the set of GPG keys which have access to them, we use the existing secrets (previously made available with a call to `git-cipher unlock`). Construct a JSON representation of the authentication key, the encryption key, the salt, and a couple of additional fields, then encrypt it using `gpg` and commit the result to the repository at `.git-cipher/secrets.json.asc`. The additional fields are not required for encryption or decryption, and are merely informative; they are `version`, a positive integer describing the version of this PROTOCOL document that the implementation used to produce the file, and `url`, a link to the document describing the protocol.
10. Use `git config filter.git-cipher.clean <command>` and `git config filter.git-cipher.smudge <command>` to configure the repo to use `git-cipher` to transparently encrypt and decrypt files. The exact `<command>` that will be configured depends on whether `git-cipher` is running from a local checkout (in which case, the command will be an absolute path pointing at the local copy) or from a global install running out of `$PATH` (in which case it will either be `git cipher clean` or `git cipher smudge`).
11. Install pre-commit hook to report problems if unencrypted plain-text has been staged.

Observations:

- We use one key for encryption and one key for HMAC authentication [not because we have to, but because we can](https://stackoverflow.com/a/2504628/2103996).
- Likewise, we use `scrypt` for key derivation rather than simply using bytes from the CSPRNG because in the future, we may wish to offer the ability to derive a key from a user-supplied passphrase (for example, to enable a mode of operation that did not depend on `gpg`; note that this would require us to generate a single, larger "key" using `scrypt` (or ideally, a key derivation function that didn't require us to provide and somehow store an additional salt) and then split it up into segments, providing us with an encryption key, an authentication key, and a salt).

[^scrypt]: At the time of writing, [the default parameters](https://nodejs.org/api/crypto.html#cryptoscryptpassword-salt-keylen-options-callback) are a CPU/memory cost parameter of 16,384, a block size of 8, a parallelization factor of 1, and a maximum memory bound of 33,554,432 (32 &times; 1024 &times; 1024).

## `git-cipher unlock`

This procedure is used to give access to the plain-text contents of encrypted files previously added to a project using `git-cipher init` (to configure the repo) and `git-cipher add` (to encrypt files within it).

1. Create a directory at `.git/git-cipher` for storing decrypted secrets, if one does not already exist.
2. Set permissions on `.git/git-cipher` to be mode 0700 (accessible only to owner).
3. Decrypt the file at `.git-cipher/secrets.json.asc` and write the contents to `.git/git-cipher/secrets.json` with permissions set to 0600.
4. Set permissions on the repo to 0700 to protect plaintext in the worktree.
5. Update managed files in the worktree with their plaintext content.

Observations:

- Note that the decrypted key material is not kept in `.git/config` but rather in a separate directory whose permissions we can control.
- Likewise, note that this directory is not located in the worktree itself, to prevent it from ever being accidentally committed.
- Security of the key material is dependent on filesystem security, as is access (or lack of access) to the decrypted plaintext at rest in the worktree.

## `git-cipher lock`

This procedure is used to remove decrypted secrets from the local repository, and replace the contents of any decrypted files in the worktree with their encrypted contents.

1. If the worktree is dirty, abort (unless a `--force` flag is provided); this is important, because in step 3 we're going to overwrite any plain-text in the worktree that was previously decrypted from ciphertext.
2. If a file exists at `.git/git-cipher/secrets.json`, remove it.
3. For all decrypted encrypted files in the worktree, check out the encrypted contents again.

## `git-cipher add`

Adds a new file to the list of encrypted files managed by git-cipher.

1. If the file is not already listed in `.gitattributes` add a line of the form: `<file> diff=git-cipher filter=git-cipher`.
2. Run `git add --renormalize` (or `git rm --cached -- $file && git add -- $file`).

Observations:

- While `.gitattributes` supports globs (see `man gitattributes`), `git-cipher add` only ever adds or removes entries for individual files. This is because git-cipher is not intended as a mass-encryption tool that would encrypt the bulk of the contents fo a large repository; rather it is intended to used judiciously to protect a small number of low-value secrets. If you wish to protect a large number of secrets, or the value of the individual secrets is higher, another solution would probably be better suited.

## `git-cipher ls`

Lists files under management by git-cipher. A similar effect can be achieved by inspecting the `.gitattributes` file and looking for lines matching `filter=git-cipher`. A `--verbose` flag also runs some additional checks on each of the managed files.

TODO: actually document this

## `git-cipher is-encrypted`

TODO: document

## `git-cipher clean` (encrypt)

This command can be run manually for debugging purposes, but in normal usage, it will be invoked automatically by Git's "clean" filter functionality. It's job is to ensure that contents in the worktree get encrypted using the secrets at `.git/git-cipher/secrets.json` (ie. the repository must be unlocked with `git-cipher unlock` in order for this to work).

Here is an example encrypted file:

    magic = dev.wincent.git-cipher
    url = https://github.com/wincent/git-cipher/blob/v2.0.0-pre.3/PROTOCOL.md
    version = 2
    algorithm = aes-256-cbc
    filename = "examples/file"
    iv = c380d4534364071ac8717100d0aba6cb
    ciphertext =
    4329beb7f1c21f64cdfdef95f88e376e249692d9af3c920a652193b68b602d827bc8d257
    7fc8c1e511f50992f6e5ce79ba5914190bd5398c3414d0329b77d915a7c2ab313b9935f6
    abf994c393a0e9cd6c862d03255b915aa7528dab86e7c78eb4af0f0a34867edc84113561
    667e902b2431c66e7d188b49e695abda444ca2da2c7f9cc5dca2eae709c7840ed5242cc7
    79f268313ab697e6b37a6ccb9e7664b257158f818e1c7868063a830609fc0ed910a6bda7
    9d1a9feeb15ab775421aa2c4928081e2baadc0b70b58b4e7e7335079a655c0a9c83d67a6
    c386c31c4602ef6c18cfae7a62f3586e2e943e7d65a0947d57432acffb08e633e4896c33
    1099e13fd92e986e7f3d4ef62d5310f7a79dfb426052951ddf6d3ca6c277cfff7e26aaaf
    ba5baba0d9cd8022db2671384b66c911b5cf7f8d15844caf8d87a49beac74bf1b7662e67
    c27efc96e80a241860aaa1b17a8bf156e56b5501c7c16afd4b29ed07acedc37dff7f44ba
    8c28ab48c168317b8cf533e27a5e5c7b35d0e390b4ac0dcc94901f76c7efd47a8c9b7459
    138917bb72f210c2134ed13b24cf041f415f697fe3292ecd7ee159319fd2d88cbe2f6df0
    826a4c9d70d403248e6d72e4885d6872bffe22020665d071fcfe759c56632a39940f2ddf
    ccc0f9f690a1d9262c4cfcf57a7fba39b2746030199c41ad84b977a1eb4b012e09468341
    c81d79858d84ecf170b50db11aca07dbd8a1fa5c7294f033
    hmac = a44a0fd3ff4f2eb2452892bb6568f37712186b265afbba9a4b723518b58d2a4b

Fields:

- `magic`:
- filename = json stringified to make sure it fits on one line, informative only
  useful to detect, say, a `git mv` on an encrypted file

TODO: document these.

Observations:

- We could easily have made these ciphertexts binary files to save space, but the intended workload here is not to encrypt large files nor many files. As such, we use hexadecimal representation in a text file, for greater introspectability and debuggability.

## `git-cipher smudge` (decrypt)

---

# Appendix: Prior art

- [wincent/git-cipher v1.x](https://github.com/wincent/git-cipher/tree/1-x-release).
- [AGWA/git-crypt](https://github.com/AGWA/git-crypt).
- [elasticdog/transcrypt](https://github.com/elasticdog/transcrypt).
- [shadowhand/git-encrypt](https://github.com/shadowhand/git-encrypt/tree/legacy).
- [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html).

# Appendix: Ancient Git mailing list threads

When you search for Git encryption, and specifically the use of "clean"/"smudge" filters, an oft-cited thread turns up in the results which has since become [a broken link](http://thread.gmane.org/gmane.comp.version-control.git/113124). However, I believe I've found [an intact copy](http://public-inbox.org/git/978bdee00903121419o61cd7a87rb55809796bd257d7@mail.gmail.com/) of what those old links are referring to. For posterity, here is a mirror. The thread is of note because it specifically recommends _against_ using "clean"/"smudge" filters for this kind of purpose. By 2012, at least, this position had softened enough to allow [commit 36daaaca0046542f](https://github.com/git/git/commit/36daaaca0046542f4d5576ad5766ac55f43e3fc3) ("Add a setting to require a filter to be successful", 2012-02-17) to incorporate a reference to using `openssl` in a filter in the `gitattributes` documentation. The [discussion of the patch on the mailing list at the time](http://public-inbox.org/git/7vobsywck1.fsf@alter.siamese.dyndns.org/) did not make any reference to the prior concerns.

## "Transparently encrypt repository contents with GPG" (2009-03-12)

```
Hi,

I'm new to Git but I really already love it. ;-)

I would like to have repository that transparently encrypts and
decrypts all files using GPG.

What I need is a way to automatically modify each file

a) before it is written in the repository
b) after it is read from the repository

Is there a way to get this work somehow? Can someone give me some
hints where I need to begin?

---

Have a look at smudging, you might not need to touch the git source
code at all ;).

---

And people asked me not to be cryptic... even though the OP explicitely
asked for encryption, of course ;)

"git help attributes" may help: look for filter and set attributes and
config (filter.$name.{clean,smudge}) accordingly. smudge should probably
decrypt, clean should encrypt.

BTW: Why not use an encrypted file system? That way your work tree would
be encrypted also.

---

I wasn't being cryptic, I just don't remember the details of smudge,
just that it exists, and that it allows you to perform operations on a
file on checkout and on add.

---

Wouldn't this trip over the randomness included in all encryption [to
avoid generating the same cyphertext for two separate identical
messages, which gives away some information], which would let git
think the file has been changed as soon as its stat info has changed
(or is just racy)?

Not to mention that this makes most source-oriented features such as
diff, blame, merge, etc., rather useless.

---

I would assume that smudge takes care of this somehow, it'd seem like
a rather useless feature otherwise :).

---

Sverre was being prophetic with the somehow. Here's a working setup
(though I still don't know why not to use luks):

In .gitattributes (or.git/info/a..) use

* filter=gpg diff=gpg

In your config:

[filter "gpg"]
        smudge = gpg -d -q --batch --no-tty
        clean = gpg -ea -q --batch --no-tty -r C920A124
[diff "gpg"]
        textconv = decrypt

This gives you textual diffs even in log! You want use gpg-agent here.

Now for Sverre's prophecy and the helper I haven't shown you yet: It
turns out that blobs are not smudged before they are fed to textconv!
[Also, it seems that the textconv config does allow parameters, bit I
haven't checked thoroughly.]

This means that e.g. when diffing work tree with HEAD textconv is called
twice: once is with a smudged file (from the work tree) and once with a
cleaned file (from HEAD). That's why I needed a small helper script
"decrypt" which does nothing but

#!/bin/sh
gpg -d -q --batch --no-tty "$1" || cat $1

Yeah, this assumes gpg errors out because it's fed something unencrypted
(and not encrypted with the wrong key) etc. It's only proof of concept
quality.

Me thinks it's not right that diff is failing to call smudge here, isn't it?

---

Glad to hear I was right ;). Also awesome that you looked into this
and shared your findings, thanks!

---

> Sverre was being prophetic with the somehow. Here's a working setup
> (though I still don't know why not to use luks):
>
> In .gitattributes (or.git/info/a..) use
>
> * filter=gpg diff=gpg
>
> In your config:
>
> [filter "gpg"]
>         smudge = gpg -d -q --batch --no-tty
>         clean = gpg -ea -q --batch --no-tty -r C920A124
> [diff "gpg"]
>         textconv = decrypt
>
> This gives you textual diffs even in log! You want use gpg-agent here.

This is not going to work very well in general.  Smudging and cleaning
is about putting the canonical version of a file in the git repo, and
munging it for the working tree. Trying to go backwards is going to lead
to problems, including:

  1. Git sometimes wants to look at content of special files inside
     trees, like .gitignore. Now it can't.

  2. Git uses timestamps and inodes to decide whether files need to be
     looked at all to determine if they are different. So when you do
     a checkout and "git diff", everything will look OK. But when it
     does actually look at file contents, it compares canonical
     versions. And your canonical versions are going to be _different_
     everytime you encrypt, even if the content is the same:

       echo content &gt;file
       git add file
       git diff ;# no output
       touch file
       git diff ;# looks like file is totally rewritten

     So you will probably end up with extra cruft in your commits if you
     ever touch files.

> Now for Sverre's prophecy and the helper I haven't shown you yet: It
> turns out that blobs are not smudged before they are fed to textconv!
> [Also, it seems that the textconv config does allow parameters, bit I
> haven't checked thoroughly.]

I don't think they should be smudged. Smudging is about converting for
the working tree, and the diff is operating on canonical formats. If
anything, I think the error is that we feed smudged data from the
working tree to textconv; we should always be handing it clean data (and
this goes for external diff, too, which I suspect behaves the same way).

I haven't looked, but it probably is a result of the optimization to
reuse worktree files.

---

> In .gitattributes (or.git/info/a..) use
>
> * filter=gpg diff=gpg
>
> In your config:
>
> [filter "gpg"]
>         smudge = gpg -d -q --batch --no-tty
>         clean = gpg -ea -q --batch --no-tty -r C920A124
> [diff "gpg"]
>         textconv = decrypt
>
> This gives you textual diffs even in log! You want use gpg-agent here.

Don't do this.

Think why the smudge/clean pair exists.

The version controlled data, the contents, may not be suitable for
consumption in the work tree in its verbatim form.  For example, a cross
platform project would want to consistently use LF line termination inside
a repository, but on a platform whose tools expect CRLF line endings, the
contents cannot be used verbatim.  We "smudge" the contents running
unix2dos when checking things out on such platforms, and "clean" the
platform specific CRLF line endings by running dos2unix when checking
things in.  By doing so, you can see what really got changed between
versions without getting distracted, and more importantly, "you" in this
sentence is not limited to the human end users alone.

git internally runs diff and xdelta to see what was changed, so that:

 * it can reduce storage requirement when it runs pack-objects;

 * it can check what path in the preimage was similar to what other path
   in the postimage, to deduce a rename;

 * it can check what blocks of lines in the postimage came from what other
   blocks of lines in the preimage, to pass blames across file boundaries.

If your "clean" encrypts and "smudge" decrypts, it means you are refusing
all the benifit git offers.  You are making a pair of similar "smudged"
contents totally dissimilar in their "clean" counterparts.  That is simply
backwards.

As the sole raison d'etre of diff.textconv is to allow potentially lossy
conversion (e.g. msword-to-text) applied to the preimage and postimage
pair of contents (that are supposed to be "clean") before giving a textual
diff to human consumption, the above config may appear to work, but if you
really want an encrypted repository, you should be using an encrypting
filesystem.  That would give an added benefit that the work tree
associated with your repository would also be encrypted.

---

Exactly. This is why I suggested using cryptfs/luks in my first response
already.

But I don't know the OP's requirements, which is why I also told him how
to do what he wanted, even though it has the drawbacks you and Jeff (and
maybe I) mentioned. Maybe it's an attempt at hosting a semi-private repo
on a public (free) server?

Besides the non-text nature of encrypted content, the problem here is
that d(e(x))=x for all x but e(d(x)) differs from x most probably, and
hopefully randomly, unless you use the right version of debian's openssl
of course ;)

That being said:
git diff calls textconv filters with smudged as well as cleaned files
(when diffing work tree files to blobs), and this does not seem right. I
hope this is not happening with the internal diff, nor with crlf!

Since both the cleaned and the smudged version are supposed to be
"authoritative" (as opposed to the textconv'ed one) one may argue either
way what's the right approach. For internal use comparing the cleaned
versions may make more sense, for displaying diff's the checked-out
form, i.e. smudged versions make more sense.

But that is another topic which would need to be substantiated with
tests. It's not completely unlikely I may come up with some, but don't
count on it...

---

> Since both the cleaned and the smudged version are supposed to be
> "authoritative" (as opposed to the textconv'ed one) one may argue either
> way what's the right approach.

Smudged one can never be authoritative.  That is the whole point of smudge
filter and in general the whole convert_to_working_tree() infrastructure.
It changes depending on who you are (e.g. on what platform you are on).
So running comparison between two clean versions is the only sane thing to
do.

You could argue textconv should work on smudged contents or on clean
contents before smudging.  As long as it is done consistently, I do not
care either way too deeply, as its output is not supposed to be used for
anything but human consumption.  Two equally sane arrangement would be:

 (1) Start from two clean contents (run convert_to_git() if contents were
     obtained from the work tree), run textconv, run diff, and output the
     result literally; or

 (2) Start from two smudged contents (run convert_to_working_tree() for
     contents taken from the repository), run textconv, run diff, and
     run clean before sending the result to the output.

The former assumes a textconv filter that wants to work on clean
contents, the latter for a one that expects smudged input.  I probably
would suggest going the former approach, as it is consistent with the
general principle in other parts of the system (the internal processing
happens on clean contents).

Both of the above two assumes that the output should come in clean form;
it is consistent with the way normal diff is generated for consumption by
git-apply. You can certainly argue that the final output should be in
smudged form when textconv is used, as it is purely for human consumption,
and is not even supposed to be fed to apply.

---

> Smudged one can never be authoritative.  That is the whole point of smudge
> filter and in general the whole convert_to_working_tree() infrastructure.
> It changes depending on who you are (e.g. on what platform you are on).
> So running comparison between two clean versions is the only sane thing to
> do.

Yes. I guess I'm being too much of a mathematician here: if clean is a
well-defined function, then clean(x) is well defined by specifying x. In
that sense x is equally authoritative.
Again, if smudge is the inverse of clean, i.e. smudge and clean are
bijective, then x differs from y iff clean(x) differs from clean(y).

> Both of the above two assumes that the output should come in clean form;
> it is consistent with the way normal diff is generated for consumption by
> git-apply. You can certainly argue that the final output should be in
> smudged form when textconv is used, as it is purely for human consumption,
> and is not even supposed to be fed to apply.

Also, I don't expect clean to be necessarily meaningful when applied to
the result of textconv, and even less so to the output of diff.

Now, a simple test shows that git diff obviously does this when diffing
HEAD to worktree:

diff between HEAD and clean(worktree)

Which is the right thing. It just seems so that textconv is not even
called "in the wrong place of the chain", but messes the diff up in this
way:

diff between textconv(HEAD) and textconv(worktree)

(I expected clean(textconv(worktree)) first, which would be wrong, too).
I.e., the clean filter is ignored completely in the presence of textconv.

OK, I'll stop bugging you, until I checked the existing tests and the
code...

---

> (I expected clean(textconv(worktree)) first, which would be wrong, too).
> I.e., the clean filter is ignored completely in the presence of textconv.

Yeah, I think this should probably be textconv(clean(worktree)) to match
the regular HEAD/worktree diff (if it isn't already). Can you put
together a test that shows the breakage?

---

> As the sole raison d'etre of diff.textconv is to allow potentially lossy
> conversion (e.g. msword-to-text) applied to the preimage and postimage
> pair of contents (that are supposed to be "clean") before giving a textual
> diff to human consumption, the above config may appear to work, but if you
> really want an encrypted repository, you should be using an encrypting
> filesystem.  That would give an added benefit that the work tree
> associated with your repository would also be encrypted.

I can think of one reason that having git do the encryption might be
beneficial: pushing to an untrusted source.

If you encrypted all blobs but kept trees and commits in plaintext, you
could retain (some of) the benefits of git's incremental push. The
downsides, though, are:

  1. You are revealing the hashes of your blobs' plaintext. Which means
     I can try brute-forcing your blobs by checking against a hash
     function.

  2. The remote can't actually look at the blobs. The most obvious
     problem with this is that you can't send it thin packs, since it
     can't actually resolve deltas.

And given the ensuing mess that it would make of the code to
conditionally say "Oh, we have this object, but you're not allowed to
read it", it is almost certainly not worth it.

But maybe somebody can prove me wrong and design a system that allows
efficient encrypted pushing to a non-trusted remote and also doesn't
suck.
```

## "[Q] Encrypted GIT?" (2008-03-13)

[This prior thread](http://public-inbox.org/git/c6c947f60803130148w7981a3f0r718c0801343c7b78@mail.gmail.com/) also covers some of the same territory:

```
Hi, list!

I want to create a private GIT repo (without working copy) on a
machine in external data-center. While I do not actually believe that
it is possible that someone who has physical access to a machine would
be interested in peeking into my repo, I'd like to play safe and to
have this issue covered.

Please advise what is the best way to do it. Are there any existing solutions?

---

i don't think but you can write a wrapper around git receive/upload-pack
and use (for example) tar+gpg to keep your repo encrypted on the disc.

---

The problem is: you cannot decrypt on the remote side, otherwise you will
lose all the security.

But if you do not decrypt on the remote side, you cannot store deltified
objects (you lose all the benefits of Git's efficient storage), neither
can you update incrementally (you lose all the benefits of Git's efficient
transport).

The latter can be remedied (somewhat) by encrypting each object
individually.  In that case, .gitattributes can help (you should be able
to find a mail to that extent, which I sent no more than 2 weeks ago).
However, you must make sure that the encryption is repeatable, i.e. two
different encryption runs _must_ result in _identical_ output.

If it is only a single file containing all your secrets, it can also make
sense to just encrypt it, and track the _encrypted_ file directly
(without clean/smudge filters).

---

> The latter can be remedied (somewhat) by encrypting each object
> individually.  In that case, .gitattributes can help (you should be able
> to find a mail to that extent, which I sent no more than 2 weeks ago).
> However, you must make sure that the encryption is repeatable, i.e. two
> different encryption runs _must_ result in _identical_ output.

afaik, this is not the case for gpg.

---

> afaik, this is not the case for gpg.

No, and you wouldn't want to use gpg because of the overhead it adds
around an encrypted message.  You would need to use a raw encryption
algorithm, or one with very minimal wrapping.  It's normally at this
point that that you'd need to bring in a security expert to ask a
whole lot of questions about your exact use scenario, do a formal
threat analysis, since there are all sorts of unanswered questions
about what kind of key management solution you really need for your
situation.

It's usually not as simple as "just encrypt it".  How many people need
to have access to the to the repository?  Do you need to revoke access
to the repository later?  Who is allowed to give a new person access
to the repository?  etc., etc., etc.

---

>  It's normally at this point that that you'd need to bring in a security expert to ask a
>  whole lot of questions about your exact use scenario, do a formal
>  threat analysis, since there are all sorts of unanswered questions
>  about what kind of key management solution you really need for your
>  situation.

Uh. This is for kind of hobbyist noncommercial usage, so there are not
that much resources for bringing in security experts. :-)

Also I do not expect this data to be protected from determined (payed)
professional attack -- a determined professional would probably be
able to find some weaker spot elsewhere. However I do want such attack
to cost enough to ward off idle amateurs and bored professionals. :-)

>  It's usually not as simple as "just encrypt it".

> How many people need to have access to the to the repository?

Well, 2-5, up to ten, I guess. In immediate future -- two persons only. :-)

>  Do you need to revoke access to the repository later?

Probably. But restricting remote access should be enough.

> Who is allowed to give a new person access to the repository?

To keep things simple, me myself only.

---

> No, and you wouldn't want to use gpg because of the overhead it adds
> around an encrypted message.

To the contrary: if your files are small (which they are most likely), you
_want_ the overhead, in order to make the encryption harder to crack.

AFAICT gpg is a good all-round encryption tool, and reinventing the wheel
just for encrypting things in a git repository just does not cut it.

---

> No, and you wouldn't want to use gpg because of the overhead it adds
> around an encrypted message.  You would need to use a raw encryption
> algorithm, or one with very minimal wrapping.  It's normally at this

Well, "raw encryption algorithm" is a bit vague here. :)

I thought about this a while ago and come to a few conclusions:

  - encrypting before git sees content sucks, because you are either
    sacrificing security (content X always encrypts to Y) or system
    stability (git doesn't know that Y and Y' are really the same thing)

  - encrypting at the object level (when we do zlib) sucks, because we
    still want to name contents by their hash, which means the object
    database index contains information about what's in your content.
    There's also some per-object overhead. Plus any system without the
    key can't do deltas.

  - encrypting whole packfiles sucks for local storage, since you lose
    the random access property (unless you go with something static like
    an ECB mode, but then you are sacrificing security).

  - encrypting whole packfiles is a bit better for transport. The
    key-holding repo does the deltas and just treats the remote repo as
    dumb storage (it can't be smart, since that would involve looking at
    the data). Storage overhead is minimal if packfiles are a reasonable
    size.

So I think the last makes the most sense, where your local repo is
totally unprotected, but you efficiently push git objects to a remote
untrusted repo.

You could probably do something totally external to git using bundles as
the primitive. Store an encrypted index on the remote that says "here
are the packs I have, and the objects they contain." Whenever you push,
pull the index (which is of course more network-intensive than regular
git protocol, but not as bad as pulling all the data) and calculate a
thin-pack bundle yourself. Encrypt the bundle and store remotely.

> point that that you'd need to bring in a security expert to ask a
> whole lot of questions about your exact use scenario, do a formal
> threat analysis, since there are all sorts of unanswered questions
> about what kind of key management solution you really need for your
> situation.

I don't know if a formal thread analysis is necessary. I think most
people are interested in "if the contents of remote storage X are
known, how much do people know about the _contents_ of my repo stored on
X?" and they don't care about masking the size, time of updates, etc.

That's a fairly straightforward application of cryptography. The tricky
part is doing it in a way that can still leverage some of git's
efficiencies.

> It's usually not as simple as "just encrypt it".  How many people need
> to have access to the to the repository?  Do you need to revoke access
> to the repository later?  Who is allowed to give a new person access
> to the repository?  etc., etc., etc.

Sure, those are all interesting questions for a complete system. But I
think it makes sense to incrementally try the basics first.

---

> > No, and you wouldn't want to use gpg because of the overhead it adds
> > around an encrypted message.
>
> To the contrary: if your files are small (which they are most likely), you
> _want_ the overhead, in order to make the encryption harder to crack.

Not necessarily. Using random IVs, random salts, and random padding does
increase security.  Adding headers to every object that tell which
algorithm and parameters were used are nice for interoperability, but
don't help with security. Doing per-object asymmetric encryptions (gpg
--encrypt without --symmetric) is performance insanity.

> AFAICT gpg is a good all-round encryption tool, and reinventing the wheel
> just for encrypting things in a git repository just does not cut it.

Keep in mind that in the example you posted before, you were not using
99% of gpg. You were just asking it to do a symmetric CBC cipher using a
passphrase. So it is overkill for that, but at the same time not
actually very flexible for doing those sorts of low-level things.
OpenSSL provides a much better toolkit for that.

---

> You could probably do something totally external to git using bundles as
> the primitive. Store an encrypted index on the remote that says "here
> are the packs I have, and the objects they contain." Whenever you push,
> pull the index (which is of course more network-intensive than regular
> git protocol, but not as bad as pulling all the data) and calculate a
> thin-pack bundle yourself. Encrypt the bundle and store remotely.

Oh, and a scheme like this generalizes well from "there is one key" to
"N asymmetric keyholders".

> I don't know if a formal thread analysis is necessary. I think most

That should of course be "threa_t_ analysis". I of course want to
formally analyze this thread. ;)

---

Potential solution to store arbitrary data in a safe manner:

mkdir remote_git_raw remote_git
sshfs <data-center>:<path @ datacenter> $PWD/remote_git_raw
encfs $PWD/remote_git_raw $PWD/remote_git

This will lock your data in a remote encfs volume.  (Uses FUSE)

Not quite sure about the implications on performance... but this will
certainly keep your data safe on that remote location.

---
>   - encrypting whole packfiles is a bit better for transport. The
>     key-holding repo does the deltas and just treats the remote repo as
>     dumb storage (it can't be smart, since that would involve looking at
>     the data). Storage overhead is minimal if packfiles are a reasonable
>     size.
>
> So I think the last makes the most sense, where your local repo is
> totally unprotected, but you efficiently push git objects to a remote
> untrusted repo.

If the main goal is primarily backup of your repository to an
untrusted remote server, yes, that makes perfect sense.

If you assume multiple trusted developers would actually be
*operating* on an encrypted repo, the life gets much harder, as you've
pointed out.

>   - encrypting before git sees content sucks, because you are either
>     sacrificing security (content X always encrypts to Y) or system
>     stability (git doesn't know that Y and Y' are really the same thing)

It's not clear that "content X always encrypts to Y" is a fatal flaw,
by the way.  Yes, it leaks a bit of information, but in a source code
management situation, it may not matter.  If you do absolutely care,
tough, it might be that the simplest solution is to store the entire
repository and working tree under cryptofs.  After all, what's the
point of encrypting the local repo if the checked-out working tree is
unprotected for all to see?  :-)

---

> If the main goal is primarily backup of your repository to an
> untrusted remote server, yes, that makes perfect sense.
>
> If you assume multiple trusted developers would actually be
> *operating* on an encrypted repo, the life gets much harder, as you've
> pointed out.

Well, it depends on the meaning of "operate". :) I think you could still
use it as a rendezvous point as you would any bare repository.  Pushing
and pulling would have a little larger network overhead, and a lot more
CPU overhead.

But yes, that scheme is horrible for a working repo.

> >   - encrypting before git sees content sucks, because you are either
> >     sacrificing security (content X always encrypts to Y) or system
> >     stability (git doesn't know that Y and Y' are really the same thing)
>
> It's not clear that "content X always encrypts to Y" is a fatal flaw,
> by the way.  Yes, it leaks a bit of information, but in a source code

Agreed (I actually recommended in Dscho's original thread "you can do it
by eliminating the salt, if you accept the consequences...").

So after my saying "no formal threat analysis is necessary" you have
clearly called me on making a bunch of usage assumptions. Oops. :)

> management situation, it may not matter.  If you do absolutely care,
> tough, it might be that the simplest solution is to store the entire
> repository and working tree under cryptofs.  After all, what's the
> point of encrypting the local repo if the checked-out working tree is
> unprotected for all to see?  :-)

Yes. And it doesn't involve any git-specific code at all. :)

---

>The latter can be remedied (somewhat) by encrypting each object
>individually.  In that case, .gitattributes can help (you should be able
>to find a mail to that extent, which I sent no more than 2 weeks ago).
>However, you must make sure that the encryption is repeatable, i.e. two
>different encryption runs _must_ result in _identical_ output.

Any decent file encryption program will never have this characteristic.
It's normally a bad idea from a security perspective.

---

> Please advise what is the best way to do it. Are there any existing
> solutions?

An obvious and easy solution: use an encrypted partition on the
remote server and ssh as transport. Last time I checked, git on
encrypted volumes is plenty fast.

---

> An obvious and easy solution: use an encrypted partition on the
> remote server and ssh as transport. Last time I checked, git on
> encrypted volumes is plenty fast.

If its an encrypted partition on the remote server... then its visible
@ that server.. which I don't think is desired in the situation.

An encrypted partition is fairly useless on a remote server unless the
remote server is expected to be physically removed/powered down...
otherwise anything can get into that data while its alive (pending
permissions, lack-of-holes, etc..)

The encfs solution makes sure that nothing is ever revealed
remote-side... all data is prevented from even going over ssh in its
unencrypted form.

---

> The encfs solution makes sure that nothing is ever revealed
> remote-side... all data is prevented from even going over ssh in its
> unencrypted form.

Yes encfs over an sshfs is probably the safest. But it is intolerably
slow if you need any kind of random access of data, which git does
all the time. You can mount the encrypted partition using a key over
ssh per git push or pull to minimize exposure while get the
performance you want.
```
