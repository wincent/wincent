#!/usr/bin/env fish
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: 
# Scheme author: 
# Template author: Tinted Theming (https://github.com/tinted-theming)

set -l color00 "4c/4f/69"
set -l color01 "d2/0f/39"
set -l color02 "40/a0/2b"
set -l color03 "df/8e/1d"
set -l color04 "1e/66/f5"
set -l color05 "88/39/ef"
set -l color06 "17/92/99"
set -l color07 "dc/e0/e8"
set -l color08 "6c/6f/85"
set -l color09 "f8/26/53"
set -l color10 "53/d1/38"
set -l color11 "ee/aa/4b"
set -l color12 "59/8e/f8"
set -l color13 "aa/72/f4"
set -l color14 "18/cb/d5"
set -l color15 "ff/ff/ff"
set -l color_foreground "4c/4f/69"
set -l color_background "dc/e0/e8"

if test -z "$TTY"
  set -gx TTY (tty)
end
if test -z "$TTY"; or not test -w "$TTY"
  function put_template; true; end
  function put_template_var; true; end
  function put_template_custom; true; end
else if set -q TMUX; or string match -q 'tmux*' $TERM
  # Tell tmux to pass the escape sequences through
  # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
  function put_template; printf '\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\033\\' $argv > "$TTY"; end
  function put_template_var; printf '\033Ptmux;\033\033]%d;rgb:%s\033\033\\\033\\' $argv > "$TTY"; end
  function put_template_custom; printf '\033Ptmux;\033\033]%s%s\033\033\\\033\\' $argv > "$TTY"; end
else if string match -q 'screen*' $TERM
  # GNU screen (screen, screen-256color, screen-256color-bce)
  function put_template; printf '\033P\033]4;%d;rgb:%s\007\033\\' $argv > "$TTY"; end
  function put_template_var; printf '\033P\033]%d;rgb:%s\007\033\\' $argv > "$TTY"; end
  function put_template_custom; printf '\033P\033]%s%s\007\033\\' $argv > "$TTY"; end
else if string match -q 'linux*' $TERM
  function put_template; test $argv[1] -lt 16 && printf "\e]P%x%s" $argv[1] (echo $argv[2] | sed 's/\///g') > "$TTY"; end
  function put_template_var; true; end
  function put_template_custom; true; end
else
  function put_template; printf '\033]4;%d;rgb:%s\033\\' $argv > "$TTY"; end
  function put_template_var; printf '\033]%d;rgb:%s\033\\' $argv > "$TTY"; end
  function put_template_custom; printf '\033]%s%s\033\\' $argv > "$TTY"; end
end

# 16 color space
put_template 0  $color00
put_template 1  $color01
put_template 2  $color02
put_template 3  $color03
put_template 4  $color04
put_template 5  $color05
put_template 6  $color06
put_template 7  $color07
put_template 8  $color08
put_template 9  $color09
put_template 10 $color10
put_template 11 $color11
put_template 12 $color12
put_template 13 $color13
put_template 14 $color14
put_template 15 $color15
put_template 21 $color21

# foreground / background / cursor color
if test -n "$ITERM_SESSION_ID"
  put_template_custom Pg 4c4f69 # foreground
  put_template_custom Ph dce0e8 # background
  put_template_custom Pi 4c4f69 # bold color
  put_template_custom Pj b6bfd1 # selection color
  put_template_custom Pk 4c4f69 # selected text color
  put_template_custom Pl 4c4f69 # cursor
  put_template_custom Pm dce0e8 # cursor text
else
  put_template_var 10 $color_foreground
  if test "$TINTED8_SHELL_SET_BACKGROUND" != false
    put_template_var 11 $color_background
    if string match -q 'rxvt*' $TERM
      put_template_var 708 $color_background # internal border (rxvt)
    end
  end
  put_template_custom 12 ";7" # cursor (reverse video)
end

