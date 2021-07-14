-- BUG: this file isn't running (and .vim version didn't either)

-- But see also comment in statusline.lua, about `nvim_buf_get_name()`
-- prepending the current working directory here.
wincent.vim.setlocal('statusline', '  ' .. vim.api.nvim_buf_get_name(0):gsub(' ', '\\ '))
