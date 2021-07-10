let g:ledger_decimal_sep=','

augroup WincentLedger
  autocmd!
  autocmd FileType ledger noremap <silent> { :keeppatterns ?^\d<CR>
  autocmd FileType ledger noremap <silent> } :keeppatterns /^\d<CR>
augroup END
