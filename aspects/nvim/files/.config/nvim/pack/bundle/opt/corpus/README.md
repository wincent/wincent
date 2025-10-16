<p align="center">
  <img src="https://raw.githubusercontent.com/wincent/corpus/media/corpus-logo.png" />
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/wincent/corpus/media/corpus-demo.gif" />
</p>

# corpus<a name="corpus-corpus" href="#user-content-corpus-corpus"></a>

## Intro<a name="corpus-intro" href="#user-content-corpus-intro"></a>

> Corpus is a note-management application for Neovim.

<p align="right"><a name="corpus-features" href="#user-content-corpus-features"><code>corpus-features</code></a></p>

Notes exist as Markdown files in a Git repository. Corpus provides:

- An interface for listing, searching, switching to, and creating notes.
- Bindings for creating links between notes.
- Optionally, automatic creation of Git commits after each save.
- Optionally, automatic creation of references for Markdown links.
- Optionally, automatic tagging or titling of content in Markdown frontmatter sections.
- Configurable rules for naming and linking such that Corpus directories can be used for local notes (eg. personal wikis) and hosted notes (eg. public wikis on the web).

If you're a visual person, the following screencast presents an early version of the plug-in and how it works: https://youtu.be/KRlNBcYw74I

This screencast shows a more recent update: https://youtu.be/kmsKO0hfHx8

## Installation<a name="corpus-installation" href="#user-content-corpus-installation"></a>

To install Corpus, use your plug-in management system of choice.

Note that Corpus requires a recent version of Neovim.

## Commands<a name="corpus-commands" href="#user-content-corpus-commands"></a>

<p align="right"><a name="corpus" href="#user-content-corpus"><code>:Corpus</code></a></p>

### `:Corpus {search}`<a name="corpus-corpus-search" href="#user-content-corpus-corpus-search"></a>

