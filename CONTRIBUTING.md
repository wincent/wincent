# Contributing

Patches are welcome via the usual mechanisms (pull requests, email, posting to the project issue tracker etc).

## Updating npm dependencies

```
# See what will be updated.
# Prints a list that is useful to include in the commit message.
bin/npm update --dry-run

# Actually do the update.
bin/npm update
```

### Updating non-npm dependencies

As described in [wincent#157](https://github.com/wincent/wincent/issues/157) I used to manage many of the dependencies — things like Neovim plugins — in this repo using Git submodules, but now that I am experimenting with [Jujutsu](https://jj-vcs.github.io/), which [doesn't support submodules yet](https://github.com/jj-vcs/jj/issues/494) (and [quite possibly won't for a long, long time, if ever](https://github.com/jj-vcs/jj/issues/494#issuecomment-3683285530)), I have switched to creating source snapshots using the script in [`bin/update-dependencies`](./bin/update-dependencies) and committing them to the repo. This works okay, but there are some wrinkles:

- The update process is multi-step if theme updates are included, as described in [072ebc6c0f926cd2b](https://github.com/wincent/wincent/commit/072ebc6c0f926cd2bb5eb7fd80febc605c5f2a9f).
- I have to make sure build artifacts get written [in a cache directory where Jujutsu and rsync can't see them](https://github.com/wincent/wincent/blob/537bd6017b8e66ca0cf100025c7178e4b915ebad/bin/update-dependencies#L145-L156) so that they don't get accidentally committed or blown away by the update process.
- Developing my own Neovim plug-ins in-place is a bit more complicated now (previously, I could just edit them in the submodules, test them, then commit; now I have to edit them in the corresponding `.cache/repos/` and sync the changes over).

On the bright side:

- Cloning the repo now brings everything needed in a single step,
- I now have a clear place to implement support for patching dependencies without forking them (see [wincent#84](https://github.com/wincent/wincent/issues/84)), because I can edit the repos under `.cache/repos/` and sync the changes (actually making this work will require some tweaks to the update script).
