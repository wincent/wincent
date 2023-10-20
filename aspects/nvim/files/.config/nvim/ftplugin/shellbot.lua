vim.bo.textwidth = 0
vim.wo.showbreak = ''

local has_shellbot = require('chatgpt')
if has_shellbot then
  vim.keymap.set({ 'i', 'n' }, '<M-CR>', ChatGPTSubmit, { buffer = true })
end
