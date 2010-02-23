set nocompatible                  " just in case system-wide vimrc has set this otherwise
set hlsearch                      " highlight search strings
set incsearch                     " incremental search ("find as you type")
set ignorecase                    " ignore case when searching
set smartcase                     " except when search string includes a capital letter
set number                        " show line numbers in gutter
set laststatus=2                  " always show status line
set ww=h,l,<,>,[,]                " allow h/l/left/right to cross line boundaries
set autoread                      " if not changed in Vim, automatically pick up changes after "git co" etc
set guioptions-=T                 " don't show toolbar
set guifont=Monaco:h10            " the best programming font, Monaco 10
set hidden                        " allows you to hide buffers with unsaved changes without being prompted
set wildmenu                      " show options as list when switching buffers etc
set wildmode=longest:full,full    " shell-like autocomplete to unambiguous portion
set history=1000                  " longer search and command history (default is 20)
set scrolloff=3                   " start scrolling 3 lines before edge of viewport
set sidescrolloff=3               " same, but for columns
set backupdir=~/.vim/tmp/backup,. " keep backup files out of the way
set directory=~/.vim/tmp/swap,.   " keep swap files out of the way
set ttimeoutlen=50                " speed up O etc in the Terminal
set virtualedit=block             " allow cursor to move where there is no text in visual block mode
set showmatch                     " show matching brackets
set showcmd                       " extra info in command line
set nojoinspaces                  " don't autoinsert two spaces after '.', '?', '!' for join command
set wildignore+=*.o               " don't offer to autocomplete object files

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
set tabstop=2                     " spaces per tab
set expandtab                     " always use spaces instead of tabs
set smarttab                      " <tab>
set list                          " show whitespace
set listchars=nbsp:¬,eol:¶,tab:>-,extends:»,precedes:«,trail:•
set autoindent

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

" automatic, language-dependent indentation, syntax coloring and other
" functionality
filetype indent plugin on
syntax on

color wincent       " modified version of default MacVim scheme (light yellow background)

let mapleader=","

" XP Template: default mapping of <C-\> doesn't work on most European keyboards
let g:xptemplate_key='<F5>'

" a.vim
let g:alternateExtensions_m = "h"
let g:alternateExtensions_h = "m,c,mm,cpp,cxx,cc,CC"

" http://vim.wikia.com/wiki/Detect_window_creation_with_WinEnter
autocmd VimEnter * autocmd WinEnter * let w:created=1
autocmd VimEnter * let w:created=1

" http://vim.wikia.com/wiki/Highlight_text_beyond_80_columns
let w:m1=matchadd('LineProximity',  '\%<81v.\%>75v', -1)  " for first window at launch
let w:m2=matchadd('LineOverflow',   '\%<133v.\%>80v', -1) " for first window at launch
let w:m2=matchadd('LineHardLimit',  '\%>132v.\+', -1)     " for first window at launch

" for all other windows
autocmd WinEnter * if !exists('w:created') | let w:m1=matchadd('LineProximity', '\%<81v.\%>75v', -1) | endif
autocmd WinEnter * if !exists('w:created') | let w:m2=matchadd('LineOverflow',  '\%<133v.\%>80v', -1) | endif
autocmd WinEnter * if !exists('w:created') | let w:m2=matchadd('LineHardLimit', '\%>132v.\+', -1) | endif

" see changes made to current buffer since file was loaded
" (from vimrc example file)
" to get out of diff mode do :diffoff!
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" ,e -- edit file, starting in same directory as current file
map <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" emulate Command-T in TextMate
map <silent> <leader>t :FufFile<CR>
map <silent> <leader>b :FufBuffer<CR>

" set up :Ack command as replacement for :grep
function! AckGrep(command)
  cexpr system("ack " . a:command)
  cw " show quickfix window already
endfunction
command! -nargs=+ -complete=file Ack call AckGrep(<q-args>)
map <leader>a :Ack<space>

function! RunSpec(command)
  if a:command == ''
    let dir = 'spec'
  else
    let dir = a:command
  endif
  cexpr system("spec -r spec/vim_formatter.rb -f Spec::Runner::Formatter::VimFormatter " . dir)"a:command)
  cw
endfunction
command! -nargs=? -complete=file Spec call RunSpec(<q-args>)
map <leader>s :Spec<space>

source $VIMRUNTIME/macros/matchit.vim
