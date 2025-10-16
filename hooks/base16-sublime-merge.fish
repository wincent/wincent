#!/usr/bin/env fish

# ----------------------------------------------------------------------
# Setup config variables and env
# ----------------------------------------------------------------------

if test -z "$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH"
  return 1
end

if not test -f "$BASE16_SHELL_THEME_NAME_PATH"
  return 1
end

# The path/to/sublime-merge/Package must be set
if not test -d "$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH"
  return 1
end

# The base16-sublime-merge repo must be cloned at
if not test -d "$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH/base16-sublime-merge"
  return 1
end

set BASE16_SHELL_SUBLIMEMERGE_SETTINGS_PATH "$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH/User/Preferences.sublime-settings"

# The Sublime Merge settings path should exist
if not test -f "$BASE16_SHELL_SUBLIMEMERGE_SETTINGS_PATH"
  return 1
end

function find_replace_json_value_in_sublimemerge_settings
  set property $argv[1]
  set value $argv[2]
  set json_file "$BASE16_SHELL_SUBLIMEMERGE_PACKAGE_PATH/User/Preferences.sublime-settings"

  # Use sed to find the property and change its value
  sed -i "s/\"$property\": \".*\"/\"$property\": \"$value\"/" $BASE16_SHELL_SUBLIMEMERGE_SETTINGS_PATH
end

# ----------------------------------------------------------------------
# Execution
# ----------------------------------------------------------------------
set current_theme_name (cat "$BASE16_SHELL_THEME_NAME_PATH")

find_replace_json_value_in_sublimemerge_settings "theme" "base16-$current_theme_name.sublime-theme"
find_replace_json_value_in_sublimemerge_settings "color_scheme" "base16-$current_theme_name.sublime-color-scheme"
