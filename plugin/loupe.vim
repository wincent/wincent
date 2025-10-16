" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

""
" @header
"
" @image https://raw.githubusercontent.com/wincent/loupe/media/loupe-small.jpg center
"

""
"
" @plugin loupe Loupe plug-in for Vim
"
" # Intro
"
" > "loupe (noun)<br>
" > a small magnifying glass used by jewelers and watchmakers."
"
"                                                               *loupe-features*
" Loupe enhances Vim's |search-commands| in four ways:
"
" ## 1. Makes the currently selected match easier to see
"
" When searching using |/|, |?|, |star|, |#|, |n|, |N| or similar, it can be
" hard to see the "current" match from among all the matches that 'hlsearch'
" highlights. Loupe makes the currently selected match easier to see by:
"
" - Applying a different |:highlight| group (by default, |hl-IncSearch|) to the
"   match under the cursor.
" - Keeping the matching line centered within the window when jumping between
"   matches with |n| and |N|.
"
" ## 2. Applies sane pattern syntax by default
"
" Loupe makes "very magic" (|/\v|) syntax apply by default when searching. This
" is true even if you initiate a search via a novel means, such as from a visual
" selection or with a complicated |:range| prefix.
"
" This means that you can use a pattern syntax closer to the familiar regular
" expression syntax from languages such as Perl, Ruby, JavaScript (indeed, most
" other modern languages that support regular expressions).
"
" ## 3. Provides a shortcut to remove search highlighting
"
" Loupe maps <leader>n to quickly remove all 'hlsearch' highlighting (although
" you can provide an alternative mapping of your choosing or suppress the
" feature entirely).
"
" ## 4. Sensible defaults for search-related features
"
" Loupe provides reasonable defaults for most search-related Vim settings to
" provide a good "out of the box" experience. For more details, or to see how to
" override Loupe's settings, see |loupe-overrides|.
"
"
" # Installation
"
" To install Loupe, use your plug-in management system of choice.
"
" If you don't have a "plug-in management system of choice", I recommend
" Pathogen (https://github.com/tpope/vim-pathogen) due to its simplicity and
" robustness. Assuming that you have Pathogen installed and configured, and that
" you want to install Loupe into `~/.vim/bundle`, you can do so with:
"
" ```
" git clone https://github.com/wincent/loupe.git ~/.vim/bundle/loupe
" ```
"
" Alternatively, if you use a Git submodule for each Vim plug-in, you could do
" the following after `cd`-ing into the top-level of your Git superproject:
"
" ```
" git submodule add https://github.com/wincent/loupe.git ~/vim/bundle/loupe
" git submodule init
" ```
"
" To generate help tags under Pathogen, you can do so from inside Vim with:
"
" ```
" :call pathogen#helptags()
" ```
"
" @footer
"
" # Overrides
"
" Loupe sets a number of search-related Vim settings to reasonable defaults in
" order to provide a good "out of the box" experience. The following overrides
" will be set unless suppressed or overridden (see |loupe-suppress-overrides|):
"
" @indent
"                                                        *loupe-history-override*
"   |'history'|
"
"   Increased to 1000, to increase the number of previous searches remembered.
"   Note that Loupe only applies this setting if the current value of 'history'
"   is less than 1000.
"
"                                                       *loupe-hlsearch-override*
"   |'hlsearch'|
"
"   Turned on (when there is a previous search pattern, highlight all its
"   matches).
"
"                                                      *loupe-incsearch-override*
"   |'incsearch'|
"
"   Turned on (while typing a search command, show where the pattern matches, as
"   it was typed so far).
"
"                                                     *loupe-ignorecase-override*
"   |'ignorecase'|
"
"   Turned on (to ignore case in search patterns).
"
"                                                      *loupe-shortmess-override*
"   |'shortmess'|
"
"   Adds "s", which suppresses the display of "search hit BOTTOM, continuing at
"   TOP" and "search hit TOP, continuing at BOTTOM" messages.
"
"                                                      *loupe-smartcase-override*
"   |'smartcase'|
"
"   Turned on (overrides |'ignorecase'|, making the search pattern
"   case-sensitive whenever it containers uppercase characters).
"
" @dedent
"
"                                                      *loupe-suppress-overrides*
" ## Preventing Loupe overrides from taking effect
"
" To override any of these choices, you can place overrides in an
" |after-directory| (ie. `~/.vim/after/plugin/loupe.vim`). For example:
"
" ```
" " Override Loupe's 'history' setting from 1000 to 10000.
" set history=10000
"
" " Reset Loupe's 'incsearch' back to Vim default.
" set incsearch&vim
"
" " Remove unwanted 's' from 'shortmess'.
" set shortmess-=s
" ```
"
" # Related
"
" Just as Loupe aims to improve the within-file search experience, Ferret does
" the same for multi-file searching and replacing:
"
" - https://github.com/wincent/ferret
"
" # Website
"
" Source code:
"
" - https://github.com/wincent/loupe
"
" Official releases are listed at:
"
" - http://www.vim.org/scripts/script.php?script_id=5215
"
"
" # License
"
" Copyright 2015-present Greg Hurrell. All rights reserved.
"
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions are met:
"
" 1. Redistributions of source code must retain the above copyright notice,
"    this list of conditions and the following disclaimer.
"
" 2. Redistributions in binary form must reproduce the above copyright notice,
"    this list of conditions and the following disclaimer in the documentation
"    and/or other materials provided with the distribution.
"
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
" IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
" ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
" LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
" CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
" SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
" INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
" CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
" ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
" POSSIBILITY OF SUCH DAMAGE.
"
"
" # Development
"
" ## Contributing patches
"
" Patches can be sent via mail to greg@hurrell.net, or as GitHub pull requests
" at: https://github.com/wincent/loupe/pulls
"
" ## Cutting a new release
"
" At the moment the release process is manual:
"
" - Perform final sanity checks and manual testing
" - Update the |loupe-history| section of the documentation
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
" git archive -o loupe-$VERSION.zip HEAD -- .
" ```
"
" - Upload to http://www.vim.org/scripts/script.php?script_id=5215
"
" # Authors
"
" Loupe is written and maintained by Greg Hurrell <greg@hurrell.net>.
"
" The original idea for the |g:LoupeHighlightGroup| feature was taken from
" Damian Conway's Vim set-up:
"
" - https://github.com/thoughtstream/Damian-Conway-s-Vim-Setup/blob/master/plugin/hlnext.vim
"
" Which he discussed in his "More Instantly Better Vim" presentation at OSCON
" 2013:
"
" - https://www.youtube.com/watch?v=aHm36-na4-4
"
" # History
"
" ## main (not yet released)
"
" - Add |g:LoupeCaseSettingsAlways| to make Vim respect |'ignorecase'| and
"   |'smartcase'| settings while using |star|, |gstar|, |#| and |g#|.
" - Ensure that |g:LoupeVeryMagic| takes effect with longer-forms of the
"   |:global|, |:substitute| and |:vglobal| commands.
" - Treat `:g!` as equivalent to `:v`
"   (https://github.com/wincent/loupe/issues/20).
"
" ## 1.2.2 (7 August 2018)
"
" - Fix error-handling to work regardless of |'iskeyword'| setting
"   (https://github.com/wincent/loupe/pull/14).
"
" ## 1.2.1 (13 July 2016)
"
" - Match default Vim behavior of opening folds when jumping to a match.
"
" ## 1.2 (27 June 2016)
"
" - Suppress unwanted cursor movement after |<Plug>(LoupeClearHighlight)| and
"   when using |:nohighlight|.
" - Expose |loupe#hlmatch()| (previously was a private function) for users who
"   wish to do low-level intergration with other plug-ins.
" - Provide |<Plug>| mappings for |star|, |#|, |n|, |N|, |gstar|, |g#|
"   (see |<Plug>(LoupeStar)|, |<Plug>(LoupeOctothorpe)|, |<Plug>(Loupen)|,
"   |<Plug>(LoupeN)|, |<Plug>(LoupeGStar)|, |<Plug>(LoupeGOctothorpe)|).
"
" ## 1.1 (15 June 2016)
"
" - Make compatible with older versions of Vim that do not have |v:hlsearch|.
" - Add support for special delimiters with |:substitute| command.
"
" ## 1.0 (28 December 2015)
"
" - Renamed the |<Plug>LoupeClearHighlight| mapping to
"   |<Plug>(LoupeClearHighlight)|.
"
" ## 0.1 (5 July 2015)
"
" - Initial release, extracted from my dotfiles
"   (https://github.com/wincent/wincent).

