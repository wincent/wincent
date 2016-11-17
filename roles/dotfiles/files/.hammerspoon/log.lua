--
-- Simple logging facility.
--

local logLevel = 'info' -- generally want 'debug' or 'info'
local log = hs.logger.new('wincent', logLevel)

return {
  i = log.i,
  w = log.w,
}
