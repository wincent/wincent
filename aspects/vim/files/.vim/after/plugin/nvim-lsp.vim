if !has('nvim')
  finish
endif

lua << END
  require'nvim_lsp'.ocamlls.setup{}
  require'nvim_lsp'.tsserver.setup{}
  require'nvim_lsp'.vimls.setup{}
END

function! s:SetUpLspHighlights()
  if !wincent#pinnacle#active()
    return
  endif

  execute 'highlight LspDiagnosticsError ' . pinnacle#decorate('italic,underline', 'ModeMsg')

  execute 'highlight LspDiagnosticsHint ' . pinnacle#decorate('bold,italic,underline', 'Type')

  execute 'highlight LspDiagnosticsHintSign ' . pinnacle#highlight({
        \   'bg': pinnacle#extract_bg('ColorColumn'),
        \   'fg': pinnacle#extract_fg('Type')
        \ })

  execute 'highlight LspDiagnosticsErrorSign ' . pinnacle#highlight({
        \   'bg': pinnacle#extract_bg('ColorColumn'),
        \   'fg': pinnacle#extract_fg('ErrorMsg')
        \ })
endfunction

sign define LspDiagnosticsErrorSign text=✖
sign define LspDiagnosticsWarningSign text=⚠
sign define LspDiagnosticsInformationSign text=ℹ
sign define LspDiagnosticsHintSign text=➤

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>

augroup WincentLanguageClientAutocmds
  autocmd!

  if exists('*nvim_open_win')
    " TODO: figure out how to detect lsp floating window...
    " Can use floating window.
    autocmd BufEnter __LanguageClient__ call s:Bind()
  endif

  if exists('+signcolumn')
    autocmd FileType javascript,typescript,vim setlocal signcolumn=yes
  endif

  autocmd ColorScheme * call s:SetUpLspHighlights()
augroup END