""
" @option g:LoupeLoaded any
"
" To prevent Loupe from being loaded, set |g:LoupeLoaded| to any value in your
" |.vimrc|. For example:
"
" ```
" let g:LoupeLoaded=1
" ```
if exists('g:LoupeLoaded') || &compatible || v:version < 700
  finish
endif
let g:LoupeLoaded=1

" Temporarily set 'cpoptions' to Vim default as per `:h use-cpo-save`.
let s:cpoptions=&cpoptions
set cpoptions&vim

" Reasonable defaults for search-related settings.
if &history < 1000
  set history=1000 " Longer search and command history (default is 50).
endif
if has('extra_search')
  set hlsearch   " Highlight search strings.
  set incsearch  " Incremental search ("find as you type").
endif
set ignorecase   " Ignore case when searching.
set shortmess+=s " Don't echo search wrap messages.
set smartcase    " Case-sensitive search if search string includes a capital letter.

""
" @option g:LoupeClearHighlightMap boolean 1
"
" Controls whether to set up the |<Plug>(LoupeClearHighlight)| mapping. To
"  prevent any mapping from being configured, set to 0:
"
" ```
" let g:LoupeClearHighlightMap=0
" ```
let s:clear=get(g:, 'LoupeClearHighlightMap', 1)
if s:clear
  if !hasmapto('<Plug>(LoupeClearHighlight)') && maparg('<leader>n', 'n') ==# ''
    nmap <silent> <unique> <leader>n <Plug>(LoupeClearHighlight)
  endif
