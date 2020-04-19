--
-- Simple logging facility.
--

-- Possible values, from most to least verbose:
--
--   - verbose
--   - debug
--   - info
--   - warning (the Hammerspoon default)
--   - error
--   - nothing
--
local logLevel = 'info'

local log = hs.logger.new('wincent', logLevel)

local module = {
  d = log.d,
  df = log.df,
  i = log.i,
  w = log.w,
  wf = log.wf,

  -- Convenience methods, simpler than doing this in the console:
  --
  --   hs.logger.setGlobalLogLevel('debug')
  --
  debug = (function() log.setLogLevel('debug') end),
  info = (function() log.setLogLevel('info') end),
  verbose = (function() log.setLogLevel('verbose') end),
  warning = (function() log.setLogLevel('warning') end),
  error = (function() log.setLogLevel('error') end),
  nothing = (function() log.setLogLevel('nothing') end),
}

-- Add this separately in order to avoid a syntax error.
module['if'] = log['if']

return module
