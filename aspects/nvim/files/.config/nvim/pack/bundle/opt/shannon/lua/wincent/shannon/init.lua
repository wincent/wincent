local M = {}

function M.setup(opts)
  opts = opts or {}
  local keymaps = opts.keymaps == nil or opts.keymaps
  local prefix = opts.prefix or '<Leader>s'

  require('wincent.shannon.private').set_agents(opts.agents)

  if keymaps then
    vim.keymap.set({ 'n', 'v' }, prefix .. 's', ':Shannon<CR>', { silent = true })
    vim.keymap.set('n', prefix .. 'n', ':ShannonNextMark<CR>', { silent = true })
    vim.keymap.set('n', prefix .. 'p', ':ShannonPreviousMark<CR>', { silent = true })
    vim.keymap.set('n', prefix .. 'c', ':ShannonClearMarks<CR>', { silent = true })
  end
end

return M
