#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Ayu Light
# Scheme author: Tinted Theming (https://github.com/tinted-theming), Ayu Theme (https://github.com/ayu-theme)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="ayu-light"

color00="f8/f9/fa" # Base 00 - Black
color01="f0/71/71" # Base 08 - Red
color02="6c/bf/49" # Base 0B - Green
color03="f2/ae/49" # Base 0A - Yellow
color04="39/9e/e6" # Base 0D - Blue
color05="a3/7a/cc" # Base 0E - Magenta
color06="4c/bf/99" # Base 0C - Cyan
color07="5c/61/66" # Base 05 - White
color08="a0/a6/ac" # Base 03 - Bright Black
color09="ff/73/83" # Base 12 - Bright Red
color10="86/b3/00" # Base 14 - Bright Green
color11="ff/aa/33" # Base 13 - Bright Yellow
color12="47/8a/cc" # Base 16 - Bright Blue
color13="b5/95/d6" # Base 17 - Bright Magenta
color14="55/b4/d4" # Base 15 - Bright Cyan
color15="40/44/47" # Base 07 - Bright White
color16="fa/8d/3e" # Base 09
color17="e6/ba/7e" # Base 0F
color18="ed/ef/f1" # Base 01
color19="d2/d4/d8" # Base 02
color20="8a/91/99" # Base 04
color21="4e/52/57" # Base 06
color_foreground="5c/61/66" # Base 05
color_background="f8/f9/fa" # Base 00


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
  put_template_custom Pg 5c6166 # foreground
  put_template_custom Ph f8f9fa # background
  put_template_custom Pi 5c6166 # bold color
  put_template_custom Pj d2d4d8 # selection color
  put_template_custom Pk 5c6166 # selected text color
  put_template_custom Pl 5c6166 # cursor
  put_template_custom Pm f8f9fa # cursor text
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
  export BASE24_COLOR_00_HEX="f8f9fa"
  export BASE24_COLOR_01_HEX="edeff1"
  export BASE24_COLOR_02_HEX="d2d4d8"
  export BASE24_COLOR_03_HEX="a0a6ac"
  export BASE24_COLOR_04_HEX="8a9199"
  export BASE24_COLOR_05_HEX="5c6166"
  export BASE24_COLOR_06_HEX="4e5257"
  export BASE24_COLOR_07_HEX="404447"
  export BASE24_COLOR_08_HEX="f07171"
  export BASE24_COLOR_09_HEX="fa8d3e"
  export BASE24_COLOR_0A_HEX="f2ae49"
  export BASE24_COLOR_0B_HEX="6cbf49"
  export BASE24_COLOR_0C_HEX="4cbf99"
  export BASE24_COLOR_0D_HEX="399ee6"
  export BASE24_COLOR_0E_HEX="a37acc"
  export BASE24_COLOR_0F_HEX="e6ba7e"
  export BASE24_COLOR_10_HEX="f9f9f9"
  export BASE24_COLOR_11_HEX="ffffff"
  export BASE24_COLOR_12_HEX="ff7383"
  export BASE24_COLOR_13_HEX="ffaa33"
  export BASE24_COLOR_14_HEX="86b300"
  export BASE24_COLOR_15_HEX="55b4d4"
  export BASE24_COLOR_16_HEX="478acc"
  export BASE24_COLOR_17_HEX="b595d6"
fi
