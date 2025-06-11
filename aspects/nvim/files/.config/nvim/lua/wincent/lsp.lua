local lsp = {}

local open_floating_preview = vim.lsp.util.open_floating_preview

local signs = {
  ERROR = '✖',
  WARN = '⚐',
  INFO = '𝒾',
  HINT = '✶',
  UNKNOWN = '•',
}

local on_attach = function()
  -- Mnemonic: k = "kill (toggle) line diagnostics"
  vim.keymap.set('n', '<Leader>k', function()
    if vim.diagnostic.config().virtual_lines then
      vim.diagnostic.config({ virtual_lines = false })
    else
      vim.diagnostic.config({ virtual_lines = true })
    end
  end, { buffer = true, silent = true })

  -- Mnemonic: l = "toggle line diagnostics floating window"
  vim.keymap.set('n', '<Leader>l', vim.diagnostic.open_float, { buffer = true, silent = true })

  vim.keymap.set('n', '<c-]>', vim.lsp.buf.definition, { buffer = true, silent = true })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = true, silent = true })
  vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, { buffer = true, silent = true })

  vim.wo.signcolumn = 'yes'
end

local window = nil
local buffer = nil
local last_message = nil
local timer = nil

local function open_floating_window()
  local editor_height = vim.o.lines
  local editor_width = vim.o.columns
  local window_height = 1
  local window_width = math.max(1, math.floor(editor_width / 2))
  if buffer == nil or not vim.api.nvim_buf_is_valid(buffer) then
    buffer = vim.api.nvim_create_buf(false, true)
  end
  window = vim.api.nvim_open_win(buffer, false, {
    relative = 'editor',
    width = window_width,
    height = window_height,
    row = editor_height - window_height - 4,
    col = editor_width - window_width - 2,
    style = 'minimal',
    border = 'rounded',
  })

  vim.api.nvim_set_option_value('winblend', 75, {
    scope = 'local',
    win = window,
  })
end

lsp.init = function()
  -- Global override, from https://github.com/neovim/nvim-lspconfig/wiki/UI-customization
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'single'
    return open_floating_preview(contents, syntax, opts, ...)
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

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if has_cmp_nvim_lsp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  local has_lspconfig = pcall(require, 'lspconfig')
  if has_lspconfig then
    vim.lsp.config('*', {
      capabilities = capabilities,
      handlers = {
        ['$/progress'] = function(_, result, _context, _config)
          local message = nil
          if result and result.value then
            if result.value.kind == 'begin' and result.value.title then
              message = tostring(result.value.title)
            elseif result.value.kind == 'end' then
              -- Nothing...
            elseif result.value.kind == 'report' and result.value.message then
              message = tostring(result.value.message)
              if result.value.percentage and result.value.percentage > 0 then
                message = string.format('%s (%d%%)', message, result.value.percentage)
              end
            end
          end
          if message and message ~= last_message then
            if window == nil then
              open_floating_window()
            end
            vim.api.nvim_buf_set_lines(buffer, 0, 1, false, { message })
            last_message = message

            if timer then
              timer:stop()
            end

            timer = vim.defer_fn(function()
              if window then
                vim.api.nvim_win_close(window, true)
                window = nil
                last_message = nil
              end
            end, 1000)
          end
        end,
        ['window/showMessage'] = function(_, result, _context, _config)
          if result.message:match('For performance reasons') then
            -- Suppress Lua LS spam:
            --
            --     LSP[lua_ls][Warning] For performance reasons, the parsing of this
            --     file has been stopped: file:///...
            return
          else
            vim.lsp.log.info(result.message)
          end
        end,
      },
      on_attach = on_attach,
    })

    vim.lsp.config('clangd', {
      settings = {
        clangd = {
          cmd = { 'clangd', '--background-index' },
        },
      },
    })
    vim.lsp.enable('clangd')

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
      vim.lsp.config('lua_ls', {
        cmd = { cmd },
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
      vim.lsp.enable('lua_ls')
    end

    vim.lsp.enable('gopls')
    vim.lsp.enable('ocamlls')
    vim.lsp.enable('rust_analyzer')
    vim.lsp.enable('ts_ls')
    vim.lsp.enable('vimls')
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

    -- Virtual lines colors
    pinnacle.set('DiagnosticVirtualLinesError', pinnacle.italicize('DiagnosticError'))
    pinnacle.set('DiagnosticVirtualLinesHint', pinnacle.italicize('DiagnosticHint'))
    pinnacle.set('DiagnosticVirtualLinesInfo', pinnacle.italicize('DiagnosticInfo'))
    pinnacle.set('DiagnosticVirtualLinesWarn', pinnacle.italicize('DiagnosticWarn'))

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
