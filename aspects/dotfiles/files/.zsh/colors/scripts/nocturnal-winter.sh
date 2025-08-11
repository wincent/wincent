#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Nocturnal Winter
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="nocturnal-winter"

color00="0d/0d/17" # Base 00 - Black
color01="f1/2d/52" # Base 08 - Red
color02="08/cd/7d" # Base 0B - Green
color03="60/95/fe" # Base 0A - Yellow
color04="30/81/df" # Base 0D - Blue
color05="fe/2a/6c" # Base 0E - Magenta
color06="09/c8/7a" # Base 0C - Cyan
color07="dc/dc/dc" # Base 05 - White
color08="9e/9e/9e" # Base 03 - Bright Black
color09="f1/6c/85" # Base 12 - Bright Red
color10="0a/e7/8d" # Base 14 - Bright Green
color11="fe/fb/67" # Base 13 - Bright Yellow
color12="60/95/fe" # Base 16 - Bright Blue
color13="ff/78/a2" # Base 17 - Bright Magenta
color14="0a/e7/8d" # Base 15 - Bright Cyan
color15="ff/ff/ff" # Base 07 - Bright White
color16="f5/f0/79" # Base 09
color17="78/16/29" # Base 0F
color18="4c/4c/4c" # Base 01
color19="7f/7f/7f" # Base 02
color20="bd/bd/bd" # Base 04
color21="fb/fb/fb" # Base 06
color_foreground="dc/dc/dc" # Base 05
color_background="0d/0d/17" # Base 00


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
  put_template_custom Pg dcdcdc # foreground
  put_template_custom Ph 0d0d17 # background
  put_template_custom Pi dcdcdc # bold color
  put_template_custom Pj 7f7f7f # selection color
  put_template_custom Pk dcdcdc # selected text color
  put_template_custom Pl dcdcdc # cursor
  put_template_custom Pm 0d0d17 # cursor text
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
  export BASE24_COLOR_00_HEX="0d0d17"
  export BASE24_COLOR_01_HEX="4c4c4c"
  export BASE24_COLOR_02_HEX="7f7f7f"
  export BASE24_COLOR_03_HEX="9e9e9e"
  export BASE24_COLOR_04_HEX="bdbdbd"
  export BASE24_COLOR_05_HEX="dcdcdc"
  export BASE24_COLOR_06_HEX="fbfbfb"
  export BASE24_COLOR_07_HEX="ffffff"
  export BASE24_COLOR_08_HEX="f12d52"
  export BASE24_COLOR_09_HEX="f5f079"
  export BASE24_COLOR_0A_HEX="6095fe"
  export BASE24_COLOR_0B_HEX="08cd7d"
  export BASE24_COLOR_0C_HEX="09c87a"
  export BASE24_COLOR_0D_HEX="3081df"
  export BASE24_COLOR_0E_HEX="fe2a6c"
  export BASE24_COLOR_0F_HEX="781629"
  export BASE24_COLOR_10_HEX="545454"
  export BASE24_COLOR_11_HEX="2a2a2a"
  export BASE24_COLOR_12_HEX="f16c85"
  export BASE24_COLOR_13_HEX="fefb67"
  export BASE24_COLOR_14_HEX="0ae78d"
  export BASE24_COLOR_15_HEX="0ae78d"
  export BASE24_COLOR_16_HEX="6095fe"
  export BASE24_COLOR_17_HEX="ff78a2"
fi
