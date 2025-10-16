#!/usr/bin/env fish

# ----------------------------------------------------------------------
# Setup config variables and env
# ----------------------------------------------------------------------

# Allow users to optionally configure their tmux plugin path and set the
# value if one doesn't exist. This runs each time a script is switched
# so it's important to check for previously set values.

if test -z "$BASE16_SHELL_TMUXCONF_PATH"
  set -g BASE16_SHELL_TMUXCONF_PATH "$BASE16_CONFIG_PATH/tmux.base16.conf"
end

if test -z "$BASE16_TMUX_PLUGIN_PATH"
  if test -n "$XDG_CONFIG_HOME"
    set -g BASE16_TMUX_PLUGIN_PATH "$XDG_CONFIG_HOME/tmux/plugins/base16-tmux"
  else
    set -g BASE16_TMUX_PLUGIN_PATH "$HOME/.tmux/plugins/base16-tmux"
  end
end

# If base16-tmux path directory doesn't exist, stop hook
if not test -d $BASE16_TMUX_PLUGIN_PATH
  return 2
end

# ----------------------------------------------------------------------
# Execution
# ----------------------------------------------------------------------

# If base16-tmux is used, provide a file for base16-tmux to source
if test -d "$BASE16_TMUX_PLUGIN_PATH"; and command -v 'tmux' > /dev/null
  # Set current theme name
  set current_theme_name (cat "$BASE16_SHELL_THEME_NAME_PATH")

  echo "set -g @colors-base16 '$current_theme_name'" > \
    "$BASE16_SHELL_TMUXCONF_PATH"

  # Source tmux config if tmux is running
  if test -n "$TMUX"
    tmux source-file (tmux display-message -p "#{config_files}")
  end
end
