-- TODO: complete `find` arg names too
-- TODO: check escaping is correct
vim.cmd [[command! -nargs=* -complete=file Find call wincent#commands#find(<q-args>)]]

vim.cmd [[command! Lint call wincent#commands#lint()]]
vim.cmd [[command! -nargs=* -complete=file -range OpenOnGitHub <line1>,<line2>call wincent#commands#open_on_github(<f-args>)]]
vim.cmd [[command! Typecheck call wincent#commands#typecheck()]]
vim.cmd [[command! Vim call wincent#commands#vim()]]

-- Markdown previews.
vim.cmd [[command! -nargs=? -complete=file Glow call wincent#commands#glow(<q-args>)]]
vim.cmd [[command! -nargs=* -complete=file Marked call wincent#commands#marked(<q-args>)]]
vim.cmd [[command! -nargs=* -complete=file Preview call wincent#commands#preview(<q-args>)]]
