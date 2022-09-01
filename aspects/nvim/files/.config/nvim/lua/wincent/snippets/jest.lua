local luasnip = require('luasnip')
local fmt = require('luasnip.extras.fmt').fmt

local s = luasnip.snippet

luasnip.add_snippets('jest', {
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
})
