#!/usr/bin/env fish
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: 
# Scheme author: 
# Template author: Tinted Theming (https://github.com/tinted-theming)

set -l color00 "2f/37/42"
set -l color01 "f4/70/67"
set -l color02 "57/ab/5a"
set -l color03 "c6/90/26"
set -l color04 "53/9b/f5"
set -l color05 "b0/83/f0"
set -l color06 "39/c5/cf"
set -l color07 "f0/f6/fc"
set -l color08 "65/6c/76"
set -l color09 "ff/93/8a"
set -l color10 "6b/c4/6d"
set -l color11 "da/aa/3f"
set -l color12 "6c/b6/ff"
set -l color13 "dc/bd/fb"
set -l color14 "56/d4/dd"
set -l color15 "cd/d9/e5"
set -l color_foreground "d1/d7/e0"
set -l color_background "21/28/30"

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
  put_template_custom Pg d1d7e0 # foreground
  put_template_custom Ph 212830 # background
  put_template_custom Pi d1d7e0 # bold color
  put_template_custom Pj 656c76 # selection color
  put_template_custom Pk f0f6fc # selected text color
  put_template_custom Pl d1d7e0 # cursor
  put_template_custom Pm 212830 # cursor text
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
set -U fish_color_normal d1d7e0
set -U fish_color_command 
set -U fish_color_keyword 
set -U fish_color_quote dcbdfb
set -U fish_color_redirection f47067
set -U fish_color_end d1d7e0
set -U fish_color_error 
set -U fish_color_param d1d7e0
set -U fish_color_valid_path --underline
set -U fish_color_option d1d7e0 --italics
set -U fish_color_comment 
set -U fish_color_selection f0f6fc --background=656c76
set -U fish_color_operator f47067
set -U fish_color_escape 6cb6ff
set -U fish_color_autosuggestion 9198a1
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_host_remote normal
set -U fish_color_status e5534b
set -U fish_color_cancel -r
set -U fish_color_search_match c69026 --background=656c76
set -U fish_color_history_current --underline=curly
set -U fish_pager_color_progress 262c36 --background=d1d7e0
set -U fish_pager_color_background --background=
set -U fish_pager_color_prefix --bold --italics
set -U fish_pager_color_completion f0f6fc
set -U fish_pager_color_description 
set -U fish_pager_color_selected_background --background=656c76
set -U fish_pager_color_selected_prefix --bold --italics --background=656c76
set -U fish_pager_color_selected_completion f0f6fc
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
set -Ux TINTED8_THEME github-dark-dimmed

# Optionally export variables
if test -n "$TINTED_SHELL_ENABLE_TINTED8_VARS"
  set -gx TINTED8_COLOR_BLACK_NORMAL_HEX "2f3742"
  set -gx TINTED8_COLOR_BLACK_RED_HEX "f47067"
  set -gx TINTED8_COLOR_BLACK_GREEN_HEX "57ab5a"
  set -gx TINTED8_COLOR_YELLOW_NORMAL_HEX "c69026"
  set -gx TINTED8_COLOR_BLUE_NORMAL_HEX "539bf5"
  set -gx TINTED8_COLOR_MAGENTA_NORMAL_HEX "b083f0"
  set -gx TINTED8_COLOR_CYAN_NORMAL_HEX "39c5cf"
  set -gx TINTED8_COLOR_WHITE_NORMAL_HEX "f0f6fc"

  set -gx TINTED8_COLOR_BLACK_BRIGHT_HEX "656c76"
  set -gx TINTED8_COLOR_RED_BRIGHT_HEX "ff938a"
  set -gx TINTED8_COLOR_GREEN_BRIGHT_HEX "6bc46d"
  set -gx TINTED8_COLOR_YELLOW_BRIGHT_HEX "daaa3f"
  set -gx TINTED8_COLOR_BLUE_BRIGHT_HEX "6cb6ff"
  set -gx TINTED8_COLOR_MAGENTA_BRIGHT_HEX "dcbdfb"
  set -gx TINTED8_COLOR_CYAN_BRIGHT_HEX "56d4dd"
  set -gx TINTED8_COLOR_WHITE_BRIGHT_HEX "cdd9e5"

  set -gx TINTED8_COLOR_BLACK_DIM_HEX "15191e"
  set -gx TINTED8_COLOR_RED_DIM_HEX "f73427"
  set -gx TINTED8_COLOR_GREEN_DIM_HEX "3f8542"
  set -gx TINTED8_COLOR_YELLOW_DIM_HEX "976c18"
  set -gx TINTED8_COLOR_BLUE_DIM_HEX "1279f9"
  set -gx TINTED8_COLOR_MAGENTA_DIM_HEX "8c45f1"
  set -gx TINTED8_COLOR_CYAN_DIM_HEX "239fa8"
  set -gx TINTED8_COLOR_WHITE_DIM_HEX "bad7f4"
end
