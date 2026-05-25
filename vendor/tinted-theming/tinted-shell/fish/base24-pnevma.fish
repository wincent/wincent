#!/usr/bin/env fish
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Pnevma
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)

set -l color00 "1c/1c/1c" # Base 00 - Black
set -l color01 "a3/66/66" # Base 08 - Red
set -l color02 "90/a5/7d" # Base 0B - Green
set -l color03 "a1/bd/ce" # Base 0A - Yellow
set -l color04 "7f/a5/bd" # Base 0D - Blue
set -l color05 "c7/9e/c4" # Base 0E - Magenta
set -l color06 "8a/db/b4" # Base 0C - Cyan
set -l color07 "ae/ae/ad" # Base 05 - White
set -l color08 "6b/6a/67" # Base 03 - Bright Black
set -l color09 "d7/87/87" # Base 12 - Bright Red
set -l color10 "af/be/a2" # Base 14 - Bright Green
set -l color11 "e4/c9/af" # Base 13 - Bright Yellow
set -l color12 "a1/bd/ce" # Base 16 - Bright Blue
set -l color13 "d7/be/da" # Base 17 - Bright Magenta
set -l color14 "b1/e7/dd" # Base 15 - Bright Cyan
set -l color15 "ef/ef/ef" # Base 07 - Bright White
set -l color16 "d7/af/87" # Base 09
set -l color17 "51/33/33" # Base 0F
set -l color18 "2f/2e/2d" # Base 01
set -l color19 "4a/48/45" # Base 02
set -l color20 "8d/8c/8a" # Base 04
set -l color21 "d0/d0/d0" # Base 06
set -l color_foreground "ae/ae/ad" # Base 05
set -l color_background "1c/1c/1c" # Base 00

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

# 256 color space
put_template 16 $color16
put_template 17 $color17
put_template 18 $color18
put_template 19 $color19
put_template 20 $color20
put_template 21 $color21

# foreground / background / cursor color
if test -n "$ITERM_SESSION_ID"
  put_template_custom Pg aeaead # foreground
  put_template_custom Ph 1c1c1c # background
  put_template_custom Pi aeaead # bold color
  put_template_custom Pj 4a4845 # selection color
  put_template_custom Pk aeaead # selected text color
  put_template_custom Pl aeaead # cursor
  put_template_custom Pm 1c1c1c # cursor text
else
  put_template_var 10 $color_foreground
  if test "$BASE24_SHELL_SET_BACKGROUND" != false
    put_template_var 11 $color_background
    if string match -q 'rxvt*' $TERM
      put_template_var 708 $color_background # internal border (rxvt)
    end
  end
  put_template_custom 12 ";7" # cursor (reverse video)
end

set -U fish_color_normal normal
set -U fish_color_command blue
set -U fish_color_keyword magenta
set -U fish_color_quote green
set -U fish_color_redirection brblue
set -U fish_color_end normal
set -U fish_color_error brred
set -U fish_color_param brcyan
set -U fish_color_valid_path --underline
set -U fish_color_option brcyan --italics
set -U fish_color_comment 6b6a67
set -U fish_color_selection d0d0d0 --background=4a4845
set -U fish_color_operator magenta
set -U fish_color_escape d7af87
set -U fish_color_autosuggestion 6b6a67
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_host_remote normal
set -U fish_color_status red
set -U fish_color_cancel -r
set -U fish_color_search_match yellow --background=4a4845
set -U fish_color_history_current --underline=curly
set -U fish_pager_color_progress 2f2e2d --background=8d8c8a
set -U fish_pager_color_background --background=1c1c1c
set -U fish_pager_color_prefix --bold --italics
set -U fish_pager_color_completion normal
set -U fish_pager_color_description d7af87
set -U fish_pager_color_selected_background --background=4a4845
set -U fish_pager_color_selected_prefix --bold --italics --background=4a4845
set -U fish_pager_color_selected_completion normal
set -U fish_pager_color_description d7af87

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
set -e color16
set -e color17
set -e color18
set -e color19
set -e color20
set -e color21
set -e color_foreground
set -e color_background
functions -e put_template put_template_var put_template_custom
set -l legacy_env (string match -r '^(BASE16|BASE24|TINTED8)_(THEME|COLOR_).*' (set -xn))
test -n "$legacy_env"; and set -e $legacy_env
set -l legacy_env (string match -r '^(BASE16|BASE24|TINTED8)_THEME' (set -Uxn))
test -n "$legacy_env"; and set -Ue $legacy_env
set -e legacy_env

# Set theme
set -Ux BASE24_THEME pnevma

# Optionally export variables
if test -n "$TINTED_SHELL_ENABLE_BASE24_VARS"; or test -n "$BASE24_SHELL_ENABLE_VARS"
  set -gx BASE24_COLOR_00_HEX "1c1c1c"
  set -gx BASE24_COLOR_01_HEX "2f2e2d"
  set -gx BASE24_COLOR_02_HEX "4a4845"
  set -gx BASE24_COLOR_03_HEX "6b6a67"
  set -gx BASE24_COLOR_04_HEX "8d8c8a"
  set -gx BASE24_COLOR_05_HEX "aeaead"
  set -gx BASE24_COLOR_06_HEX "d0d0d0"
  set -gx BASE24_COLOR_07_HEX "efefef"
  set -gx BASE24_COLOR_08_HEX "a36666"
  set -gx BASE24_COLOR_09_HEX "d7af87"
  set -gx BASE24_COLOR_0A_HEX "a1bdce"
  set -gx BASE24_COLOR_0B_HEX "90a57d"
  set -gx BASE24_COLOR_0C_HEX "8adbb4"
  set -gx BASE24_COLOR_0D_HEX "7fa5bd"
  set -gx BASE24_COLOR_0E_HEX "c79ec4"
  set -gx BASE24_COLOR_0F_HEX "513333"
end
