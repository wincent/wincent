# cmp-nvim-lua

nvim-cmp source for neovim Lua API.

# Setup

```lua
require'cmp'.setup {
  sources = {
    { name = 'nvim_lua' }
  }
}
```

# Options

### `include_deprecated` (boolean: default false)

Specify should includes deprecated things or not.


# What is this source?

This source will complete neovim's Lua runtime API such `vim.lsp.*`.

You can get the `vim.lsp.util.*` API with this source.
