local luasnip = require('luasnip')

local f = luasnip.function_node
local i = luasnip.insert_node
local s = luasnip.snippet
local t = luasnip.text_node

return {
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
