#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Setup config variables and env
# ----------------------------------------------------------------------

if [ -z "$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH" ]; then
  return 1
fi

if ! [ -f "$BASE16_SHELL_THEME_NAME_PATH" ]; then
  return 1
fi

# The path/to/sublime-merge/Package must be set
if ! [ -d "$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH" ]; then
  return 1
fi

# The base16-sublime-merge repo must be cloned at
if ! [ -d "$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH/base16-sublime-merge" ]; then
  return 1
fi

BASE16_SHELL_SUBLIMEMERGE_SETTINGS_PATH="$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH"/User/Preferences.sublime-settings 

# The Sublime Merge settings path should exist
if ! [ -f "$BASE16_SHELL_SUBLIMEMERGE_SETTINGS_PATH" ]; then
  return 1
fi

read current_theme_name < "$BASE16_SHELL_THEME_NAME_PATH"

# The Sublime Merge theme should exist
if ! [ -f "$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH/base16-sublime-merge/colorschemes/base16-$current_theme_name.sublime-color-scheme" ]; then
  output="'$current_theme_name' theme doesn't exist in base16-sublime-merge. Make sure "
  output+="the local repository is using the latest commit. \`cd\` to "
  output+="the directory and try doing a \`git pull\`."

  echo $output
  exit 1
fi

find_replace_json_value_in_sublimemerge_settings() {
  local property=$1
  local value=$2
  local json_file="$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH"/User/Preferences.sublime-settings

  # Determine the operating system
  OS="$(uname)"

  # Define the sed command based on the operating system
  case "$OS" in
    Darwin|FreeBSD)
      # macOS system (BSD sed)
      SED_COMMAND=(sed -i '')
      ;;
    *)
      # Assume Linux or other (GNU sed)
      SED_COMMAND=(sed -i)
      ;;
  esac

  # Use the determined sed command in your script
  "${SED_COMMAND[@]}" "s/\"$property\": \".*\"/\"$property\": \"$value\"/" "$BASE16_SHELL_SUBLIMEMERGE_SETTINGS_PATH"
}

# ----------------------------------------------------------------------
# Execution
# ----------------------------------------------------------------------
find_replace_json_value_in_sublimemerge_settings "theme" "base16-$current_theme_name.sublime-theme"
find_replace_json_value_in_sublimemerge_settings "color_scheme" "base16-$current_theme_name.sublime-color-scheme"
