runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()                " add .vim/bundle subdirs to runtime path
call pathogen#helptags()              " wasteful, but no shortage of grunt available

set nocompatible                      " just in case system-wide vimrc has set this otherwise
set autoread                          " if not changed in Vim, automatically pick up changes after "git co" etc
set backspace=indent,start,eol        " allow unrestricted backspacing in insert mode
set backupdir=~/.vim/tmp/backup,.     " keep backup files out of the way
set cursorline                        " highlight current line
set directory=~/.vim/tmp/swap,.       " keep swap files out of the way
if has('folding')
  set foldlevelstart=1                " start with some but not all folds closed
  set foldmethod=indent               " not as cool as syntax, but faster
endif
set formatoptions+=n                  " smart auto-indenting inside numbered lists
set guifont=Consolas:h13
set guioptions-=T                     " don't show toolbar
set hidden                            " allows you to hide buffers with unsaved changes without being prompted
set history=1000                      " longer search and command history (default is 20)
set hlsearch                          " highlight search strings
set ignorecase                        " ignore case when searching
set incsearch                         " incremental search ("find as you type")
set laststatus=2                      " always show status line
set nojoinspaces                      " don't autoinsert two spaces after '.', '?', '!' for join command
set noshowmatch                       " don't jump between matching brackets
set scrolloff=3                       " start scrolling 3 lines before edge of viewport
set shortmess+=A                      " ignore annoying swapfile messages
set shortmess+=I                      " no splash screen
if has('showcmd')
  set showcmd                         " extra info at end of command line
endif
set sidescrolloff=3                   " same, but for columns
set smartcase                         " except when search string includes a capital letter
set ttimeoutlen=50                    " speed up O etc in the Terminal
set virtualedit=block                 " allow cursor to move where there is no text in visual block mode
set wildignore+=*.o,.git              " patterns to ignore during file-navigation
set wildmenu                          " show options as list when switching buffers etc
set wildmode=longest:full,full        " shell-like autocomplete to unambiguous portion
set whichwrap=b,h,l,s,<,>,[,],~       " allow <BS>/h/l/<Left>/<Right>/<Space>, ~ to cross line boundaries

if has('syntax')
  set spellfile=~/.vim/.spellfile.utf-8.add
endif

if has('persistent_undo')
  set undodir=~/.vim/tmp/undo,.       " keep undo files out of the way
  set undofile                        " actually use undo files
endif

if exists('+cursorcolumn')
  " disable for now due to performance issues
  "set cursorcolumn                   " highlight current column
endif

if has('statusline')
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
endif

if exists('+relativenumber')
  set relativenumber " show relative numbers in gutter

  " cycle through number, relativenumber and no numbering
  nnoremap <leader>r :set <c-r>={ '00': 'r', '01': 'no', '10': ''}[&rnu . &nu]<CR>nu<CR>
else
  set number " show line numbers in gutter

  " toggle line numbers on and off
  nnoremap <leader>r :set nu!<cr>
endif

" change shape of cursor in insert mode in iTerm 2
let s:iterm = exists('$ITERM_PROFILE')
let s:tmux = exists('$TMUX')

if s:iterm
  if s:tmux
    " in theory this should work -- see https://gist.github.com/1195581 -- but
    " it corrupts the screen when doing r<ESC> (leaves visible ^]r on the right)
    "let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    "let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

    " this works with a hack to the ~/.tmux.conf file
    let &t_SI = "\<Esc>[3 q"
    let &t_EI = "\<Esc>[0 q"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
endif

" defaults for all languages
set shiftwidth=2                  " spaces per tab (when shifting)
set shiftround                    " always indent by multiple of shiftwidth
set tabstop=2                     " spaces per tab
set expandtab                     " always use spaces instead of tabs
set smarttab                      " <tab>/<BS> indent/dedent in leading whitespace
set list                          " show whitespace
set listchars=nbsp:¬,eol:¶,tab:>-,extends:»,precedes:«,trail:•
set autoindent                    " maintain indent of current line
set textwidth=80                  " automatically hard wrap at 80 columns
if exists('+colorcolumn')
  set cc=+0
endif

" C
autocmd FileType c set shiftwidth=4 | set tabstop=4

" Git commit messages
autocmd FileType gitcommit setlocal textwidth=72

" Go
autocmd FileType go set shiftwidth=4 | set tabstop=4 | set noexpandtab

" Jasmine
autocmd BufNewFile,BufRead *_spec.js set ft=javascript.jasmine

" NERDTree
autocmd FileType nerdtree setlocal nocursorcolumn | setlocal nolist
if has('folding')
  autocmd FileType nerdtree setlocal nofoldenable
endif

" Objective-C
let filetype_m='objc'
autocmd FileType objc set shiftwidth=4 | set tabstop=4

" Prolog
let filetype_pl='prolog'
autocmd FileType prolog set shiftwidth=2 | set tabstop=2

" Quickfix listing
autocmd BufReadPost quickfix
      \ setlocal nocursorcolumn |
      \ setlocal nolist |
      \ setlocal number |
      \ setlocal so=0

" RSpec
autocmd BufNewFile,BufRead *_spec.rb set ft=ruby.spec

" Ruby
autocmd FileType ruby set shiftwidth=2 | set smartindent | set tabstop=2

" automatic, language-dependent indentation, syntax coloring and other
" functionality
filetype indent plugin on
syntax on

" colorscheme
if filereadable(expand("~/.vim/dark"))
  set background=dark
else
  set background=light
endif

let g:solarized_visibility='low'
color solarized
set t_Co=16

