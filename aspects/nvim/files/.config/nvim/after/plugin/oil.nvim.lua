local has_oil, oil = pcall(require, 'oil')
if has_oil then
  local ns = vim.api.nvim_create_namespace('wincent.oil')
  oil.setup({
    -- Disable defaults because some of them are annoying; eg.
    --
    -- - `<C-h>` opens in horizontal split, but muscle memory dictates that it
    --   should be mapped to move cursor to window on left (`:h CTRL-W_CTRL-H`).
    -- - `<C-s>` opens in a vertical split, but muscle memory dictates that is
    --   should be a horizontal split.
    use_default_keymaps = false,
    keymaps = {
      -- Defaults:
      --
      ['g?'] = { 'actions.show_help', mode = 'n' },
      ['<CR>'] = 'actions.select',
      ['<C-t>'] = { 'actions.select', opts = { tab = true } },
      ['<C-p>'] = 'actions.preview',
      ['<C-l>'] = 'actions.refresh',
      ['-'] = { 'actions.parent', mode = 'n' },
      ['_'] = { 'actions.open_cwd', mode = 'n' },
      ['gs'] = { 'actions.change_sort', mode = 'n' },
      ['g.'] = { 'actions.toggle_hidden', mode = 'n' },

      -- This is slow due to ambiguity with vim-slime bindings.
      ['<C-c>'] = { 'actions.close', mode = 'n' },

      -- I don't find these particularly useful, but keeping them because they
      -- are harmless...
      ['`'] = { 'actions.cd', mode = 'n' },
      ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
      ['gx'] = 'actions.open_external',
      ['g\\'] = { 'actions.toggle_trash', mode = 'n' },

      -- Custom mappings:
      --
      -- `<C-v>` to open in vertical split, like Command-T (normally, Oil uses
      -- `<C-h>` for this).
      ['<C-v>'] = { 'actions.select', opts = { vertical = true } },

      -- `<C-s>` to open in horizontal split, like Command-T (normally, Oil uses
      -- `<C-v>` for this).
      ['<C-s>'] = { 'actions.select', opts = { horizontal = true } },

      -- These to match nvim-cmp documentation window bindings.
      ['<C-b>'] = 'actions.preview_scroll_up',
      ['<C-f>'] = 'actions.preview_scroll_down',

      ['yy'] = {
        function()
          require('oil.actions').yank_entry.callback()

          -- Highlight line like a real yank would. (`yank_entry()` is just calling
          -- `setreg()` under the covers, so this won't happen automatically.)
          local line = vim.fn.line('.')
          vim.hl.range(0, ns, 'Substitute', { line - 1, 1 }, { line - 1, -1 }, { timeout = 200 })

          local has_clipper = wincent.plugin.is_loaded('vim-clipper')
          if has_clipper then
            vim.cmd('Clip')
          end
        end,
        mode = 'n',
      },
    },
  })
  vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
end
