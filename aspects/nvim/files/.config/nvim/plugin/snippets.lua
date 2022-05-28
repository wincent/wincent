local has_luasnip, luasnip = pcall(require, 'luasnip')
if has_luasnip then
  local s = luasnip.snippet
  local sn = luasnip.snippet_node
  local t = luasnip.text_node
  local i = luasnip.insert_node
  local f = luasnip.function_node
  local c = luasnip.choice_node
  local d = luasnip.dynamic_node
  local r = luasnip.restore_node
  local types = require('luasnip.util.types')
  local fmt = require('luasnip.extras.fmt').fmt

  luasnip.config.setup({
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = {{"← Choice", "Todo"}},
        },
      },
      -- [types.insertNode] = {
      --   active = {
      --     virt_text = {{"← ...", "Todo"}},
      --   },
      -- },
    },
    store_selection_keys="<Tab>",
    update_events="InsertLeave,TextChangedI",
  })

  -- If ~/.github-handles.json exists, use it.
  local cob = (vim.fn.filereadable(vim.fn.expand('~/.github-handles.json')) == 1) and
    fmt('Co-Authored-By: {}', {
      i(1, '@handle'),
    }) or
    fmt('Co-Authored-By: {} <{}@{}>', {
      i(1, 'Name'),
      i(2, 'user'),
      i(3, 'github.com'),
    })

  -- Snippets common to JS and TS.
  local js_ts = {
    -- TODO: make these smart about whether to use trailing semi or
    -- not, based on directory (or maybe .editorconfig)
    s(
      {trig = 'import', dscr = 'import statement'},
      fmt("import {} from '{}{}';", {
        i(1, 'name'),
        i(2),
        d(3, function (nodes)
          local text = nodes[1][1]
          local _, _, typish, target = text:find("^%s*(%a*)%s*{?%s*(%a+).*}?%s*$")
          if typish == 'type' and target then
            return sn(1, {i(1, target)})
          elseif typish and target then
            return sn(1, {i(1, typish .. target)})
          else
            return sn(1, {i(1, 'specifier')})
          end
        end, {1}),
      })
    ),
    s(
      {trig = 'log', dscr = 'console.log'},
      fmt('console.log({});', {i(1, 'value')})
    ),
    s(
      {trig = 'require', dscr = 'require statement'},
      fmt("const {} = require('{}{}');", {
        i(1, 'name'),
        i(2),
        d(3, function (nodes)
          local text = nodes[1][1]
          return sn(1, {i(1, text)})
        end, {1}),
      })
    ),
    s(
      {trig = '**', dscr = 'docblock'},
      {
        t({'/**', ''}),
        f(function (args, snip)
          local lines = vim.tbl_map(
            function(line)
              return ' * ' .. vim.trim(line)
            end,
            snip.env.SELECT_RAW
          )
          if #lines == 0 then
            return ' * '
          else
            return lines
          end
        end, {}),
        i(1),
        t({'', ' */'}),
      }
    ),
  }

  luasnip.snippets = {
    all = {
      s(
        {trig = 'lorem', dscr = 'Lorem ipsum'},
        t('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
      ),
      s(
        -- TODO: can probably make this one much smarter; right now it's basically just syntax reminder
        {trig = 'table', dscr = 'Table template'},
        fmt([[
          | {}  | Second Header |
          | ------------- | ------------- |
          | Content Cell  | Content Cell  |
          | Content Cell  | Content Cell  |
        ]], {
          i(1, 'First Header'),
        })
      )
    },
    gitcommit = {
      s(
        {trig = 'cob', dscr = 'Co-Authored-By:'},
        cob
      ),
    },
    javascript = js_ts,
    jest = {
      s(
        {trig = 'describe', dscr = 'describe()'},
        fmt([[
          describe('{}', () => {{
            {}{}
          }});
        ]], {
          i(1, 'description'),
          i(2, '// Body.'),
          i(0),
        })
      ),
      s(
        {trig = 'it', dscr = 'it()'},
        fmt([[
          it('{}', () => {{
            {}{}
          }});
        ]], {
          i(1, 'description'),
          i(2, '// Body.'),
          i(0),
        })
      ),
    },
    markdown = {
      s(
        {trig = 'frontmatter', dscr = 'Document frontmatter'},
        fmt([[
          ---
          tags: {}
          ---

        ]],
        {
          i(1, 'value')
        })
      ),
    },
    spec = {
      s(
        {trig = 'context', dscr = 'Test context block'},
        fmt([[
          context "{}" do
            {}{}
          end
        ]], {
          i(1, 'description'),
          i(2, '# body'),
          i(0),
        })
      ),
      s(
        {trig = 'test', dscr = 'Test block'},
        fmt([[
          test "{}" do
            {}{}
          end
        ]], {
          i(1, 'description'),
          i(2, '# body'),
          i(0),
        })
      ),
    },
    typescript = js_ts,
  }
end
