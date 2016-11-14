" Replay last-recorded macro, or @q if no specific last macro has been previously recorded.
nnoremap <expr> <silent> <CR> empty(&buftype) ? ':call replay#repeat_last_macro()<CR>' : '<CR>'

" Try to figure out which macro was the last updated.
nnoremap <silent> <expr> q replay#spy_on_registers()
