
# docvim<a name="docvim-docvim" href="#user-content-docvim-docvim"></a>

<p align="right"><a name="vim-docvim" href="#user-content-vim-docvim"><code>vim-docvim</code></a></p>

## Intro<a name="docvim-intro" href="#user-content-docvim-intro"></a>

vim-docvim provides additional syntax highlighting for Vim script files that contain embedded docvim comments.

docvim (the tool, not this plug-in) is a documentation generator that processes those embedded comments and produces documentation in Markdown and Vim &quot;help&quot; formats. To avoid confusion, this document refers to the Vim plug-in as &quot;vim-docvim&quot; and the separate generation tool as &quot;docvim&quot;.


## Installation<a name="docvim-installation" href="#user-content-docvim-installation"></a>

To install vim-docvim, use your plug-in management system of choice.

If you don't have a &quot;plug-in management system of choice&quot;, I recommend Pathogen (https://github.com/tpope/vim-pathogen) due to its simplicity and robustness. Assuming that you have Pathogen installed and configured, and that you want to install vim-docvim into `~/.vim/bundle`, you can do so with:

```
git clone https://github.com/wincent/vim-docvim.git ~/.vim/bundle/vim-docvim
```

Alternatively, if you use a Git submodule for each Vim plug-in, you could do the following after `cd`-ing into the top-level of your Git superproject:

```
git submodule add https://github.com/wincent/vim-docvim.git ~/vim/bundle/vim-docvim
git submodule init
```

To generate help tags under Pathogen, you can do so from inside Vim with:

```
:call pathogen#helptags()
```


## Related<a name="docvim-related" href="#user-content-docvim-related"></a>


### Docvim<a name="docvim-docvim" href="#user-content-docvim-docvim"></a>

The Docvim tool itself is a Haskell module, available at:

http://hackage.haskell.org/package/docvim

Source code:

- https://github.com/wincent/docvim
- https://gitlab.com/wincent/docvim
- https://bitbucket.org/ghurrell/docvim


## Website<a name="docvim-website" href="#user-content-docvim-website"></a>

Source code for vim-docvim:

- https://github.com/wincent/vim-docvim
- https://gitlab.com/wincent/vim-docvim
- https://bitbucket.org/ghurrell/vim-docvim

Official releases are listed at:

http://www.vim.org/scripts/script.php?script_id=5758


## License<a name="docvim-license" href="#user-content-docvim-license"></a>

Copyright (c) 2015-present Greg Hurrell

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the &quot;Software&quot;), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


## Development<a name="docvim-development" href="#user-content-docvim-development"></a>


### Contributing patches<a name="docvim-contributing-patches" href="#user-content-docvim-contributing-patches"></a>

Patches can be sent via mail to greg@hurrell.net, or as GitHub pull requests at: https://github.com/wincent/vim-docvim/pulls


### Cutting a new release<a name="docvim-cutting-a-new-release" href="#user-content-docvim-cutting-a-new-release"></a>

At the moment the release process is manual:

- Perform final sanity checks and manual testing
- Update the <strong>[`docvim-history`](#user-content-docvim-history)</strong> section of the documentation
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
git archive -o vim-docvim-$VERSION.zip HEAD -- .
```

- Upload to http://www.vim.org/scripts/script.php?script_id=5758


## Authors<a name="docvim-authors" href="#user-content-docvim-authors"></a>

vim-docvim is written and maintained by Greg Hurrell &lt;greg@hurrell.net&gt;.


## History<a name="docvim-history" href="#user-content-docvim-history"></a>


### 1.0 (25 December 2018)<a name="docvim-10-25-december-2018" href="#user-content-docvim-10-25-december-2018"></a>

- Initial release.
