-- http://stackoverflow.com/a/39348498/2103996
local registers = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"'

--- Empties every writable register.
local function clearregisters()
  for i = 1, #registers do
    vim.fn.setreg(registers:sub(i, i), {})
  end
end

return clearregisters
