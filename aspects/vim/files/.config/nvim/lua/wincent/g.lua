-- Using a real global here to make sure anything stashed in here survives even
-- after the last reference to it goes away.
--
-- We use a lowercase variable name — even though the LSP doesn't like that
-- (it says "Global variable in lowercase initial") — to facilitate access via
-- `v:lua.wincent.g`.
--
-- But do note: if you use the global in this way, you should _still_
-- `require'wincent.g'` (or `require'wincent'` and then access
-- `wincent.g`), to ensure that the globals are initialized before any
-- access via `v:lua`.
--
wincent = {
  g = {
    autocommand_callbacks = {},
    map_callbacks = {},
  }
}

return wincent.g
