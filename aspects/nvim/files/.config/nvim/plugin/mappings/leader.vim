" Leader mappings.

" <Leader><Leader> -- Open last buffer.
nnoremap <Leader><Leader> <C-^>

" <Leader>g -- git grep for something (mnemonic: [g]it [g]rep).
nnoremap <Leader>g :VcsJump grep<Space>

nnoremap <Leader>o :only<CR>

" <Leader>p -- Show the path of the current file (mnemonic: path; useful when
" you have a lot of splits and the status line gets truncated).
nnoremap <Leader>p :echo expand('%')<CR>

" <Leader>pp -- Like <Leader>p, but additionally yanks the filename and sends it
" off to Clipper.
nnoremap <Leader>pp :let @0=expand('%') <Bar> :Clip<CR> :echo expand('%')<CR>

nnoremap <Leader>q :quit<CR>

" <Leader>r -- Cycle through relativenumber + number, number (only), and no
" numbering (mnemonic: relative).
nnoremap <silent> <Leader>r :lua require'wincent.mappings.leader'.cycle_numbering()<CR>

nnoremap <Leader>w :write<CR>
nnoremap <Leader>x :xit<CR>

" <Leader>zz -- Zap trailing whitespace in the current buffer.
"
"        As this one is somewhat destructive and relatively close to the
"        oft-used <leader>a mapping, make this one a double key-stroke.
nnoremap <silent> <Leader>zz :call wincent#mappings#leader#zap()<CR>

" <LocalLeader>s -- Fix (most) syntax highlighting problems in current buffer
" (mnemonic: syntax).
nnoremap <silent> <LocalLeader>s :syntax sync fromstart<CR>

" <LocalLeader>d... -- Diff mode bindings:
" - <LocalLeader>dd: show diff view (mnemonic: [d]iff)
" - <LocalLeader>dh: choose hunk from left (mnemonic: [h] = left)
" - <LocalLeader>dl: choose hunk from right (mnemonic: [l] = right)
nnoremap <silent> <LocalLeader>dd :Gvdiffsplit!<CR>
nnoremap <silent> <LocalLeader>dh :diffget //2<CR>
nnoremap <silent> <LocalLeader>dl :diffget //3<CR>

" <LocalLeader>e -- Edit file, starting in same directory as current file.
nnoremap <LocalLeader>e :edit <C-R>=expand('%:p:h') . '/'<CR>


" <LocalLeader>p -- [P]rint the syntax highlighting group(s) that apply at the
" current cursor position.
"
" Taken from: http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
nnoremap <LocalLeader>p :echo 'hi<' . synIDattr(synID(line('.'),col('.'),1),'name') . '> trans<'
\ . synIDattr(synID(line('.'),col('.'),0),'name') . '> lo<'
\ . synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name') . '>'<CR>

" <LocalLeader>x -- Turn references to the word under the cursor to references
" to the WORD under the cursor:
"
" eg. if the cursor is on the first "w":
"
"     [@wincent](https://github.com/wincent)
"
" Can be used to turn all references to "wincent" into links to "@wincent".
"
" (mnemonic: e[X]tract handle)
nnoremap <LocalLeader>x :%s#\v<C-r><c-w>#<C-r><C-a>#gc<CR>

" Stop annoying paren match highlighting from flashing all over the screen,
" or start it.
"
" (mnemonic: [m]atch paren)
nnoremap <silent> <Leader>m :call wincent#mappings#leader#matchparen()<CR>
