#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Ciapre
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="ciapre"

color00="18/1c/27" # Base 00 - Black
color01="80/00/09" # Base 08 - Red
color02="48/51/3b" # Base 0B - Green
color03="2f/97/c6" # Base 0A - Yellow
color04="56/6d/8c" # Base 0D - Blue
color05="72/4c/7c" # Base 0E - Magenta
color06="5b/4f/4a" # Base 0C - Cyan
color07="97/8f/73" # Base 05 - White
color08="6b/68/5f" # Base 03 - Bright Black
color09="ab/38/34" # Base 12 - Bright Red
color10="a6/a6/5d" # Base 14 - Bright Green
color11="dc/de/7b" # Base 13 - Bright Yellow
color12="2f/97/c6" # Base 16 - Bright Blue
color13="d3/30/60" # Base 17 - Bright Magenta
color14="f3/da/b1" # Base 15 - Bright Cyan
color15="f3/f3/f3" # Base 07 - Bright White
color16="cc/8a/3e" # Base 09
color17="40/00/04" # Base 0F
color18="18/18/18" # Base 01
color19="55/55/55" # Base 02
color20="81/7c/69" # Base 04
color21="ad/a3/7e" # Base 06
color_foreground="97/8f/73" # Base 05
color_background="18/1c/27" # Base 00


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
  put_template_custom Pg 978f73 # foreground
  put_template_custom Ph 181c27 # background
  put_template_custom Pi 978f73 # bold color
  put_template_custom Pj 555555 # selection color
  put_template_custom Pk 978f73 # selected text color
  put_template_custom Pl 978f73 # cursor
  put_template_custom Pm 181c27 # cursor text
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
  export BASE24_COLOR_00_HEX="181c27"
  export BASE24_COLOR_01_HEX="181818"
  export BASE24_COLOR_02_HEX="555555"
  export BASE24_COLOR_03_HEX="6b685f"
  export BASE24_COLOR_04_HEX="817c69"
  export BASE24_COLOR_05_HEX="978f73"
  export BASE24_COLOR_06_HEX="ada37e"
  export BASE24_COLOR_07_HEX="f3f3f3"
  export BASE24_COLOR_08_HEX="800009"
  export BASE24_COLOR_09_HEX="cc8a3e"
  export BASE24_COLOR_0A_HEX="2f97c6"
  export BASE24_COLOR_0B_HEX="48513b"
  export BASE24_COLOR_0C_HEX="5b4f4a"
  export BASE24_COLOR_0D_HEX="566d8c"
  export BASE24_COLOR_0E_HEX="724c7c"
  export BASE24_COLOR_0F_HEX="400004"
  export BASE24_COLOR_10_HEX="383838"
  export BASE24_COLOR_11_HEX="1c1c1c"
  export BASE24_COLOR_12_HEX="ab3834"
  export BASE24_COLOR_13_HEX="dcde7b"
  export BASE24_COLOR_14_HEX="a6a65d"
  export BASE24_COLOR_15_HEX="f3dab1"
  export BASE24_COLOR_16_HEX="2f97c6"
  export BASE24_COLOR_17_HEX="d33060"
fi
