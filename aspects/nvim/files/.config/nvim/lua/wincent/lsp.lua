local lsp = {}

local on_attach = function()
  vim.keymap.set('n', '<Leader>ld', '<cmd>lua vim.diagnostic.open_float()<CR>', { buffer = true, silent = true })

  -- Mnemonic: kd = "kill diagnostics" (although it's really "toggle diagnostics")
  vim.keymap.set('n', '<Leader>kd', function()
    local toggle = not vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_text = toggle })
  end, { buffer = true, silent = true })

  vim.keymap.set('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', { buffer = true, silent = true })
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { buffer = true, silent = true })
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', { buffer = true, silent = true })

  vim.wo.signcolumn = 'yes'
end

lsp.init = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- UI tweaks from https://github.com/neovim/nvim-lspconfig/wiki/UI-customization
  local border = {
    { '╭', 'FloatBorder' },
    { '─', 'FloatBorder' },
    { '╮', 'FloatBorder' },
    { '│', 'FloatBorder' },
    { '╯', 'FloatBorder' },
    { '─', 'FloatBorder' },
    { '╰', 'FloatBorder' },
    { '│', 'FloatBorder' },
  }
  local handlers = {
    ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
    ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
  }

  local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if has_cmp_nvim_lsp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  require('lspconfig').clangd.setup({
    capabilities = capabilities,
    cmd = { 'clangd', '--background-index' },
    handlers = handlers,
    on_attach = on_attach,
  })

  -- Prerequisite: https://github.com/LuaLS/lua-language-server
  --
  -- `brew install lua-language-server` on macOS.
  -- `yay -S lua-language-server` on Arch.
  --
  -- See also:
  --
  -- - https://github.com/luals/lua-language-server/wiki/Getting-Started#command-line
  -- - https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
  --
  local cmd = 'lua-language-server'
  if vim.fn.executable(cmd) == 1 then
    require('lspconfig').lua_ls.setup({
      capabilities = capabilities,
      cmd = { cmd },
      handlers = handlers,
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            enable = true,
            globals = { 'vim' },
          },
          filetypes = { 'lua' },
          runtime = {
            path = vim.split(package.path, ';'),
            version = 'LuaJIT',
          },
          telemetry = {
            -- Do not send telemetry data.
            enable = false,
          },
          workspace = {
            -- Make the server aware of Neovim runtime files.
            library = vim.api.nvim_get_runtime_file('', true),
            -- Stop "Do you need to configure your work environment as
            -- `luassert`?" spam.
            checkThirdParty = false,
          },
        },
      },
    })
  end

  require('lspconfig').gopls.setup({
    capabilities = capabilities,
    handlers = handlers,
    on_attach = on_attach,
  })

  require('lspconfig').ocamlls.setup({
    capabilities = capabilities,
    handlers = handlers,
    on_attach = on_attach,
  })

  require('lspconfig').rust_analyzer.setup({
    capabilities = capabilities,
    handlers = handlers,
    on_attach = on_attach,
  })

  --[[
  require('lspconfig').solargraph.setup({
    capabilities = capabilities,
    handlers = handlers,
    on_attach = on_attach,
  })
  --]]
  require('lspconfig').sorbet.setup({
    capabilities = capabilities,
    handlers = handlers,
    on_attach = on_attach,
  })

  require('lspconfig').tsserver.setup({
    capabilities = capabilities,
    handlers = handlers,
    on_attach = on_attach,
  })

  require('lspconfig').vimls.setup({
    capabilities = capabilities,
    handlers = handlers,
    on_attach = on_attach,
  })
end

lsp.set_up_highlights = function()
  local has_pinnacle, pinnacle = pcall(require, 'wincent.pinnacle')
  if has_pinnacle then
    pinnacle.set('DiagnosticError', pinnacle.decorate('italic,underline', 'ModeMsg'))
    pinnacle.set('DiagnosticHint', pinnacle.decorate('bold,italic,underline', 'Type'))

    pinnacle.set('DiagnosticSignHint', {
      bg = pinnacle.bg('ColorColumn'),
      fg = pinnacle.fg('Type'),
    })

    pinnacle.set('DiagnosticSignError', {
      bg = pinnacle.bg('ColorColumn'),
      fg = pinnacle.fg('ErrorMsg'),
    })

    pinnacle.set('DiagnosticSignInformation', {
      bg = pinnacle.bg('ColorColumn'),
      fg = pinnacle.fg('DiagnosticHint'),
    })

    pinnacle.set('DiagnosticSignWarning', {
      bg = pinnacle.bg('ColorColumn'),
      fg = pinnacle.fg('DiagnosticHint'),
    })
  end
end

return lsp
