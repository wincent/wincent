wincent.vim.plaintext()

wincent.vim.setlocal('breakindent')
wincent.vim.setlocal('breakindentopt', 'sbr,shift:' .. vim.bo.shiftwidth)
wincent.vim.setlocal('synmaxcol', 0)
