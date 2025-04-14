#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Pnevma 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="pnevma"

color00="1c/1c/1c" # Base 00 - Black
color01="a3/66/66" # Base 08 - Red
color02="90/a5/7d" # Base 0B - Green
color03="a1/bd/ce" # Base 0A - Yellow
color04="7f/a5/bd" # Base 0D - Blue
color05="c7/9e/c4" # Base 0E - Magenta
color06="8a/db/b4" # Base 0C - Cyan
color07="d0/d0/d0" # Base 06 - White
color08="4a/48/45" # Base 02 - Bright Black
color09="d7/87/87" # Base 12 - Bright Red
color10="af/be/a2" # Base 14 - Bright Green
color11="e4/c9/af" # Base 13 - Bright Yellow
color12="a1/bd/ce" # Base 16 - Bright Blue
color13="d7/be/da" # Base 17 - Bright Magenta
color14="b1/e7/dd" # Base 15 - Bright Cyan
color15="ef/ef/ef" # Base 07 - Bright White
color16="d7/af/87" # Base 09
color17="51/33/33" # Base 0F
color18="2f/2e/2d" # Base 01
color19="4a/48/45" # Base 02
color20="8d/8c/8a" # Base 04
color21="d0/d0/d0" # Base 06
color_foreground="ae/ae/ad" # Base 05
color_background="1c/1c/1c" # Base 00


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
  put_template_custom Pg aeaead # foreground
  put_template_custom Ph 1c1c1c # background
  put_template_custom Pi aeaead # bold color
  put_template_custom Pj 4a4845 # selection color
  put_template_custom Pk aeaead # selected text color
  put_template_custom Pl aeaead # cursor
  put_template_custom Pm 1c1c1c # cursor text
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
  export BASE24_COLOR_00_HEX="1c1c1c"
  export BASE24_COLOR_01_HEX="2f2e2d"
  export BASE24_COLOR_02_HEX="4a4845"
  export BASE24_COLOR_03_HEX="6b6a67"
  export BASE24_COLOR_04_HEX="8d8c8a"
  export BASE24_COLOR_05_HEX="aeaead"
  export BASE24_COLOR_06_HEX="d0d0d0"
  export BASE24_COLOR_07_HEX="efefef"
  export BASE24_COLOR_08_HEX="a36666"
  export BASE24_COLOR_09_HEX="d7af87"
  export BASE24_COLOR_0A_HEX="a1bdce"
  export BASE24_COLOR_0B_HEX="90a57d"
  export BASE24_COLOR_0C_HEX="8adbb4"
  export BASE24_COLOR_0D_HEX="7fa5bd"
  export BASE24_COLOR_0E_HEX="c79ec4"
  export BASE24_COLOR_0F_HEX="513333"
  export BASE24_COLOR_10_HEX="31302e"
  export BASE24_COLOR_11_HEX="181817"
  export BASE24_COLOR_12_HEX="d78787"
  export BASE24_COLOR_13_HEX="e4c9af"
  export BASE24_COLOR_14_HEX="afbea2"
  export BASE24_COLOR_15_HEX="b1e7dd"
  export BASE24_COLOR_16_HEX="a1bdce"
  export BASE24_COLOR_17_HEX="d7beda"
fi
