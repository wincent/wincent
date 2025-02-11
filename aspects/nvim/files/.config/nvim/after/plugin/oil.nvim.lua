local has_oil, oil = pcall(require, 'oil')
if has_oil then
  oil.setup()
  vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
end
