" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the MIT license.

""
" @header
"
" @image https://raw.githubusercontent.com/wincent/corpus/media/corpus-logo.png center
" @image https://raw.githubusercontent.com/wincent/corpus/media/corpus-demo.gif center

""
" @plugin corpus Corpus plug-in for Neovim
"
" # Intro
"
" > Corpus is a note-management application for Neovim.
"
"                                                             *corpus-features*
"
" Notes exist as Markdown files in a Git repository. Corpus provides:
"
" - An interface for listing, searching, switching to, and creating notes.
" - Bindings for creating links between notes.
" - Optionally, automatic creation of Git commits after each save.
" - Optionally, automatic creation of references for Markdown links.
" - Optionally, automatic tagging or titling of content in Markdown
"   frontmatter sections.
" - Configurable rules for naming and linking such that Corpus directories can
"   be used for local notes (eg. personal wikis) and hosted notes (eg. public
"   wikis on the web).
"
" If you're a visual person, the following screencast presents an early version
" of the plug-in and how it works: https://youtu.be/KRlNBcYw74I
"
" This screencast shows a more recent update: https://youtu.be/kmsKO0hfHx8
"
" # Installation
"
" To install Corpus, use your plug-in management system of choice.
"
" Note that Corpus requires a recent version of Neovim.
"
" @mappings
"
" In ".md" files inside a Corpus directory, "corpus" is added to the
" |'filetype'| and a buffer-local `<C-]>` mapping is configured. Hitting this
" mapping over a word turns it into a shorthand reference link. For example:
"
" ```
" if cursor is on THIS here
" ```
"
" it will turn into:
"
" ```
" if cursor is on [THIS] here
" ```
"
" In |Visual| mode, the selection can be turned into a link:
"
" ```
" if THIS IS SELECTED here
" ```
"
" hitting the mapping will produce:
"
" ```
" if [THIS IS SELECTED] here
" ```
"
" When the cursor is on such a link, hitting `<C-]>` will navigate to that file.
"
" @options
"
"                                         *CorpusDirectories* *g:CorpusDirectories*
" Corpus relies on a list of |CorpusDirectories| defined as a Lua
" table variable in your |init.lua|, or as a Vim dictionary in your
" |init.vim|. For example:
"
" ```
" -- init.lua (as Lua global):
" CorpusDirectories = {
"   ['~/Documents/Corpus'] = {
"       autocommit = true,
"       autoreference = 1,
"       autotitle = 1,
"       base = './',
"       transform = 'local',
"     },
"     ['~/code/masochist/content/content/wiki'] = {
"       autocommit = false,
"       autoreference = 1,
"       autotitle = 1,
"       base = '/wiki/',
"       tags = {'wiki'},
"       transform = 'web',
"     },
" }
"
" -- init.lua (as Vim global):
" vim.g.CorpusDirectories = {...}
"
" " init.vim (as Vim global):
" let g:CorpusDirectories = {...}
" ```
"
" Keys in the table name directories containing Corpus notes. These
" directories should be Git repositories. A tilde in the name will be
" automatically expanded.
"
" Values are tables describing the desired behavior for the corresponding
" directory.
"
"                                                            *corpus-autocommit*
" ## `autocommit`
"
" When `true`, Corpus will create a commit each time a file is written.
"
" Defaults to `false`.
"
"                                                         *corpus-autoreference*
" ## `autoreference`
"
" When true, Corpus will update Markdown link references each time a file is
" saved. For example, given this text:
"
" ```
" This one [is a link] to somewhere else.
" ```
"
" We will see references like the following created at the bottom of the file:
"
" ```
" [is a link]: <./is a link.md>
" ```
"
" Defaults to `false`.
"
"                                                       *corpus-referenceheader*
" ## `referenceheader`
"
" When set to a string value, Corpus will maintain a header above the references
" list using HTML comment syntax. For example, given a `referenceheader` of
" 'References', it will insert a comment of the form `<!-- References -->`.
"
" Defaults to `nil` (ie. no header).
"
"                                                             *corpus-autotitle*
" ## `autotitle`
"
" When true, Corpus will update the `title` in the Markdown frontmatter
" (based on the filename) each time the note is saved.
"
" For example, a file named "Some article.md" would produce the following
" metadata:
"
" ```
" title: Some article
" ```
"
" Defaults to `false`.
"
"                                                                  *corpus-base*
" ## `base`
"
" When set, Corpus will use the `base` as a prefix when generating link targets,
" which is particularly useful when the notes in question are to be hosted on a
" public website.
"
" For example, give a `base` of "/wiki/" and a link such as "foobar", the
" resulting link target will be "/wiki/foobar".
"
" Defaults to an empty string.
"
"                                                                  *corpus-tags*
" ## `tags`
"
" When true, Corpus will update the `tags` list in the Markdown frontmatter
" (based on the filename) each time the note is saved.
"
" For example, given a `tags` value of `{'foo', 'bar'}`, Corpus would
" produce the following metadata:
"
" ```
" tags: foo bar
" ```
"
" Defaults to `nil`, which means that no tags get added to the frontmatter.
"
"                                                             *corpus-transform*
" ## `transform`
"
" When set to "local", tells Corpus to transform filenames into link
" targets in a way that is suitable for navigating between files on a
" local filesystem. This is the "local personal wiki" use case. For example,
" given a filename of "Shopping list.md", we have:
"
" - A title of "Shopping list".
" - Links of the form `[Shopping list]`.
" - Link targets of the form `Shopping list.md`.
"
" When set to "web", tells Corpus to transform filenames into link targets in a
" way that is suitable for deployment as a public wiki on the web. Spaces are
" transformed into underscores, and the |corpus-base| setting is prepended. For
" example, given a filename of "Troubleshooting tips.md", we have:
"
" - A title of "Troubleshooting tips".
" - Links of the form `[Troubleshooting tips]`.
" - Link targets of the form `/wiki/Troubleshooting_tips`.
"
" Defaults to 'local'.
"
" @footer
"
" # Website
"
" Source code:
"
"   https://github.com/wincent/corpus
"
" # License
"
" Copyright (c) 2015-present Greg Hurrell
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
" KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
" WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
" # Development
"
" ## Contributing patches
"
" Patches can be sent via mail to greg@hurrell.net, or as GitHub pull requests
" at: https://github.com/wincent/corpus/pulls
"
" # Authors
"
" Corpus is written and maintained by Greg Hurrell <greg@hurrell.net>. Other
" contributors that have submitted patches include, in alphabetical order:
"
" - Cody Buell
" - Joe Lencioni
"
" This list produced with:
"
" ```
" :read !git shortlog -s HEAD | grep -v 'Greg Hurrell' | cut -f 2- | sed -e 's/^/- /'
" ```
"
" # History
"
" ## main (not yet released)
"
" - Initial release.
" - Added |g:CorpusChooserSelectionHighlight| and |g:CorpusPreviewWinhighlight|
"   settings (https://github.com/wincent/corpus/issues/75).
" - Added |g:CorpusBangCreation| (https://github.com/wincent/corpus/issues/81).
" - Accept either a Lua global (`CorpusDirectories`) or a Vim Global
"   (`g:CorpusDirectories`) for configuration.
" - Added |g:CorpusAutoCd| (https://github.com/wincent/corpus/pull/84, patch
"   from Cody Buell).
" - Added |g:CorpusSort| (https://github.com/wincent/corpus/issues/74).
" - Added `referenceheader` setting (see |corpus-referenceheader|).

