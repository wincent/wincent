-- Workaround to enable karabiner-kill to be called from a Karabiner shell_command:
-- https://github.com/tekezo/Karabiner-Elements/issues/1573

tell application "Terminal"
  activate
  do script "/bin/sh ~/bin/karabiner-kill"
end tell
