# main (not yet released)

- feat: add `--version` switch.

# 2.0.0 (3 August 2025)

- feat: don't churn blob contents when bumping version number.

# 2.0.0-pre.4 (2 August 2025)

- fix: address possible issue in wrapping algorithm.

# 2.0.0-pre.3 (2 July 2024)

- Updated protocol version from 1 to 2.

# 2.0.0-pre.2 (10 September 2022)

- Basically feature complete.

# 2.0.0-pre.1 (3 August 2022)

- Republish with missing file included.

# 2.0.0-pre.0 (3 August 2022)

- Published placeholder package ("blinking light" demo) to npm.

# 1.1 (2 August 2022)

- Allow `command` check to work on Linux systems without a concrete `command` executable like macOS has.
- GPG users may now be specified as a comma-separated list, which means that files can be encrypted such that they can be decrypted by multiple recipients.
- `status` now reports `[STALE]` for files whose decrypted content is out-of-date; this complements the `[MODIFIED]` status which applies to files whose encrypted content is out of date.
- Commands no longer implicitly consider or operate on Git-ignored ciphertext files; it is still possible to operate on such files by providing explicit paths.

# 1.0 (16 January 2019)

- Add `status` subcommand.

# 0.3 (24 April 2017)

- Recursively explore dot directories when searching for matching files.
- Include original filename in `log` output.
- Assume `gnupg2`: relatedly, drop support for the `preset` and `forget` subcommands, as they are no longer really needed.
- Add `ls` subcommand.
- Set executable bit on decrypted files with common scripting extensions.

# 0.2 (8 February 2016)

- Add `log` subcommand.

# 0.1 (31 March 2015)

- Initial release.
