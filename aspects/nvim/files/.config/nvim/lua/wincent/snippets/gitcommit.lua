local luasnip = require('luasnip')
local fmt = require('luasnip.extras.fmt').fmt

local i = luasnip.insert_node
local s = luasnip.snippet

-- If ~/.github-handles.json exists, use it.
local cab = (vim.fn.filereadable(vim.fn.expand('~/.github-handles.json')) == 1) and
  fmt('Co-Authored-By: {}', {
    i(1, '@handle'),
  }) or
  fmt('Co-Authored-By: {} <{}@{}>', {
    i(1, 'Name'),
    i(2, 'user'),
    i(3, 'github.com'),
  })

luasnip.add_snippets('gitcommit', {
  s(
    {trig = 'cab', dscr = 'Co-Authored-By:'},
    cab
  ),
})