endif

""
" @mapping <Plug>(LoupeClearHighlight)
"
" Loupe maps <leader>n to |<Plug>(LoupeClearHighlight)|, which clears all
" visible highlights (like |:nohighlight| does). To use an alternative mapping
" instead, create a different one in your |.vimrc| instead using |:nmap|:
"
" ```
" " Instead of <leader>n, use <leader>x.
" nmap <leader>x <Plug>(LoupeClearHighlight)
" ```
"
" Note that Loupe will not try to set up its <leader>n mapping if any of the
" following are true:
"
" - A mapping for <leader>n already exists.
" - An alternative mapping for |<Plug>(LoupeClearHighlight)| has already been set
"   up from a |.vimrc|.
" - The mapping has been suppressed by setting |g:LoupeClearHighlightMap| to 1
"   in your |.vimrc|.
nnoremap <silent> <Plug>(LoupeClearHighlight)
      \ :nohlsearch<bar>
      \ call loupe#private#clear_highlight()<CR>

function! s:Nohlsearch(command)
  if getcmdtype() == ':' && getcmdpos() == len(a:command) + 1
    call loupe#private#clear_highlight()
    return a:command
  else
    return a:command
  endif
endfunction

" Make `:nohlsearch` behave like <Plug>(LoupeClearHighlight).
cnoreabbrev <expr> noh <SID>Nohlsearch('noh')
cnoreabbrev <expr> nohl <SID>Nohlsearch('nohl')
cnoreabbrev <expr> nohls <SID>Nohlsearch('nohls')
cnoreabbrev <expr> nohlse <SID>Nohlsearch('nohlse')
cnoreabbrev <expr> nohlsea <SID>Nohlsearch('nohlsea')
cnoreabbrev <expr> nohlsear <SID>Nohlsearch('nohlsear')
cnoreabbrev <expr> nohlsearc <SID>Nohlsearch('nohlsearc')
cnoreabbrev <expr> nohlsearch <SID>Nohlsearch('nohlsearch')

