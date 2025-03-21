#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Gigavolt 
# Scheme author: Aidan Swope (http://github.com/Whillikers)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="gigavolt"

color00="20/21/26" # Base 00 - Black
color01="ff/66/1a" # Base 08 - Red
color02="f2/e6/a9" # Base 0B - Green
color03="ff/dc/2d" # Base 0A - Yellow
color04="40/bf/ff" # Base 0D - Blue
color05="ae/94/f9" # Base 0E - Magenta
color06="fb/6a/cb" # Base 0C - Cyan
color07="ef/f0/f9" # Base 06 - White
color08="5a/57/6e" # Base 02 - Bright Black
color09="ff/66/1a" # Base 12 - Bright Red
color10="f2/e6/a9" # Base 14 - Bright Green
color11="ff/dc/2d" # Base 13 - Bright Yellow
color12="40/bf/ff" # Base 16 - Bright Blue
color13="ae/94/f9" # Base 17 - Bright Magenta
color14="fb/6a/cb" # Base 15 - Bright Cyan
color15="f2/fb/ff" # Base 07 - Bright White
color16="19/f9/88" # Base 09
color17="61/87/ff" # Base 0F
color18="2d/30/3d" # Base 01
color19="5a/57/6e" # Base 02
color20="ca/d3/ff" # Base 04
color21="ef/f0/f9" # Base 06
color_foreground="e9/e7/e1" # Base 05
color_background="20/21/26" # Base 00


if [ -z "$TTY" ] && ! TTY=$(tty); then
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
  put_template_custom Pg e9e7e1 # foreground
  put_template_custom Ph 202126 # background
  put_template_custom Pi e9e7e1 # bold color
  put_template_custom Pj 5a576e # selection color
  put_template_custom Pk e9e7e1 # selected text color
  put_template_custom Pl e9e7e1 # cursor
  put_template_custom Pm 202126 # cursor text
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
  export BASE24_COLOR_00_HEX="202126"
  export BASE24_COLOR_01_HEX="2d303d"
  export BASE24_COLOR_02_HEX="5a576e"
  export BASE24_COLOR_03_HEX="a1d2e6"
  export BASE24_COLOR_04_HEX="cad3ff"
  export BASE24_COLOR_05_HEX="e9e7e1"
  export BASE24_COLOR_06_HEX="eff0f9"
  export BASE24_COLOR_07_HEX="f2fbff"
  export BASE24_COLOR_08_HEX="ff661a"
  export BASE24_COLOR_09_HEX="19f988"
  export BASE24_COLOR_0A_HEX="ffdc2d"
  export BASE24_COLOR_0B_HEX="f2e6a9"
  export BASE24_COLOR_0C_HEX="fb6acb"
  export BASE24_COLOR_0D_HEX="40bfff"
  export BASE24_COLOR_0E_HEX="ae94f9"
  export BASE24_COLOR_0F_HEX="6187ff"
  export BASE24_COLOR_10_HEX="202126"
  export BASE24_COLOR_11_HEX="202126"
  export BASE24_COLOR_12_HEX="ff661a"
  export BASE24_COLOR_13_HEX="ffdc2d"
  export BASE24_COLOR_14_HEX="f2e6a9"
  export BASE24_COLOR_15_HEX="fb6acb"
  export BASE24_COLOR_16_HEX="40bfff"
  export BASE24_COLOR_17_HEX="ae94f9"
fi
