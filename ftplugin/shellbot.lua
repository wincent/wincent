vim.bo.buflisted = true
vim.bo.buftype = 'nofile'
vim.bo.modified = false
vim.bo.textwidth = 0
vim.wo.breakindent = true
vim.wo.linebreak = true
vim.wo.list = false
vim.wo.number = false
vim.wo.relativenumber = false
vim.wo.showbreak = 'NONE'
vim.wo.wrap = true

local has_shellbot = pcall(require, 'chatbot')
if has_shellbot then
  vim.keymap.set({ 'i', 'n' }, '<M-CR>', ChatBotSubmit, { buffer = true })
  vim.keymap.set({ 'i', 'n' }, '<C-Enter>', ChatBotSubmit, { buffer = true })
  vim.keymap.set({ 'i', 'n' }, '<C-o>', ChatBotNewBuf, { buffer = true })
end
