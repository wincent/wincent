<p align="center">
  <img src="https://raw.githubusercontent.com/wincent/scalpel/media/scalpel.png" />
</p>
<p align="center">
  <img src="https://raw.githubusercontent.com/wincent/scalpel/media/scalpel.gif" />
</p>

# scalpel<a name="scalpel-scalpel" href="#user-content-scalpel-scalpel"></a>


## Intro<a name="scalpel-intro" href="#user-content-scalpel-intro"></a>

Scalpel provides a streamlined shortcut for replacing all instances of the word currently under the cursor throughout a file.

In normal mode pressing `<Leader>e` (mnemonic: &quot;edit&quot;) will display a prompt pre-populated with the current word and with the cursor placed so that you can start typing the desired replacement:

```
:Scalpel/\v<foo>//
```

Press `<Enter>` and Scalpel will prompt to confirm each substitution, starting at the current word (unlike a normal `:%s` command, which starts at the top of the file).

Scalpel works similarly in visual mode, except that it scopes itself to the current visual selection rather than operating over the entire file.

Screencasts that show Scalpel in action:

- https://youtu.be/YwMgnmZNWXA: &quot;Vim screencast #13: Multiple Cursors&quot;
- https://youtu.be/7Bx_mLDBtRc: &quot;Vim screencast #14: *Ncgn&quot;
- https://youtu.be/iNVyCPPYFzc: &quot;Vim screencast #21: Scalpel update&quot;

Note that `:Scalpel` just calls through to an underlying `scalpel#substitute` function that does the real work, ultimately calling Vim's own `:substitute`. As such, be aware that whatever changes you make to the command-line prior to pressing `<Enter>` must keep it a valid pattern, or bad things will happen.

The mapping can be suppressed by setting:

```
let g:ScalpelMap=0
```

Or overridden:

```
" Use <Leader>s instead of default <Leader>e:
nmap <Leader>s <Plug>(Scalpel)
```

In any case, Scalpel won't overwrite any pre-existing mapping that you might have defined for `<Leader>e`, nor will it create an unnecessary redundant mapping if you've already mapped something to `<Plug>(Scalpel)`.

The `:Scalpel` command name can be overridden if desired. For example, you could shorten it to `:S` with:

```
let g:ScalpelCommand='S'
```

Then your Scalpel prompt would look like:

```
:S/\v<foo>//
```

The command can be entirely suppressed by setting `g:ScalpelCommand` to an empty string:

```
let g:ScalpelCommand=''
```

Finally, all plug-in functionality can be deactivated by setting:

```
let g:ScalpelLoaded=1
```

in your `~/.vimrc`.


## Installation<a name="scalpel-installation" href="#user-content-scalpel-installation"></a>

To install Scalpel, use your plug-in management system of choice.

If you don't have a &quot;plug-in management system of choice&quot; and your version of Vim has `packages` support (ie. `+packages` appears in the output of `:version`) then you can simply place the plugin at a location under your `'packpath'` (eg. `~/.vim/pack/bundle/start/scalpel` or similar).

For older versions of Vim, I recommend [Pathogen](https://github.com/tpope/vim-pathogen) due to its simplicity and robustness. Assuming that you have Pathogen installed and configured, and that you want to install Scalpel into `~/.vim/bundle`, you can do so with:

```
git clone https://github.com/wincent/scalpel.git ~/.vim/bundle/scalpel
```

Alternatively, if you use a Git submodule for each Vim plug-in, you could do the following after `cd`-ing into the top-level of your Git superproject:

```
git submodule add https://github.com/wincent/scalpel.git ~/vim/bundle/scalpel
git submodule init
```

To generate help tags under Pathogen, you can do so from inside Vim with:

```
:call pathogen#helptags()
```


## FAQ<a name="scalpel-faq" href="#user-content-scalpel-faq"></a>


### Why use Scalpel rather than a built-in alternative?<a name="scalpel-why-use-scalpel-rather-than-a-built-in-alternative" href="#user-content-scalpel-why-use-scalpel-rather-than-a-built-in-alternative"></a>

Scalpel is a lightweight plug-in that provides subtle but valuable improvements to the experience you'd get by using Vim's built-in functionality.

Compared to writing a <strong>`:substitute`</strong> command manually:

- Scalpel is quickly activated by a mapping.
- Scalpel prepopulates the search pattern with the word currently under the cursor.
- Scalpel avoids a jarring jump to the top of the file, instead starting replacements at the current location.

Compared to a mapping such as &quot;*Ncgn&quot;:

- Scalpel allows you to preview the location at which each change will occur instead of performing the change blindly.


## Website<a name="scalpel-website" href="#user-content-scalpel-website"></a>

Source code:

- https://github.com/wincent/scalpel
- https://gitlab.com/wincent/scalpel
- https://bitbucket.org/ghurrell/scalpel

Official releases are listed at:

http://www.vim.org/scripts/script.php?script_id=5381


## License<a name="scalpel-license" href="#user-content-scalpel-license"></a>

Copyright (c) 2016-present Greg Hurrell

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the &quot;Software&quot;), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


