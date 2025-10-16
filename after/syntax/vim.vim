""
" @plugin docvim Syntax highlighting for docvim comments
"
"                                                                    *vim-docvim*
" # Intro
"
" vim-docvim provides additional syntax highlighting for Vim script files that
" contain embedded docvim comments.
"
" docvim (the tool, not this plug-in) is a documentation generator that
" processes those embedded comments and produces documentation in Markdown and
" Vim "help" formats. To avoid confusion, this document refers to the Vim
" plug-in as "vim-docvim" and the separate generation tool as "docvim".
"
"
" # Installation
"
" To install vim-docvim, use your plug-in management system of choice.
"
" If you don't have a "plug-in management system of choice", I recommend
" Pathogen (https://github.com/tpope/vim-pathogen) due to its simplicity and
" robustness. Assuming that you have Pathogen installed and configured, and that
" you want to install vim-docvim into `~/.vim/bundle`, you can do so with:
"
" ```
" git clone https://github.com/wincent/vim-docvim.git ~/.vim/bundle/vim-docvim
" ```
"
" Alternatively, if you use a Git submodule for each Vim plug-in, you could do
" the following after `cd`-ing into the top-level of your Git superproject:
"
" ```
" git submodule add https://github.com/wincent/vim-docvim.git ~/vim/bundle/vim-docvim
" git submodule init
" ```
"
" To generate help tags under Pathogen, you can do so from inside Vim with:
"
" ```
" :call pathogen#helptags()
" ```
"
"
" # Related
"
" ## Docvim
"
" The Docvim tool itself is a Haskell module, available at:
"
"   http://hackage.haskell.org/package/docvim
"
" Source code:
"
"   - https://github.com/wincent/docvim
"   - https://gitlab.com/wincent/docvim
"   - https://bitbucket.org/ghurrell/docvim
"
" # Website
"
" Source code for vim-docvim:
"
"   - https://github.com/wincent/vim-docvim
"   - https://gitlab.com/wincent/vim-docvim
"   - https://bitbucket.org/ghurrell/vim-docvim
"
" Official releases are listed at:
"
"   http://www.vim.org/scripts/script.php?script_id=5758
"
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
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"
" # Development
"
" ## Contributing patches
"
" Patches can be sent via mail to greg@hurrell.net, or as GitHub pull requests
" at: https://github.com/wincent/vim-docvim/pulls
"
" ## Cutting a new release
"
" At the moment the release process is manual:
"
" - Perform final sanity checks and manual testing
" - Update the |docvim-history| section of the documentation
" - Verify clean work tree:
"
" ```
" git status
" ```
"
" - Tag the release:
"
" ```
" git tag -s -m "$VERSION release" $VERSION
" ```
"
" - Publish the code:
"
" ```
" git push origin main --follow-tags
" git push github main --follow-tags
" ```
"
" - Produce the release archive:
"
" ```
" git archive -o vim-docvim-$VERSION.zip HEAD -- .
" ```
"
" - Upload to http://www.vim.org/scripts/script.php?script_id=5758
"
"
" # Authors
"
" vim-docvim is written and maintained by Greg Hurrell <greg@hurrell.net>.
"
"
" # History
"
" ## 1.0 (25 December 2018)
"
" - Initial release.

syntax region docvimBlock start='\v^\s*""' end='\v^\zs\ze\s*($|[^ \t"])' containedin=vimFuncBody
syntax region docvimPre start='\v^\s*"\s+\zs```\s*$' end='\v^\s*"\s+```\s*$' containedin=docvimBlock contained keepend

