#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Ayu Dark
# Scheme author: Tinted Theming (https://github.com/tinted-theming), Ayu Theme (https://github.com/ayu-theme)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="ayu-dark"

color00="0b/0e/14" # Base 00 - Black
color01="f0/71/78" # Base 08 - Red
color02="aa/d9/4c" # Base 0B - Green
color03="ff/b4/54" # Base 0A - Yellow
color04="59/c2/ff" # Base 0D - Blue
color05="d2/a6/ff" # Base 0E - Magenta
color06="95/e6/cb" # Base 0C - Cyan
color07="e6/e1/cf" # Base 05 - White
color08="3e/4b/59" # Base 03 - Bright Black
color09="f2/6d/78" # Base 12 - Bright Red
color10="7f/d9/62" # Base 14 - Bright Green
color11="e6/b6/73" # Base 13 - Bright Yellow
color12="73/b8/ff" # Base 16 - Bright Blue
color13="dd/bc/ff" # Base 17 - Bright Magenta
color14="39/ba/e6" # Base 15 - Bright Cyan
color15="f2/f0/e7" # Base 07 - Bright White
color16="ff/8f/40" # Base 09
color17="e6/b4/50" # Base 0F
color18="13/17/21" # Base 01
color19="20/22/29" # Base 02
color20="bf/bd/b6" # Base 04
color21="ec/e8/db" # Base 06
color_foreground="e6/e1/cf" # Base 05
color_background="0b/0e/14" # Base 00


if [ -z "$TTY" ] && ! TTY=$(tty) || [ ! -w "$TTY" ]; then
  put_template() { true; }
  put_template_var() { true; }
  put_template_custom() { true; }
elif [ -n "$TMUX" ] || [ "${TERM%%[-.]*}" = "tmux" ]; then
  # Tell tmux to pass the escape sequences through
  # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
  put_template() { printf '\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\033\\' "$@" > "$TTY"; }
  put_template_var() { printf '\033Ptmux;\033\033]%d;rgb:%s\033\033\\\033\\' "$@" > "$TTY"; }
  put_template_custom() { printf '\033Ptmux;\033\033]%s%s\033\033\\\033\\' "$@" > "$TTY"; }
elif [ "${TERM%%[-.]*}" = "screen" ]; then
  # GNU screen (screen, screen-256color, screen-256color-bce)
  put_template() { printf '\033P\033]4;%d;rgb:%s\007\033\\' "$@" > "$TTY"; }
  put_template_var() { printf '\033P\033]%d;rgb:%s\007\033\\' "$@" > "$TTY"; }
  put_template_custom() { printf '\033P\033]%s%s\007\033\\' "$@" > "$TTY"; }
elif [ "${TERM%%-*}" = "linux" ]; then
  put_template() { [ "$1" -lt 16 ] && printf "\e]P%x%s" "$1" "$(echo "$2" | sed 's/\///g')" > "$TTY"; }
  put_template_var() { true; }
  put_template_custom() { true; }
else
  put_template() { printf '\033]4;%d;rgb:%s\033\\' "$@" > "$TTY"; }
  put_template_var() { printf '\033]%d;rgb:%s\033\\' "$@" > "$TTY"; }
  put_template_custom() { printf '\033]%s%s\033\\' "$@" > "$TTY"; }
fi

# 16 color space
put_template 0  "$color00"
put_template 1  "$color01"
put_template 2  "$color02"
put_template 3  "$color03"
put_template 4  "$color04"
put_template 5  "$color05"
put_template 6  "$color06"
put_template 7  "$color07"
put_template 8  "$color08"
put_template 9  "$color09"
put_template 10 "$color10"
put_template 11 "$color11"
put_template 12 "$color12"
put_template 13 "$color13"
put_template 14 "$color14"
put_template 15 "$color15"

# foreground / background / cursor color
if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  put_template_custom Pg e6e1cf # foreground
  put_template_custom Ph 0b0e14 # background
  put_template_custom Pi e6e1cf # bold color
  put_template_custom Pj 202229 # selection color
  put_template_custom Pk e6e1cf # selected text color
  put_template_custom Pl e6e1cf # cursor
  put_template_custom Pm 0b0e14 # cursor text
else
  put_template_var 10 "$color_foreground"
  if [ "$BASE24_SHELL_SET_BACKGROUND" != false ]; then
    put_template_var 11 "$color_background"
    if [ "${TERM%%-*}" = "rxvt" ]; then
      put_template_var 708 "$color_background" # internal border (rxvt)
    fi
  fi
  put_template_custom 12 ";7" # cursor (reverse video)
fi

# clean up
unset put_template
unset put_template_var
unset put_template_custom
unset color00
unset color01
unset color02
unset color03
unset color04
unset color05
unset color06
unset color07
unset color08
unset color09
unset color10
unset color11
unset color12
unset color13
unset color14
unset color16
unset color17
unset color18
unset color19
unset color20
unset color21
unset color15
unset color_foreground
unset color_background

# Optionally export variables
if [ -n "$TINTED_SHELL_ENABLE_BASE24_VARS" ]; then
  export BASE24_COLOR_00_HEX="0b0e14"
  export BASE24_COLOR_01_HEX="131721"
  export BASE24_COLOR_02_HEX="202229"
  export BASE24_COLOR_03_HEX="3e4b59"
  export BASE24_COLOR_04_HEX="bfbdb6"
  export BASE24_COLOR_05_HEX="e6e1cf"
  export BASE24_COLOR_06_HEX="ece8db"
  export BASE24_COLOR_07_HEX="f2f0e7"
  export BASE24_COLOR_08_HEX="f07178"
  export BASE24_COLOR_09_HEX="ff8f40"
  export BASE24_COLOR_0A_HEX="ffb454"
  export BASE24_COLOR_0B_HEX="aad94c"
  export BASE24_COLOR_0C_HEX="95e6cb"
  export BASE24_COLOR_0D_HEX="59c2ff"
  export BASE24_COLOR_0E_HEX="d2a6ff"
  export BASE24_COLOR_0F_HEX="e6b450"
  export BASE24_COLOR_10_HEX="0a0d13"
  export BASE24_COLOR_11_HEX="06070a"
  export BASE24_COLOR_12_HEX="f26d78"
  export BASE24_COLOR_13_HEX="e6b673"
  export BASE24_COLOR_14_HEX="7fd962"
  export BASE24_COLOR_15_HEX="39bae6"
  export BASE24_COLOR_16_HEX="73b8ff"
  export BASE24_COLOR_17_HEX="ddbcff"
fi
