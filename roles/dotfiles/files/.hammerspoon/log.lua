--
-- Simple logging facility.
--

local logLevel = 'info' -- generally want 'debug' or 'info'
local log = hs.logger.new('wincent', logLevel)

return {
  w = log.w
}
