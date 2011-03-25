call pathogen#runtime_append_all_bundles()  " add .vim/bundle subdirs to runtime path
call pathogen#helptags()                    " wasteful, but no shortage of grunt available

set nocompatible                      " just in case system-wide vimrc has set this otherwise
set hlsearch                          " highlight search strings
set incsearch                         " incremental search ("find as you type")
set ignorecase                        " ignore case when searching
set smartcase                         " except when search string includes a capital letter
set number                            " show line numbers in gutter
set laststatus=2                      " always show status line
set ww=h,l,<,>,[,]                    " allow h/l/left/right to cross line boundaries
set autoread                          " if not changed in Vim, automatically pick up changes after "git co" etc
set guioptions-=T                     " don't show toolbar
set guifont=Consolas\ for\ BBEdit:h14 " the best programming font for old people, Consolas 18
set hidden                            " allows you to hide buffers with unsaved changes without being prompted
set wildmenu                          " show options as list when switching buffers etc
set wildmode=longest:full,full        " shell-like autocomplete to unambiguous portion
set history=1000                      " longer search and command history (default is 20)
set scrolloff=3                       " start scrolling 3 lines before edge of viewport
set sidescrolloff=3                   " same, but for columns
set backupdir=~/.vim/tmp/backup,.     " keep backup files out of the way
set directory=~/.vim/tmp/swap,.       " keep swap files out of the way
set ttimeoutlen=50                    " speed up O etc in the Terminal
set virtualedit=block                 " allow cursor to move where there is no text in visual block mode
set showmatch                         " show matching brackets
set showcmd                           " extra info in command line
set nojoinspaces                      " don't autoinsert two spaces after '.', '?', '!' for join command
set wildignore+=*.o,.git              " patterns to ignore during file-navigation
set foldmethod=indent
set foldlevelstart=1
set foldlevel=1

" statusline
" cf the default statusline: %<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" format markers:
"   %< truncation point
"   %n buffer number
"   %f relative path to file
"   %m modified flag [+] (modified), [-] (unmodifiable) or nothing
"   %r readonly flag [RO]
"   %y filetype [ruby]
"   %= split point for left and right justification
"   %-35. width specification
"   %l current line number
"   %L number of lines in buffer
"   %c current column number
"   %V current virtual column number (-n), if different from %c
"   %P percentage through buffer
"   %) end of width specification
set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)

" all languages
set shiftwidth=2                  " spaces per tab (when shifting)
set shiftround                    " always indent by multiple of shiftwidth
set tabstop=2                     " spaces per tab
set expandtab                     " always use spaces instead of tabs
set smarttab                      " <tab>
set list                          " show whitespace
set listchars=nbsp:¬,eol:¶,tab:>-,extends:»,precedes:«,trail:•
set autoindent

" Quickfix listing
autocmd BufReadPost quickfix setlocal so=0 | setlocal nolist

" Conque
autocmd FileType conque_term setlocal nolist " suppress whitespace highlighting

" NERDTree
autocmd FileType nerdtree setlocal nolist " suppress whitespace highlighting

" Ruby
autocmd FileType ruby set smartindent
autocmd FileType ruby set tabstop=2
autocmd FileType ruby set shiftwidth=2
autocmd FileType ruby call HighlightLongLines(0, 0, 0)

" C
autocmd FileType c set tabstop=4
autocmd FileType c set shiftwidth=4

" Objective-C
let filetype_m='objc'
autocmd FileType objc set tabstop=4
autocmd FileType objc set shiftwidth=4

" RSpec
autocmd BufNewFile,BufRead *_spec.rb set ft=ruby.spec

" automatic, language-dependent indentation, syntax coloring and other
" functionality
filetype indent plugin on
syntax on

color wincent       " modified version of default MacVim scheme (light yellow background)

let mapleader=","

" a.vim
let g:alternateExtensions_m = "h"
let g:alternateExtensions_h = "m,c,mm,cpp,cxx,cc,CC"

" minibufexpl.vim
let g:miniBufExplMapCTabSwitchBufs = 1
autocmd BufEnter -MiniBufExplorer- setlocal nolist " suppress whitespace highlighting

" http://vim.wikia.com/wiki/Detect_window_creation_with_WinEnter
autocmd VimEnter * autocmd WinEnter * let w:created=1
autocmd VimEnter * let w:created=1

function! HighlightLongLines(proximity, overflow, hardlimit)
  let proximity = a:proximity == 0 ? 75 : a:proximity
  let overflow  = a:overflow == 0  ? 80 : a:overflow
  let hardlimit = a:hardlimit == 0 ? 132 : a:hardlimit
  let proximity_highlight =
        \'\%<' .
        \ string(overflow) .
        \ 'v.\%>' .
        \ string(proximity) .
        \ 'v'
  let overflow_highlight =
        \ '\%<' .
        \ string(hardlimit) .
        \ 'v.\%>' .
        \ string(overflow) .
        \ 'v'
  let hardlimit_highlight =
        \ '\%>' .
        \ string(hardlimit) .
        \ 'v.\+'
  let w:m1=matchadd('LineProximity',  proximity_highlight, -1)
  let w:m2=matchadd('LineOverflow',   overflow_highlight, -1)
  let w:m3=matchadd('LineHardLimit',  hardlimit_highlight, -1)
endfunction

" see changes made to current buffer since file was loaded
" (from vimrc example file)
" to get out of diff mode do :diffoff!
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" ,e -- edit file, starting in same directory as current file
map <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" FuzzyFinder
map <silent> <leader>b :FufBuffer<CR>

" Command-T
let g:CommandTMaxHeight = 10

" set up :Ack command as replacement for :grep
function! AckGrep(command)
  cexpr system("ack " . a:command)
  cw " show quickfix window already
endfunction
command! -nargs=+ -complete=file Ack call AckGrep(<q-args>)
map <leader>a :Ack<space>

" :Term to bring up Conque (:Terms to bring up in a new split)
function! s:Term()
  execute 'ConqueTerm bash'
endfunction
command! Term call s:Term()

function! s:Terms()
  execute 'ConqueTermSplit bash'
endfunction
command! Terms call s:Terms()

" delete all buffers, except for those with unsaved changes
map <leader>bda :bufdo silent! bdelete<CR>

function! RunSpec(command)
  if a:command == ''
    let dir = 'spec'
  else
    let dir = a:command
  endif
  cexpr system("bin/rspec -r spec/support/vim_formatter.rb -f RSpec::Core::Formatters::VimFormatter " . dir)"a:command)
  cw
endfunction
command! -nargs=? -complete=file Spec call RunSpec(<q-args>)
map <leader>s :Spec<space>

" functions for moving lines up or down within buffer
" based on:
"   http://stackoverflow.com/questions/741814/move-entire-line-up-and-down-in-vim
function! SwapLines(l1, l2)
  let current = getline(a:l1)
  let other   = getline(a:l2)
  call setline(a:l1, other)
  call setline(a:l2, current)
  exec a:l2
endfunction

function! SwapWithPrevious()
  let n = line('.')
  if n == 1
    return
  endif
  call SwapLines(n, n - 1)
endfunction

function! SwapWithNext()
  let n = line('.')
  if n == line('$')
    return
  endif
  call SwapLines(n, n + 1)
endfunction

" multi-mode mappings (Normal, Visual, Operating-pending modes)
noremap Y y$

" Command mode mappings
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" Normal mode mappings
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <silent> <leader>j :call SwapWithNext()<CR>
nnoremap <silent> <leader>k :call SwapWithPrevious()<CR>

source $VIMRUNTIME/macros/matchit.vim
