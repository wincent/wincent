local has_luasnip, luasnip = pcall(require, 'luasnip')
if has_luasnip then
  local types = require('luasnip.util.types')

  luasnip.config.setup({
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { '← Choice', 'Todo' } },
        },
      },
      -- [types.insertNode] = {
      --   active = {
      --     virt_text = {{'← ...', 'Todo'}},
      --   },
      -- },
    },
    store_selection_keys = '<Tab>',
    update_events = 'InsertLeave,TextChangedI',
  })

  -- Tell LuaSnip to load on demand based on file-type.
  require('luasnip.loaders.from_lua').lazy_load({
    paths = '~/.config/nvim/lua/wincent/snippets',
  })
end
