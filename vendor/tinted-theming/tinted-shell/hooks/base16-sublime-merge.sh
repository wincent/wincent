#!/usr/bin/env sh

# ----------------------------------------------------------------------
# Setup config variables and env
# ----------------------------------------------------------------------

if [ -z "$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH" ]; then
  return 1
fi

if [ ! -f "$BASE16_SHELL_THEME_NAME_PATH" ]; then
  return 1
fi

# The path/to/sublime-merge/Package must be set
if [ ! -d "$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH" ]; then
  return 1
fi

# The base16-sublime-merge repo must be cloned at
if [ ! -d "$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH/base16-sublime-merge" ]; then
  return 1
fi

BASE16_SHELL_SUBLIMEMERGE_SETTINGS_PATH="$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH"/User/Preferences.sublime-settings 

# The Sublime Merge settings path should exist
if [ ! -f "$BASE16_SHELL_SUBLIMEMERGE_SETTINGS_PATH" ]; then
  return 1
fi

read -r current_theme_name < "$BASE16_SHELL_THEME_NAME_PATH"

# The Sublime Merge theme should exist
if [ ! -f "$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH/base16-sublime-merge/colorschemes/base16-$current_theme_name.sublime-color-scheme" ]; then
  printf "'%s' theme doesn't exist in base16-sublime-merge. Make sure the repo is up to date (cd there and git pull).\n" \
    "$current_theme_name"
  return 1
fi

find_replace_json_value_in_sublimemerge_settings() {
  property=$1
  value=$2
  json_file="$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH"/User/Preferences.sublime-settings

  tmp_file="${json_file}.tmp.$$"
  # Replace the value for the given property, write to tmp then move back
  sed "s/\"$property\": \"[^\"]*\"/\"$property\": \"$value\"/" "$json_file" > "$tmp_file" \
    && mv "$tmp_file" "$json_file"

  unset property
  unset value
  unset json_file
  unset tmp_file
}

# ----------------------------------------------------------------------
# Execution
# ----------------------------------------------------------------------
find_replace_json_value_in_sublimemerge_settings "theme" "base16-$current_theme_name.sublime-theme"
find_replace_json_value_in_sublimemerge_settings "color_scheme" "base16-$current_theme_name.sublime-color-scheme"
