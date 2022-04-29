--
-- Leader mappings.
--

-- <Leader><Leader> -- Open last buffer.
vim.keymap.set('n', '<Leader><Leader>', '<C-^>')

-- <Leader>g -- git grep for something (mnemonic: [g]it [g]rep).
vim.keymap.set('n', '<Leader>g', ':VcsJump grep<Space>')

vim.keymap.set('n', '<Leader>o', ':only<CR>')

-- <Leader>p -- Show the path of the current file (mnemonic: path; useful when
-- you have a lot of splits and the status line gets truncated).
vim.keymap.set('n', '<Leader>p', ":echo expand('%')<CR>")

-- <Leader>pp -- Like <Leader>p, but additionally yanks the filename and sends it
-- off to Clipper.
vim.keymap.set('n', '<Leader>pp', ":let @0=expand('%') <Bar> :Clip<CR> :echo expand('%')<CR>")

vim.keymap.set('n', '<Leader>q', ':quit<CR>')

-- <Leader>r -- Cycle through relativenumber + number, number (only), and no
-- numbering (mnemonic: relative).
vim.keymap.set('n', '<Leader>r', function() wincent.mappings.leader.cycle_numbering() end, {silent = true})

vim.keymap.set('n', '<Leader>w', ':write<CR>')
vim.keymap.set('n', '<Leader>x', ':xit<CR>')

-- <Leader>zz -- Zap trailing whitespace in the current buffer.
--
--        As this one is somewhat destructive and relatively close to the
--        oft-used <leader>a mapping, make this one a double key-stroke.
vim.keymap.set('n', '<Leader>zz', ':call wincent#mappings#leader#zap()<CR>', {silent = true})

-- Stop annoying paren match highlighting from flashing all over the screen,
-- or start it.
--
-- (mnemonic: [m]atch paren)
vim.keymap.set('n', '<Leader>m', ':call wincent#mappings#leader#matchparen()<CR>', {silent = true})

-- Micro-optimizating the slightly-hard-to-type-on-Colemak-but-very-useful `gv`.
vim.keymap.set('n', '<Leader>v', 'gv')

-- File-wise movement in/out of jump list.
vim.keymap.set('n', '<Leader>,', function () wincent.mappings.leader.jump_out_file() end, {silent = true})
vim.keymap.set('n', '<Leader>.', function () wincent.mappings.leader.jump_in_file() end, {silent = true})

-- Grow/shrink window horizontally (ie. make wider or narrower).
vim.keymap.set('n', '<Leader>=', ':vertical resize +5<CR>', {silent = true})
vim.keymap.set('n', '<Leader>-', ':vertical resize -5<CR>', {silent = true})

-- <LocalLeader>s -- Fix (most) syntax highlighting problems in current buffer
-- (mnemonic: syntax).
vim.keymap.set('n', '<LocalLeader>s',  ':syntax sync fromstart<CR>', {silent = true})

-- <LocalLeader>d... -- Diff mode bindings:
-- - <LocalLeader>dd: show diff view (mnemonic: [d]iff)
-- - <LocalLeader>dh: choose hunk from left (mnemonic: [h] = left)
-- - <LocalLeader>dl: choose hunk from right (mnemonic: [l] = right)
vim.keymap.set('n', '<LocalLeader>dd', ':Gvdiffsplit!<CR>', {silent = true})
vim.keymap.set('n', '<LocalLeader>dh', ':diffget //2<CR>', {silent = true})
vim.keymap.set('n', '<LocalLeader>dl', ':diffget //3<CR>', {silent = true})

-- <LocalLeader>e -- Edit file, starting in same directory as current file.
vim.keymap.set('n', '<LocalLeader>e', ":edit <C-R>=expand('%:p:h') . '/'<CR>")

-- <LocalLeader>p -- [P]rint the syntax highlighting group(s) that apply at the
-- current cursor position.
vim.keymap.set('n', '<LocalLeader>p',  ':echomsg v:lua.wincent.mappings.leader.get_highlight_group()<CR>')

-- <LocalLeader>x -- Turn references to the word under the cursor to references
-- to the WORD under the cursor:
--
-- eg. if the cursor is on the first "w":
--
--     [@wincent](https://github.com/wincent)
--
-- Can be used to turn all references to "wincent" into links to "@wincent".
--
-- (mnemonic: e[X]tract handle)
vim.keymap.set('n', '<LocalLeader>x', ':%s#\\v<C-r><c-w>#<C-r><C-a>#gc<CR>')

-- Grow/shrink window vertically (ie. make taller or shorter).
vim.keymap.set('n', '<LocalLeader>=', ':resize +5<CR>', {silent = true})
vim.keymap.set('n', '<LocalLeader>-', ':resize -5<CR>', {silent = true})
