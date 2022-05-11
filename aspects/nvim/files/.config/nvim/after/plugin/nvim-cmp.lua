local has_cmp, cmp = pcall(require, 'cmp')

if has_cmp then
  local rhs = wincent.vim.rhs
  local has_luasnip, luasnip = pcall(require, 'luasnip')

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
  local smart_bs = function ()
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
        local current_column = vim.fn.virtcol({vim.fn.line('.'), previous_column}) + 1
        local remainder = (current_column - 1) % sw
        local move = remainder == 0 and sw or sw - remainder
        keys = (' '):rep(move)
      end
    end

    vim.api.nvim_feedkeys(rhs(keys), 'nt', true)
  end

  cmp.setup {
    mapping = {
      ['<BS>'] = cmp.mapping(function(_fallback)
        local keys = smart_bs()
        vim.api.nvim_feedkeys(keys, 'nt', true)
      end, { 'i', 's' }),

      ['<C-e>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.close()
        elseif has_luasnip and luasnip.choice_active() then
          luasnip.jump(1)
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<C-j>'] = cmp.get_config().mapping['<Down>'],
      ['<C-k>'] = cmp.get_config().mapping['<Up>'],

      ['<C-y>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = true })
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
            cmp.confirm({ select = true })
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
      documentation = cmp.config.window.bordered(),
    },
  }
end
