let g:ledger_decimal_sep=','

augroup WincentLedger
  autocmd!
  autocmd FileType ledger noremap { ?^\d<CR>
  autocmd FileType ledger noremap } /^\d<CR>
augroup END
