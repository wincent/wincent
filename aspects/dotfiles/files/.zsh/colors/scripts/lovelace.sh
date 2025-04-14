#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Lovelace 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="lovelace"

color00="1d/1f/28" # Base 00 - Black
color01="f3/7f/97" # Base 08 - Red
color02="5a/de/cd" # Base 0B - Green
color03="55/6f/ff" # Base 0A - Yellow
color04="88/97/f4" # Base 0D - Blue
color05="c5/74/dd" # Base 0E - Magenta
color06="79/e6/f3" # Base 0C - Cyan
color07="fd/fd/fd" # Base 06 - White
color08="41/44/58" # Base 02 - Bright Black
color09="ff/49/71" # Base 12 - Bright Red
color10="18/e3/c8" # Base 14 - Bright Green
color11="ff/80/37" # Base 13 - Bright Yellow
color12="55/6f/ff" # Base 16 - Bright Blue
color13="b0/43/d1" # Base 17 - Bright Magenta
color14="3f/dc/ee" # Base 15 - Bright Cyan
color15="be/be/c1" # Base 07 - Bright White
color16="f2/a2/72" # Base 09
color17="79/3f/4b" # Base 0F
color18="28/2a/36" # Base 01
color19="41/44/58" # Base 02
color20="9f/a0/aa" # Base 04
color21="fd/fd/fd" # Base 06
color_foreground="ce/ce/d3" # Base 05
color_background="1d/1f/28" # Base 00


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
  put_template_custom Pg ceced3 # foreground
  put_template_custom Ph 1d1f28 # background
  put_template_custom Pi ceced3 # bold color
  put_template_custom Pj 414458 # selection color
  put_template_custom Pk ceced3 # selected text color
  put_template_custom Pl ceced3 # cursor
  put_template_custom Pm 1d1f28 # cursor text
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
  export BASE24_COLOR_00_HEX="1d1f28"
  export BASE24_COLOR_01_HEX="282a36"
  export BASE24_COLOR_02_HEX="414458"
  export BASE24_COLOR_03_HEX="707281"
  export BASE24_COLOR_04_HEX="9fa0aa"
  export BASE24_COLOR_05_HEX="ceced3"
  export BASE24_COLOR_06_HEX="fdfdfd"
  export BASE24_COLOR_07_HEX="bebec1"
  export BASE24_COLOR_08_HEX="f37f97"
  export BASE24_COLOR_09_HEX="f2a272"
  export BASE24_COLOR_0A_HEX="556fff"
  export BASE24_COLOR_0B_HEX="5adecd"
  export BASE24_COLOR_0C_HEX="79e6f3"
  export BASE24_COLOR_0D_HEX="8897f4"
  export BASE24_COLOR_0E_HEX="c574dd"
  export BASE24_COLOR_0F_HEX="793f4b"
  export BASE24_COLOR_10_HEX="2b2d3a"
  export BASE24_COLOR_11_HEX="15161d"
  export BASE24_COLOR_12_HEX="ff4971"
  export BASE24_COLOR_13_HEX="ff8037"
  export BASE24_COLOR_14_HEX="18e3c8"
  export BASE24_COLOR_15_HEX="3fdcee"
  export BASE24_COLOR_16_HEX="556fff"
  export BASE24_COLOR_17_HEX="b043d1"
fi
