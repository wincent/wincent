local augroup = require('wincent.nvim.augroup')

local lsp = {}

local open_floating_preview = vim.lsp.util.open_floating_preview

local signs = {
  ERROR = '✖',
  WARN = '⚐',
  INFO = '𝒾',
  HINT = '✶',
  UNKNOWN = '•',
}

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function()
    -- Mnemonic: k = "kill (toggle) line diagnostics"
    vim.keymap.set('n', '<Leader>k', function()
      if vim.diagnostic.config().virtual_lines then
        vim.diagnostic.config({ virtual_lines = false })
      else
        vim.diagnostic.config({ virtual_lines = true })
      end
    end, { buffer = true, silent = true })

    -- Mnemonic: l = "toggle line diagnostics floating window"
    vim.keymap.set('n', '<Leader>l', function()
      vim.diagnostic.open_float({ border = 'single' })
    end, { buffer = true, silent = true })

    vim.keymap.set('n', '<c-]>', vim.lsp.buf.definition, { buffer = true, silent = true })
    vim.keymap.set('n', 'K', function()
      vim.lsp.buf.hover({ border = 'single' })
    end, { buffer = true, silent = true })
    vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, { buffer = true, silent = true })

    vim.wo.signcolumn = 'yes'
  end,
})

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
    -- Set up defaults, but beware that individual LSP configs may override
    -- these settings: https://github.com/neovim/nvim-lspconfig/issues/3827
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
                if vim.api.nvim_win_is_valid(window) then
                  vim.api.nvim_win_close(window, true)
                end
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
    })

    if vim.fn.executable('clangd') == 1 then
      vim.lsp.config('clangd', {
        settings = {
          clangd = {
            cmd = { 'clangd', '--background-index' },
          },
        },
      })
      vim.lsp.enable('clangd')
    end

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
    if vim.fn.executable('lua-language-server') == 1 then
      local config_directory = vim.fn.stdpath('config')

      --- @param a string A path
      --- @param b string A possible prefix matching or included in that path
      --- @return boolean Does path `a` include `b` as a prefix?
      local function has_prefix(a, b)
        return string.sub(a .. '/', 1, #(b .. '/')) == (b .. '/')
      end

      -- `nvim_get_runtime_file()` will return:
      --
      -- - The top-level config path (ie. "~/.config/nvim")
      -- - Special folders inside the top-level, like "~/.config/nvim/after"
      -- - Plug-in paths like "~/.config/nvim/pack/bundle/opt/command-t"
      -- - System paths like "/opt/homebrew/Cellar/neovim/0.11.2/share/nvim/runtime"
      --
      -- If we include paths that are nested inside other paths
      -- lua-language-server will actually read some files more than once, and
      -- produce spurious `duplicate-doc-field` diagnostics.
      --
      -- Additionally, passing our own config file or plug-in files into
      -- "workspace.library" is likely a misuse of the setting; the docs state
      -- it is for "library implementation code and definition files" (the later
      -- should generally be tagged with `@meta`, and not include executable Lua
      -- code).
      --
      -- So, filter out the main config path and anything that's under it. This
      -- is what definitively resolves the `duplicate-doc-field` diagnostics.
      --
      -- See:
      -- - https://github.com/neovim/nvim-lspconfig/issues/3189
      -- - https://github.com/LuaLS/lua-language-server/issues/2061
      -- - https://luals.github.io/wiki/settings/#workspacelibrary
      -- - https://luals.github.io/wiki/definition-files/
      local function get_library_directories(options)
        local filter = options and options.filter or false
        local runtime_directories = vim.api.nvim_get_runtime_file('', true)
        if filter then
          return vim.tbl_filter(function(path)
            -- Keep directory unless it coincides with the config directory (or
            -- is inside it).
            return not has_prefix(path, config_directory)
          end, runtime_directories)
        else
          return runtime_directories
        end
      end

      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            -- Found a root marker.
            local path = client.workspace_folders[1].name
            if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
              -- We have a ".luarc.json" (or ".luarc.jsonc"); defer to that.
              return
            end

            -- Is the workspace somewhere under "~/.nvim/config" or any runtime
            -- directory?
            local real_workspace_path = vim.uv.fs_realpath(path)
            local library_directories = get_library_directories()
            for _, library_directory in ipairs(library_directories) do
              local real_library_directory_path = vim.uv.fs_realpath(library_directory)
              if
                real_workspace_path
                and real_library_directory_path
                and has_prefix(real_workspace_path, real_library_directory_path)
              then
                -- Provide defaults for my common case (working on Neovim Lua).
                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                  diagnostics = {
                    enable = true,
                    globals = { 'vim' },
                  },
                  filetypes = { 'lua' },
                  runtime = {
                    path = {
                      -- Load modules the same was as Neovim does (see `:help lua-module-load`).
                      'lua/?.lua',
                      'lua/?/init.lua',
                    },
                    version = 'LuaJIT',
                  },
                  telemetry = {
                    -- Do not send telemetry data.
                    enable = false,
                  },
                  workspace = {
                    -- Make the server aware of Neovim runtime files.
                    library = get_library_directories({ filter = true }),
                    -- Stop "Do you need to configure your work environment as
                    -- `luassert`?" spam.
                    checkThirdParty = false,
                  },
                })
                return
              end
            end
          end
        end,
        root_markers = {
          { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml' },
          '.git',
        },
        settings = {
          Lua = {},
        },
      })
      vim.lsp.enable('lua_ls')
    end

    if vim.fn.executable('gopls') == 1 then
      vim.lsp.enable('gopls')
    end

    if vim.fn.executable('ocaml-language-server') == 1 then
      vim.lsp.enable('ocamlls')
    end

    if vim.fn.executable('rust-analyzer') == 1 then
      vim.lsp.enable('rust_analyzer')
    end

    if vim.fn.executable('typescript-language-server') == 1 then
      vim.lsp.enable('ts_ls')
    end

    if vim.fn.executable('vim-language-server') == 1 then
      vim.lsp.enable('vimls')
    end
  end

  augroup('wincent.lsp', function(autocmd)
    autocmd('ColorScheme', '*', function()
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
    end)
  end)
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
