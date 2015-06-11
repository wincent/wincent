" YouCompleteMe and UltiSnips compatibility.
let g:UltiSnipsExpandTrigger = '<Tab>'
let g:UltiSnipsJumpForwardTrigger = '<Tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'

" Prevent UltiSnips from removing our carefully-crafted mappings.
let g:UltiSnipsMappingsToIgnore = ['autocomplete']

autocmd! User UltiSnipsDoSnippet
autocmd User UltiSnipsDoSnippet call autocomplete#setup_mappings()
autocmd User UltiSnipsSnippetDone call autocomplete#teardown_mappings()

let g:ycm_key_list_select_completion = ['<C-j>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']

" Additional UltiSnips config
let g:UltiSnipsSnippetsDir = '~/.vim/ultisnips'
let g:UltiSnipsSnippetDirectories = ['ultisnips']

" Additional YouCompleteMe config
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_seed_identifiers_with_syntax = 1
