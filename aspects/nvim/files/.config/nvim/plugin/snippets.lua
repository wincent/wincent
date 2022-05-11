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
  })

  -- Snippets common to JS and TS.
  local js_ts = {
    -- TODO: make these smart about whether to use trailing semi or
    -- not, based on directory (or maybe .editorconfig)
    s(
      {trig = 'import', dscr = 'import statement'},
      {t('import'),
      c(1, {t(' '), t(' type ')}),
      i(2, 'ModuleName'),
      t(" from '"),
      i(3),
      d(4, function (nodes)
        local text = nodes[1][1]
        return sn(1, {i(1, text)})
      end, {2}),
      t("';"),
      i(0)
    }
    ),
    s(
      {trig = 'log', dscr = 'console.log'},
      {t('console.log('), i(1, 'value'), t(');')}
    ),
    s(
      {trig = 'require', dscr = 'require statement'},
      {t('const '),
      i(1, 'ModuleName'),
      t(" = require('"),
      i(2),
      d(3, function (nodes)
        return sn(1, {i(1, nodes[1][1])})
      end, {1}),
      t("');"),
      i(0)
    }
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
        {t('| '), i(1, 'First Header'), t({'  | Second Header |',
          '| ------------- | ------------- |',
          '| Content Cell  | Content Cell  |',
          '| Content Cell  | Content Cell  |',
        })}
      )
    },
    javascript = js_ts,
    jest = {
      s(
        {trig = 'describe', dscr = 'describe()'},
        {t("describe('"), i(1, 'description'), t({"', () => {", '  '}), i(2, '// Body.'), t({'', '});'})}
      ),
      s(
        {trig = 'it', dscr = 'it()'},
        {t("it('"), i(1, 'description'), t({"', () => {", '  '}), i(2, '// Body.'), t({'', '});'})}
      ),
    },
    markdown = {
      s(
        {trig = 'frontmatter', dscr = 'Document frontmatter'},
        {t({'---', 'tags: '}), i(1, 'value'), t({'', '---', ''})}
      ),
    },
    spec = {
      s(
        {trig = 'context', dscr = 'Test context block'},
        {t('context "'), i(1, 'description'), t({'" do', '  '}), i(2, '# body'), t({'', 'end'})}
      ),
      s(
        {trig = 'test', dscr = 'Test block'},
        {t('test "'), i(1, 'description'), t({'" do', '  '}), i(2, '# body'), t({'', 'end'})}
      ),
    },
    typescript = js_ts,
  }
end
