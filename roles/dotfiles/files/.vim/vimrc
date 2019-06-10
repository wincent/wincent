if v:progname == 'vi'
  set noloadplugins
endif

let mapleader="\<Space>"
let maplocalleader="\\"

" Extension -> filetype mappings.
let filetype_m='objc'
let filetype_pl='prolog'

" Stark highlighting is enough to see the current match; don't need the
" centering, which can be annoying.
let g:LoupeCenterResults=0

" Would be useful mappings, but they interfere with my default window movement
" bindings (<C-j> and <C-k>).
let g:NERDTreeMapJumpPrevSibling='<Nop>'
let g:NERDTreeMapJumpNextSibling='<Nop>'

" Prevent tcomment from making a zillion mappings (we just want the operator).
let g:tcomment_mapleader1=''
let g:tcomment_mapleader2=''
let g:tcomment_mapleader_comment_anyway=''
let g:tcomment_textobject_inlinecomment=''

" The default (g<) is a bit awkward to type.
let g:tcomment_mapleader_uncomment_anyway='gu'

let g:LanguageClient_diagnosticsDisplay = {
      \   1: {'signTexthl': 'LineNr', 'virtualTexthl': 'User8'},
      \   2: {'signTexthl': 'LineNr', 'virtualTexthl': 'User8'},
      \   3: {'signTexthl': 'LineNr', 'virtualTexthl': 'User8'},
      \   4: {'signTexthl': 'LineNr', 'virtualTexthl': 'User8'},
      \ }

let g:LanguageClient_rootMarkers = {
      \   'javascript': ['tsconfig.json', '.flowconfig', 'package.json'],
      \   'typescript': ['tsconfig.json', '.flowconfig', 'package.json']
      \ }

let g:LanguageClient_serverCommands = {}

if exists('$DEBUG_LSP_LOGFILE')
  let s:debug_args=['--trace', '--logfile', $DEBUG_LSP_LOGFILE]
else
  let s:debug_args=[]
endif

" From `npm install -g javascript-typescript-langserver`:
let s:ts_lsp=executable('javascript-typescript-stdio') ?
      \ extend([exepath('javascript-typescript-stdio')], s:debug_args) :
      \ []

if exists('$DEBUG_LSP_LOGFILE')
  let s:debug_args=[
        \   '--log-level=4',
        \   '--tsserver-log-file',
        \   $DEBUG_LSP_LOGFILE,
        \   '--tsserver-log-verbosity=verbose'
        \ ]
else
  let s:debug_args=[]
endif

" From `npm install -g typescript-language-server`:
" let s:ts_lsp= executable('typescript-language-server') ?
"         \ extend([exepath('typescript-language-server'), '--stdio'], s:debug_args) :
"         \ []

" From `npm install -g flow-bin`:
let s:flow_lsp=executable('flow') ?
      \ [exepath('flow'), 'lsp'] :
      \ []

let s:ts_filetypes=[
      \   'typescript',
      \   'typescript.jsx',
      \   'typescript.jest',
      \   'typescript.jest.jsx'
      \ ]

let s:js_filetypes=[
      \   'javascript',
      \   'javascript.jsx',
      \   'javascript.jest',
      \   'javascript.jest.jsx'
      \ ]

if s:ts_lsp != []
  for s:ts_filetype in s:ts_filetypes
    let g:LanguageClient_serverCommands[s:ts_filetype]=s:ts_lsp
  endfor
endif

if s:ts_lsp != [] && filereadable('tsconfig.json')
  let s:js_lsp=s:ts_lsp
elseif s:flow_lsp != [] && filereadable('.flowconfig')
  let s:js_lsp=s:flow_lsp
elseif s:ts_lsp != []
  let s:js_lsp=s:ts_lsp
endif

