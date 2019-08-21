function! s:Config()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    if &filetype == 'reason'
      " Format selection with gq.
      setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()

      " <Leader>f -- Format buffer.
      nnoremap <buffer> <silent> <Leader>f :call LanguageClient_textDocument_formatting()<CR>
    endif

    " gd -- go to definition
    nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>

    " K -- lookup keyword
    nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>

    if exists('+signcolumn')
      setlocal signcolumn=yes
    endif
  endif
endfunction

function! s:BindK()
  nnoremap <buffer> <silent> K :close<CR>
endfunction

augroup WincentLanguageClientAutocmds
  autocmd!
  autocmd FileType * call s:Config()

  if has('nvim') && exists('*nvim_open_win')
    " Can use floating window.
    autocmd BufEnter __LanguageClient__ call s:BindK()
  endif
augroup END
