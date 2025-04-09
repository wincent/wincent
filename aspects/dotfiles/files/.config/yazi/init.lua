--
-- Plug-ins.
--

require('full-border'):setup()

--
-- Additions
--

-- Make status bar show symlink target.
--
-- See: https://yazi-rs.github.io/docs/tips#symlink-in-status
--
Status:children_add(function(self)
  local h = self._current.hovered
  if h and h.link_to then
    return ui.Span(string.format(' → %s', tostring(h.link_to))):style(th.mgr.symlink_target) or ''
  else
    return ''
  end
end, 3300, Status.LEFT)

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
