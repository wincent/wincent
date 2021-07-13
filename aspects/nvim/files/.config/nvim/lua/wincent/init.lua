local autoload = require'wincent.autoload'

local wincent = autoload('wincent')

-- Using a real global here to make sure anything stashed in here (and
-- in `wincent.g`) survives even after the last reference to it goes away.
_G.wincent = wincent

return wincent
