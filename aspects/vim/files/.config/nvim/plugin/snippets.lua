local ok = pcall(function ()
  local ls = require'luasnip'
  local s = ls.s
  local sn = ls.sn
  local t = ls.t
  local i = ls.i
  local f = ls.f
  local c = ls.c
  local d = ls.d

  ls.snippets = {
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
        -- TODO: decide whether i want regex match or req etc
        {trig = 'require', dscr = 'require statement', --[[regTrig = true--]]},
        {t('const '),
        i(1, 'ModuleName'),
        t(" = require('"),
        d(2, function (nodes)
          return sn(1, {i(1, nodes[1][1])})
        end, {1}),
        t("');"),
      }
      ),
    },
  }
end)

if not ok then
  print('luasnip setup failed')
end
