if v:progname == 'vi'
  set noloadplugins
endif

let mapleader="\<Space>"
let maplocalleader="\\"

" Extension -> filetype mappings.
let filetype_m='objc'
let filetype_pl='prolog'

if has('nvim')
  " As per `:h script-here`, need to bury this inside a function.
  function! s:Lua()
    lua <<
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
.
  endfunction
  call s:Lua()
endif

" Stark highlighting is enough to see the current match; don't need the
" centering, which can be annoying.
let g:LoupeCenterResults=0

" And it turns out that if we're going to turn off the centering, we don't even
" need the mappings; see: https://github.com/wincent/loupe/pull/15
nmap <Nop><F1> <Plug>(LoupeN)
nmap <Nop><F2> <Plug>(Loupen)

" Stop Ferret from binding <Leader>l, which we want to keep for interactions
" with the language server client (the rare-ish times I want :Lack, I can just
" type it out).
map <Nop><F3> <Plug>(FerretLack)

" nvim-compe.
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true

" Prevent tcomment from making a zillion mappings (we just want the operator).
let g:tcomment_mapleader1=''
let g:tcomment_mapleader2=''
let g:tcomment_mapleader_comment_anyway=''
let g:tcomment_textobject_inlinecomment=''

" The default (g<) is a bit awkward to type.
let g:tcomment_mapleader_uncomment_anyway='gu'

" Turn off most of the features of this plug-in; I really just want the folding.
let g:vim_markdown_override_foldtext=0
let g:vim_markdown_no_default_key_mappings=1
let g:vim_markdown_emphasis_multiline=0
let g:vim_markdown_conceal=0
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_frontmatter=1
let g:vim_markdown_new_list_item_indent=0

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

" Allow for per-machine overrides in ~/.config/nvim/host/$HOSTNAME.vim and
" ~/.vim/vimrc.local.
let s:hostfile =
      \ $HOME .
      \ '/.config/nvim/host/' .
      \ substitute(hostname(), "\\..*", '', '') .
      \ '.vim'
if filereadable(s:hostfile)
  execute 'source ' . s:hostfile
endif

if has('nvim')
  let s:nvim_config_local=$HOME . '/.config/nvim/init-local.vim'
  if filereadable(s:nvim_config_local)
    execute 'source ' . s:nvim_config_local
  endif
else
  let s:vimrc_local=$HOME . '/.vim/vimrc.local'
  if filereadable(s:vimrc_local)
    execute 'source ' . s:vimrc_local
  endif
endif

if &loadplugins
  if has('packages')
    packadd! applescript.vim
    packadd! base16-vim
    packadd! command-t
    packadd! corpus
    " packadd! fern.vim
    packadd! ferret
    packadd! loupe

    if has('nvim')
      packadd! lspsaga.nvim
    endif

    packadd! neco-ghc

    if has('nvim')
      packadd! nvim-compe
      packadd! nvim-lspconfig
    endif

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
    packadd! vim-dirvish
    packadd! vim-dispatch
    packadd! vim-docvim
    packadd! vim-easydir
    packadd! vim-eunuch
    packadd! vim-fugitive
    packadd! vim-git
    packadd! vim-javascript
    packadd! vim-json
    packadd! vim-jsx
    packadd! vim-ledger
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
    source $HOME/.config/nvim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim
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
" See ~/.config/nvim/after for files evaluated after that.
" See `:scriptnames` for a list of all scripts, in evaluation order.
" Launch Vim with `vim --startuptime vim.log` for profiling info.
"
" To see all leader mappings, including those from plugins:
"
"   vim -c 'set t_te=' -c 'set t_ti=' -c 'map <space>' -c q | sort
