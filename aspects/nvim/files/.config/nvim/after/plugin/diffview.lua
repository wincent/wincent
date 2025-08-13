local has_diffview, diffview = pcall(require, 'diffview')

if has_diffview then
  local actions = require('diffview.actions')
  diffview.setup({
    keymaps = {
      file_history_panel = {
        -- Mnemonic: "[g]o [n]ext".
        -- Normally mapped to `<tab>`, which we use to toggle folds.
        { 'n', 'gn', actions.select_next_entry, { desc = 'Open the diff for the next file' } },
        ['<tab>'] = false,

        -- Mnemonic: "[g]o [p]revious".
        -- Normally mapped to `<s-tab`.
        { 'n', 'gp', actions.select_prev_entry, { desc = 'Open the diff for the previous file' } },
        ['<s-tab>'] = false,
      },
      view = {
        -- Mnemonic: "[g]o [n]ext".
        -- Normally mapped to `<tab>`, which we use to toggle folds.
        { 'n', 'gn', actions.select_next_entry, { desc = 'Open the diff for the next file' } },
        ['<tab>'] = false,

        -- Mnemonic: "[g]o [p]revious".
        -- Normally mapped to `<s-tab`.
        { 'n', 'gp', actions.select_prev_entry, { desc = 'Open the diff for the previous file' } },
        ['<s-tab>'] = false,
      },
    },

    -- Stop warning "nvim-web-devicons is required to use file icons!".
    use_icons = false,
  })
end
