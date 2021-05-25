local lsp = {}

local nnoremap = function (lhs, rhs)
  vim.api.nvim_buf_set_keymap(0, 'n', lhs, rhs, {noremap = true, silent = true})
end

local on_attach = function ()
  local mappings = {
    ['<Leader>ld'] = '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
    ['<c-]>'] = '<cmd>lua vim.lsp.buf.definition()<CR>',
    ['K'] = '<cmd>lua vim.lsp.buf.hover()<CR>',
    ['gd'] = '<cmd>lua vim.lsp.buf.declaration()<CR>',
  }

  for lhs, rhs in pairs(mappings) do
    nnoremap(lhs, rhs)
  end

  vim.api.nvim_win_set_option(0, 'signcolumn', 'yes')
end

lsp.bind = function ()
  pcall(function ()
    if vim.api.nvim_win_get_var(0, 'textDocument/hover') then
      nnoremap('K', ':call nvim_win_close(0, v:true)<CR>')
      nnoremap('<Esc>', ':call nvim_win_close(0, v:true)<CR>')

      vim.api.nvim_win_set_option(0, 'cursorline', false)

      -- I believe this is supposed to happen automatically because I can see
      -- this in lsp/util.lua:
      --
      --     api.nvim_buf_set_option(floating_bufnr, 'modifiable', false)
      --
      -- but it doesn't seem to be working.
      vim.api.nvim_buf_set_option(0, 'modifiable', false)
    end
  end)
end

lsp.init = function ()
  require'lspconfig'.clangd.setup{
    cmd = {'clangd', '--background-index'},
    on_attach = on_attach,
  }

  -- If you're feeling brave after reading:
  --
  --    https://github.com/neovim/nvim-lspconfig/issues/319
  --
  -- Install:
  --
  --    :LspInstall sumneko_lua
  --
  -- After marvelling at the horror that is the installation script:
  --
  --     https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/sumneko_lua.lua
  --
  -- To see path:
  --
  --    :LspInstallInfo sumneko_lua
  --
  -- See: https://github.com/neovim/nvim-lspconfig#sumneko_lua
  --
  -- Failing that; you can install by hand:
  --
  --    https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
  --

  local cmd = vim.fn.expand(
      '~/code/lua-language-server/bin/macOS/lua-language-server'
  )

  local main = vim.fn.expand('~/code/lua-language-server/main.lua')

  if vim.fn.executable(cmd) == 1 then
    require'lspconfig'.sumneko_lua.setup{
      cmd = {cmd, '-E', main},
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            enable = true,
            globals = {'vim'},
          },
          filetypes = {'lua'},
          runtime = {
            path = vim.split(package.path, ';'),
            version = 'LuaJIT',
          },
        }
      },
    }
  end

  require'lspconfig'.ocamlls.setup{
    on_attach = on_attach,
  }

  require'lspconfig'.tsserver.setup{
    -- cmd = {
    --   "typescript-language-server",
    --   "--stdio",
    --   "--tsserver-log-file",
    --   "tslog"
    -- },
    on_attach = on_attach,
  }

  require'lspconfig'.vimls.setup{
    on_attach = on_attach,
  }

  -- Override hover winhighlight.
  local method = 'textDocument/hover'
  local hover = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function (_, method, result)
     hover(_, method, result)

     for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
       if pcall(function ()
         vim.api.nvim_win_get_var(winnr, 'textDocument/hover')
       end) then
         vim.api.nvim_win_set_option(winnr, 'winhighlight', 'Normal:Visual,NormalNC:Visual')
         break
       else
         -- Not a hover window.
       end
     end
  end
end

lsp.set_up_highlights = function ()
  local pinnacle = require'wincent.pinnacle'

  vim.cmd('highlight LspDiagnosticsDefaultError ' .. pinnacle.decorate('italic,underline', 'ModeMsg'))

  vim.cmd('highlight LspDiagnosticsDefaultHint ' .. pinnacle.decorate('bold,italic,underline', 'Type'))

  vim.cmd('highlight LspDiagnosticsSignHint ' .. pinnacle.highlight({
    bg = pinnacle.extract_bg('ColorColumn'),
    fg = pinnacle.extract_fg('Type'),
  }))

  vim.cmd('highlight LspDiagnosticsSignError ' .. pinnacle.highlight({
    bg = pinnacle.extract_bg('ColorColumn'),
    fg = pinnacle.extract_fg('ErrorMsg'),
  }))
end

return lsp
