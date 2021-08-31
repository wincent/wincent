local has_luasnip, luasnip = pcall(require, 'luasnip')
if has_luasnip then
  local s = luasnip.s
  local sn = luasnip.sn
  local t = luasnip.t
  local i = luasnip.i
  local f = luasnip.f
  local c = luasnip.c
  local d = luasnip.d

  luasnip.snippets = {
    all = {
      s(
        {trig = 'lorem', dscr = 'Lorem ipsum'},
        t('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
      ),
    },
    javascript = {
      -- TODO: make these smart about whether to use trailing semi or
      -- not, based on directory (or maybe .editorconfig)
      s(
        {trig = 'log', dscr = 'console.log'},
        {t('console.log('), i(1, 'value'), t(');')}
      ),
      s(
        {trig = 'require', dscr = 'require statement'},
        {t('const '),
        i(1, 'ModuleName'),
        t(" = require('"),
        d(2, function (nodes)
          return sn(1, {i(1, nodes[1][1])})
        end, {1}),
        t("');"),
      }
      ),
      -- TODO: In the future, when LuaSnip properly supports `VISUAL` without
      -- hacks (see: https://github.com/L3MON4D3/LuaSnip/issues/89#issuecomment-887458603),
      -- bring this up to parity with what I had in UltiSnips.
      s(
        {trig = '**', dscr = 'docblock'},
        {
          t({'/**', ' * '}),
          i(1, 'docblock'),
          t({'', ' */'}),
        }
      ),
    },
    markdown = {
      s(
        {trig = 'frontmatter', dscr = 'Document frontmatter'},
        {t({'---', 'tags: '}), i(1, 'value'), t({'', '---', ''})}
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
    ruby = {
      -- TODO: make these apply to test files only
      s(
        {trig = 'con', dscr = 'Test context block'},
        {t('context "'), i(1, 'description'), t({'" do', '  '}), i(2, '# body'), t({'', 'end'})}
      ),
      s(
        {trig = 'test', dscr = 'Test block'},
        {t('test "'), i(1, 'description'), t({'" do', '  '}), i(2, '# body'), t({'', 'end'})}
      ),
    },
  }
end
