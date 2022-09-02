--
-- Prevent unwanted GC by attaining a global reference to a value.
--

__globals = {}

return function(value)
  __globals[#__globals + 1] = value
  return value
end
