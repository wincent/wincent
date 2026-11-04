#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Lumina Oxblood Light
# Scheme author: Razik Ikhlef (https://github.com/RazikSF)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="lumina-oxblood-light"

color00="fe/f2/f4" # Base 00 - Black
color01="9b/28/27" # Base 08 - Red
color02="23/77/42" # Base 0B - Green
color03="a1/60/0a" # Base 0A - Yellow
color04="31/66/a6" # Base 0D - Blue
color05="65/56/a3" # Base 0E - Magenta
color06="08/73/80" # Base 0C - Cyan
color07="42/22/2f" # Base 05 - White
color08="de/ce/d1" # Base 03 - Bright Black
color09="73/29/26" # Base 12 - Bright Red
color10="0f/61/31" # Base 14 - Bright Green
color11="87/4e/00" # Base 13 - Bright Yellow
color12="1c/52/90" # Base 16 - Bright Blue
color13="68/3a/7d" # Base 17 - Bright Magenta
color14="00/5d/68" # Base 15 - Bright Cyan
color15="42/22/2f" # Base 07 - Bright White
color16="9e/51/1f" # Base 09
color17="82/46/9d" # Base 0F
color18="fb/ea/ed" # Base 01
color19="ef/de/e1" # Base 02
color20="91/82/84" # Base 04
color21="51/44/46" # Base 06
color_foreground="42/22/2f" # Base 05
color_background="fe/f2/f4" # Base 00


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
  put_template_custom Pg 42222f # foreground
  put_template_custom Ph fef2f4 # background
  put_template_custom Pi 42222f # bold color
  put_template_custom Pj efdee1 # selection color
  put_template_custom Pk 42222f # selected text color
  put_template_custom Pl 42222f # cursor
  put_template_custom Pm fef2f4 # cursor text
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
  export BASE24_COLOR_00_HEX="fef2f4"
  export BASE24_COLOR_01_HEX="fbeaed"
  export BASE24_COLOR_02_HEX="efdee1"
  export BASE24_COLOR_03_HEX="deced1"
  export BASE24_COLOR_04_HEX="918284"
  export BASE24_COLOR_05_HEX="42222f"
  export BASE24_COLOR_06_HEX="514446"
  export BASE24_COLOR_07_HEX="42222f"
  export BASE24_COLOR_08_HEX="9b2827"
  export BASE24_COLOR_09_HEX="9e511f"
  export BASE24_COLOR_0A_HEX="a1600a"
  export BASE24_COLOR_0B_HEX="237742"
  export BASE24_COLOR_0C_HEX="087380"
  export BASE24_COLOR_0D_HEX="3166a6"
  export BASE24_COLOR_0E_HEX="6556a3"
  export BASE24_COLOR_0F_HEX="82469d"
  export BASE24_COLOR_10_HEX="fffcfd"
  export BASE24_COLOR_11_HEX="f7ebed"
  export BASE24_COLOR_12_HEX="732926"
  export BASE24_COLOR_13_HEX="874e00"
  export BASE24_COLOR_14_HEX="0f6131"
  export BASE24_COLOR_15_HEX="005d68"
  export BASE24_COLOR_16_HEX="1c5290"
  export BASE24_COLOR_17_HEX="683a7d"
fi
