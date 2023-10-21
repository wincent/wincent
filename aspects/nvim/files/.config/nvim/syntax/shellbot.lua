if vim.fn.exists('main_syntax') == 0 then
  if vim.fn.exists('b:current_syntax') == 1 then
    return
  end
  vim.g.main_syntax = 'shellbot'
elseif vim.fn.exists('b:current_syntax') == 1 and vim.b.current_syntax == 'shellbot' then
  return
end

vim.cmd('runtime! syntax/markdown.vim')

local cpo = vim.o.cpo

vim.cmd([[
  set cpo&vim
  syntax match ChatGPTHeader /^ 🤓 .*/ containedin=ALL
  syntax match ChatGPTHeader /^ 🤖 .*/ containedin=ALL
  highlight def link ChatGPTHeader TermCursor
]])

vim.b.current_syntax = 'shellbot'
if vim.g.main_syntax == 'shellbot' then
  vim.api.nvim_del_var('main_syntax')
end
vim.o.cpo = cpo