" TODO: update all of these docs...

""
" @option g:CorpusAutoCd number 0
"
" When set to 1, and when there is only one Corpus directory, initiating a
" |:Corpus| command will automatically |:cd| into that directory.
"
" ```
" let g:CorpusAutoCd=1
" ```
"
" @option g:CorpusBangCreation number 0
"
" When set to `1`, Corpus will take a trailing "!" at the end of a search term
" as a cue to create a file with that name. For example, an invocation like
" `:Corpus Foo!` would create or open a file called "Foo.md".
"
" ```
" let g:CorpusBangCreation=1
" ```
"
" @option g:CorpusChooserSelectionHighlight string "PMenuSel"
"
" Specifies the highlight group applied to the currently selected item
" in the chooser listing (the left-hand pane). To override from the default
" value of "PMenuSel", set a different value in your |init.vim|:
"
" ```
" let g:CorpusChooserSelectionHighlight='Error'
" ```
"
" @option g:CorpusPreviewWinhighlight string see below
"
" Specifies the |'winhighlight'| string for the preview pane (the right-hand
" pane). The default is:
"
" ```
" EndOfBuffer:LineNr,FoldColumn:StatusLine,Normal:LineNr.
" ```
"
" To override, provide an alternate setting in your |init.vim|:
"
" ```
" let g:CorpusPreviewWinhighlight='Normal:ModeMsg'
" ```
"
"
" @option g:CorpusLoaded any
"
" To prevent Corpus from being loaded, set |g:CorpusLoaded| to any value in your
" |init.vim|. For example:
"
" ```
" let g:CorpusLoaded=1
" ```
if exists('g:CorpusLoaded') || &compatible || !has('nvim')
  finish
