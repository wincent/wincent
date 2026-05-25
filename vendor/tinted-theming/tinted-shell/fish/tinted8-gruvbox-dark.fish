#!/usr/bin/env fish
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: 
# Scheme author: 
# Template author: Tinted Theming (https://github.com/tinted-theming)

set -l color00 "28/28/28"
set -l color01 "cc/24/1d"
set -l color02 "98/97/1a"
set -l color03 "d7/99/21"
set -l color04 "45/85/88"
set -l color05 "b1/62/86"
set -l color06 "68/9d/6a"
set -l color07 "eb/db/b2"
set -l color08 "3c/38/36"
set -l color09 "fb/49/34"
set -l color10 "b8/bb/26"
set -l color11 "fa/bd/2f"
set -l color12 "83/a5/98"
set -l color13 "d3/86/9b"
set -l color14 "8e/c0/7c"
set -l color15 "fb/f1/c7"
set -l color_foreground "eb/db/b2"
set -l color_background "28/28/28"

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
  put_template_custom Pg ebdbb2 # foreground
  put_template_custom Ph 282828 # background
  put_template_custom Pi ebdbb2 # bold color
  put_template_custom Pj 3c3836 # selection color
  put_template_custom Pk ebdbb2 # selected text color
  put_template_custom Pl ebdbb2 # cursor
  put_template_custom Pm 282828 # cursor text
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
set -U fish_color_normal ebdbb2
set -U fish_color_command 
set -U fish_color_keyword 
set -U fish_color_quote 83a598
set -U fish_color_redirection d79921
set -U fish_color_end ebdbb2
set -U fish_color_error 
set -U fish_color_param 8ec07c
set -U fish_color_valid_path --underline
set -U fish_color_option 8ec07c --italics
set -U fish_color_comment 
set -U fish_color_selection ebdbb2 --background=3c3836
set -U fish_color_operator d79921
set -U fish_color_escape d65d0e
set -U fish_color_autosuggestion 716457
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_host_remote normal
set -U fish_color_status cc241d
set -U fish_color_cancel -r
set -U fish_color_search_match d79921 --background=3c3836
set -U fish_color_history_current --underline=curly
set -U fish_pager_color_progress 3c3836 --background=ebdbb2
set -U fish_pager_color_background --background=
set -U fish_pager_color_prefix --bold --italics
set -U fish_pager_color_completion ebdbb2
set -U fish_pager_color_description 
set -U fish_pager_color_selected_background --background=3c3836
set -U fish_pager_color_selected_prefix --bold --italics --background=3c3836
set -U fish_pager_color_selected_completion ebdbb2
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
set -Ux TINTED8_THEME gruvbox-dark

# Optionally export variables
if test -n "$TINTED_SHELL_ENABLE_TINTED8_VARS"
  set -gx TINTED8_COLOR_BLACK_NORMAL_HEX "282828"
  set -gx TINTED8_COLOR_BLACK_RED_HEX "cc241d"
  set -gx TINTED8_COLOR_BLACK_GREEN_HEX "98971a"
  set -gx TINTED8_COLOR_YELLOW_NORMAL_HEX "d79921"
  set -gx TINTED8_COLOR_BLUE_NORMAL_HEX "458588"
  set -gx TINTED8_COLOR_MAGENTA_NORMAL_HEX "b16286"
  set -gx TINTED8_COLOR_CYAN_NORMAL_HEX "689d6a"
  set -gx TINTED8_COLOR_WHITE_NORMAL_HEX "ebdbb2"

  set -gx TINTED8_COLOR_BLACK_BRIGHT_HEX "3c3836"
  set -gx TINTED8_COLOR_RED_BRIGHT_HEX "fb4934"
  set -gx TINTED8_COLOR_GREEN_BRIGHT_HEX "b8bb26"
  set -gx TINTED8_COLOR_YELLOW_BRIGHT_HEX "fabd2f"
  set -gx TINTED8_COLOR_BLUE_BRIGHT_HEX "83a598"
  set -gx TINTED8_COLOR_MAGENTA_BRIGHT_HEX "d3869b"
  set -gx TINTED8_COLOR_CYAN_BRIGHT_HEX "8ec07c"
  set -gx TINTED8_COLOR_WHITE_BRIGHT_HEX "fbf1c7"

  set -gx TINTED8_COLOR_BLACK_DIM_HEX "1d2021"
  set -gx TINTED8_COLOR_RED_DIM_HEX "9b1611"
  set -gx TINTED8_COLOR_GREEN_DIM_HEX "65650f"
  set -gx TINTED8_COLOR_YELLOW_DIM_HEX "a77514"
  set -gx TINTED8_COLOR_BLUE_DIM_HEX "2f5f61"
  set -gx TINTED8_COLOR_MAGENTA_DIM_HEX "914467"
  set -gx TINTED8_COLOR_CYAN_DIM_HEX "4d7b4f"
  set -gx TINTED8_COLOR_WHITE_DIM_HEX "e3c67d"
end
