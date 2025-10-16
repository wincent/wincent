#!/usr/bin/env fish

# ----------------------------------------------------------------------
# Setup config variables and env
# ----------------------------------------------------------------------

# Allow users to optionally configure their hexchat plugin path and set
# the value if one doesn't exist. This runs each time a script is
# switched so it's important to check for previously set values.

if test -z "$BASE16_HEXCHAT_PATH"
  if test -n "$XDG_CONFIG_HOME"
    set -g BASE16_HEXCHAT_PATH "$XDG_CONFIG_HOME/tinted-theming/base16-hexchat"
  else
    set -g BASE16_HEXCHAT_PATH "$HOME/.config/tinted-theming/base16-hexchat"
  end
end

# If BASE16_HEXCHAT_PATH doesn't exist, stop hook
if not test -d "$BASE16_HEXCHAT_PATH"
  return 2
end

# If BASE16_HEXCHAT_COLORS_CONF_PATH hasn't been configured, stop hook
if test -z "$BASE16_HEXCHAT_COLORS_CONF_PATH"
  return 1
end

# If BASE16_HEXCHAT_COLORS_CONF_PATH has been configured, but the file doesn't
# exist
if test -n "$BASE16_HEXCHAT_COLORS_CONF_PATH"; \
  and not test -f "$BASE16_HEXCHAT_COLORS_CONF_PATH"
  echo "\$BASE16_HEXCHAT_COLORS_CONF_PATH is not a file."
  return 2
end

# Set current theme name
set current_theme_name (cat "$BASE16_SHELL_THEME_NAME_PATH")

set hexchat_theme_path "$BASE16_HEXCHAT_PATH/colors/base16-$current_theme_name.conf"

if not test -f "$hexchat_theme_path"
  set output (string join "\n" \
    "'$current_theme_name' theme doesn't exist in base16-hex. Make sure " \
    "the local repository is using the latest commit. \`cd\` to " \
    "the directory and try doing a \`git pull\`.")

  echo $output

  return 2
end

# ----------------------------------------------------------------------
# Execution
# ----------------------------------------------------------------------

command cp -f "$hexchat_theme_path" "$BASE16_HEXCHAT_COLORS_CONF_PATH"