endif

let g:CorpusLoaded=1

""
" @option g:CorpusSort string "default"
"
" Specifies the sort order for the chooser listing. The default sort order
" maintains the order of results returned by `git-ls-files` and `git-grep`, which
" should be lexicographical order.
"
" To sort by last-modified timestamp instead (ie. showing the most recently
" modified files at the top of the listing), set to "stat".
"
" ```
" let g:CorpusSort='stat'
" ```

" Temporarily set 'cpoptions' to Vim default as per `:h use-cpo-save`.
let s:cpoptions=&cpoptions
set cpoptions&vim

if has('autocmd')
  augroup Corpus
    autocmd!
    autocmd BufNewFile *.md call corpus#buf_new_file()

    if exists('##CmdlineChanged')
      autocmd CmdlineChanged * call v:lua.require'wincent.corpus'.cmdline_changed(expand('<afile>'))
    endif

    autocmd CmdlineEnter * lua require'wincent.corpus'.cmdline_enter()
    autocmd CmdlineLeave * lua require'wincent.corpus'.cmdline_leave()
  augroup END
endif

""
" @command :Corpus {search}
"
" When inside a Corpus directory, accepts a search query. On the left
" side of Corpus will show a list of files containing all of the words
" in the search query. On the right side, it will show a preview of the
" currently selected file. The selection can be moved up and down with the
" |<Up>| and |<Down>| keys (or equivalently, with `<C-k>` and `<C-j>`. Pressing
" `<Enter>` opens the selection in a buffer. Pressing `<Esc>` dismisses the
" search interface.
"
" If the search query does not match any files, pressing `<Enter>` will
" create a new file with the same name. There are three additional
" special cases that you can use to create a new file:
"
" - You can append an explicit ".md" file extension to the search
"   query. This supports the following use case: imagine you want to
"   create a file "Foo.md", but your notes directory already contains
"   a file, "Bar.md", that happens to contain the string "Foo". In this
"   situation, typing "Foo" will show the "Bar" in the list of candidate
"   files. Pressing `<Enter>` in this scenario would open "Bar.md". If you
"   instead type "Foo.md", you can press `<Enter>` to create "Foo.md".
" - You can invoke |:Corpus| with a |<bang>| suffix (ie. as `:Corpus!`) to tell
"   it that you intend to create a file matching the name of your search term,
"   if one doesn't exist already. In this mode, a preview of matching filenames
"   is still shown (so that you can see whether there is an existing file with
"   the desired name or not), but regardless of what is shown, pressing `<Enter>`
"   will create or open a file with exactly that name (".md" will be appended to
"   the filename if not already present).
" - Alternatively, if you get to the end of your desired filename and
"   realize that neither of the preceding two tricks work (ie. because you
"   already have a file with contents "Foo.md" inside it, or because you
"   didn't use `:Corpus!`), you can append a trailing "!" to your search
"   term, which Corpus will take as a cue to create a new file no matter
"   what. This last technique only works when |g:CorpusBangCreation| is
"   set to `1`; the feature is optional because it can make it awkward to
"   include exclamation marks in your search terms and filenames. For example,
"   if |g:CorpusBangCreation| is set and you want to search for "foo bar!", that
"   search term would lead to the creation of a file, "foo bar.md"; to avoid
"   this, search instead for "bar! foo" (the exclamation mark forces file
"   creation only if it appears at the end of the search).
"
" When outside a Corpus directory, you can use tab-completion to switch to one
" of the configured |CorpusDirectories|.
command! -bang -complete=customlist,corpus#complete -nargs=* Corpus call v:lua.require'wincent.corpus'.choose(<q-args>, "<bang>")

" TODO: use vim.api.nvim_create_user_command instead of this ^^^

nnoremap <Plug>(Corpus) :Corpus<Space>

if !hasmapto('<Plug>(Corpus)') && maparg('<Leader>c', 'n') ==# ''
  ""
  " @mapping <Plug>(Corpus)
  "
  " Corpus maps <Leader>c to |<Plug>(Corpus)|, which triggers the |:Corpus|
  " command. To use an alternative mapping instead, create a different one in
  " your |init.vim| instead using |:nmap|:
  "
  " ```
  " " Instead of <Leader>c, use <Leader>o.
  " nmap <leader>o <Plug>(Corpus)
  " ```
  nmap <unique> <Leader>c <Plug>(Corpus)
endif

" Restore 'cpoptions' to its former value.
let &cpoptions = s:cpoptions
unlet s:cpoptions
