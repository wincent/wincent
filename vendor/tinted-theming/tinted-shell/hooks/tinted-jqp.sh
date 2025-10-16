#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Setup config variables and env
# ----------------------------------------------------------------------
#

# Users can supply the path to where they cloned the tinted-theming/tinted-jqp repo.
# By default, we'll look for it under the tinted-theming config dir.

TINTED_JQP_PATH="${TINTED_JQP_PATH:-$BASE16_CONFIG_PATH/tinted-jqp}"

# If TINTED_JQP_PATH doesn't exist, stop hook
if [ ! -d "$TINTED_JQP_PATH" ]; then
  return 2
fi

TINTED_JQP_CONFIG_FILE="${TINTED_JQP_CONFIG_FILE:-$BASE16_CONFIG_PATH/jqp_theme.yaml}"

if [[ -d "$TINTED_JQP_CONFIG_FILE" ]]; then
  2>&1 echo "${TINTED_JQP_CONFIG_FILE} exists but is a directory. It should either be non-existent, or a file."
  return 1
fi

# Set current theme name
read current_theme_name < "$BASE16_SHELL_THEME_NAME_PATH"

jqp_theme_path="$TINTED_JQP_PATH/themes/base16-$current_theme_name.yaml"

if [ ! -f "$jqp_theme_path" ]; then
  cat <<EOF 2>&1
${current_theme_name} theme doesn't exist in tinted-jqp. Make sure you have the latest commits:

cd ${TINTED_JQP_PATH}
git pull
EOF

  return 3
fi

# ----------------------------------------------------------------------
# Execution
# ----------------------------------------------------------------------

command cp -f "$jqp_theme_path" "$TINTED_JQP_CONFIG_FILE"
