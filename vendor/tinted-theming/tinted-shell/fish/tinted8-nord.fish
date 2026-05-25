#!/usr/bin/env fish
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: 
# Scheme author: 
# Template author: Tinted Theming (https://github.com/tinted-theming)

set -l color00 "2e/34/40"
set -l color01 "bf/61/6a"
set -l color02 "a3/be/8c"
set -l color03 "eb/cb/8b"
set -l color04 "81/a1/c1"
set -l color05 "b4/8e/ad"
set -l color06 "88/c0/d0"
set -l color07 "e5/e9/f0"
set -l color08 "46/51/65"
set -l color09 "d1/8d/93"
set -l color10 "c2/d4/b3"
set -l color11 "f4/e2/bf"
set -l color12 "aa/c0/d5"
set -l color13 "cc/b3/c8"
set -l color14 "b4/d7/e1"
set -l color15 "ec/ef/f4"
set -l color_foreground "e5/e9/f0"
set -l color_background "2e/34/40"

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
  put_template_custom Pg e5e9f0 # foreground
  put_template_custom Ph 2e3440 # background
  put_template_custom Pi e5e9f0 # bold color
  put_template_custom Pj 465165 # selection color
  put_template_custom Pk e5e9f0 # selected text color
  put_template_custom Pl e5e9f0 # cursor
  put_template_custom Pm 2e3440 # cursor text
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
set -U fish_color_normal e5e9f0
set -U fish_color_command 
set -U fish_color_keyword 
set -U fish_color_quote aac0d5
set -U fish_color_redirection 81a1c1
set -U fish_color_end e5e9f0
set -U fish_color_error 
set -U fish_color_param b4d7e1
set -U fish_color_valid_path --underline
set -U fish_color_option b4d7e1 --italics
set -U fish_color_comment 
set -U fish_color_selection e5e9f0 --background=465165
set -U fish_color_operator 81a1c1
set -U fish_color_escape 88c0d0
set -U fish_color_autosuggestion 616e88
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_host_remote normal
set -U fish_color_status bf616a
set -U fish_color_cancel -r
set -U fish_color_search_match ebcb8b --background=465165
set -U fish_color_history_current --underline=curly
set -U fish_pager_color_progress 465165 --background=e5e9f0
set -U fish_pager_color_background --background=
set -U fish_pager_color_prefix --bold --italics
set -U fish_pager_color_completion e5e9f0
set -U fish_pager_color_description 
set -U fish_pager_color_selected_background --background=465165
set -U fish_pager_color_selected_prefix --bold --italics --background=465165
set -U fish_pager_color_selected_completion e5e9f0
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
set -Ux TINTED8_THEME nord

# Optionally export variables
if test -n "$TINTED_SHELL_ENABLE_TINTED8_VARS"
  set -gx TINTED8_COLOR_BLACK_NORMAL_HEX "2e3440"
  set -gx TINTED8_COLOR_BLACK_RED_HEX "bf616a"
  set -gx TINTED8_COLOR_BLACK_GREEN_HEX "a3be8c"
  set -gx TINTED8_COLOR_YELLOW_NORMAL_HEX "ebcb8b"
  set -gx TINTED8_COLOR_BLUE_NORMAL_HEX "81a1c1"
  set -gx TINTED8_COLOR_MAGENTA_NORMAL_HEX "b48ead"
  set -gx TINTED8_COLOR_CYAN_NORMAL_HEX "88c0d0"
  set -gx TINTED8_COLOR_WHITE_NORMAL_HEX "e5e9f0"

  set -gx TINTED8_COLOR_BLACK_BRIGHT_HEX "465165"
  set -gx TINTED8_COLOR_RED_BRIGHT_HEX "d18d93"
  set -gx TINTED8_COLOR_GREEN_BRIGHT_HEX "c2d4b3"
  set -gx TINTED8_COLOR_YELLOW_BRIGHT_HEX "f4e2bf"
  set -gx TINTED8_COLOR_BLUE_BRIGHT_HEX "aac0d5"
  set -gx TINTED8_COLOR_MAGENTA_BRIGHT_HEX "ccb3c8"
  set -gx TINTED8_COLOR_CYAN_BRIGHT_HEX "b4d7e1"
  set -gx TINTED8_COLOR_WHITE_BRIGHT_HEX "eceff4"

  set -gx TINTED8_COLOR_BLACK_DIM_HEX "14171d"
  set -gx TINTED8_COLOR_RED_DIM_HEX "a53e48"
  set -gx TINTED8_COLOR_GREEN_DIM_HEX "84aa63"
  set -gx TINTED8_COLOR_YELLOW_DIM_HEX "e9b650"
  set -gx TINTED8_COLOR_BLUE_DIM_HEX "5e81ac"
  set -gx TINTED8_COLOR_MAGENTA_DIM_HEX "9d6793"
  set -gx TINTED8_COLOR_CYAN_DIM_HEX "59abc2"
  set -gx TINTED8_COLOR_WHITE_DIM_HEX "d8dee9"
end