if exists('s:js_lsp')
  let g:LanguageClient_serverCommands['javascript']=s:js_lsp
  let g:LanguageClient_serverCommands['javascript.jest']=s:js_lsp
  let g:LanguageClient_serverCommands['javascript.jest.jsx']=s:js_lsp
  let g:LanguageClient_serverCommands['javascript.jsx']=s:js_lsp
endif

if executable('ocaml-language-server')
  let s:ocaml_lsp=[exepath('ocaml-language-server')]
  let g:LanguageClient_serverCommands['reason']=s:ocaml_lsp
  let g:LanguageClient_serverCommands['ocaml']=s:ocaml_lsp
endif

let g:LanguageClient_diagnosticsList='Location'

if filereadable('/usr/local/bin/python3')
  " Avoid search, speeding up start-up.
  let g:python3_host_prog='/usr/local/bin/python3'
endif

" Normally <leader>s (mnemonic: "[s]earch");
" use <leader>f instead (mnemonic: "[f]ind")
nmap <leader>f <Plug>(FerretAckWord)

" Normally <leader>r (mnemonic: "[r]eplace");
" use <leader>s (mnemonic: "[s]ubstitute") instead.
nmap <leader>s <Plug>(FerretAcks)

" Allow for per-machine overrides in ~/.vim/host/$HOSTNAME.vim and
" ~/.vim/vimrc.local.
let s:hostfile =
      \ $HOME .
      \ '/.vim/host/' .
      \ substitute(hostname(), "\\..*", '', '') .
      \ '.vim'
if filereadable(s:hostfile)
  execute 'source ' . s:hostfile
endif

let s:vimrc_local = $HOME . '/.vim/vimrc.local'
if filereadable(s:vimrc_local)
  execute 'source ' . s:vimrc_local
endif

if has('gui')
  " Turn off scrollbars. (Default on macOS is "egmrL").
  set guioptions-=L
  set guioptions-=R
  set guioptions-=b
  set guioptions-=l
  set guioptions-=r
endif

if &loadplugins
  if has('packages')
    packadd! LanguageClient-neovim
    packadd! base16-vim
    packadd! command-t
    packadd! ferret
    packadd! indentLine
    packadd! loupe
    packadd! neco-ghc
    packadd! pinnacle
    packadd! replay
    packadd! scalpel
    packadd! tcomment_vim
    packadd! terminus
    packadd! typescript-vim
    packadd! ultisnips
    packadd! vcs-jump
    packadd! vim-ansible-yaml
    packadd! vim-clipper
    packadd! vim-docvim
    packadd! vim-easydir
    packadd! vim-eunuch
    packadd! vim-fugitive
    packadd! vim-git
    packadd! vim-javascript
    packadd! vim-json
    packadd! vim-jsx
    packadd! vim-lion
    packadd! vim-markdown
    packadd! vim-operator-user
    packadd! vim-projectionist
    packadd! vim-reason-plus
    packadd! vim-repeat
    packadd! vim-signature
    packadd! vim-slime
    packadd! vim-soy
    packadd! vim-speeddating
    packadd! vim-surround
    packadd! vim-textobj-comment
    packadd! vim-textobj-rubyblock
    packadd! vim-textobj-user
    packadd! vim-zsh
  else
    source $HOME/.vim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim
    call pathogen#infect('pack/bundle/opt/{}')
  endif
endif

" Automatic, language-dependent indentation, syntax coloring and other
" functionality.
"
" Must come *after* the `:packadd!` calls above otherwise the contents of
" package "ftdetect" directories won't be evaluated.
filetype indent plugin on
syntax on

" After this file is sourced, plugin code will be evaluated.
" See ~/.vim/after for files evaluated after that.
" See `:scriptnames` for a list of all scripts, in evaluation order.
" Launch Vim with `vim --startuptime vim.log` for profiling info.
"
" To see all leader mappings, including those from plugins:
"
"   vim -c 'set t_te=' -c 'set t_ti=' -c 'map <space>' -c q | sort