syntax match docvimAnnotation '\v\@command( .+)?' containedin=docvimBlock contained
syntax match docvimAnnotation '@commands' containedin=docvimBlock contained
syntax match docvimAnnotation '@dedent' containedin=docvimBlock contained
syntax match docvimAnnotation '@footer' containedin=docvimBlock contained
syntax match docvimAnnotation '\v\@function( .+)?' containedin=docvimBlock contained
syntax match docvimAnnotation '@functions' containedin=docvimBlock contained
syntax match docvimAnnotation '@header' containedin=docvimBlock contained
syntax match docvimAnnotation '\v\@image( .+)?' containedin=docvimBlock contained
syntax match docvimAnnotation '@indent' containedin=docvimBlock contained
syntax match docvimAnnotation '\v\@mapping( .+)?' containedin=docvimBlock contained
syntax match docvimAnnotation '@mappings' containedin=docvimBlock contained
syntax match docvimAnnotation '\v\@option( .+)?' containedin=docvimBlock contained
syntax match docvimAnnotation '@options' containedin=docvimBlock contained
syntax match docvimAnnotation '@param' containedin=docvimBlock contained
syntax match docvimAnnotation '\v\@plugin( .+)?' containedin=docvimBlock contained
syntax match docvimAnnotation '@private' containedin=docvimBlock contained
syntax match docvimBackticks '\v`[^\s`]+`' containedin=docvimBlock contained
syntax match docvimBlockquote '\v^\s*"\s+\zs\>\s+.+$' containedin=docvimBlock contained
syntax match docvimCrossReference '\v\c\|:?[a-z0-9()<>\.:-]+\|' containedin=docvimBlock contained
syntax match docvimHeading '\v^\s*"\s+\zs#\s+.+$' containedin=docvimBlock contained
syntax match docvimPreComment '\v^\s*"' containedin=docvimPre contained
syntax match docvimSetting "\v'[a-z]{2,}'" containedin=docvimBlock contained
syntax match docvimSetting "\v't_..'" containedin=docvimBlock contained
syntax match docvimSpecial '\v\<CSM-.\>' containedin=docvimBlock contained
syntax match docvimSpecial '\v\<[-a-zA-Z0-9_]+\>' containedin=docvimBlock contained
syntax match docvimSubheading '\v^\s*"\s+\zs##\s+.+$' containedin=docvimBlock contained
syntax match docvimTarget '\v\c\*:?[a-z0-9()<>-]+\*' containedin=docvimBlock contained

" Stolen from $VIMRUNTIME/syntax/help.vim:
syntax match docvimURL `\v<(((https?|ftp|gopher)://|(mailto|file|news):)[^' 	<>"]+|(www|web|w3)[a-z0-9_-]*\.[a-z0-9._-]+\.[^' 	<>"]+)[a-zA-Z0-9/]` containedin=docvimBlock contained

if has('conceal')
  syntax match docvimBacktick '\v`' containedin=docvimBackticks contained conceal
  syntax match docvimBar '\v\|' containedin=docvimCrossReference contained conceal
  syntax match docvimHeadingPrefix '\v# ' containedin=docvimHeading contained conceal
  syntax match docvimStar '\v\*' containedin=docvimTarget contained conceal
  syntax match docvimSubheadingPrefix '\v## ' containedin=docvimSubheading contained conceal
else
  syntax match docvimBacktick '\v`' containedin=docvimBackticks contained
  syntax match docvimBar '\v\|' containedin=docvimCrossReference contained
  syntax match docvimHeadingPrefix '\v# ' containedin=docvimHeading contained
  syntax match docvimStar '\v\*' containedin=docvimTarget contained
  syntax match docvimSubheadingPrefix '\v## ' containedin=docvimSubheading contained
endif

function! s:italicize(name, link)
  try
    execute 'highlight! ' . a:name . ' ' . pinnacle#italicize(a:link)
  catch
    execute 'highlight! link ' . a:name . ' ' . a:link
  endtry
endfunction

function! s:highlight()
  call s:italicize('docvimAnnotation', 'String')
  call s:italicize('docvimBacktick', 'Comment')
  call s:italicize('docvimBackticks', 'Comment')
  call s:italicize('docvimBar', 'Identifier')
  call s:italicize('docvimBlock', 'Normal')
  call s:italicize('docvimBlockquote', 'Comment')
  call s:italicize('docvimComment', 'Normal')
  call s:italicize('docvimCrossReference', 'Identifier')
  call s:italicize('docvimHeading', 'Identifier')
  call s:italicize('docvimHeadingPrefix', 'Identifier')
  call s:italicize('docvimPre', 'Comment')
  call s:italicize('docvimSetting', 'Type')
  call s:italicize('docvimSpecial', 'Special')
  call s:italicize('docvimStar', 'String')
  call s:italicize('docvimSubheading', 'PreProc')
  call s:italicize('docvimSubheadingPrefix', 'PreProc')
  call s:italicize('docvimTarget', 'String')
  call s:italicize('docvimURL', 'String')
endfunction

if has('autocmd')
  augroup Docvim
    autocmd!
    autocmd ColorScheme * call s:highlight()
  augroup END
endif

call s:highlight()
