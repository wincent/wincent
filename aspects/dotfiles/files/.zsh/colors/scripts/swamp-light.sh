#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Swamp Light
# Scheme author: Masroof Maindak (https://github.com/masroof-maindak)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="swamp-light"

color00="F1/E3/D1" # Base 00 - Black
color01="D0/97/00" # Base 08 - Red
color02="90/8D/6A" # Base 0B - Green
color03="99/33/33" # Base 0A - Yellow
color04="BF/79/79" # Base 0D - Blue
color05="9E/55/81" # Base 0E - Magenta
color06="d0/97/00" # Base 0C - Cyan
color07="64/51/3E" # Base 05 - White
color08="B5/A4/92" # Base 03 - Bright Black
color09="D0/97/00" # Base 12 - Bright Red
color10="90/8D/6A" # Base 14 - Bright Green
color11="99/33/33" # Base 13 - Bright Yellow
color12="BF/79/79" # Base 16 - Bright Blue
color13="9E/55/81" # Base 17 - Bright Magenta
color14="d0/97/00" # Base 15 - Bright Cyan
color15="8C/7B/68" # Base 07 - Bright White
color16="64/51/3E" # Base 09
color17="75/85/8C" # Base 0F
color18="DD/CE/BC" # Base 01
color19="C9/B9/A7" # Base 02
color20="A0/90/7D" # Base 04
color21="78/66/53" # Base 06
color_foreground="64/51/3E" # Base 05
color_background="F1/E3/D1" # Base 00


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

# 256 color space
put_template 16 "$color16"
put_template 17 "$color17"
put_template 18 "$color18"
put_template 19 "$color19"
put_template 20 "$color20"
put_template 21 "$color21"

# foreground / background / cursor color
if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  put_template_custom Pg 64513E # foreground
  put_template_custom Ph F1E3D1 # background
  put_template_custom Pi 64513E # bold color
  put_template_custom Pj C9B9A7 # selection color
  put_template_custom Pk 64513E # selected text color
  put_template_custom Pl 64513E # cursor
  put_template_custom Pm F1E3D1 # cursor text
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
unset color15
unset color16
unset color17
unset color18
unset color19
unset color20
unset color21
unset color_foreground
unset color_background

# Optionally export variables
if [ -n "$TINTED_SHELL_ENABLE_BASE24_VARS" ]; then
  export BASE24_COLOR_00_HEX="F1E3D1"
  export BASE24_COLOR_01_HEX="DDCEBC"
  export BASE24_COLOR_02_HEX="C9B9A7"
  export BASE24_COLOR_03_HEX="B5A492"
  export BASE24_COLOR_04_HEX="A0907D"
  export BASE24_COLOR_05_HEX="64513E"
  export BASE24_COLOR_06_HEX="786653"
  export BASE24_COLOR_07_HEX="8C7B68"
  export BASE24_COLOR_08_HEX="D09700"
  export BASE24_COLOR_09_HEX="64513E"
  export BASE24_COLOR_0A_HEX="993333"
  export BASE24_COLOR_0B_HEX="908D6A"
  export BASE24_COLOR_0C_HEX="d09700"
  export BASE24_COLOR_0D_HEX="BF7979"
  export BASE24_COLOR_0E_HEX="9E5581"
  export BASE24_COLOR_0F_HEX="75858C"
  export BASE24_COLOR_10_HEX="F1E3D1"
  export BASE24_COLOR_11_HEX="F1E3D1"
  export BASE24_COLOR_12_HEX="D09700"
  export BASE24_COLOR_13_HEX="993333"
  export BASE24_COLOR_14_HEX="908D6A"
  export BASE24_COLOR_15_HEX="d09700"
  export BASE24_COLOR_16_HEX="BF7979"
  export BASE24_COLOR_17_HEX="9E5581"
fi
