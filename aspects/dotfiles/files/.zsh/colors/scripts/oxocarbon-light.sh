#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Oxocarbon Light
# Scheme author: shaunsingh/IBM, Tinted Theming (https://github.com/tinted-theming)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="oxocarbon-light"

color00="f2/f4/f8" # Base 00 - Black
color01="ff/7e/b6" # Base 08 - Red
color02="42/be/65" # Base 0B - Green
color03="ff/6f/00" # Base 0A - Yellow
color04="0f/62/fe" # Base 0D - Blue
color05="be/95/ff" # Base 0E - Magenta
color06="67/3a/b7" # Base 0C - Cyan
color07="52/5f/70" # Base 05 - White
color08="a1/ac/ba" # Base 03 - Bright Black
color09="ff/7e/b6" # Base 12 - Bright Red
color10="42/be/65" # Base 14 - Bright Green
color11="ff/6f/00" # Base 13 - Bright Yellow
color12="0f/62/fe" # Base 16 - Bright Blue
color13="be/95/ff" # Base 17 - Bright Magenta
color14="67/3a/b7" # Base 15 - Bright Cyan
color15="27/2d/35" # Base 07 - Bright White
color16="ee/53/96" # Base 09
color17="80/38/00" # Base 0F
color18="dd/e1/e6" # Base 01
color19="be/c6/cf" # Base 02
color20="68/78/8d" # Base 04
color21="3d/46/52" # Base 06
color_foreground="52/5f/70" # Base 05
color_background="f2/f4/f8" # Base 00


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
  put_template_custom Pg 525f70 # foreground
  put_template_custom Ph f2f4f8 # background
  put_template_custom Pi 525f70 # bold color
  put_template_custom Pj bec6cf # selection color
  put_template_custom Pk 525f70 # selected text color
  put_template_custom Pl 525f70 # cursor
  put_template_custom Pm f2f4f8 # cursor text
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
  export BASE24_COLOR_00_HEX="f2f4f8"
  export BASE24_COLOR_01_HEX="dde1e6"
  export BASE24_COLOR_02_HEX="bec6cf"
  export BASE24_COLOR_03_HEX="a1acba"
  export BASE24_COLOR_04_HEX="68788d"
  export BASE24_COLOR_05_HEX="525f70"
  export BASE24_COLOR_06_HEX="3d4652"
  export BASE24_COLOR_07_HEX="272d35"
  export BASE24_COLOR_08_HEX="ff7eb6"
  export BASE24_COLOR_09_HEX="ee5396"
  export BASE24_COLOR_0A_HEX="ff6f00"
  export BASE24_COLOR_0B_HEX="42be65"
  export BASE24_COLOR_0C_HEX="673ab7"
  export BASE24_COLOR_0D_HEX="0f62fe"
  export BASE24_COLOR_0E_HEX="be95ff"
  export BASE24_COLOR_0F_HEX="803800"
  export BASE24_COLOR_10_HEX="f2f4f8"
  export BASE24_COLOR_11_HEX="f2f4f8"
  export BASE24_COLOR_12_HEX="ff7eb6"
  export BASE24_COLOR_13_HEX="ff6f00"
  export BASE24_COLOR_14_HEX="42be65"
  export BASE24_COLOR_15_HEX="673ab7"
  export BASE24_COLOR_16_HEX="0f62fe"
  export BASE24_COLOR_17_HEX="be95ff"
fi
