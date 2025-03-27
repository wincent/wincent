local lsp = {}

local open_floating_preview = vim.lsp.util.open_floating_preview

local signs = {
  ERROR = '✖',
  WARN = '⚐',
  INFO = '𝒾',
  HINT = '✶',
  UNKNOWN = '•',
}

local get_window = function(bufnr)
  local windows = vim.fn.win_findbuf(bufnr)
  local tab = vim.api.nvim_get_current_tabpage()
  for _, window in ipairs(windows) do
    if tab == vim.api.nvim_win_get_tabpage(window) then
      return window
    end
  end
  return windows[1]
end

local on_attach = function()
  -- Mnemonic: ld = "(toggle) line diagnostics"
  vim.keymap.set('n', '<Leader>ld', function()
    if vim.diagnostic.config().virtual_lines then
      vim.diagnostic.config({ virtual_lines = false })
    else
      vim.diagnostic.config({ virtual_lines = true })
    end
  end, { buffer = true, silent = true })

  -- Mnemonic: ld = "(toggle) line diagnostics floating window"
  vim.keymap.set('n', '<LocalLeader>ld', '<cmd>lua vim.diagnostic.open_float()<CR>', { buffer = true, silent = true })

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

  vim.lsp.handlers['window/showMessage'] = function(_, result, _context, _config)
    if result.message:match('For performance reasons') then
      -- Suppress Lua LS spam:
      --
      --     LSP[lua_ls][Warning] For performance reasons, the parsing of this
      --     file has been stopped: file:///...
      return
    else
      vim.lsp.log.info(result.message)
    end
  end

  vim.diagnostic.config({
    float = {
      header = 'Diagnostics', -- Default is "Diagnostics:"
      prefix = function(diagnostic, i, total)
        if diagnostic.severity == vim.diagnostic.severity.ERROR then
          return (signs.ERROR .. ' '), ''
        elseif diagnostic.severity == vim.diagnostic.severity.HINT then
          return (signs.HINT .. ' '), ''
        elseif diagnostic.severity == vim.diagnostic.severity.INFO then
          return (signs.INFO .. ' '), ''
        elseif diagnostic.severity == vim.diagnostic.severity.WARN then
          return (signs.WARN .. ' '), ''
        else
          return (signs.UNKNOWN .. ' '), ''
        end
      end,
    },

    severity_sort = true,

    -- See also: https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#change-diagnostic-symbols-in-the-sign-column-gutter
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = signs.ERROR,
        [vim.diagnostic.severity.HINT] = signs.HINT,
        [vim.diagnostic.severity.INFO] = signs.INFO,
        [vim.diagnostic.severity.WARN] = signs.WARN,
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

    virtual_lines = true,
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
    -- - https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
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
    pinnacle.set('DiagnosticFloatingError', pinnacle.decorate('italic,bold', 'DiagnosticError'))
    pinnacle.set('DiagnosticFloatingHint', pinnacle.italicize('DiagnosticHint'))
    pinnacle.set('DiagnosticFloatingInfo', pinnacle.italicize('DiagnosticInfo'))
    pinnacle.set('DiagnosticFloatingWarn', pinnacle.italicize('DiagnosticWarn'))
  end
end

return lsp

-- Testing diagnostics using Lua
-- (https://github.com/LuaLS/lua-language-server/wiki/Diagnostics)

--[[

-- Line with an INFO diagnostic ("Global variable in lowecase initial, Did you
-- miss `local` or misspell it?"):

something = true

-- Line with a HINT diagnostic ("Unused functions"):

local function example(); end

-- Line with a WARN diangostic ("Compute `'hello' .. _.e` first. You may need to
-- add brackets"):

print('hello' .. _.e or 'World')

-- Line with an ERROR diagnostic ("Unexpected <exp>"):

vim.....

--]]
