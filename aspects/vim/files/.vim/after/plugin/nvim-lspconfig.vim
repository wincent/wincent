if !has('nvim')
  finish
endif

lua << END
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
  --     https://github.com/neovim/nvim-lspconfig/blob/master/lua/nvim_lsp/sumneko_lua.lua
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
    require'nvim_lsp'.sumneko_lua.setup{
      cmd = {cmd, '-E', main},
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

  require'nvim_lsp'.ocamlls.setup{}

  require'nvim_lsp'.tsserver.setup{
    -- cmd = {
    --   "typescript-language-server",
    --   "--stdio",
    --   "--tsserver-log-file",
    --   "tslog"
    -- }
  }

  require'nvim_lsp'.vimls.setup{}

  -- Override hover winhighlight.
  local method = 'textDocument/hover'
  local hover = vim.lsp.callbacks[method]
  vim.lsp.callbacks[method] = function (_, method, result)
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
END

function! s:Bind()
  try
    if nvim_win_get_var(0, 'textDocument/hover')
      nnoremap <buffer> <silent> K :call nvim_win_close(0, v:true)<CR>
      nnoremap <buffer> <silent> <Esc> :call nvim_win_close(0, v:true)<CR>

      setlocal nocursorline

      " I believe this is supposed to happen automatically because I can see
      " this in lsp/util.lua:
      "
      "     api.nvim_buf_set_option(floating_bufnr, 'modifiable', false)
      "
      " but it doesn't seem to be working.
      setlocal nomodifiable
    endif
  catch /./
    " Not a hover window.
  endtry
endfunction

function! s:ConfigureBuffer()
    nnoremap <buffer> <silent> <Leader>ld <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
    nnoremap <buffer> <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <buffer> <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <buffer> <silent> gd <cmd>lua vim.lsp.buf.declaration()<CR>

    if exists('+signcolumn')
      setlocal signcolumn=yes
    endif
endfunction

function! s:SetUpLspHighlights()
  if !wincent#pinnacle#active()
    return
  endif

  execute 'highlight LspDiagnosticsError ' . pinnacle#decorate('italic,underline', 'ModeMsg')

  execute 'highlight LspDiagnosticsHint ' . pinnacle#decorate('bold,italic,underline', 'Type')

  execute 'highlight LspDiagnosticsHintSign ' . pinnacle#highlight({
        \   'bg': pinnacle#extract_bg('ColorColumn'),
        \   'fg': pinnacle#extract_fg('Type')
        \ })

  execute 'highlight LspDiagnosticsErrorSign ' . pinnacle#highlight({
        \   'bg': pinnacle#extract_bg('ColorColumn'),
        \   'fg': pinnacle#extract_fg('ErrorMsg')
        \ })
endfunction

sign define LspDiagnosticsErrorSign text=✖
sign define LspDiagnosticsWarningSign text=⚠
sign define LspDiagnosticsInformationSign text=ℹ
sign define LspDiagnosticsHintSign text=➤

if has('autocmd')
  augroup WincentLanguageClientAutocmds
    autocmd!

    autocmd WinEnter * call s:Bind()

    autocmd FileType javascript,lua,typescript,vim  call s:ConfigureBuffer()

    autocmd ColorScheme * call s:SetUpLspHighlights()
  augroup END
endif
