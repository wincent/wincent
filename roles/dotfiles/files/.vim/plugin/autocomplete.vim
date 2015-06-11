" YouCompleteMe and UltiSnips compatibility.
let g:UltiSnipsExpandTrigger = '<Tab>'
let g:UltiSnipsJumpForwardTrigger = '<Tab>'

" TODO: change UltiSnips to not try mapping if this is empty; setting this to
" <C-k> here rather than <S-Tab> to prevent it from getting clobbered in:
" ultisnips/pythonx/UltiSnips/snippet_manager.py: _map_inner_keys
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

let g:ycm_key_list_select_completion = ['<C-j>', '<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<C-p>', '<Up>']

let g:ulti_jump_forwards_res = 0
let g:ulti_expand_res = 0

augroup WincentAutocomplete
  autocmd!

  " Override late bindings set up by YouCompleteMe in autoload file.
  autocmd BufEnter * exec 'inoremap <silent> <Tab> <C-R>=autocomplete#expand_or_jump("N")<CR>'
  autocmd BufEnter * exec 'inoremap <silent> <S-Tab> <C-R>=autocomplete#expand_or_jump("P")<CR>'

  " TODO: ideally would only do this while snippet is active
  " (see pythonx/UltiSnips/snippet_manager.py; might need to open a feature
  " request or a PR to have _map_inner_keys, _unmap_inner_keys fire off
  " autocommands that I can subscribe to)
  " BUG: seems you have to do <CR> twice to actual finalize completion
  " (this happens even with the standard <C-Y>
  inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "<CR>"
augroup END

" Additional UltiSnips config
let g:UltiSnipsSnippetsDir = '~/.vim/ultisnips'
let g:UltiSnipsSnippetDirectories = ['ultisnips']

" Additional YouCompleteMe config
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_seed_identifiers_with_syntax = 1
