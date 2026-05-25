#!/usr/bin/env fish
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Gruvbox light, medium
# Scheme author: Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
# Template author: Tinted Theming (https://github.com/tinted-theming)

set -l color00 "fb/f1/c7" # Base 00 - Black
set -l color01 "9d/00/06" # Base 08 - Red
set -l color02 "79/74/0e" # Base 0B - Green
set -l color03 "b5/76/14" # Base 0A - Yellow
set -l color04 "07/66/78" # Base 0D - Blue
set -l color05 "8f/3f/71" # Base 0E - Magenta
set -l color06 "42/7b/58" # Base 0C - Cyan
set -l color07 "50/49/45" # Base 05 - White
set -l color08 "bd/ae/93" # Base 03 - Bright Black
set -l color09 "$color01" # Base 08 - Bright Red
set -l color10 "$color02" # Base 0B - Bright Green
set -l color11 "$color03" # Base 0A - Bright Yellow
set -l color12 "$color04" # Base 0D - Bright Blue
set -l color13 "$color05" # Base 0E - Bright Magenta
set -l color14 "$color06" # Base 0C - Bright Cyan
set -l color15 "28/28/28" # Base 07 - Bright White
set -l color16 "af/3a/03" # Base 09
set -l color17 "d6/5d/0e" # Base 0F
set -l color18 "eb/db/b2" # Base 01
set -l color19 "d5/c4/a1" # Base 02
set -l color20 "66/5c/54" # Base 04
set -l color21 "3c/38/36" # Base 06
set -l color_foreground "50/49/45" # Base 05
set -l color_background "fb/f1/c7" # Base 00

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
  put_template_custom Pg 504945 # foreground
  put_template_custom Ph fbf1c7 # background
  put_template_custom Pi 504945 # bold color
  put_template_custom Pj d5c4a1 # selection color
  put_template_custom Pk 504945 # selected text color
  put_template_custom Pl 504945 # cursor
  put_template_custom Pm fbf1c7 # cursor text
else
  put_template_var 10 $color_foreground
  if test "$BASE16_SHELL_SET_BACKGROUND" != false
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
set -U fish_color_comment bdae93
set -U fish_color_selection 3c3836 --background=d5c4a1
set -U fish_color_operator magenta
set -U fish_color_escape af3a03
set -U fish_color_autosuggestion bdae93
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_host_remote normal
set -U fish_color_status red
set -U fish_color_cancel -r
set -U fish_color_search_match yellow --background=d5c4a1
set -U fish_color_history_current --underline=curly
set -U fish_pager_color_progress ebdbb2 --background=665c54
set -U fish_pager_color_background --background=fbf1c7
set -U fish_pager_color_prefix --bold --italics
set -U fish_pager_color_completion normal
set -U fish_pager_color_description af3a03
set -U fish_pager_color_selected_background --background=d5c4a1
set -U fish_pager_color_selected_prefix --bold --italics --background=d5c4a1
set -U fish_pager_color_selected_completion normal
set -U fish_pager_color_description af3a03

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
set -Ux BASE16_THEME gruvbox-light-medium

# Optionally export variables
if test -n "$TINTED_SHELL_ENABLE_BASE16_VARS"; or test -n "$BASE16_SHELL_ENABLE_VARS"
  set -gx BASE16_COLOR_00_HEX "fbf1c7"
  set -gx BASE16_COLOR_01_HEX "ebdbb2"
  set -gx BASE16_COLOR_02_HEX "d5c4a1"
  set -gx BASE16_COLOR_03_HEX "bdae93"
  set -gx BASE16_COLOR_04_HEX "665c54"
  set -gx BASE16_COLOR_05_HEX "504945"
  set -gx BASE16_COLOR_06_HEX "3c3836"
  set -gx BASE16_COLOR_07_HEX "282828"
  set -gx BASE16_COLOR_08_HEX "9d0006"
  set -gx BASE16_COLOR_09_HEX "af3a03"
  set -gx BASE16_COLOR_0A_HEX "b57614"
  set -gx BASE16_COLOR_0B_HEX "79740e"
  set -gx BASE16_COLOR_0C_HEX "427b58"
  set -gx BASE16_COLOR_0D_HEX "076678"
  set -gx BASE16_COLOR_0E_HEX "8f3f71"
  set -gx BASE16_COLOR_0F_HEX "d65d0e"
end