## Development<a name="scalpel-development" href="#user-content-scalpel-development"></a>


### Contributing patches<a name="scalpel-contributing-patches" href="#user-content-scalpel-contributing-patches"></a>

Patches can be sent via mail to greg@hurrell.net, or as GitHub pull requests at: https://github.com/wincent/scalpel/pulls


### Cutting a new release<a name="scalpel-cutting-a-new-release" href="#user-content-scalpel-cutting-a-new-release"></a>

At the moment the release process is manual:

- Perform final sanity checks and manual testing.
- Update the [scalpel-history](#user-content-scalpel-history) section of the documentation.
- Regenerate the documentation:

```
docvim README.md doc/scalpel.txt
```

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
git archive -o scalpel-$VERSION.zip HEAD -- .
```

- Upload to http://www.vim.org/scripts/script.php?script_id=5381


## Authors<a name="scalpel-authors" href="#user-content-scalpel-authors"></a>

Scalpel is written and maintained by Greg Hurrell &lt;greg@hurrell.net&gt;.

Other contributors that have submitted patches include (in alphabetical order):

- Keng Kiat Lim

This list produced with:

```
:read !git shortlog -s HEAD | grep -v 'Greg Hurrell' | cut -f 2-3 | sed -e 's/^/- /'
```


## History<a name="scalpel-history" href="#user-content-scalpel-history"></a>


### 1.1 (12 June 2020)<a name="scalpel-11-12-june-2020" href="#user-content-scalpel-11-12-june-2020"></a>

- Automatically escape characters that may have special meaning for <strong>`/\v`</strong> (patch from Keng Kiat Lim, https://github.com/wincent/scalpel/pull/11).


### 1.0.1 (6 March 2019)<a name="scalpel-101-6-march-2019" href="#user-content-scalpel-101-6-march-2019"></a>

- Prefer <strong>`execute()`</strong> when available to avoid potential nested <strong>`:redir`</strong> issues.


### 1.0 (3 January 2019)<a name="scalpel-10-3-january-2019" href="#user-content-scalpel-10-3-january-2019"></a>

- Perform multiple replacements per line even when <strong>`'gdefault'`</strong> is on.


### 0.5 (28 July 2018)<a name="scalpel-05-28-july-2018" href="#user-content-scalpel-05-28-july-2018"></a>

- Fix problem with <strong>`Visual`</strong> mode operation on older versions of Vim (GitHub issue #8).


### 0.4 (23 July 2018)<a name="scalpel-04-23-july-2018" href="#user-content-scalpel-04-23-july-2018"></a>

- Fix problem with replacement patterns containing the number 1 (GitHub issue #7).


### 0.3 (10 May 2018)<a name="scalpel-03-10-may-2018" href="#user-content-scalpel-03-10-may-2018"></a>

- Fix compatibility with older versions of Vim that don't implement <strong>`getcurpos()`</strong>.


### 0.2 (13 June 2016)<a name="scalpel-02-13-june-2016" href="#user-content-scalpel-02-13-june-2016"></a>

- Support visual mode.
- Do not show &quot;N substitutions on N lines&quot; messages.


### 0.1 (29 April 2016)<a name="scalpel-01-29-april-2016" href="#user-content-scalpel-01-29-april-2016"></a>

- Initial release.