When inside a Corpus directory, accepts a search query. On the left side of Corpus will show a list of files containing all of the words in the search query. On the right side, it will show a preview of the currently selected file. The selection can be moved up and down with the <strong>`<Up>`</strong> and <strong>`<Down>`</strong> keys (or equivalently, with `<C-k>` and `<C-j>`. Pressing `<Enter>` opens the selection in a buffer. Pressing `<Esc>` dismisses the search interface.

If the search query does not match any files, pressing `<Enter>` will create a new file with the same name. There are three additional special cases that you can use to create a new file:

- You can append an explicit &quot;.md&quot; file extension to the search query. This supports the following use case: imagine you want to create a file &quot;Foo.md&quot;, but your notes directory already contains a file, &quot;Bar.md&quot;, that happens to contain the string &quot;Foo&quot;. In this situation, typing &quot;Foo&quot; will show the &quot;Bar&quot; in the list of candidate files. Pressing `<Enter>` in this scenario would open &quot;Bar.md&quot;. If you instead type &quot;Foo.md&quot;, you can press `<Enter>` to create &quot;Foo.md&quot;.
- You can invoke <strong>[`:Corpus`](#user-content-corpus)</strong> with a <strong>`<bang>`</strong> suffix (ie. as `:Corpus!`) to tell it that you intend to create a file matching the name of your search term, if one doesn't exist already. In this mode, a preview of matching filenames is still shown (so that you can see whether there is an existing file with the desired name or not), but regardless of what is shown, pressing `<Enter>` will create or open a file with exactly that name (&quot;.md&quot; will be appended to the filename if not already present).
- Alternatively, if you get to the end of your desired filename and realize that neither of the preceding two tricks work (ie. because you already have a file with contents &quot;Foo.md&quot; inside it, or because you didn't use `:Corpus!`), you can append a trailing &quot;!&quot; to your search term, which Corpus will take as a cue to create a new file no matter what. This last technique only works when <strong>[`g:CorpusBangCreation`](#user-content-gcorpusbangcreation)</strong> is set to `1`; the feature is optional because it can make it awkward to include exclamation marks in your search terms and filenames. For example, if <strong>[`g:CorpusBangCreation`](#user-content-gcorpusbangcreation)</strong> is set and you want to search for &quot;foo bar!&quot;, that search term would lead to the creation of a file, &quot;foo bar.md&quot;; to avoid this, search instead for &quot;bar! foo&quot; (the exclamation mark forces file creation only if it appears at the end of the search).

When outside a Corpus directory, you can use tab-completion to switch to one of the configured <strong>[`CorpusDirectories`](#user-content-corpusdirectories)</strong>.

## Mappings<a name="corpus-mappings" href="#user-content-corpus-mappings"></a>

In &quot;.md&quot; files inside a Corpus directory, &quot;corpus&quot; is added to the <strong>`'filetype'`</strong> and a buffer-local `<C-]>` mapping is configured. Hitting this mapping over a word turns it into a shorthand reference link. For example:

```
if cursor is on THIS here
```

it will turn into:

```
if cursor is on [THIS] here
```

In <strong>`Visual`</strong> mode, the selection can be turned into a link:

```
if THIS IS SELECTED here
```

hitting the mapping will produce:

```
if [THIS IS SELECTED] here
```

When the cursor is on such a link, hitting `<C-]>` will navigate to that file.

### `<Plug>(Corpus)`<a name="corpus-plugcorpus" href="#user-content-corpus-plugcorpus"></a>

Corpus maps &lt;Leader&gt;c to <strong>[`<Plug>(Corpus)`](#user-content-plugcorpus)</strong>, which triggers the <strong>[`:Corpus`](#user-content-corpus)</strong> command. To use an alternative mapping instead, create a different one in your <strong>`init.vim`</strong> instead using <strong>`:nmap`</strong>:

```
" Instead of <Leader>c, use <Leader>o.
nmap <leader>o <Plug>(Corpus)
```

## Options<a name="corpus-options" href="#user-content-corpus-options"></a>

<p align="right"><a name="corpusdirectories" href="#user-content-corpusdirectories"><code>CorpusDirectories</code></a> <a name="gcorpusdirectories" href="#user-content-gcorpusdirectories"><code>g:CorpusDirectories</code></a></p>

Corpus relies on a list of <strong>[`CorpusDirectories`](#user-content-corpusdirectories)</strong> defined as a Lua table variable in your <strong>`init.lua`</strong>, or as a Vim dictionary in your <strong>`init.vim`</strong>. For example:

```
 -- init.lua (as Lua global):
 CorpusDirectories = {
   ['~/Documents/Corpus'] = {
       autocommit = true,
       autoreference = 1,
       autotitle = 1,
       base = './',
       transform = 'local',
     },
     ['~/code/masochist/content/content/wiki'] = {
       autocommit = false,
       autoreference = 1,
       autotitle = 1,
       base = '/wiki/',
       tags = {'wiki'},
       transform = 'web',
     },
 }

 -- init.lua (as Vim global):
 vim.g.CorpusDirectories = {...}

 " init.vim (as Vim global):
 let g:CorpusDirectories = {...}
```

Keys in the table name directories containing Corpus notes. These directories should be Git repositories. A tilde in the name will be automatically expanded.

Values are tables describing the desired behavior for the corresponding directory.

<p align="right"><a name="corpus-autocommit" href="#user-content-corpus-autocommit"><code>corpus-autocommit</code></a></p>

### `autocommit`<a name="corpus-autocommit" href="#user-content-corpus-autocommit"></a>

When `true`, Corpus will create a commit each time a file is written.

Defaults to `false`.

<p align="right"><a name="corpus-autoreference" href="#user-content-corpus-autoreference"><code>corpus-autoreference</code></a></p>

### `autoreference`<a name="corpus-autoreference" href="#user-content-corpus-autoreference"></a>

When true, Corpus will update Markdown link references each time a file is saved. For example, given this text:

```
This one [is a link] to somewhere else.
```

We will see references like the following created at the bottom of the file:

```
[is a link]: <./is a link.md>
```

Defaults to `false`.

<p align="right"><a name="corpus-referenceheader" href="#user-content-corpus-referenceheader"><code>corpus-referenceheader</code></a></p>

### `referenceheader`<a name="corpus-referenceheader" href="#user-content-corpus-referenceheader"></a>

When set to a string value, Corpus will maintain a header above the references list using HTML comment syntax. For example, given a `referenceheader` of 'References', it will insert a comment of the form `<!-- References -->`.

Defaults to `nil` (ie. no header).

<p align="right"><a name="corpus-autotitle" href="#user-content-corpus-autotitle"><code>corpus-autotitle</code></a></p>

### `autotitle`<a name="corpus-autotitle" href="#user-content-corpus-autotitle"></a>

When true, Corpus will update the `title` in the Markdown frontmatter (based on the filename) each time the note is saved.

For example, a file named &quot;Some article.md&quot; would produce the following metadata:

```
title: Some article
```

Defaults to `false`.

<p align="right"><a name="corpus-base" href="#user-content-corpus-base"><code>corpus-base</code></a></p>

### `base`<a name="corpus-base" href="#user-content-corpus-base"></a>

When set, Corpus will use the `base` as a prefix when generating link targets, which is particularly useful when the notes in question are to be hosted on a public website.

For example, give a `base` of &quot;/wiki/&quot; and a link such as &quot;foobar&quot;, the resulting link target will be &quot;/wiki/foobar&quot;.

Defaults to an empty string.

<p align="right"><a name="corpus-tags" href="#user-content-corpus-tags"><code>corpus-tags</code></a></p>

### `tags`<a name="corpus-tags" href="#user-content-corpus-tags"></a>

When true, Corpus will update the `tags` list in the Markdown frontmatter (based on the filename) each time the note is saved.

For example, given a `tags` value of `{'foo', 'bar'}`, Corpus would produce the following metadata:

```
tags: foo bar
```

Defaults to `nil`, which means that no tags get added to the frontmatter.

<p align="right"><a name="corpus-transform" href="#user-content-corpus-transform"><code>corpus-transform</code></a></p>

### `transform`<a name="corpus-transform" href="#user-content-corpus-transform"></a>

When set to &quot;local&quot;, tells Corpus to transform filenames into link targets in a way that is suitable for navigating between files on a local filesystem. This is the &quot;local personal wiki&quot; use case. For example, given a filename of &quot;Shopping list.md&quot;, we have:

- A title of &quot;Shopping list&quot;.
- Links of the form `[Shopping list]`.
- Link targets of the form `Shopping list.md`.

When set to &quot;web&quot;, tells Corpus to transform filenames into link targets in a way that is suitable for deployment as a public wiki on the web. Spaces are transformed into underscores, and the <strong>[`corpus-base`](#user-content-corpus-base)</strong> setting is prepended. For example, given a filename of &quot;Troubleshooting tips.md&quot;, we have:

- A title of &quot;Troubleshooting tips&quot;.
- Links of the form `[Troubleshooting tips]`.
- Link targets of the form `/wiki/Troubleshooting_tips`.

Defaults to 'local'.

<p align="right"><a name="gcorpusautocd" href="#user-content-gcorpusautocd"><code>g:CorpusAutoCd</code></a></p>

### `g:CorpusAutoCd` (number, default: 0)<a name="corpus-gcorpusautocd-number-default-0" href="#user-content-corpus-gcorpusautocd-number-default-0"></a>

When set to 1, and when there is only one Corpus directory, initiating a <strong>[`:Corpus`](#user-content-corpus)</strong> command will automatically <strong>`:cd`</strong> into that directory.

```
let g:CorpusAutoCd=1
```

<p align="right"><a name="gcorpusbangcreation" href="#user-content-gcorpusbangcreation"><code>g:CorpusBangCreation</code></a></p>

### `g:CorpusBangCreation` (number, default: 0)<a name="corpus-gcorpusbangcreation-number-default-0" href="#user-content-corpus-gcorpusbangcreation-number-default-0"></a>

When set to `1`, Corpus will take a trailing &quot;!&quot; at the end of a search term as a cue to create a file with that name. For example, an invocation like `:Corpus Foo!` would create or open a file called &quot;Foo.md&quot;.

```
let g:CorpusBangCreation=1
```

<p align="right"><a name="gcorpuschooserselectionhighlight" href="#user-content-gcorpuschooserselectionhighlight"><code>g:CorpusChooserSelectionHighlight</code></a></p>

### `g:CorpusChooserSelectionHighlight` (string, default: "PMenuSel")<a name="corpus-gcorpuschooserselectionhighlight-string-default-pmenusel" href="#user-content-corpus-gcorpuschooserselectionhighlight-string-default-pmenusel"></a>

Specifies the highlight group applied to the currently selected item in the chooser listing (the left-hand pane). To override from the default value of &quot;PMenuSel&quot;, set a different value in your <strong>`init.vim`</strong>:

```
let g:CorpusChooserSelectionHighlight='Error'
```

<p align="right"><a name="gcorpuspreviewwinhighlight" href="#user-content-gcorpuspreviewwinhighlight"><code>g:CorpusPreviewWinhighlight</code></a></p>

### `g:CorpusPreviewWinhighlight` (string, default: see below)<a name="corpus-gcorpuspreviewwinhighlight-string-default-see-below" href="#user-content-corpus-gcorpuspreviewwinhighlight-string-default-see-below"></a>

Specifies the <strong>`'winhighlight'`</strong> string for the preview pane (the right-hand pane). The default is:

```
EndOfBuffer:LineNr,FoldColumn:StatusLine,Normal:LineNr.
```

To override, provide an alternate setting in your <strong>`init.vim`</strong>:

```
let g:CorpusPreviewWinhighlight='Normal:ModeMsg'
```

<p align="right"><a name="gcorpusloaded" href="#user-content-gcorpusloaded"><code>g:CorpusLoaded</code></a></p>

### `g:CorpusLoaded` (any, default: none)<a name="corpus-gcorpusloaded-any-default-none" href="#user-content-corpus-gcorpusloaded-any-default-none"></a>

To prevent Corpus from being loaded, set <strong>[`g:CorpusLoaded`](#user-content-gcorpusloaded)</strong> to any value in your <strong>`init.vim`</strong>. For example:

```
let g:CorpusLoaded=1
```

<p align="right"><a name="gcorpussort" href="#user-content-gcorpussort"><code>g:CorpusSort</code></a></p>

### `g:CorpusSort` (string, default: "default")<a name="corpus-gcorpussort-string-default-default" href="#user-content-corpus-gcorpussort-string-default-default"></a>

Specifies the sort order for the chooser listing. The default sort order maintains the order of results returned by `git-ls-files` and `git-grep`, which should be lexicographical order.

To sort by last-modified timestamp instead (ie. showing the most recently modified files at the top of the listing), set to &quot;stat&quot;.

```
let g:CorpusSort='stat'
```

## Website<a name="corpus-website" href="#user-content-corpus-website"></a>

Source code:

https://github.com/wincent/corpus

## License<a name="corpus-license" href="#user-content-corpus-license"></a>

Copyright (c) 2015-present Greg Hurrell

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the &quot;Software&quot;), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Development<a name="corpus-development" href="#user-content-corpus-development"></a>

### Contributing patches<a name="corpus-contributing-patches" href="#user-content-corpus-contributing-patches"></a>

Patches can be sent via mail to greg@hurrell.net, or as GitHub pull requests at: https://github.com/wincent/corpus/pulls

## Authors<a name="corpus-authors" href="#user-content-corpus-authors"></a>

Corpus is written and maintained by Greg Hurrell &lt;greg@hurrell.net&gt;. Other contributors that have submitted patches include, in alphabetical order:

- Cody Buell
- Joe Lencioni

This list produced with:

```
:read !git shortlog -s HEAD | grep -v 'Greg Hurrell' | cut -f 2- | sed -e 's/^/- /'
```

## History<a name="corpus-history" href="#user-content-corpus-history"></a>

### main (not yet released)<a name="corpus-main-not-yet-released" href="#user-content-corpus-main-not-yet-released"></a>

- Initial release.
- Added <strong>[`g:CorpusChooserSelectionHighlight`](#user-content-gcorpuschooserselectionhighlight)</strong> and <strong>[`g:CorpusPreviewWinhighlight`](#user-content-gcorpuspreviewwinhighlight)</strong> settings (https://github.com/wincent/corpus/issues/75).
- Added <strong>[`g:CorpusBangCreation`](#user-content-gcorpusbangcreation)</strong> (https://github.com/wincent/corpus/issues/81).
- Accept either a Lua global (`CorpusDirectories`) or a Vim Global (`g:CorpusDirectories`) for configuration.
- Added <strong>[`g:CorpusAutoCd`](#user-content-gcorpusautocd)</strong> (https://github.com/wincent/corpus/pull/84, patch from Cody Buell).
- Added <strong>[`g:CorpusSort`](#user-content-gcorpussort)</strong> (https://github.com/wincent/corpus/issues/74).
- Added `referenceheader` setting (see <strong>[`corpus-referenceheader`](#user-content-corpus-referenceheader)</strong>).
