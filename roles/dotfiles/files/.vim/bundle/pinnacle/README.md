# Intro

Pinnacle provides functions for manipulating `:highlight` groups.

# Installation

To install Pinnacle, use your plug-in management system of choice.

If you don't have a "plug-in management system of choice", I recommend Pathogen (https://github.com/tpope/vim-pathogen) due to its simplicity and robustness. Assuming that you have Pathogen installed and configured, and that you want to install vim-docvim into `~/.vim/bundle`, you can do so with:

```
git clone https://github.com/wincent/pinnacle.git ~/.vim/bundle/pinnacle
```

Alternatively, if you use a Git submodule for each Vim plug-in, you could do the following after `cd`-ing into the top-level of your Git superproject:

```
git submodule add https://github.com/wincent/pinnacle.git ~/vim/bundle/pinnacle
git submodule init
```

To generate help tags under Pathogen, you can do so from inside Vim with:

```
:call pathogen#helptags()
```

# Website

The official Pinnacle source code repo is at:

http://git.wincent.com/pinnacle.git

Mirrors exist at:

- https://github.com/wincent/pinnacle
- https://gitlab.com/wincent/pinnacle
- https://bitbucket.org/ghurrell/pinnacle

Official releases are listed at:

http://www.vim.org/scripts/script.php?script_id=[TODO]

# License

Copyright (c) 2016-present Greg Hurrell

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Development

## Contributing patches

Patches can be sent via mail to greg@hurrell.net, or as GitHub pull requests at: https://github.com/wincent/pinnacle/pulls

## Cutting a new release

At the moment the release process is manual:

- Perform final sanity checks and manual testing
- Update the [pinnacle-history](#user-content-pinnacle-history) section of the documentation
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
git push origin master --follow-tags
git push github master --follow-tags
```

- Produce the release archive:

```
git archive -o vim-docvim-$VERSION.zip HEAD -- .
```

- Upload to http://www.vim.org/scripts/script.php?script_id=[TODO]

# Authors

Pinnacle is written and maintained by Greg Hurrell <greg@hurrell.net>.

# History

## 0.1 (30 March 2016)

- Initial release.
