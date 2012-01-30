call pathogen#runtime_append_all_bundles()  " add .vim/bundle subdirs to runtime path
call pathogen#helptags()                    " wasteful, but no shortage of grunt available

set nocompatible                      " just in case system-wide vimrc has set this otherwise
set backspace=indent,start,eol        " allow unrestricted backspacing in insert mode
set hlsearch                          " highlight search strings
set incsearch                         " incremental search ("find as you type")
set ignorecase                        " ignore case when searching
set smartcase                         " except when search string includes a capital letter
set number                            " show line numbers in gutter
set laststatus=2                      " always show status line
set ww=h,l,<,>,[,]                    " allow h/l/left/right to cross line boundaries
set autoread                          " if not changed in Vim, automatically pick up changes after "git co" etc
set guioptions-=T                     " don't show toolbar
set guifont=Monaco:h12
set hidden                            " allows you to hide buffers with unsaved changes without being prompted
set wildmenu                          " show options as list when switching buffers etc
set wildmode=longest:full,full        " shell-like autocomplete to unambiguous portion
set history=1000                      " longer search and command history (default is 20)
set scrolloff=3                       " start scrolling 3 lines before edge of viewport
set sidescrolloff=3                   " same, but for columns
set backupdir=~/.vim/tmp/backup,.     " keep backup files out of the way
set directory=~/.vim/tmp/swap,.       " keep swap files out of the way

if has('persistent_undo')
  set undodir=~/.vim/tmp/undo,.       " keep undo files out of the way
  set undofile                        " actually use undo files
endif

set ttimeoutlen=50                    " speed up O etc in the Terminal
set virtualedit=block                 " allow cursor to move where there is no text in visual block mode
set cursorline                        " highlight current line
set showmatch                         " show matching brackets
set showcmd                           " extra info in command line
set nojoinspaces                      " don't autoinsert two spaces after '.', '?', '!' for join command
set wildignore+=*.o,.git              " patterns to ignore during file-navigation
set shortmess+=A                      " ignore annoying swapfile messages
set foldmethod=indent                 " not as cool as syntax, but faster
set foldlevelstart=1                  " start with some but not all folds closed
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
set textwidth=80
if has('colorcolumn')
  set cc=+0
endif

" Quickfix listing
autocmd BufReadPost quickfix setlocal so=0 | setlocal nolist

" Git commit messages
autocmd FileType gitcommit setlocal textwidth=72

" Conque
autocmd FileType conque_term setlocal nolist " suppress whitespace highlighting
autocmd FileType conque_term setlocal textwidth=0

" NERDTree
autocmd FileType nerdtree setlocal nolist " suppress whitespace highlighting

" Ruby
autocmd FileType ruby set smartindent
autocmd FileType ruby set tabstop=2
autocmd FileType ruby set shiftwidth=2

" C
autocmd FileType c set tabstop=4
autocmd FileType c set shiftwidth=4

" Objective-C
let filetype_m='objc'
autocmd FileType objc set tabstop=4
autocmd FileType objc set shiftwidth=4

" Prolog
let filetype_pl='prolog'
autocmd FileType prolog set tabstop=2
autocmd FileType prolog set shiftwidth=2

" RSpec
autocmd BufNewFile,BufRead *_spec.rb set ft=ruby.spec

" automatic, language-dependent indentation, syntax coloring and other
" functionality
filetype indent plugin on
syntax on

" colorscheme
if filereadable(expand("~/.vim/dark"))
  set background=dark
  color elflord
else
  set background=light
  let g:solarized_visibility='low'
  color solarized
endif

if has('mouse')
  set mouse=a
  if &term =~ "screen" || &term =~ "xterm"
    " for some reason, doing this directly with 'set ttymouse=xterm2'
    " doesn't work -- 'set ttymouse?' returns xterm2 but the mouse
    " makes tmux enter copy mode instead of selecting or scrolling
    " inside Vim -- but luckily, setting it up from within the VimEnter
    " autocmd works
    autocmd VimEnter * set ttymouse=xterm2
    autocmd FocusGained * set ttymouse=xterm2
    autocmd BufEnter * set ttymouse=xterm2
  endif
endif

" a.vim
let g:alternateExtensions_m = "h"
let g:alternateExtensions_h = "m,c,mm,cpp,cxx,cc,CC"

" http://vim.wikia.com/wiki/Detect_window_creation_with_WinEnter
autocmd VimEnter * autocmd WinEnter * let w:created=1
autocmd VimEnter * let w:created=1

" see changes made to current buffer since file was loaded
" (from vimrc example file)
" to get out of diff mode do :diffoff!
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif

" \e -- edit file, starting in same directory as current file
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" \zz -- Zap trailing whitespace in the current buffer.
"
"        As this one is somewhat destructive and relatively close to the
"        oft-used <leader>a mapping, make this one a double key-stroke.
"
nnoremap <silent> <leader>zz :let _last_search=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_last_search <Bar> :noh<CR>

" Command-T
let g:CommandTMatchWindowReverse   = 1
let g:CommandTMaxHeight            = 10
let g:CommandTMaxFiles             = 30000
let g:CommandTMaxCachedDirectories = 10
let g:CommandTScanDotDirectories   = 1
nnoremap <leader>f :CommandTFlush<CR>
nnoremap <silent> <leader>j :CommandTJump<CR>
if &term =~ "screen" || &term =~ "xterm"
  let g:CommandTCancelMap     = ['<ESC>', '<C-c>']
  let g:CommandTSelectNextMap = ['<C-n>', '<C-j>', '<ESC>OB']
  let g:CommandTSelectPrevMap = ['<C-p>', '<C-k>', '<ESC>OA']
endif

" prevent Align.vim from defining a bunch of maps starting with <leader>t
" and introducing an annoying delay when opening Command-T
let g:loaded_AlignMapsPlugin = "v41"

" Gundo
nnoremap <silent> <leader>u :GundoToggle<CR>

" set up :Ack command as replacement for :grep
function! AckGrep(command)
  cexpr system("ack " . a:command)
  cw " show quickfix window already
endfunction
command! -nargs=+ -complete=file Ack call AckGrep(<q-args>)
nnoremap <leader>a :Ack<space>

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
nnoremap <leader>da :bufdo silent! bdelete<CR>

command W w !sudo tee % > /dev/null

function! s:ToggleVisibility()
  if g:solarized_visibility != 'high'
    let g:solarized_visibility = 'high'
  else
    let g:solarized_visibility = 'low'
  endif
  color solarized
endfunction

" mnemonic: [w]hitespace
nnoremap <leader>w :call <SID>ToggleVisibility()<CR>

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
nnoremap <C-kPlus> <C-w>+
nnoremap <C-kMinus> <C-w>-

source $VIMRUNTIME/macros/matchit.vim
