#!/usr/bin/env fish
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Lumina Olive Dark
# Scheme author: Razik Ikhlef (https://github.com/RazikSF)
# Template author: Tinted Theming (https://github.com/tinted-theming)

set -l color00 "1a/1b/0c" # Base 00 - Black
set -l color01 "d3/72/6a" # Base 08 - Red
set -l color02 "b5/d5/c6" # Base 0B - Green
set -l color03 "eb/c2/7c" # Base 0A - Yellow
set -l color04 "a2/c4/f0" # Base 0D - Blue
set -l color05 "c0/ba/f2" # Base 0E - Magenta
set -l color06 "8b/cf/d7" # Base 0C - Cyan
set -l color07 "e1/df/ce" # Base 05 - White
set -l color08 "32/34/22" # Base 03 - Bright Black
set -l color09 "e0/93/8c" # Base 12 - Bright Red
set -l color10 "b5/f7/da" # Base 14 - Bright Green
set -l color11 "ff/de/a7" # Base 13 - Bright Yellow
set -l color12 "c4/dd/ff" # Base 16 - Bright Blue
set -l color13 "f0/bb/eb" # Base 17 - Bright Magenta
set -l color14 "a3/e9/f2" # Base 15 - Bright Cyan
set -l color15 "e1/df/ce" # Base 07 - Bright White
set -l color16 "ff/c3/9b" # Base 09
set -l color17 "d5/a2/d0" # Base 0F
set -l color18 "1f/20/0f" # Base 01
set -l color19 "28/29/18" # Base 02
set -l color20 "6a/6e/58" # Base 04
set -l color21 "b1/b2/a5" # Base 06
set -l color_foreground "e1/df/ce" # Base 05
set -l color_background "1a/1b/0c" # Base 00

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
  put_template_custom Pg e1dfce # foreground
  put_template_custom Ph 1a1b0c # background
  put_template_custom Pi e1dfce # bold color
  put_template_custom Pj 282918 # selection color
  put_template_custom Pk e1dfce # selected text color
  put_template_custom Pl e1dfce # cursor
  put_template_custom Pm 1a1b0c # cursor text
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
set -U fish_color_comment 323422
set -U fish_color_selection b1b2a5 --background=282918
set -U fish_color_operator magenta
set -U fish_color_escape ffc39b
set -U fish_color_autosuggestion 323422
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_host_remote normal
set -U fish_color_status red
set -U fish_color_cancel -r
set -U fish_color_search_match yellow --background=282918
set -U fish_color_history_current --underline=curly
set -U fish_pager_color_progress 1f200f --background=6a6e58
set -U fish_pager_color_background --background=1a1b0c
set -U fish_pager_color_prefix --bold --italics
set -U fish_pager_color_completion normal
set -U fish_pager_color_description ffc39b
set -U fish_pager_color_selected_background --background=282918
set -U fish_pager_color_selected_prefix --bold --italics --background=282918
set -U fish_pager_color_selected_completion normal
set -U fish_pager_color_description ffc39b

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
set -Ux BASE24_THEME lumina-olive-dark

# Optionally export variables
if test -n "$TINTED_SHELL_ENABLE_BASE24_VARS"; or test -n "$BASE24_SHELL_ENABLE_VARS"
  set -gx BASE24_COLOR_00_HEX "1a1b0c"
  set -gx BASE24_COLOR_01_HEX "1f200f"
  set -gx BASE24_COLOR_02_HEX "282918"
  set -gx BASE24_COLOR_03_HEX "323422"
  set -gx BASE24_COLOR_04_HEX "6a6e58"
  set -gx BASE24_COLOR_05_HEX "e1dfce"
  set -gx BASE24_COLOR_06_HEX "b1b2a5"
  set -gx BASE24_COLOR_07_HEX "e1dfce"
  set -gx BASE24_COLOR_08_HEX "d3726a"
  set -gx BASE24_COLOR_09_HEX "ffc39b"
  set -gx BASE24_COLOR_0A_HEX "ebc27c"
  set -gx BASE24_COLOR_0B_HEX "b5d5c6"
  set -gx BASE24_COLOR_0C_HEX "8bcfd7"
  set -gx BASE24_COLOR_0D_HEX "a2c4f0"
  set -gx BASE24_COLOR_0E_HEX "c0baf2"
  set -gx BASE24_COLOR_0F_HEX "d5a2d0"
end
