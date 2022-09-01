local luasnip = require('luasnip')
local fmt = require('luasnip.extras.fmt').fmt

local s = luasnip.snippet

luasnip.add_snippets('spec', {
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
})
