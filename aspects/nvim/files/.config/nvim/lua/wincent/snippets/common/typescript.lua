local luasnip = require('luasnip')
local fmt = require('luasnip.extras.fmt').fmt
local docblock = require('wincent.snippets.common.docblock')

local d = luasnip.dynamic_node
local i = luasnip.insert_node
local s = luasnip.snippet
local sn = luasnip.snippet_node

-- Snippets common to JS and TS.
local snippets = {
  -- TODO: make these smart about whether to use trailing semi or
  -- not, based on directory (or maybe .editorconfig)
  s(
    { trig = 'import', dscr = 'import statement' },
    fmt("import {} from '{}{}';", {
      i(1, 'name'),
      i(2),
      d(3, function(nodes)
        local text = nodes[1][1]
        local _, _, typish, target = text:find('^%s*(%a*)%s*{?%s*(%a+).*}?%s*$')
        if typish == 'type' and target then
          return sn(1, { i(1, target) })
        elseif typish and target then
          return sn(1, { i(1, typish .. target) })
        else
          return sn(1, { i(1, 'specifier') })
        end
      end, { 1 }),
    })
  ),
  s({ trig = 'log', dscr = 'console.log' }, fmt('console.log({});', { i(1, 'value') })),
  s(
    { trig = 'require', dscr = 'require statement' },
    fmt("const {} = require('{}{}');", {
      i(1, 'name'),
      i(2),
      d(3, function(nodes)
        local text = nodes[1][1]
        return sn(1, { i(1, text) })
      end, { 1 }),
    })
  ),
}

-- Can't use `vim.tbl_flatten` to concat `docblock` and these snippets; it will
-- silently fail, producing an empty list. 🤦 Seems to only work for primitive
-- values.
for _, value in ipairs(docblock) do
  table.insert(snippets, value)
end

return snippets
