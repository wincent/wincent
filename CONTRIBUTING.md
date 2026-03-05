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

## Working on subprojects

As an illustration, consider working on Command-T:

1. Make changes in `.cache/repos/github/wincent/command-t/`
2. Test them locally by running `bin/sync-dependencies`
3. When it comes time to officially update, push the changes.
4. Run `bin/update-dependencies`. Note that this will "update" the local cache repo (ie. it will update the metadata about what is available on the remote, and it will "merge" those changes in to the cache, which will be a no-op because they were already present), then "sync" the changes into the worktree (again a no-op because they were previously copied over by `bin/sync-dependencies`), and finally update the metadata in `dependencies.json`. Note that this produces the desired changelog entry, because we show the log from the hash that was recorded in `dependencies.json` the _previous_ time `bin/update-dependencies` was run to the new hash.

Note that you don't have to go through steps "1" through 4" for every commit; you can produce several commits (ie. do "1" and "2" repeatedly as many times as you like, and optionally "3" if you want to see the changes run in CI on GitHub) before doing the final sync ("4").
