#!/usr/bin/env fish

# ----------------------------------------------------------------------
# Setup config variables and env
# ----------------------------------------------------------------------

set BASE16_SHELL_VIM_PATH "$BASE16_CONFIG_PATH/set_theme.vim"
set BASE16_SHELL_NVIM_PATH "$BASE16_CONFIG_PATH/set_theme.lua"

if test -f "$BASE16_SHELL_VIM_PATH"
  touch "$BASE16_SHELL_VIM_PATH"
end

if test -f "$BASE16_SHELL_NVIM_PATH"
  touch "$BASE16_SHELL_NVIM_PATH"
end

# ----------------------------------------------------------------------
# Execution
# ----------------------------------------------------------------------
set current_theme_name (cat "$BASE16_SHELL_THEME_NAME_PATH")

set vim_output (string join "\n" \
  "if !exists('g:colors_name') || g:colors_name != 'base16-$current_theme_name'" \
  "  colorscheme base16-$current_theme_name" \
  "endif")

set nvim_output (string join "\n" \
  "local current_theme_name = \"$current_theme_name\"" \
  "if current_theme_name ~= \"\" and vim.g.colors_name ~= 'base16-' .. current_theme_name then" \
  "  vim.cmd('colorscheme base16-' .. current_theme_name)" \
  "end")

echo -e "$vim_output" > "$BASE16_SHELL_VIM_PATH"
echo -e "$nvim_output" > "$BASE16_SHELL_NVIM_PATH"
