#!/usr/bin/env fish
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: 
# Scheme author: 
# Template author: Tinted Theming (https://github.com/tinted-theming)

set -l color00 "1e/1e/2e"
set -l color01 "f3/8b/a8"
set -l color02 "a6/e3/a1"
set -l color03 "f9/e2/af"
set -l color04 "89/b4/fa"
set -l color05 "cb/a6/f7"
set -l color06 "94/e2/d5"
set -l color07 "cd/d6/f4"
set -l color08 "35/35/54"
set -l color09 "f9/c2/d2"
set -l color10 "d3/f1/d0"
set -l color11 "fc/f6/e9"
set -l color12 "c4/d9/fc"
set -l color13 "ec/e0/fb"
set -l color14 "c4/ef/e8"
set -l color15 "ff/ff/ff"
set -l color_foreground "cd/d6/f4"
set -l color_background "1e/1e/2e"

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
  put_template_custom Pg cdd6f4 # foreground
  put_template_custom Ph 1e1e2e # background
  put_template_custom Pi cdd6f4 # bold color
  put_template_custom Pj 353554 # selection color
  put_template_custom Pk cdd6f4 # selected text color
  put_template_custom Pl cdd6f4 # cursor
  put_template_custom Pm 1e1e2e # cursor text
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
set -U fish_color_normal cdd6f4
set -U fish_color_command 
set -U fish_color_keyword 
set -U fish_color_quote c4d9fc
set -U fish_color_redirection cba6f7
set -U fish_color_end cdd6f4
set -U fish_color_error 
set -U fish_color_param c4efe8
set -U fish_color_valid_path --underline
set -U fish_color_option c4efe8 --italics
set -U fish_color_comment 
set -U fish_color_selection cdd6f4 --background=353554
set -U fish_color_operator 94e2d5
set -U fish_color_escape fab387
set -U fish_color_autosuggestion 505365
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_host_remote normal
set -U fish_color_status f38ba8
set -U fish_color_cancel -r
set -U fish_color_search_match f9e2af --background=353554
set -U fish_color_history_current --underline=curly
set -U fish_pager_color_progress 353554 --background=cdd6f4
set -U fish_pager_color_background --background=
set -U fish_pager_color_prefix --bold --italics
set -U fish_pager_color_completion cdd6f4
set -U fish_pager_color_description 
set -U fish_pager_color_selected_background --background=353554
set -U fish_pager_color_selected_prefix --bold --italics --background=353554
set -U fish_pager_color_selected_completion cdd6f4
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
set -Ux TINTED8_THEME catppuccin-mocha

# Optionally export variables
if test -n "$TINTED_SHELL_ENABLE_TINTED8_VARS"
  set -gx TINTED8_COLOR_BLACK_NORMAL_HEX "1e1e2e"
  set -gx TINTED8_COLOR_BLACK_RED_HEX "f38ba8"
  set -gx TINTED8_COLOR_BLACK_GREEN_HEX "a6e3a1"
  set -gx TINTED8_COLOR_YELLOW_NORMAL_HEX "f9e2af"
  set -gx TINTED8_COLOR_BLUE_NORMAL_HEX "89b4fa"
  set -gx TINTED8_COLOR_MAGENTA_NORMAL_HEX "cba6f7"
  set -gx TINTED8_COLOR_CYAN_NORMAL_HEX "94e2d5"
  set -gx TINTED8_COLOR_WHITE_NORMAL_HEX "cdd6f4"

  set -gx TINTED8_COLOR_BLACK_BRIGHT_HEX "353554"
  set -gx TINTED8_COLOR_RED_BRIGHT_HEX "f9c2d2"
  set -gx TINTED8_COLOR_GREEN_BRIGHT_HEX "d3f1d0"
  set -gx TINTED8_COLOR_YELLOW_BRIGHT_HEX "fcf6e9"
  set -gx TINTED8_COLOR_BLUE_BRIGHT_HEX "c4d9fc"
  set -gx TINTED8_COLOR_MAGENTA_BRIGHT_HEX "ece0fb"
  set -gx TINTED8_COLOR_CYAN_BRIGHT_HEX "c4efe8"
  set -gx TINTED8_COLOR_WHITE_BRIGHT_HEX "ffffff"

  set -gx TINTED8_COLOR_BLACK_DIM_HEX "181825"
  set -gx TINTED8_COLOR_RED_DIM_HEX "f54c7b"
  set -gx TINTED8_COLOR_GREEN_DIM_HEX "75da6d"
  set -gx TINTED8_COLOR_YELLOW_DIM_HEX "fbd070"
  set -gx TINTED8_COLOR_BLUE_DIM_HEX "478dff"
  set -gx TINTED8_COLOR_MAGENTA_DIM_HEX "aa67f9"
  set -gx TINTED8_COLOR_CYAN_DIM_HEX "89dceb"
  set -gx TINTED8_COLOR_WHITE_DIM_HEX "97abed"
end
