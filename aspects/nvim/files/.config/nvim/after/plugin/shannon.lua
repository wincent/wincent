local has_shannon, _ = pcall(require, 'wincent.shannon')
if has_shannon then
  vim.keymap.set({ 'n', 'v' }, '<Leader>ss', ':Shannon<CR>', { silent = true })
  vim.keymap.set('n', '<Leader>sn', ':ShannonNextMark<CR>', { silent = true })
  vim.keymap.set('n', '<Leader>sp', ':ShannonPreviousMark<CR>', { silent = true })
  vim.keymap.set('n', '<Leader>sc', ':ShannonClearMarks<CR>', { silent = true })
end
