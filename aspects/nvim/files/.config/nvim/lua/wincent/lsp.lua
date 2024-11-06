local lsp = {}

local open_floating_preview = vim.lsp.util.open_floating_preview

local virtual_text = {
  virt_text_pos = 'right_align',
  format = function(diagnostic)
    local bufnr = diagnostic.bufnr
    local lnum = diagnostic.lnum
    local window = nil
    for _, window_id in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(window_id) == bufnr then
        window = window_id
        break
      end
    end
    local win_width = vim.api.nvim_win_get_width(window)
    local line = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1]
    local line_length = #line
    local padding = 20
    local excess = (line_length + padding + #diagnostic.message) - win_width
    if excess > 0 then
      local trimmed = string.sub(diagnostic.message, 1, -excess) .. '…'
      return trimmed
    else
      return diagnostic.message
    end
  end,
}

local on_attach = function()
  vim.keymap.set('n', '<Leader>ld', '<cmd>lua vim.diagnostic.open_float()<CR>', { buffer = true, silent = true })

  -- Mnemonic: kd = "kill diagnostics" (although it's really "toggle diagnostics")
  vim.keymap.set('n', '<Leader>kd', function()
    if vim.diagnostic.config().virtual_text then
      vim.diagnostic.config({ virtual_text = false })
    else
      vim.diagnostic.config({ virtual_text = virtual_text })
    end
  end, { buffer = true, silent = true })

  vim.keymap.set('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', { buffer = true, silent = true })
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { buffer = true, silent = true })
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', { buffer = true, silent = true })

  vim.wo.signcolumn = 'yes'
end

lsp.init = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Global override, from https://github.com/neovim/nvim-lspconfig/wiki/UI-customization
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'single'
    return open_floating_preview(contents, syntax, opts, ...)
  end

  vim.diagnostic.config({
    virtual_text = virtual_text,
    severity_sort = true,
  })

  local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if has_cmp_nvim_lsp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  local has_lspconfig, lspconfig = pcall(require, 'lspconfig')
  if has_lspconfig then
    lspconfig.clangd.setup({
      capabilities = capabilities,
      cmd = { 'clangd', '--background-index' },
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
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        cmd = { cmd },
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

    lspconfig.gopls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig.ocamlls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig.rust_analyzer.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig.vimls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end
end

lsp.set_up_highlights = function()
  local has_pinnacle, pinnacle = pcall(require, 'wincent.pinnacle')
  if has_pinnacle then
    pinnacle.set('DiagnosticError', pinnacle.decorate('italic,underline', 'ErrorMsg'))
    pinnacle.set('DiagnosticHint', pinnacle.decorate('italic,underline', 'ModeMsg'))
    pinnacle.set('DiagnosticInfo', pinnacle.decorate('italic,underline', 'NvimLightCyan'))
    pinnacle.set('DiagnosticWarn', pinnacle.decorate('italic,underline', 'Type'))

    pinnacle.set('DiagnosticSignError', {
      bg = pinnacle.bg('ColorColumn'),
      fg = pinnacle.fg('ErrorMsg'),
    })

    pinnacle.set('DiagnosticSignHint', {
      bg = pinnacle.bg('ColorColumn'),
      fg = pinnacle.fg('ModeMsg'),
    })

    pinnacle.set('DiagnosticSignInformation', {
      bg = pinnacle.bg('ColorColumn'),
      fg = pinnacle.fg('NvimLightCyan'),
    })

    pinnacle.set('DiagnosticSignWarning', {
      bg = pinnacle.bg('ColorColumn'),
      fg = pinnacle.fg('Type'),
    })
  end
end

return lsp
