#!/usr/bin/env fish
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: 
# Scheme author: 
# Template author: Tinted Theming (https://github.com/tinted-theming)

set -l color00 "1f/23/28"
set -l color01 "cf/22/2e"
set -l color02 "11/63/29"
set -l color03 "4d/2d/00"
set -l color04 "09/69/da"
set -l color05 "82/50/df"
set -l color06 "1b/7c/83"
set -l color07 "59/63/6e"
set -l color08 "39/3f/46"
set -l color09 "a4/0e/26"
set -l color10 "1a/7f/37"
set -l color11 "63/3c/01"
set -l color12 "21/8b/ff"
set -l color13 "a4/75/f9"
set -l color14 "31/92/aa"
set -l color15 "81/8b/98"
set -l color_foreground "1f/23/28"
set -l color_background "ff/ff/ff"

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
  put_template_custom Pg 1f2328 # foreground
  put_template_custom Ph ffffff # background
  put_template_custom Pi 1f2328 # bold color
  put_template_custom Pj 3d454c # selection color
  put_template_custom Pk 1f2328 # selected text color
  put_template_custom Pl 1f2328 # cursor
  put_template_custom Pm ffffff # cursor text
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
set -U fish_color_normal 1f2328
set -U fish_color_command 
set -U fish_color_keyword 
set -U fish_color_quote 6639ba
set -U fish_color_redirection cf222e
set -U fish_color_end 1f2328
set -U fish_color_error 
set -U fish_color_param 1f2328
set -U fish_color_valid_path --underline
set -U fish_color_option 1f2328 --italics
set -U fish_color_comment 
set -U fish_color_selection 1f2328 --background=3d454c
set -U fish_color_operator cf222e
set -U fish_color_escape 0550ae
set -U fish_color_autosuggestion 59636e
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_host_remote normal
set -U fish_color_status d1242f
set -U fish_color_cancel -r
set -U fish_color_search_match 4d2d00 --background=3d454c
set -U fish_color_history_current --underline=curly
set -U fish_pager_color_progress f6f8fa --background=1f2328
set -U fish_pager_color_background --background=
set -U fish_pager_color_prefix --bold --italics
set -U fish_pager_color_completion 1f2328
set -U fish_pager_color_description 
set -U fish_pager_color_selected_background --background=3d454c
set -U fish_pager_color_selected_prefix --bold --italics --background=3d454c
set -U fish_pager_color_selected_completion 1f2328
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
set -Ux TINTED8_THEME github

# Optionally export variables
if test -n "$TINTED_SHELL_ENABLE_TINTED8_VARS"
  set -gx TINTED8_COLOR_BLACK_NORMAL_HEX "1f2328"
  set -gx TINTED8_COLOR_BLACK_RED_HEX "cf222e"
  set -gx TINTED8_COLOR_BLACK_GREEN_HEX "116329"
  set -gx TINTED8_COLOR_YELLOW_NORMAL_HEX "4d2d00"
  set -gx TINTED8_COLOR_BLUE_NORMAL_HEX "0969da"
  set -gx TINTED8_COLOR_MAGENTA_NORMAL_HEX "8250df"
  set -gx TINTED8_COLOR_CYAN_NORMAL_HEX "1b7c83"
  set -gx TINTED8_COLOR_WHITE_NORMAL_HEX "59636e"

  set -gx TINTED8_COLOR_BLACK_BRIGHT_HEX "393f46"
  set -gx TINTED8_COLOR_RED_BRIGHT_HEX "a40e26"
  set -gx TINTED8_COLOR_GREEN_BRIGHT_HEX "1a7f37"
  set -gx TINTED8_COLOR_YELLOW_BRIGHT_HEX "633c01"
  set -gx TINTED8_COLOR_BLUE_BRIGHT_HEX "218bff"
  set -gx TINTED8_COLOR_MAGENTA_BRIGHT_HEX "a475f9"
  set -gx TINTED8_COLOR_CYAN_BRIGHT_HEX "3192aa"
  set -gx TINTED8_COLOR_WHITE_BRIGHT_HEX "818b98"

  set -gx TINTED8_COLOR_BLACK_DIM_HEX "040506"
  set -gx TINTED8_COLOR_RED_DIM_HEX "9f151e"
  set -gx TINTED8_COLOR_GREEN_DIM_HEX "073013"
  set -gx TINTED8_COLOR_YELLOW_DIM_HEX "100900"
  set -gx TINTED8_COLOR_BLUE_DIM_HEX "014ca5"
  set -gx TINTED8_COLOR_MAGENTA_DIM_HEX "5e20d2"
  set -gx TINTED8_COLOR_CYAN_DIM_HEX "0f4d52"
  set -gx TINTED8_COLOR_WHITE_DIM_HEX "3d454c"
end
