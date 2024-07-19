vim.bo.textwidth = 0
vim.wo.list = false
vim.wo.number = false
vim.wo.relativenumber = false
vim.wo.showbreak = 'NONE'

local has_shellbot = pcall(require, 'chatbot')
if has_shellbot then
  vim.keymap.set({ 'i', 'n' }, '<M-CR>', ChatBotSubmit, { buffer = true })
end
