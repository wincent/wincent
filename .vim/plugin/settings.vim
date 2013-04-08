set autoindent                        " maintain indent of current line
set autoread                          " if not changed in Vim, automatically pick up changes after "git checkout" etc
set backspace=indent,start,eol        " allow unrestricted backspacing in insert mode
set backupdir=~/.vim/tmp/backup,.     " keep backup files out of the way

if exists('+colorcolumn')
  set colorcolumn=+0
endif

if exists('+cursorcolumn')
  " disable for now due to performance issues
  "set cursorcolumn                   " highlight current column
endif

set cursorline                        " highlight current line
set directory=~/.vim/tmp/swap,.       " keep swap files out of the way
set expandtab                         " always use spaces instead of tabs

if has('folding')
  set foldlevelstart=1                " start with some but not all folds closed
  set foldmethod=indent               " not as cool as syntax, but faster
endif

set formatoptions+=n                  " smart auto-indenting inside numbered lists
set guifont=Monaco:h12
set guioptions-=T                     " don't show toolbar
set hidden                            " allows you to hide buffers with unsaved changes without being prompted
set history=1000                      " longer search and command history (default is 20)
set hlsearch                          " highlight search strings
set ignorecase                        " ignore case when searching
set incsearch                         " incremental search ("find as you type")
set laststatus=2                      " always show status line
set list                              " show whitespace
set listchars=nbsp:¬,eol:¶,tab:>-,extends:»,precedes:«,trail:•
set nojoinspaces                      " don't autoinsert two spaces after '.', '?', '!' for join command
set noshowmatch                       " don't jump between matching brackets

if exists('+relativenumber')
  set relativenumber                  " show relative numbers in gutter
else
  set number                          " show line numbers in gutter
endif

set scrolloff=3                       " start scrolling 3 lines before edge of viewport
set shiftround                        " always indent by multiple of shiftwidth
set shiftwidth=2                      " spaces per tab (when shifting)
set shortmess+=A                      " ignore annoying swapfile messages
set shortmess+=I                      " no splash screen

if has('showcmd')
  set showcmd                         " extra info at end of command line
endif

set sidescrolloff=3                   " same, but for columns
set smartcase                         " except when search string includes a capital letter
set smarttab                          " <tab>/<BS> indent/dedent in leading whitespace

if has('syntax')
  set spellfile=~/.vim/.spellfile.utf-8.add
endif

set splitbelow                        " open horizontal splits below current window
set splitright                        " open vertical splits to the right of the current window
set tabstop=2                         " spaces per tab
set textwidth=80                      " automatically hard wrap at 80 columns
set ttimeoutlen=50                    " speed up O etc in the Terminal

if has('persistent_undo')
  set undodir=~/.vim/tmp/undo,.       " keep undo files out of the way
  set undofile                        " actually use undo files
endif

set virtualedit=block                 " allow cursor to move where there is no text in visual block mode
set wildignore+=*.o,.git              " patterns to ignore during file-navigation
set wildmenu                          " show options as list when switching buffers etc
set wildmode=longest:full,full        " shell-like autocomplete to unambiguous portion
set whichwrap=b,h,l,s,<,>,[,],~       " allow <BS>/h/l/<Left>/<Right>/<Space>, ~ to cross line boundaries
