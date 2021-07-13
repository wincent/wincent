local wincent = require'wincent'

local nnoremap = wincent.vim.nnoremap

local lsp = {}

local on_attach = function ()
  nnoremap('<Leader>ld', "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>", {silent = true})
  nnoremap('<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', {silent = true})
  nnoremap('K', "<cmd>lua require'lspsaga.hover'.render_hover_doc()<CR>", {silent = true})
  nnoremap('gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', {silent = true})

  vim.wo.signcolumn = 'yes'
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

  local cmd = nil

  if vim.fn.has('mac') == 1 then
    cmd = vim.fn.expand('~/code/lua-language-server/bin/macOS/lua-language-server')
    if vim.fn.executable(cmd) == 1 then
      cmd = {cmd, '-E', vim.fn.expand('~/code/lua-language-server/main.lua')}
    else
      cmd = nil
    end
  elseif vim.fn.has('unix') == 1 then
    cmd = '/usr/bin/lua-language-server'
    if vim.fn.executable(cmd) == 1 then
      cmd = {cmd}
    else
      cmd = nil
    end
  else
    cmd = 'lua-language-server'
    if vim.fn.executable(cmd) == 1 then
      cmd = {cmd}
    else
      cmd = nil
    end
  end

  if cmd ~= nil then
    require'lspconfig'.sumneko_lua.setup{
      cmd = cmd,
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

  vim.cmd('highlight LspDiagnosticsSignInformation ' .. pinnacle.highlight({
    bg = pinnacle.extract_bg('ColorColumn'),
    fg = pinnacle.extract_fg('LspDiagnosticsDefaultHint'),
  }))

  vim.cmd('highlight LspDiagnosticsSignWarning ' .. pinnacle.highlight({
    bg = pinnacle.extract_bg('ColorColumn'),
    fg = pinnacle.extract_fg('LspDiagnosticsDefaultHint'),
  }))
end

return lsp