""
" @option g:LoupeVeryMagic boolean 1
"
" Controls whether "very magic" pattern syntax (|/\v|) is applied by default.
" To disable, set to 0:
"
" ```
" let g:LoupeVeryMagic=0
" ```
function s:MagicString()
  let s:magic=get(g:, 'LoupeVeryMagic', 1)
  return s:magic ? '\v' : ''
endfunction

nnoremap <expr> / loupe#private#prepare_highlight('/' . <SID>MagicString())
nnoremap <expr> ? loupe#private#prepare_highlight('?' . <SID>MagicString())
xnoremap <expr> / loupe#private#prepare_highlight('/' . <SID>MagicString())
xnoremap <expr> ? loupe#private#prepare_highlight('?' . <SID>MagicString())
if !empty(s:MagicString())
  " Any single-byte character may be used as a delimiter except \, ", | and
  " alphanumerics. See `:h E146`.
  cnoremap <expr> ! loupe#private#very_magic_slash('!')
  cnoremap <expr> # loupe#private#very_magic_slash('#')
  cnoremap <expr> $ loupe#private#very_magic_slash('$')
  cnoremap <expr> % loupe#private#very_magic_slash('%')
  cnoremap <expr> & loupe#private#very_magic_slash('&')
  cnoremap <expr> ' loupe#private#very_magic_slash("'")
  cnoremap <expr> ( loupe#private#very_magic_slash('(')
  cnoremap <expr> ) loupe#private#very_magic_slash(')')
  cnoremap <expr> * loupe#private#very_magic_slash('*')
  cnoremap <expr> + loupe#private#very_magic_slash('+')
  cnoremap <expr> , loupe#private#very_magic_slash(',')
  cnoremap <expr> - loupe#private#very_magic_slash('-')
  cnoremap <expr> . loupe#private#very_magic_slash('.')
  cnoremap <expr> / loupe#private#very_magic_slash('/')
  cnoremap <expr> : loupe#private#very_magic_slash(':')
  cnoremap <expr> ; loupe#private#very_magic_slash(';')
  cnoremap <expr> < loupe#private#very_magic_slash('<')
  cnoremap <expr> = loupe#private#very_magic_slash('=')
  cnoremap <expr> > loupe#private#very_magic_slash('>')
  cnoremap <expr> ? loupe#private#very_magic_slash('?')
  cnoremap <expr> @ loupe#private#very_magic_slash('@')
  cnoremap <expr> [ loupe#private#very_magic_slash('[')
  cnoremap <expr> ] loupe#private#very_magic_slash(']')
  cnoremap <expr> ^ loupe#private#very_magic_slash('^')
  cnoremap <expr> _ loupe#private#very_magic_slash('_')
  cnoremap <expr> ` loupe#private#very_magic_slash('`')
  cnoremap <expr> { loupe#private#very_magic_slash('{')
  cnoremap <expr> } loupe#private#very_magic_slash('}')
  cnoremap <expr> ~ loupe#private#very_magic_slash('~')
endif

