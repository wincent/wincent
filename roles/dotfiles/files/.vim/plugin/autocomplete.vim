let g:UltiSnipsJumpForwardTrigger = '<Tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'

" Prevent UltiSnips from removing our carefully-crafted mappings.
let g:UltiSnipsMappingsToIgnore = ['autocomplete']

if has('autocmd')
  augroup WincentAutocomplete
    autocmd!
    autocmd! User UltiSnipsEnterFirstSnippet
    autocmd User UltiSnipsEnterFirstSnippet call wincent#autocomplete#setup_mappings()
    autocmd! User UltiSnipsExitLastSnippet
    autocmd User UltiSnipsExitLastSnippet call wincent#autocomplete#teardown_mappings()
  augroup END
endif

" Additional UltiSnips config.
let g:UltiSnipsSnippetsDir = $HOME . '/.vim/ultisnips'
let g:UltiSnipsSnippetDirectories = [
      \ $HOME . '/.vim/ultisnips',
      \ $HOME . '/.vim/ultisnips-private'
      \ ]

if has('nvim')
  " Don't forget to run :UpdateRemotePlugins to populate
  " `~/.local/share/nvim/rplugin.vim`.
  packadd! deoplete
  call wincent#defer#defer('call wincent#autocomplete#deoplete_init()')

  inoremap <expr><C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
  inoremap <expr><Down> pumvisible() ? "\<C-n>" : "\<Down>"
  inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<C-j>"
  inoremap <expr><Up> pumvisible() ? "\<C-p>" : "\<Up>"

  packadd! LanguageClient-neovim
endif