# Set fish highlight colors
set -U fish_color_normal 4c4f69
set -U fish_color_command 
set -U fish_color_keyword 
set -U fish_color_quote 598ef8
set -U fish_color_redirection 8839ef
set -U fish_color_end 4c4f69
set -U fish_color_error 
set -U fish_color_param 18cbd5
set -U fish_color_valid_path --underline
set -U fish_color_option 18cbd5 --italics
set -U fish_color_comment 
set -U fish_color_selection 4c4f69 --background=b6bfd1
set -U fish_color_operator 179299
set -U fish_color_escape fe640b
set -U fish_color_autosuggestion 797f96
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_host_remote normal
set -U fish_color_status d20f39
set -U fish_color_cancel -r
set -U fish_color_search_match df8e1d --background=b6bfd1
set -U fish_color_history_current --underline=curly
set -U fish_pager_color_progress b6bfd1 --background=4c4f69
set -U fish_pager_color_background --background=
set -U fish_pager_color_prefix --bold --italics
set -U fish_pager_color_completion 4c4f69
set -U fish_pager_color_description 
set -U fish_pager_color_selected_background --background=b6bfd1
set -U fish_pager_color_selected_prefix --bold --italics --background=b6bfd1
set -U fish_pager_color_selected_completion 4c4f69
set -U fish_pager_color_description 

# clean up
set -e color00
set -e color01
set -e color02
set -e color03
set -e color04
set -e color05
set -e color06
set -e color07
set -e color08
set -e color09
set -e color10
set -e color11
set -e color12
set -e color13
set -e color14
set -e color15
set -e color_foreground
set -e color_background
functions -e put_template put_template_var put_template_custom
set -l legacy_env (string match -r '^(BASE16|BASE24|TINTED8)_(THEME|COLOR_).*' (set -xn))
test -n "$legacy_env"; and set -e $legacy_env
set -l legacy_env (string match -r '^(BASE16|BASE24|TINTED8)_THEME' (set -Uxn))
test -n "$legacy_env"; and set -Ue $legacy_env
set -e legacy_env

# Set theme
set -Ux TINTED8_THEME catppuccin-latte

# Optionally export variables
if test -n "$TINTED_SHELL_ENABLE_TINTED8_VARS"
  set -gx TINTED8_COLOR_BLACK_NORMAL_HEX "4c4f69"
  set -gx TINTED8_COLOR_BLACK_RED_HEX "d20f39"
  set -gx TINTED8_COLOR_BLACK_GREEN_HEX "40a02b"
  set -gx TINTED8_COLOR_YELLOW_NORMAL_HEX "df8e1d"
  set -gx TINTED8_COLOR_BLUE_NORMAL_HEX "1e66f5"
  set -gx TINTED8_COLOR_MAGENTA_NORMAL_HEX "8839ef"
  set -gx TINTED8_COLOR_CYAN_NORMAL_HEX "179299"
  set -gx TINTED8_COLOR_WHITE_NORMAL_HEX "dce0e8"

  set -gx TINTED8_COLOR_BLACK_BRIGHT_HEX "6c6f85"
  set -gx TINTED8_COLOR_RED_BRIGHT_HEX "f82653"
  set -gx TINTED8_COLOR_GREEN_BRIGHT_HEX "53d138"
  set -gx TINTED8_COLOR_YELLOW_BRIGHT_HEX "eeaa4b"
  set -gx TINTED8_COLOR_BLUE_BRIGHT_HEX "598ef8"
  set -gx TINTED8_COLOR_MAGENTA_BRIGHT_HEX "aa72f4"
  set -gx TINTED8_COLOR_CYAN_BRIGHT_HEX "18cbd5"
  set -gx TINTED8_COLOR_WHITE_BRIGHT_HEX "ffffff"

  set -gx TINTED8_COLOR_BLACK_DIM_HEX "323446"
  set -gx TINTED8_COLOR_RED_DIM_HEX "9e0627"
  set -gx TINTED8_COLOR_GREEN_DIM_HEX "2c711c"
  set -gx TINTED8_COLOR_YELLOW_DIM_HEX "ae6c11"
  set -gx TINTED8_COLOR_BLUE_DIM_HEX "0248d4"
  set -gx TINTED8_COLOR_MAGENTA_DIM_HEX "670be0"
  set -gx TINTED8_COLOR_CYAN_DIM_HEX "04a5e5"
  set -gx TINTED8_COLOR_WHITE_DIM_HEX "b6bfd1"
end
