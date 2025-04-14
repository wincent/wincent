#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Toy Chest 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="toy-chest"

color00="23/36/4a" # Base 00 - Black
color01="be/2d/26" # Base 08 - Red
color02="19/91/71" # Base 0B - Green
color03="33/a5/d9" # Base 0A - Yellow
color04="32/5d/96" # Base 0D - Blue
color05="8a/5d/db" # Base 0E - Magenta
color06="35/a0/8f" # Base 0C - Cyan
color07="23/d0/82" # Base 06 - White
color08="32/68/89" # Base 02 - Bright Black
color09="dd/59/43" # Base 12 - Bright Red
color10="30/cf/7b" # Base 14 - Bright Green
color11="e7/d7/4b" # Base 13 - Bright Yellow
color12="33/a5/d9" # Base 16 - Bright Blue
color13="ad/6b/dc" # Base 17 - Bright Magenta
color14="41/c3/ad" # Base 15 - Bright Cyan
color15="d4/d4/d4" # Base 07 - Bright White
color16="da/8e/26" # Base 09
color17="5f/16/13" # Base 0F
color18="2c/3f/57" # Base 01
color19="32/68/89" # Base 02
color20="2b/9c/86" # Base 04
color21="23/d0/82" # Base 06
color_foreground="27/b6/84" # Base 05
color_background="23/36/4a" # Base 00


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
  put_template_custom Pg 27b684 # foreground
  put_template_custom Ph 23364a # background
  put_template_custom Pi 27b684 # bold color
  put_template_custom Pj 326889 # selection color
  put_template_custom Pk 27b684 # selected text color
  put_template_custom Pl 27b684 # cursor
  put_template_custom Pm 23364a # cursor text
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
  export BASE24_COLOR_00_HEX="23364a"
  export BASE24_COLOR_01_HEX="2c3f57"
  export BASE24_COLOR_02_HEX="326889"
  export BASE24_COLOR_03_HEX="2f8288"
  export BASE24_COLOR_04_HEX="2b9c86"
  export BASE24_COLOR_05_HEX="27b684"
  export BASE24_COLOR_06_HEX="23d082"
  export BASE24_COLOR_07_HEX="d4d4d4"
  export BASE24_COLOR_08_HEX="be2d26"
  export BASE24_COLOR_09_HEX="da8e26"
  export BASE24_COLOR_0A_HEX="33a5d9"
  export BASE24_COLOR_0B_HEX="199171"
  export BASE24_COLOR_0C_HEX="35a08f"
  export BASE24_COLOR_0D_HEX="325d96"
  export BASE24_COLOR_0E_HEX="8a5ddb"
  export BASE24_COLOR_0F_HEX="5f1613"
  export BASE24_COLOR_10_HEX="21455b"
  export BASE24_COLOR_11_HEX="10222d"
  export BASE24_COLOR_12_HEX="dd5943"
  export BASE24_COLOR_13_HEX="e7d74b"
  export BASE24_COLOR_14_HEX="30cf7b"
  export BASE24_COLOR_15_HEX="41c3ad"
  export BASE24_COLOR_16_HEX="33a5d9"
  export BASE24_COLOR_17_HEX="ad6bdc"
fi
