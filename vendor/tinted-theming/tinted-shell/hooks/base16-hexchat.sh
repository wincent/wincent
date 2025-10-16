#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Setup config variables and env
# ----------------------------------------------------------------------

# Allow users to optionally configure their hexchat plugin path and set
# the value if one doesn't exist. This runs each time a script is
# switched so it's important to check for previously set values.

if [ -z "$BASE16_HEXCHAT_PATH" ]; then
  BASE16_HEXCHAT_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/tinted-theming/base16-hexchat"
fi

# If BASE16_HEXCHAT_PATH doesn't exist, stop hook if [ ! -d "$BASE16_HEXCHAT_PATH" ]; then
  return 2
fi

# If BASE16_HEXCHAT_COLORS_CONF_PATH hasn't been configured, stop hook
if [ -z "$BASE16_HEXCHAT_COLORS_CONF_PATH" ]; then
  return 1
fi

# If BASE16_HEXCHAT_COLORS_CONF_PATH has been configured, but the file doesn't
# exist
if [ -n "$BASE16_HEXCHAT_COLORS_CONF_PATH" ] \
  && [ ! -f "$BASE16_HEXCHAT_COLORS_CONF_PATH" ]; then
  echo "\$BASE16_HEXCHAT_COLORS_CONF_PATH is not a file."
  return 2
fi

# Set current theme name
read current_theme_name < "$BASE16_SHELL_THEME_NAME_PATH"

hexchat_theme_path="$BASE16_HEXCHAT_PATH/colors/base16-$current_theme_name.conf"

if [ ! -f "$hexchat_theme_path" ]; then
  output="'$current_theme_name' theme doesn't exist in base16-hex. Make sure "
  output+="the local repository is using the latest commit. \`cd\` to "
  output+="the directory and try doing a \`git pull\`."

  echo $output

  return 2
fi

# ----------------------------------------------------------------------
# Execution
# ----------------------------------------------------------------------

command cp -f "$hexchat_theme_path" "$BASE16_HEXCHAT_COLORS_CONF_PATH"

