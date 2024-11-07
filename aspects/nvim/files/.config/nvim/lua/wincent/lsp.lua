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

    -- See also: https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#change-diagnostic-symbols-in-the-sign-column-gutter
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '✖',
        [vim.diagnostic.severity.HINT] = '➤',
        [vim.diagnostic.severity.INFO] = 'ℹ',
        [vim.diagnostic.severity.WARN] = '⚠',
      },
      texthl = {
        [vim.diagnostic.severity.ERROR] = '',
        [vim.diagnostic.severity.HINT] = '',
        [vim.diagnostic.severity.INFO] = '',
        [vim.diagnostic.severity.WARN] = '',
      },
      numhl = {
        [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
        [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
        [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
        [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
      },
    },
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
    -- Base colors, in order of decreasing severity.
    -- The `LspDiagnosticsDefault*` highlight groups here are coming from Base16.
    pinnacle.link('DiagnosticError', 'LspDiagnosticsDefaultError') -- Red and scary.
    pinnacle.link('DiagnosticWarn', 'LspDiagnosticsDefaultWarning') -- Orange and attention-grabbing.
    pinnacle.set('DiagnosticInfo', {
      fg = pinnacle.fg('ModeMsg'), -- Green and friendly.
    })
    pinnacle.set('DiagnosticHint', {
      fg = pinnacle.fg('Special'), -- Blue/cyan and chirpy.
    })

    -- Sign column colors.
    pinnacle.set('DiagnosticSignError', {
      bg = pinnacle.bg('ColorColumn'),
      fg = pinnacle.embolden('DiagnosticError').fg,
    })
    pinnacle.set('DiagnosticSignHint', {
      bg = pinnacle.bg('ColorColumn'),
      fg = pinnacle.embolden('DiagnosticHint').fg,
    })
    pinnacle.set('DiagnosticSignInfo', {
      bg = pinnacle.bg('ColorColumn'),
      fg = pinnacle.embolden('DiagnosticInfo').fg,
    })
    pinnacle.set('DiagnosticSignWarn', {
      bg = pinnacle.bg('ColorColumn'),
      fg = pinnacle.embolden('DiagnosticWarn').fg,
    })

    -- Virtual text colors.
    pinnacle.set('DiagnosticVirtualTextError', pinnacle.decorate('italic,underline', 'DiagnosticError'))
    pinnacle.set('DiagnosticVirtualTextHint', pinnacle.decorate('italic,underline', 'DiagnosticHint'))
    pinnacle.set('DiagnosticVirtualTextInfo', pinnacle.decorate('italic,underline', 'DiagnosticInfo'))
    pinnacle.set('DiagnosticVirtualTextWarn', pinnacle.decorate('italic,underline', 'DiagnosticWarn'))

    -- Diagnostic float colors.
    pinnacle.set('DiagnosticFloatingError', pinnacle.italicize('DiagnosticError'))
    pinnacle.set('DiagnosticFloatingHint', pinnacle.italicize('DiagnosticHint'))
    pinnacle.set('DiagnosticFloatingInfo', pinnacle.italicize('DiagnosticInfo'))
    pinnacle.set('DiagnosticFloatingWarn', pinnacle.italicize('DiagnosticWarn'))
  end
end

return lsp

-- Testing diagnostics using Lua
-- (https://github.com/LuaLS/lua-language-server/wiki/Diagnostics)

-- Uncomment this to see an INFO diagnostic ("Global variable in lowecase
-- initial, Did you miss `local` or misspell it?"):

-- something = true

-- Uncomment this to see a HINT diagnostic ("Unused functions"):

-- local function example(); end

-- Uncomment this to see a WARN diangostic ("Compute `'hello' .. _.e` first. You
-- may need to add brackets"):

-- print('hello' .. _.e or 'World')

-- Uncomment this to see an ERROR diagnostic ("Unexpected <exp>"):

-- vim.....
