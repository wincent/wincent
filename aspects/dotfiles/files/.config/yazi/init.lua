--
-- Plug-ins.
--

require('full-border'):setup()

--
-- Additions
--

-- Show owner:group in status bar.
--
-- See: https://yazi-rs.github.io/docs/tips#user-group-in-status
Status:children_add(function()
  local h = cx.active.current.hovered
  if h == nil or ya.target_family() ~= 'unix' then
    return ui.Line({})
  end

  return ui.Line({
    ui.Span(' '),
    ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg('magenta'),
    ui.Span(':'),
    ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg('magenta'),
    ui.Span(' '),
  })
end, 500, Status.RIGHT)

--
-- Overrides.
--

-- Make `Entity:symlink()` render "→" instead of "->".
--
-- Original: https://github.com/sxyazi/yazi/blob/99ea3b74c4260a72/yazi-plugin/preset/components/entity.lua
function Entity:symlink()
  if not rt.mgr.show_symlink then
    return ''
  end

  local to = self._file.link_to
  return to and ui.Span(string.format(' → %s', to)):style(th.mgr.symlink_target) or ''
end

-- Make status bar show symlink target.
--
-- See: https://yazi-rs.github.io/docs/tips#symlink-in-status
--
-- Original: https://github.com/sxyazi/yazi/blob/7c445cef1fd9f/yazi-plugin/preset/components/status.lua#L60-L67
function Status:name()
  local h = self._tab.current.hovered
  if not h then
    return ui.Line({})
  end

  local linked = ui.Span('')
  if h.link_to ~= nil then
    linked = ui.Span(' → ' .. tostring(h.link_to)):italic()
  end
  return ui.Line({ ui.Span(' ' .. h.name), linked })
end
