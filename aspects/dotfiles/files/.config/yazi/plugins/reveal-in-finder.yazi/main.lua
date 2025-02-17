return {
  entry = function()
    local h = cx.active.current.hovered
    if h then
      local quoted_path = ya.quote(tostring(h.url))
      if h.cha.is_dir then
        ya.manager_emit('shell', { 'open ' .. quoted_path, confirm = true })
      else
        ya.manager_emit('shell', { 'open -R ' .. quoted_path, confirm = true })
      end
    end
  end,
}