function! s:map(keys, name)
  ""
  " @option g:LoupeCenterResults boolean 1
  "
  " Controls whether the match's line is vertically centered within the window
  " when jumping (via |n|, |N| etc). To disable, set to 0:
  "
  " ```
  " let g:LoupeCenterResults=0
  " ```
  let l:center=get(g:, 'LoupeCenterResults', 1)
  let l:center_string=l:center ? 'zz' : ''

  ""
  " @option g:LoupeCaseSettingsAlways boolean 1
  "
  " Normally Vim will respect your |'smartcase'| and |'ignorecase'| settings
  " when searching with |/|, or |?|, but it ignores them when using |star|, |#|,
  " |gstar| or |g#|.
  "
  " This setting forces Vim to respect your |'smartcase'| and |'ignorecase'|
  " settings in all cases. To disable, set to 0:
  "
  " ```
  " let g:LoupeCaseSettingsAlways=0
  " ```
  let l:case=get(g:, 'LoupeCaseSettingsAlways', 1)

  if a:keys ==# '#'
    let l:action=l:case ? ":let @/='\\V\\<'.loupe#private#escape(expand('<cword>')).'\\>'<CR>:let v:searchforward=0<CR>n" : '#'
  elseif a:keys ==# '*'
    let l:action=l:case ? ":let @/='\\V\\<'.loupe#private#escape(expand('<cword>')).'\\>'<CR>:let v:searchforward=1<CR>n" : '*'
  elseif a:keys ==# 'N'
    let l:action='N'
  elseif a:keys ==# 'g#'
    let l:action=l:case ? ":let @/='\\V'.loupe#private#escape(expand('<cword>'))<CR>:let v:searchforward=0<CR>n" : 'g#'
  elseif a:keys ==# 'g*'
    let l:action=l:case ? ":let @/='\\V'.loupe#private#escape(expand('<cword>'))<CR>:let v:searchforward=1<CR>n" : 'g*'
  elseif a:keys ==# 'n'
    let l:action='n'
  endif

  if !hasmapto('<Plug>(Loupe' . a:name . ')')
    execute 'nmap <silent> ' . a:keys . ' <Plug>(Loupe' . a:name . ')'
  endif
  execute 'nnoremap <silent> <Plug>(Loupe' . a:name . ')' .
        \ ' ' .
        \ l:action .
        \ 'zv' .
        \ l:center_string .
        \ ':call loupe#hlmatch()<CR>'
endfunction

""
" @mapping <Plug>(LoupeOctothorpe)
"
" Loupe maps |#| to |<Plug>(LoupeOctothorpe)| in order to implement custom
" highlighting and line-centering for the current match.
"
" To prevent this from happening, create an alternate mapping in your |.vimrc|:
"
" ```
" nmap <Nop> <Plug>(LoupeOctothorpe)
" ```
call s:map('#', 'Octothorpe')

""
" @mapping <Plug>(LoupeStar)
"
" Loupe maps |star| to |<Plug>(LoupeStar)| in order to implement custom
" highlighting and line-centering for the current match.
"
" To prevent this from happening, create an alternate mapping in your |.vimrc|:
"
" ```
" nmap <Nop> <Plug>(LoupeStar)
" ```
call s:map('*', 'Star')

""
" @mapping <Plug>(LoupeN)
"
" Loupe maps |N| to |<Plug>(LoupeN)| in order to implement custom
" highlighting and line-centering for the current match.
"
" To prevent this from happening, create an alternate mapping in your |.vimrc|:
"
" ```
" nmap <Nop> <Plug>(LoupeN)
" ```
call s:map('N', 'N')

""
" @mapping <Plug>(LoupeGOctothorpe)
"
" Loupe maps |g#| to |<Plug>(LoupeGOctothorpe)| in order to implement custom
" highlighting and line-centering for the current match.
"
" To prevent this from happening, create an alternate mapping in your |.vimrc|:
"
" ```
" nmap <Nop> <Plug>(LoupeGOctothorpe)
" ```
call s:map('g#', 'GOctothorpe')

""
" @mapping <Plug>(LoupeGStar)
"
" Loupe maps |gstar| to |<Plug>(LoupeGStar)| in order to implement custom
" highlighting and line-centering for the current match.
"
" To prevent this from happening, create an alternate mapping in your |.vimrc|:
"
" ```
" nmap <Nop> <Plug>(LoupeGStar)
" ```
call s:map('g*', 'GStar')

""
" @mapping <Plug>(Loupen)
"
" Loupe maps |n| to |<Plug>(Loupen)| in order to implement custom
" highlighting and line-centering for the current match.
"
" To prevent this from happening, create an alternate mapping in your |.vimrc|:
"
" ```
" nmap <Nop> <Plug>(Loupen)
" ```
call s:map('n', 'n')

" Clean-up stray `matchadd()` vestiges.
if has('autocmd') && has('extra_search')
  augroup LoupeCleanUp
    autocmd!
    autocmd WinEnter * :call loupe#private#cleanup()
  augroup END
endif

" Restore 'cpoptions' to its former value.
let &cpoptions=s:cpoptions
unlet s:cpoptions
