#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Lumina Nebula Light
# Scheme author: Razik Ikhlef (https://github.com/RazikSF)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="lumina-nebula-light"

color00="f8/f4/ff" # Base 00 - Black
color01="93/22/22" # Base 08 - Red
color02="00/76/50" # Base 0B - Green
color03="95/5b/01" # Base 0A - Yellow
color04="3f/57/77" # Base 0D - Blue
color05="5d/40/b1" # Base 0E - Magenta
color06="01/6e/90" # Base 0C - Cyan
color07="2d/2c/46" # Base 05 - White
color08="d6/d1/df" # Base 03 - Bright Black
color09="6c/24/21" # Base 12 - Bright Red
color10="00/5f/40" # Base 14 - Bright Green
color11="7a/4a/00" # Base 13 - Bright Yellow
color12="0e/41/7f" # Base 16 - Bright Blue
color13="72/35/6e" # Base 17 - Bright Magenta
color14="00/59/75" # Base 15 - Bright Cyan
color15="2d/2c/46" # Base 07 - Bright White
color16="93/49/16" # Base 09
color17="89/48/84" # Base 0F
color18="f2/ed/fb" # Base 01
color19="e6/e1/ef" # Base 02
color20="88/83/91" # Base 04
color21="4a/45/51" # Base 06
color_foreground="2d/2c/46" # Base 05
color_background="f8/f4/ff" # Base 00


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
  put_template_custom Pg 2d2c46 # foreground
  put_template_custom Ph f8f4ff # background
  put_template_custom Pi 2d2c46 # bold color
  put_template_custom Pj e6e1ef # selection color
  put_template_custom Pk 2d2c46 # selected text color
  put_template_custom Pl 2d2c46 # cursor
  put_template_custom Pm f8f4ff # cursor text
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
  export BASE24_COLOR_00_HEX="f8f4ff"
  export BASE24_COLOR_01_HEX="f2edfb"
  export BASE24_COLOR_02_HEX="e6e1ef"
  export BASE24_COLOR_03_HEX="d6d1df"
  export BASE24_COLOR_04_HEX="888391"
  export BASE24_COLOR_05_HEX="2d2c46"
  export BASE24_COLOR_06_HEX="4a4551"
  export BASE24_COLOR_07_HEX="2d2c46"
  export BASE24_COLOR_08_HEX="932222"
  export BASE24_COLOR_09_HEX="934916"
  export BASE24_COLOR_0A_HEX="955b01"
  export BASE24_COLOR_0B_HEX="007650"
  export BASE24_COLOR_0C_HEX="016e90"
  export BASE24_COLOR_0D_HEX="3f5777"
  export BASE24_COLOR_0E_HEX="5d40b1"
  export BASE24_COLOR_0F_HEX="894884"
  export BASE24_COLOR_10_HEX="fffdff"
  export BASE24_COLOR_11_HEX="f1edf8"
  export BASE24_COLOR_12_HEX="6c2421"
  export BASE24_COLOR_13_HEX="7a4a00"
  export BASE24_COLOR_14_HEX="005f40"
  export BASE24_COLOR_15_HEX="005975"
  export BASE24_COLOR_16_HEX="0e417f"
  export BASE24_COLOR_17_HEX="72356e"
fi
