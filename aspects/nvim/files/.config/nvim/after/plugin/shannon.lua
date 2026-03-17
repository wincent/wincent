local has_shannon, _ = pcall(require, 'wincent.shannon')
if has_shannon then
  vim.keymap.set({ 'n', 'v' }, '<Leader>s', ':Shannon<CR>', { silent = true })
end

