local has_cmp, cmp = pcall(require, 'cmp')

if has_cmp then
  local rhs = wincent.vim.rhs
  local has_luasnip, luasnip = pcall(require, 'luasnip')

  -- Icons from font bundled with kitty, as shown by `kitty
  -- --debug-font-fallback`:
  --
  --      [3.235] U+eb62 Face(family=Symbols Nerd Font Mono,
  --      full_name=Symbols Nerd Font Mono, postscript_name=SymbolsNFM,
  --      path=/Applications/kitty.app/Contents/Resources/kitty/fonts/SymbolsNerdFontMono-Regular.ttf,
  --      units_per_em=2048, ascent=22.4, descent=5.6, leading=0.0,
  --      scaled_point_sz=28.0, underline_position=-3.5 underline_thickness=1.4)
  --
  local lsp_kinds = {
    Class = ' ',
    Color = ' ',
    Constant = ' ',
    Constructor = ' ',
    Enum = ' ',
    EnumMember = ' ',
    Event = ' ',
    Field = ' ',
    File = ' ',
    Folder = ' ',
    Function = ' ',
    Interface = ' ',
    Keyword = ' ',
    Method = ' ',
    Module = ' ',
    Operator = ' ',
    Property = ' ',
    Reference = ' ',
    Snippet = ' ',
    Struct = ' ',
    Text = ' ',
    TypeParameter = ' ',
    Unit = ' ',
    Value = ' ',
    Variable = ' ',
  }

  -- Returns the current column number.
  local column = function()
    local _line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col
  end

  -- Based on (private) function in LuaSnip/lua/luasnip/init.lua.
  local in_snippet = function()
    local session = require('luasnip.session')
    local node = session.current_nodes[vim.api.nvim_get_current_buf()]
    if not node then
      return false
    end
    local snippet = node.parent.snippet
    local snip_begin_pos, snip_end_pos = snippet.mark:pos_begin_end()
    local pos = vim.api.nvim_win_get_cursor(0)
    if pos[1] - 1 >= snip_begin_pos[1] and pos[1] - 1 <= snip_end_pos[1] then
      return true
    end
  end

  -- Returns true if the cursor is in leftmost column or at a whitespace
  -- character.
  local in_whitespace = function()
    local col = column()
    return col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')
  end

  local shift_width = function()
    if vim.o.softtabstop <= 0 then
      return vim.fn.shiftwidth()
    else
      return vim.o.softtabstop
    end
  end

  -- Complement to `smart_tab()`.
  --
  -- When 'noexpandtab' is set (ie. hard tabs are in use), backspace:
  --
  --    - On the left (ie. in the indent) will delete a tab.
  --    - On the right (when in trailing whitespace) will delete enough
  --      spaces to get back to the previous tabstop.
  --    - Everywhere else it will just delete the previous character.
  --
  -- For other buffers ('expandtab'), we let Neovim behave as standard and that
  -- yields intuitive behavior.
  local smart_bs = function()
    if vim.o.expandtab then
      return rhs('<BS>')
    else
      local col = column()
      local line = vim.api.nvim_get_current_line()
      local prefix = line:sub(1, col)
      local in_leading_indent = prefix:find('^%s*$')
      if in_leading_indent then
        return rhs('<BS>')
      end
      local previous_char = prefix:sub(#prefix, #prefix)
      if previous_char ~= ' ' then
        return rhs('<BS>')
      end
      -- Delete enough spaces to take us back to the previous tabstop.
      --
      -- Originally I was calculating the number of <BS> to send, but
      -- Neovim has some special casing that causes one <BS> to delete
      -- multiple characters even when 'expandtab' is off (eg. if you hit
      -- <BS> after pressing <CR> on a line with trailing whitespace and
      -- Neovim inserts whitespace to match.
      --
      -- So, turn 'expandtab' on temporarily and let Neovim figure out
      -- what a single <BS> should do.
      --
      -- See `:h i_CTRL-\_CTRL-O`.
      return rhs('<C-\\><C-o>:set expandtab<CR><BS><C-\\><C-o>:set noexpandtab<CR>')
    end
  end

  -- In buffers where 'noexpandtab' is set (ie. hard tabs are in use), <Tab>:
  --
  --    - Inserts a tab on the left (for indentation).
  --    - Inserts spaces everywhere else (for alignment).
  --
  -- For other buffers (ie. where 'expandtab' applies), we use spaces everywhere.
  local smart_tab = function(opts)
    local keys = nil
    if vim.o.expandtab then
      keys = '<Tab>' -- Neovim will insert spaces.
    else
      local col = column()
      local line = vim.api.nvim_get_current_line()
      local prefix = line:sub(1, col)
      local in_leading_indent = prefix:find('^%s*$')
      if in_leading_indent then
        keys = '<Tab>' -- Neovim will insert a hard tab.
      else
        -- virtcol() returns last column occupied, so if cursor is on a
        -- tab it will report `actual column + tabstop` instead of `actual
        -- column`. So, get last column of previous character instead, and
        -- add 1 to it.
        local sw = shift_width()
        local previous_char = prefix:sub(#prefix, #prefix)
        local previous_column = #prefix - #previous_char + 1
        local current_column = vim.fn.virtcol({ vim.fn.line('.'), previous_column }) + 1
        local remainder = (current_column - 1) % sw
        local move = remainder == 0 and sw or sw - remainder
        keys = (' '):rep(move)
      end
    end

    vim.api.nvim_feedkeys(rhs(keys), 'nt', true)
  end

  local select_next_item = function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    else
      fallback()
    end
  end

  local select_prev_item = function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end

  cmp.setup({
    experimental = {
      -- See also `toggle_ghost_text()` below.
      ghost_text = true,
    },

    formatting = {
      -- See: https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
      format = function(entry, vim_item)
        -- Set `kind` to "$icon $kind".
        vim_item.kind = string.format('%s %s', lsp_kinds[vim_item.kind], vim_item.kind)
        vim_item.menu = ({
          buffer = '[Buffer]',
          nvim_lsp = '[LSP]',
          luasnip = '[LuaSnip]',
          nvim_lua = '[Lua]',
          latex_symbols = '[LaTeX]',
        })[entry.source.name]
        return vim_item
      end,
    },

    mapping = {
      ['<BS>'] = cmp.mapping(function(_fallback)
        local keys = smart_bs()
        vim.api.nvim_feedkeys(keys, 'nt', true)
      end, { 'i', 's' }),

      ['<C-b>'] = cmp.mapping.scroll_docs(-4),

      -- Choose a choice using vim.ui.select (ugh);
      -- prettier would be a pop-up, but it will require a bit of config:
      -- https://github.com/L3MON4D3/LuaSnip/wiki/Misc#choicenode-popup
      -- ['<C-u>'] = require('luasnip.extras.select_choice'),

      ['<C-e>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.close()
        elseif has_luasnip and luasnip.choice_active() then
          luasnip.jump(1)
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-j>'] = cmp.mapping(select_next_item),
      ['<Down>'] = cmp.mapping(select_next_item),
      ['<C-k>'] = cmp.mapping(select_prev_item),
      ['<Up>'] = cmp.mapping(select_prev_item),

      ['<C-y>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif has_luasnip and in_snippet() and luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<Tab>'] = cmp.mapping(function(_fallback)
        if cmp.visible() then
          -- If there is only one completion candidate, use it.
          if #cmp.get_entries() == 1 then
            cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
          else
            cmp.select_next_item()
          end
        elseif has_luasnip and luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        elseif in_whitespace() then
          smart_tab()
        else
          cmp.complete()
        end
      end, { 'i', 's' }),
    },

    completion = {
      completeopt = 'menu,menuone,noinsert',
    },

    snippet = {
      expand = function(args)
        if has_luasnip then
          luasnip.lsp_expand(args.body)
        end
      end,
    },

    sources = cmp.config.sources({
      { name = 'luasnip' },
      { name = 'nvim_lsp' },
      { name = 'nvim_lua' },
      { name = 'buffer' },
      { name = 'calc' },
      { name = 'emoji' },
      { name = 'path' },
    }),

    window = {
      completion = cmp.config.window.bordered({
        col_offset = -1,
        scrollbar = false,
        scrolloff = 3,
        -- Default for bordered() is 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None'
        -- Default for non-bordered, which we'll use here, is:
        winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
      }),
      documentation = cmp.config.window.bordered({
        scrollbar = false,
        -- Default for bordered() is 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None'
        -- Default for non-bordered is 'FloatBorder:NormalFloat'
        -- Suggestion from: https://github.com/hrsh7th/nvim-cmp/issues/2042
        -- is to use 'NormalFloat:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None'
        -- but this also seems to suffice:
        winhighlight = 'CursorLine:Visual,Search:None',
      }),
    },
  })

  -- Only show ghost text at word boundaries, not inside keywords. Based on idea
  -- from: https://github.com/hrsh7th/nvim-cmp/issues/2035#issuecomment-2347186210

  local config = require('cmp.config')

  local toggle_ghost_text = function()
    if vim.api.nvim_get_mode().mode ~= 'i' then
      return
    end

    local cursor_column = vim.fn.col('.')
    local current_line_contents = vim.fn.getline('.')
    local character_after_cursor = current_line_contents:sub(cursor_column, cursor_column)

    local should_enable_ghost_text = character_after_cursor == '' or vim.fn.match(character_after_cursor, [[\k]]) == -1

    config.set_onetime({
      experimental = {
        ghost_text = should_enable_ghost_text,
      },
    })
  end

  vim.api.nvim_create_autocmd({ 'InsertEnter', 'CursorMovedI' }, {
    callback = toggle_ghost_text,
  })
end
