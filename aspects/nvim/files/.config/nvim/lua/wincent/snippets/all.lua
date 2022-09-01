local luasnip = require('luasnip')
local fmt = require('luasnip.extras.fmt').fmt

local i = luasnip.insert_node
local s = luasnip.snippet
local t = luasnip.text_node

luasnip.add_snippets('all', {
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
  ),
})
