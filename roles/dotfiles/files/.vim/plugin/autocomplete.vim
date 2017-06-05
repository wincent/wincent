" YouCompleteMe and UltiSnips compatibility.
let g:UltiSnipsExpandTrigger = '<Tab>'
let g:UltiSnipsJumpForwardTrigger = '<Tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'

" Prevent UltiSnips from removing our carefully-crafted mappings.
let g:UltiSnipsMappingsToIgnore = ['autocomplete']

if has('autocmd')
  augroup WincentAutocomplete
    autocmd!
    autocmd! User UltiSnipsEnterFirstSnippet
    autocmd User UltiSnipsEnterFirstSnippet call autocomplete#setup_mappings()
    autocmd! User UltiSnipsExitLastSnippet
    autocmd User UltiSnipsExitLastSnippet call autocomplete#teardown_mappings()
  augroup END
endif

let g:ycm_key_list_select_completion = ['<C-j>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']
let g:ycm_key_list_accept_completion = ['<C-y>']

" Additional UltiSnips config.
let g:UltiSnipsSnippetsDir = $HOME . '/.vim/ultisnips'
let g:UltiSnipsSnippetDirectories = [
      \ $HOME . '/.vim/ultisnips',
      \ $HOME . '/.vim/ultisnips-private'
      \ ]

" Additional YouCompleteMe config.
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_seed_identifiers_with_syntax = 1

let g:ycm_extra_conf_globlist = ['~/code/masochist-pages/*']

" Disable unhelpful semantic completions.
let g:ycm_filetype_specific_completion_to_disable = {
      \   'c': 1,
      \   'gitcommit': 1,
      \   'haskell': 1,
      \   'javascript': 1,
      \   'ruby': 1
      \ }

let g:ycm_semantic_triggers = {
      \   'haskell': [
      \     '.',
      \     '(',
      \     ',',
      \     ', '
      \   ],
      \   'mail': [
      \     're!^Bcc:(.*, ?| ?)',
      \     're!^Cc:(.*, ?| ?)',
      \     're!^From:(.*, ?| ?)',
      \     're!^Reply-To:(.*, ?| ?)',
      \     're!^To:(.*, ?| ?)'
      \   ],
      \   'markdown': [
      \     ']('
      \   ]
      \ }

" Same as default, but with "mail", "markdown" and "text" removed.
let g:ycm_filetype_blacklist = {
      \   'notes': 1,
      \   'unite': 1,
      \   'tagbar': 1,
      \   'pandoc': 1,
      \   'qf': 1,
      \   'vimwiki': 1,
      \   'infolog': 1,
      \ }

if has('nvim')
  inoremap <expr><C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
  inoremap <expr><Down> pumvisible() ? "\<C-n>" : "\<Down>"
  inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<C-j>"
  inoremap <expr><Up> pumvisible() ? "\<C-p>" : "\<Up>"
else
  call defer#packadd('YouCompleteMe', 'youcompleteme.vim')
endif