" this override won't survive a roundtrip to background=dark (where the paren
" highlighting is mostly ok as-is) and back, but it's still a win for the
" common case
highlight MatchParen ctermbg=7 ctermfg=11 cterm=underline term=underline

if has('mouse')
  set mouse=a
  if &term =~ "screen" || &term =~ "xterm"
    " for some reason, doing this directly with 'set ttymouse=xterm2'
    " doesn't work -- 'set ttymouse?' returns xterm2 but the mouse
    " makes tmux enter copy mode instead of selecting or scrolling
    " inside Vim -- but luckily, setting it up from within the VimEnter
    " autocmd works
    autocmd BufEnter,FocusGained,VimEnter * set ttymouse=xterm2
  endif
endif

" make use of Xterm "bracketed paste mode"
" http://www.xfree86.org/current/ctlseqs.html#Bracketed%20Paste%20Mode
" http://stackoverflow.com/questions/5585129
if &term =~ "screen" || &term =~ "xterm"
  function! s:BeginXTermPaste(ret)
    set paste
    return a:ret
  endfunction

  " enable bracketed paste mode on entering Vim
  let &t_ti .= "\e[?2004h"

  " disable bracketed paste mode on leaving Vim
  let &t_te = "\e[?2004l" . &t_te

  set pastetoggle=<Esc>[201~
  inoremap <expr> <Esc>[200~ <SID>BeginXTermPaste("")
  nnoremap <expr> <Esc>[200~ <SID>BeginXTermPaste("i")
  vnoremap <expr> <Esc>[200~ <SID>BeginXTermPaste("c")
  cnoremap <Esc>[200~ <nop>
  cnoremap <Esc>[201~ <nop>
endif

" a.vim
let g:alternateExtensions_m = "h"
let g:alternateExtensions_h = "m,c,mm,cpp,cxx,cc,CC"

" http://vim.wikia.com/wiki/Detect_window_creation_with_WinEnter
autocmd VimEnter * autocmd WinEnter * let w:created=1
autocmd VimEnter * let w:created=1

if has('folding')
  " like the autocmd described in `:h last-position-jump` but we add `:foldopen!`
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
else
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | exe "silent! foldopen!" | endif
endif

" except for Git commit messages, where this gets old really fast
autocmd BufReadPost COMMIT_EDITMSG exec "normal! gg" |
  \ setlocal spell

" disable paste mode on leaving insert mode
autocmd InsertLeave * set nopaste

" see changes made to current buffer since file was loaded
" (from vimrc example file)
" to get out of diff mode do :diffoff!
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif

" open last buffer
nnoremap <leader><leader> <C-^>

" \e -- edit file, starting in same directory as current file
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" \zz -- Zap trailing whitespace in the current buffer.
"
"        As this one is somewhat destructive and relatively close to the
"        oft-used <leader>a mapping, make this one a double key-stroke.
"
nnoremap <silent> <leader>zz :let _last_search=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_last_search <Bar> :noh<CR>

nnoremap <leader>n :set nocursorcolumn <bar> noh<CR>

" Command-T
let g:CommandTMatchWindowReverse   = 1
let g:CommandTMaxHeight            = 10
let g:CommandTMaxFiles             = 30000
let g:CommandTMaxCachedDirectories = 10
let g:CommandTScanDotDirectories   = 1
if has('jumplist')
  nnoremap <silent> <leader>j :CommandTJump<CR>
endif
nnoremap <leader>g :CommandTTag<CR>
if &term =~ "screen" || &term =~ "xterm"
  let g:CommandTCancelMap     = ['<ESC>', '<C-c>']
  let g:CommandTSelectNextMap = ['<C-j>', '<ESC>OB']
  let g:CommandTSelectPrevMap = ['<C-k>', '<ESC>OA']
endif

" Gundo
nnoremap <silent> <leader>u :GundoToggle<CR>

set grepprg=ack\ --column
set grepformat=%f:%l:%c:%m
autocmd QuickFixCmdPost [^l]* nested cw
autocmd QuickFixCmdPost l* nested lw

function! AckGrep(command)
  cexpr system("ack --column " . a:command)
  cw
endfunction

function! LackGrep(command)
  lexpr system("ack --column " . a:command)
  lw
endfunction

command! -nargs=+ -complete=file Ack call AckGrep(<q-args>)
nnoremap <leader>a :Ack<space>
command! -nargs=+ -complete=file Lack call LackGrep(<q-args>)
nnoremap <leader>l :Lack<space>

" call :Ack with word currently under cursor (mnemonic: selection)
nnoremap <leader>s :Ack <C-r><C-w><CR>

" populate the :args list with the filenames currently in the quickfix window
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

function! GitJump(command)
  cexpr system("git jump " . a:command)
  cw
endfunction

command! -nargs=+ -complete=file GitJump call GitJump(<q-args>)
nnoremap <leader>d :GitJump diff<space>

" Clipper
nnoremap <leader>y :call system('nc localhost 8377', @0)<CR>

" make Vim's regexen more Perl-like
" turn on cursorcolumn only temporarily here; it's a big performance hit, but
" really useful for disambiguating the current match
nnoremap / :silent! set cursorcolumn<CR>/\v
vnoremap / /\v

" delete all buffers, except for those with unsaved changes
nnoremap <leader>da :bufdo silent! bdelete<CR>

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

" Insert mode mappings
inoremap jj <Esc>

source $VIMRUNTIME/macros/matchit.vim

" After this file is sourced, plug-in code will be evaluated.
" See ~/.vim/after for files evaluated after that.
" See `:scriptnames` for a list of all scripts, in evaluation order.
" Launch Vim with `vim --startuptime vim.log` for profiling info.
