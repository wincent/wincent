local lsp = {}

local on_attach = function ()
  vim.keymap.set('n', '<Leader>ld', "<cmd>lua vim.diagnostic.open_float()<CR>", {buffer = true, silent = true})
  vim.keymap.set('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', {buffer = true, silent = true})
  vim.keymap.set('n', 'K', "<cmd>lua vim.lsp.buf.hover()<CR>", {buffer = true, silent = true})
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', {buffer = true, silent = true})

  vim.wo.signcolumn = 'yes'
end

lsp.init = function ()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- UI tweaks from https://github.com/neovim/nvim-lspconfig/wiki/UI-customization
  local border = {
      {"╭", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╮", "FloatBorder"},
      {"│", "FloatBorder"},
      {"╯", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╰", "FloatBorder"},
      {"│", "FloatBorder"}
  }
  local handlers =  {
    ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border}),
    ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border }),
  }

  local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if has_cmp_nvim_lsp then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end

  require'lspconfig'.clangd.setup{
    capabilities = capabilities,
    cmd = {'clangd', '--background-index'},
    handlers = handlers,
    on_attach = on_attach,
  }

  local cmd = nil

  if vim.fn.has('mac') == 1 then
    cmd = vim.fn.expand('~/code/lua-language-server/bin/lua-language-server')
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
    -- Prerequisite: https://github.com/sumneko/lua-language-server/wiki/Build-and-Run
    require'lspconfig'.sumneko_lua.setup{
      capabilities = capabilities,
      cmd = cmd,
      handlers = handlers,
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

  require'lspconfig'.gopls.setup {
    capabilities = capabilities,
    handlers = handlers,
    on_attach = on_attach,
  }

  require'lspconfig'.ocamlls.setup{
    capabilities = capabilities,
    handlers = handlers,
    on_attach = on_attach,
  }

  require'lspconfig'.rust_analyzer.setup{
    capabilities = capabilities,
    handlers = handlers,
    on_attach = on_attach,
  }

  require'lspconfig'.solargraph.setup{
    capabilities = capabilities,
    handlers = handlers,
    on_attach = on_attach,
  }
  --[[
  require'lspconfig'.sorbet.setup{
    capabilities = capabilities,
    handlers = handlers,
    on_attach = on_attach,
  }
  --]]

  require'lspconfig'.tsserver.setup{
    capabilities = capabilities,
    handlers = handlers,
    on_attach = on_attach,
  }

  require'lspconfig'.vimls.setup{
    capabilities = capabilities,
    handlers = handlers,
    on_attach = on_attach,
  }
end

lsp.set_up_highlights = function ()
  local pinnacle = require'wincent.pinnacle'

  vim.cmd('highlight DiagnosticError ' .. pinnacle.decorate('italic,underline', 'ModeMsg'))

  vim.cmd('highlight DiagnosticHint ' .. pinnacle.decorate('bold,italic,underline', 'Type'))

  vim.cmd('highlight DiagnosticSignHint ' .. pinnacle.highlight({
    bg = pinnacle.extract_bg('ColorColumn'),
    fg = pinnacle.extract_fg('Type'),
  }))

  vim.cmd('highlight DiagnosticSignError ' .. pinnacle.highlight({
    bg = pinnacle.extract_bg('ColorColumn'),
    fg = pinnacle.extract_fg('ErrorMsg'),
  }))

  vim.cmd('highlight DiagnosticSignInformation ' .. pinnacle.highlight({
    bg = pinnacle.extract_bg('ColorColumn'),
    fg = pinnacle.extract_fg('DiagnosticHint'),
  }))

  vim.cmd('highlight DiagnosticSignWarning ' .. pinnacle.highlight({
    bg = pinnacle.extract_bg('ColorColumn'),
    fg = pinnacle.extract_fg('DiagnosticHint'),
  }))
end

return lsp
