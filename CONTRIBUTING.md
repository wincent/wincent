# Contributing

Patches are welcome via the usual mechanisms ([pull requests](https://github.com/wincent/wincent/pulls), [email](mailto:greg@hurrell.net), posting to [the project issue tracker](https://github.com/wincent/wincent/issues) etc).

## Updating npm dependencies

```
# See what will be updated.
# Prints a list that is useful to include in the commit message.
bin/npm update --dry-run

# Actually do the update.
bin/npm update
```

## Updating non-npm dependencies

As described in [wincent#157](https://github.com/wincent/wincent/issues/157) I used to manage many of the dependencies — things like Neovim plugins — in this repo using Git submodules, but now that I am experimenting with [Jujutsu](https://jj-vcs.github.io/), which [doesn't support submodules yet](https://github.com/jj-vcs/jj/issues/494) (and [quite possibly won't for a long, long time, if ever](https://github.com/jj-vcs/jj/issues/494#issuecomment-3683285530)), I have switched to creating source snapshots using the script in [`bin/update-dependencies`](./bin/update-dependencies) and committing them to the repo.

In general, the process is:

1. Run `bin/update-dependencies`.
2. If there were Neovim plug-in updates, run `bin/update-help-tags`.
3. Commit the changes with `jj ci -i`, and paste the changelog generated in step "1" in the commit message.

This works okay, but there are some wrinkles:

- The update process is multi-step if theme updates are included, as described in [072ebc6c0f926cd2b](https://github.com/wincent/wincent/commit/072ebc6c0f926cd2bb5eb7fd80febc605c5f2a9f):
  1. Run `bin/update-dependencies` to update all dependencies.
  2. Run `bin/update-themes` to create updated base16-nvim files (as well as other theme-related artifacts).
  3. Commit the changes in `../base16-nvim` and push them (eg. `cd ../base16-nvim && git commit -p "chore: run theme update from dotfiles" && git push all`[^all]).
  4. Run `bin/update-dependencies` again (effectively updating the base16-nvim metadata only, because nothing else will have changed).
  5. Create a final commit with the two changelogs produced by steps "1" and 4".
- I have to make sure build artifacts get written [in a cache directory where Jujutsu and rsync can't see them](https://github.com/wincent/wincent/blob/537bd6017b8e66ca0cf100025c7178e4b915ebad/bin/update-dependencies#L145-L156) so that they don't get accidentally committed or blown away by the update process.
- Developing my own Neovim plug-ins in-place is a bit more complicated now (previously, I could just edit them in the submodules, test them, then commit; now I have to edit them in the corresponding `.cache/repos/` and sync the changes over; see "Working on subprojects" below for more details).

[^all]: This assumes an `all` remote has been [configured](https://wincent.dev/wiki/Pushing_to_multiple_Git_remotes_at_once) that has two `pushurl` entries, one for github.com and one for git.wincent.dev.

On the bright side:

- Cloning the repo now brings everything needed in a single step,
- I now have a clear place to implement support for patching dependencies without forking them (see [wincent#84](https://github.com/wincent/wincent/issues/84)), because I can edit the repos under `.cache/repos/` and sync the changes (actually making this work will require some tweaks to the update script).
- Commits which update dependencies now show diffs representing what actually changed (ie. the real contents of the changes) rather than metadata about what changed (ie. merely the commit hashes of the "before" and "after" versions).
- If a dependency ever goes offline and there is no clear fork to switch to, I have a full snapshot of it.

## Adding new dependencies

1. Add the dependency to `dependencies.json`. Note that all values are required, so use the dependency's current `HEAD` as the value for the `"previous"` and `"current"` fields:

   ```
   "github/wincent/shannon": {
     "prefix": "aspects/nvim/files/.config/nvim/pack/bundle/opt/shannon",
     "url": "https://github.com/wincent/shannon.git",
     "branch": "main",
     "previous": "26e7b5ac9e248e7237ccebbd6918c3d9f61080d1",
     "current": "26e7b5ac9e248e7237ccebbd6918c3d9f61080d1"
   },
   ```

2. Run `bin/update-dependencies`.

## Working with VMs

To increase the safety of working with coding agents and not-fully-trusted dependencies, we use [Tart](https://tart.run/) to run Ubuntu 24.04 VMs on Apple Silicon, and carry out development tasks inside them. The `bin/vm` script is used for maintaining the base VM image, and the `sb` script is used to maintain per-project VMs derived from the base VM.

Run `bin/vm help` (or `bin/vm --help`) and `sb help` (or `sb --help`) for summaries of available commands.

### Creating and cloning a base image

`bin/vm create` clones the Cirrus Labs Ubuntu OCI image, pushes the dotfiles repo into the VM from the local host, and runs `./install` to provision it via Fig. The result is a `wincent-base` VM that can be cloned for daily use with `bin/vm clone <name>` (copy-on-write, fast and space-efficient).

On an M3 Max with 64 GB of RAM, this takes about 11 minutes.

### Pushing and pulling the base image

`bin/vm push` pushes `wincent-base` to `ghcr.io/wincent/wincent-base:latest`. `bin/vm pull` fetches it. Both require authentication:

```
tart login ghcr.io
```

Use your GitHub username and a [Personal Access Token](https://github.com/settings/tokens/new) with `write:packages` (push) or `read:packages` (pull) scope as the password.

### Starting and connecting to the base VM

```
bin/vm start               # start in foreground
bin/vm start --background  # start in background (survives shell exit)
bin/vm ssh                 # connect via SSH
```

Default credentials are `admin`/`admin`.

### Creating and connecting to a project-specific VM

```
sb create # One-time.
sb status # Check whether sandbox is running and its IP.
sb ssh # Connect to the VM.
```

### Updating dotfiles in a VM

Inside the VM, `~/code/wincent` is a Git checkout but no `origin` pointing at GitHub is configured.

When working in the "wincent-sandbox", push the latest changes from outside the VM into the sandbox with `sb inject`.

When working in another project sandbox, you can either recreate it from an update base image, or add the GitHub remote and `git pull` the new updates.

In both cases, once you have the new files, you can install as you normally would with `./install dotfiles`.

### Updating "wincent" files in the sandbox

These dotfiles are unique in being the only repo where I am currently using Jujutsu. The `sb inject`/`sb extract` workflow is intended for use with Git only (for now). So, the workflow is:

- Make Git commits in the sandbox with `git`.
- Extract Git commits with `sb extract`.
- Import the commits into Jujutsu with `jj git import`.
- If you want the Jujutsu change IDs reflected in the commit messages, use `jj desc`.

I will probably add something Jujutsu-specific to reduce this friction in the future.

### Troubleshooting

#### Sandbox VM not getting an IP address

If `sb start` times out waiting for a VM IP address, the macOS `bootpd` DHCP service may be stuck. Restart it with:

```
sudo launchctl kickstart -k system/com.apple.bootpd
```

Then try `sb restart`.

## Working on subprojects

As an illustration, consider working on Command-T:

1. Make changes in `.cache/repos/github/wincent/command-t/`
2. Test them locally by running `bin/sync-dependencies`
3. When it comes time to officially update, push the changes.
4. Run `bin/update-dependencies`. Note that this will "update" the local cache repo (ie. it will update the metadata about what is available on the remote, and it will "merge" those changes in to the cache, which will be a no-op because they were already present), then "sync" the changes into the worktree (again a no-op because they were previously copied over by `bin/sync-dependencies`), and finally update the metadata in `dependencies.json`. Note that this produces the desired changelog entry, because we show the log from the hash that was recorded in `dependencies.json` the _previous_ time `bin/update-dependencies` was run to the new hash.

Note that you don't have to go through steps "1" through 4" for every commit; you can produce several commits (ie. do "1" and "2" repeatedly as many times as you like, and optionally "3" if you want to see the changes run in CI on GitHub) before doing the final sync ("4").

### Working on subprojects in a VM

When using a sandbox VM (eg. to run a coding agent in "yolo" mode), there is no SSH agent inside the VM, so you can't push plugin changes directly to GitHub. Instead, use `git format-patch` inside the VM and `sb scp` to extract the patches to the host.

As an illustration, consider working on Command-T:

1. SSH into the VM and make changes (or have an agent do so):

   ```
   sb ssh
   cd ~/code/wincent/.cache/repos/github/wincent/command-t
   # ... make changes, commit them ...
   ```

2. Still inside the VM, generate patch files:

   ```
   cd ~/code/wincent/.cache/repos/github/wincent/command-t
   mkdir -p ~/patches/command-t
   git format-patch origin/main -o ~/patches/command-t
   ```

3. On the host, copy the patches out:

   ```
   mkdir -p ~/patches/command-t
   sb scp 'vm:patches/command-t/*' ~/patches/command-t/
   ```

4. On the host, apply the patches to the local cache repo and push:

   ```
   cd ~/code/wincent/.cache/repos/github/wincent/command-t
   git am ~/patches/command-t/*.patch
   git push
   ```

5. Run `bin/update-dependencies` to update the snapshot and metadata in the main repo.

6. Clean up patches and reset the VM so it can receive the final state via `sb inject`:

   ```
   rm -r ~/patches/command-t
   sb ssh rm -r patches/command-t
   sb inject
   ```

## Working with encrypted files

### Adding a new encrypted file

1. Add the path to the plain-text (unencrypted) file to the list of files in `bin/encrypt`.
2. Run `bin/encrypt`.
3. Verify that the path to the plain-text (unencrypted) file got added to the top-level `.gitignore`, and a new ciphertext (encrypted) file exists in the worktree.
4. Commit the ciphertext file.

### Rotating encryption keys

I don't expect to do this very often, but there may be legitimate reasons for doing it, such as switching to a post-quantum encryption key (possible as of [age v1.3.0](https://github.com/FiloSottile/age/releases/tag/v1.3.0)):

```
# Before starting, confirm we have a copy of the plaintext files.
# (If everything is decrypted, this command prints nothing.)
bin/crypt-status

# Proceed to replace the key.
cd ~/.config/age

# Remove old key; this is safe because we have a backup in 1Password.
rm key.txt

# Create a new "post-quantum" key (`-pq`).
age-keygen -pq -o ~/.config/age/key.txt

# Confirm permissions are correctly set (ie. 0600).
ls -laF

# Grab public key (recipient), so we can update `RECIPIENT` in `bin/encrypt`.
age-keygen -y key.txt

# Re-encrypt files with new key; this is ok only because we have the plaintext on disk already.
cd -
bin/encrypt

# Verify metadata for a sample file.
age-inspect aspects/ssh/templates/.ssh/config.erb.encrypted
```
