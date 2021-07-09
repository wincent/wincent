let g:UltiSnipsJumpForwardTrigger = '<Tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'

" Prevent UltiSnips from removing our carefully-crafted mappings.
let g:UltiSnipsMappingsToIgnore = ['autocomplete']

augroup WincentAutocomplete
  autocmd!
  autocmd! User UltiSnipsEnterFirstSnippet
  autocmd User UltiSnipsEnterFirstSnippet call wincent#autocomplete#setup_mappings()
  autocmd! User UltiSnipsExitLastSnippet
  autocmd User UltiSnipsExitLastSnippet call wincent#autocomplete#teardown_mappings()
augroup END

" Additional UltiSnips config.
let g:UltiSnipsSnippetDirectories = [
      \   'ultisnips',
      \   'ultisnips-private'
      \ ]

inoremap <expr><C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr><Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<C-j>"
inoremap <expr><Up> pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
