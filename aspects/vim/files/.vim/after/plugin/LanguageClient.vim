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

function! s:Bind()
  nnoremap <buffer> <silent> K :call LanguageClient#closeFloatingHover()<CR>
  nnoremap <buffer> <silent> <Esc> :call LanguageClient#closeFloatingHover()<CR>

  " I hate that this is a permanent global mapping, but we cannot set
  " it up temporarily and then unbind on BufLeave/WinLeave because
  " those fire as soon as we open the floating window (focus returns to
  " previous buffer). And BufUnload is not received reliably (we don't
  " see it, for example on closing the floating window due to cursor
  " movement).
  nnoremap <silent> <Esc> :call LanguageClient#closeFloatingHover()<CR>
endfunction

augroup WincentLanguageClientAutocmds
  autocmd!
  autocmd FileType * call s:Config()

  if has('nvim') && exists('*nvim_open_win')
    " Can use floating window.
    autocmd BufEnter __LanguageClient__ call s:Bind()
  endif
augroup END
