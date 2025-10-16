<p align="center">
  <img src="https://raw.githubusercontent.com/wincent/vcs-jump/media/logo.png" />
</p>

# vcs-jump<a name="vcs-jump-vcs-jump" href="#user-content-vcs-jump-vcs-jump"></a>

## Intro<a name="vcs-jump-intro" href="#user-content-vcs-jump-intro"></a>

This plug-in allows you to jump to useful places within a Git or Mercurial repository: diff hunks, merge conflicts, and &quot;grep&quot; results.

The actual work is done by the included `vcs-jump` script, which is a Ruby port of the &quot;git-jump&quot; (shell) script from official Git repo, adapted to work transparently with either Git or Mercurial:

https://git.kernel.org/pub/scm/git/git.git/tree/contrib/git-jump

## Requirements<a name="vcs-jump-requirements" href="#user-content-vcs-jump-requirements"></a>

- A Ruby interpreter must be available on the host system: the `vcs-jump` script uses a &quot;shebang&quot; line of &quot;/usr/bin/env ruby&quot;.

## Installation<a name="vcs-jump-installation" href="#user-content-vcs-jump-installation"></a>

To install vcs-jump, use your plug-in management system of choice.

vcs-jump consists of a Vim plug-in that provides a <strong>[`:VcsJump`](#user-content-vcsjump)</strong> command which invokes a bundled `vcs-jump` executable. The executable itself is useful outside of Vim, so you may wish to add the plug-in's `bin` directory to your `$PATH`; for example, if you installed the plug-in inside `~/.vim/pack/bundle/vcs-jump`, you could add the following to your shell's startup file:

```
export PATH=$PATH:~/.vim/pack/bundle/vcs-jump/bin
```

See <strong>[`vcs-jump-usage`](#user-content-vcs-jump-usage)</strong> for a description of usage from the command-line.

## Usage<a name="vcs-jump-usage" href="#user-content-vcs-jump-usage"></a>

vcs-jump can be used from inside or outside of Vim. Inside Vim, run <strong>[`:VcsJump`](#user-content-vcsjump)</strong> to populate the <strong>`quickfix`</strong> list with &quot;interesting&quot; locations (diff hunks, merge conflicts, or grep results).

Outside of Vim, provided you have set up your `$PATH` as described in <strong>[`vcs-jump-installation`](#user-content-vcs-jump-installation)</strong>, you can run the bundled `vcs-jump` executable in any of the following ways to open Vim and immediately populate the <strong>`quickfix`</strong> list:

```
vcs-jump diff # find hunks with diffs relative to current HEAD
vcs-jump diff HEAD~10 # find hunks with diffs relative to specified commit
vcs-jump grep stuff # find grep results for "stuff"
vcs-jump merge # find merge conflicts
```

You can also add `vcs-jump` as a Git subcommand that can be invoked as `git jump`:

```
git jump diff # find hunks with diffs relative to current HEAD
git jump diff HEAD~10 # find hunks with diffs relative to specified commit
git jump grep stuff # find grep results for "stuff"
git jump merge # find merge conflicts
```

To do this, use one of the following three methods.

Firstly, you can add a `git-jump` file to your `$PATH` with these contents, and then mark it as executable with `chmod +x`:

```
 #!/bin/sh

 vcs-jump "$@"
```

Secondly, you can add a symbolic link to the vcs-jump executable anywhere in your path:

```
cd ~/bin
ln -s path/to/vcs-jump git-jump
```

Thirdly, you can create a Git alias:

```
git config --global alias.jump '!f() { vcs-jump "$@"; }; f'
```

By default, vcs-jump will print usage information if called without any arguments. A useful enhancement to the above alias is to teach `git jump` to pick a reasonable default action instead. The following runs `git jump merge` if there are conflicts, and `git jump diff` if there are modifications, otherwise falling back to the standard behavior:

```
git config --global alias.jump '!f() {
  if [ "$#" -eq 0 ]; then
    if [ -n "$(git diff --name-only --diff-filter=U)" ]; then
      vcs-jump merge;
    elif ! git diff --quiet; then
      vcs-jump diff;
    else
      vcs-jump;
    fi;
  else
    vcs-jump "$@";
  fi;
}; f'
```

## Commands<a name="vcs-jump-commands" href="#user-content-vcs-jump-commands"></a>

<p align="right"><a name="vcsjump" href="#user-content-vcsjump"><code>:VcsJump</code></a></p>

### `:VcsJump`<a name="vcs-jump-vcsjump" href="#user-content-vcs-jump-vcsjump"></a>

This command invokes the bundled `vcs-jump` script to get the list of &quot;interesting&quot; locations (diff hunks, merge conflicts, or grep results) in the repo, and put them in the <strong>`quickfix`</strong> list.

Filename completion is available in the context of this command.

Subcommands are:

- &quot;diff&quot;: Results are diff hunks. Arguments are passed on to the Mercurial or Git `diff` invocation. This means that in the absence of any arguments, a diff against the current &quot;HEAD&quot; will be performed, but you can change that by passing options (eg. `--cached`) or specifying a target revision to compare against.
- &quot;merge&quot;: Results are merge conflicts. Arguments are ignored.
- &quot;grep&quot;: Results are grep hits. Arguments are given to the underlying Git or Mercurial `grep` command.

When called with a trailing <strong>`:command-bang`</strong> (eg. `:VcsJump!`) the current value of the <strong>[`g:VcsJumpMode`](#user-content-gvcsjumpmode)</strong> setting is inverted for the duration of that invocation.

## Mappings<a name="vcs-jump-mappings" href="#user-content-vcs-jump-mappings"></a>

### `<Plug>(VcsJump)`<a name="vcs-jump-plugvcsjump" href="#user-content-vcs-jump-plugvcsjump"></a>

This mapping invokes the bundled `vcs-jump` script, defaulting to &quot;diff&quot; mode.

By default, `<Leader>d` will invoke this mapping unless:

- A mapping with the same <strong>`{lhs}`</strong> already exists; or:
- An alternative mapping to <strong>[`<Plug>(VcsJump)`](#user-content-plugvcsjump)</strong> has already been defined in your <strong>`.vimrc`</strong>.

You can create a different mapping like this:

```
" Use <Leader>g instead of <Leader>d
nmap <Leader>g <Plug>(VcsJump)
```

## Options<a name="vcs-jump-options" href="#user-content-vcs-jump-options"></a>

<p align="right"><a name="gvcsjumpmode" href="#user-content-gvcsjumpmode"><code>g:VcsJumpMode</code></a></p>

### `g:VcsJumpMode` (string, default: "cwd")<a name="vcs-jump-gvcsjumpmode-string-default-cwd" href="#user-content-vcs-jump-gvcsjumpmode-string-default-cwd"></a>

Controls whether vcs-jump should operate relative to Vim's current working directory (when <strong>[`g:VcsJumpMode`](#user-content-gvcsjumpmode)</strong> is &quot;cwd&quot;, the default) or to the current buffer (when <strong>[`g:VcsJumpMode`](#user-content-gvcsjumpmode)</strong> is &quot;buffer&quot;).

To override the default, add this to your <strong>`.vimrc`</strong>:

```
let g:VcsJumpMode="buffer"
```

Note that you can temporarily invert the sense of this setting by running <strong>[`:VcsJump`](#user-content-vcsjump)</strong> with a trailing <strong>`:command-bang`</strong> (eg. `:VcsJump!`).

<p align="right"><a name="gvcsjumploaded" href="#user-content-gvcsjumploaded"><code>g:VcsJumpLoaded</code></a></p>

### `g:VcsJumpLoaded` (any, default: none)<a name="vcs-jump-gvcsjumploaded-any-default-none" href="#user-content-vcs-jump-gvcsjumploaded-any-default-none"></a>

To prevent vcs-jump from being loaded, set <strong>[`g:VcsJumpLoaded`](#user-content-gvcsjumploaded)</strong> to any value in your &quot; <strong>`.vimrc`</strong>. For example:

```
let g:VcsJumpLoaded=1
```

## Website<a name="vcs-jump-website" href="#user-content-vcs-jump-website"></a>

Source code:

https://github.com/wincent/vcs-jump

Official releases are listed at:

http://www.vim.org/scripts/script.php?script_id=5790

## License<a name="vcs-jump-license" href="#user-content-vcs-jump-license"></a>

Copyright 2014-present Greg Hurrell. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS &quot;AS IS&quot; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## Development<a name="vcs-jump-development" href="#user-content-vcs-jump-development"></a>

### Contributing patches<a name="vcs-jump-contributing-patches" href="#user-content-vcs-jump-contributing-patches"></a>

Patches can be sent via mail to greg@hurrell.net, or as GitHub pull requests at: https://github.com/wincent/vcs-jump/pulls

### Cutting a new release<a name="vcs-jump-cutting-a-new-release" href="#user-content-vcs-jump-cutting-a-new-release"></a>

At the moment the release process is manual:

- Perform final sanity checks and manual testing
- Update the <strong>[`vcs-jump-history`](#user-content-vcs-jump-history)</strong> section of the documentation
- Verify clean work tree:

```
git status
```

- Tag the release:

```
git tag -s -m "$VERSION release" $VERSION
```

- Publish the code:

```
git push origin main --follow-tags
git push github main --follow-tags
```

- Produce the release archive:

```
git archive -o vcs-jump-$VERSION.zip HEAD -- .
```

- Upload to http://www.vim.org/scripts/script.php?script_id=5790

## Authors<a name="vcs-jump-authors" href="#user-content-vcs-jump-authors"></a>

vcs-jump is written and maintained by Greg Hurrell &lt;greg@hurrell.net&gt;.

Other contributors that have submitted patches include (in alphabetical order):

- Aaron Schrab
- Adam P. Regasz-Rethy
- Pascal Lalancette

This list produced with:

```
:read !git shortlog -s HEAD | grep -v 'Greg Hurrell' | cut -f 2-3 | sed -e 's/^/- /'
```

## History<a name="vcs-jump-history" href="#user-content-vcs-jump-history"></a>

### main (not yet released)<a name="vcs-jump-main-not-yet-released" href="#user-content-vcs-jump-main-not-yet-released"></a>

- Pass `diff.mnemonicPrefix=no` and `diff.noprefix=no` to Git to ensure `diff` output has the necessary prefixes for parsing (patches from Aaron Schrab: https://github.com/wincent/vcs-jump/pull/7; and Adam P. Regasz-Rethy: https://github.com/wincent/vcs-jump/pull/9).
- fix: don't clobber 'cpoptions' (patch from Adam P. Regasz-Rethy: https://github.com/wincent/vcs-jump/pull/10).
- fix: don't allow local 'errorformat' to interfere with operation.

### 1.0 (12 October 2019)<a name="vcs-jump-10-12-october-2019" href="#user-content-vcs-jump-10-12-october-2019"></a>

- Provide a meaningful title for the <strong>`quickfix`</strong> listing.
- Run `git diff` with `--no-color` to prevent a `git config color.ui` setting of &quot;always&quot; from breaking diff mode (https://github.com/wincent/vcs-jump/issues/1)
- Add <strong>[`g:VcsJumpMode`](#user-content-gvcsjumpmode)</strong> and teach <strong>[`:VcsJump`](#user-content-vcsjump)</strong> to accept a <strong>`:command-bang`</strong> suffix that can be used to make vcs-jump operate relative to the current buffer instead of the current working directory (patch from Pascal Lalancette, https://github.com/wincent/vcs-jump/pull/5).

### 0.1 (2 June 2019)<a name="vcs-jump-01-2-june-2019" href="#user-content-vcs-jump-01-2-june-2019"></a>

- Initial release: originally extracted from my dotfiles in https://wincent.dev/n/vcs-jump-origin and then iterated on before extracting into a standalone Vim plug-in.
