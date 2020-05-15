if !has('nvim')
  finish
endif

lua << END
  require'nvim_lsp'.ocamlls.setup{}
  require'nvim_lsp'.tsserver.setup{
    -- cmd = {
    --   "typescript-language-server",
    --   "--stdio",
    --   "--tsserver-log-file",
    --   "tslog"
    -- }
  }
  require'nvim_lsp'.vimls.setup{}
END

function! s:Bind()
  try
    if nvim_win_get_var(0, 'textDocument/hover')
      nnoremap <buffer> <silent> K :call nvim_win_close(0, v:true)<CR>
      nnoremap <buffer> <silent> <Esc> :call nvim_win_close(0, v:true)<CR>
    endif
  catch /./
    " Not a hover window.
  endtry
endfunction

function! s:ConfigureBuffer()
    nnoremap <buffer> <silent> <Leader>ld <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
    nnoremap <buffer> <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <buffer> <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <buffer> <silent> gd <cmd>lua vim.lsp.buf.declaration()<CR>

    if exists('+signcolumn')
      setlocal signcolumn=yes
    endif
endfunction

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

if has('autocmd')
  augroup WincentLanguageClientAutocmds
    autocmd!

    autocmd WinEnter * call s:Bind()

    autocmd FileType javascript,typescript,vim  call s:ConfigureBuffer()

    autocmd ColorScheme * call s:SetUpLspHighlights()
  augroup END
endif
