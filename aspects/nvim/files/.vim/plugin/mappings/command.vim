"
" Command mode mappings.
"

cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" `<Tab>`/`<S-Tab>` to move between matches without leaving incremental search.
" Note dependency on `'wildcharm'` being set to `<C-z>` in order for this to
" work.
cnoremap <expr> <Tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<CR>/<C-r>/' : '<C-z>'
cnoremap <expr> <S-Tab> getcmdtype() == '/' \|\| getcmdtype() == '?' ? '<CR>?<C-r>/' : '<S-Tab>'

" Word-wise movement in command mode.
"
" These rely on Option-Left and Option-Right being set to send these escape
" sequences in the iTerm2 preferences. See `:help tcsh-style`.
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>

" Same, for kitty:
cnoremap <M-Right> <S-Right>
cnoremap <M-Left> <S-Left>
