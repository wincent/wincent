#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Flat 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="flat"

color00="08/28/45" # Base 00 - Black
color01="a8/23/20" # Base 08 - Red
color02="2d/94/40" # Base 0B - Green
color03="3c/7d/d2" # Base 0A - Yellow
color04="31/67/ac" # Base 0D - Blue
color05="78/1a/a0" # Base 0E - Magenta
color06="2c/93/70" # Base 0C - Cyan
color07="b0/b6/ba" # Base 06 - White
color08="2e/2e/45" # Base 02 - Bright Black
color09="d4/31/2e" # Base 12 - Bright Red
color10="32/a5/48" # Base 14 - Bright Green
color11="e5/be/0c" # Base 13 - Bright Yellow
color12="3c/7d/d2" # Base 16 - Bright Blue
color13="82/30/a7" # Base 17 - Bright Magenta
color14="35/b3/87" # Base 15 - Bright Cyan
color15="e7/ec/ed" # Base 07 - Bright White
color16="e5/8d/11" # Base 09
color17="54/11/10" # Base 0F
color18="1d/28/45" # Base 01
color19="2e/2e/45" # Base 02
color20="68/71/7b" # Base 04
color21="b0/b6/ba" # Base 06
color_foreground="8c/93/9a" # Base 05
color_background="08/28/45" # Base 00


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
  put_template_custom Pg 8c939a # foreground
  put_template_custom Ph 082845 # background
  put_template_custom Pi 8c939a # bold color
  put_template_custom Pj 2e2e45 # selection color
  put_template_custom Pk 8c939a # selected text color
  put_template_custom Pl 8c939a # cursor
  put_template_custom Pm 082845 # cursor text
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
  export BASE24_COLOR_00_HEX="082845"
  export BASE24_COLOR_01_HEX="1d2845"
  export BASE24_COLOR_02_HEX="2e2e45"
  export BASE24_COLOR_03_HEX="444e5b"
  export BASE24_COLOR_04_HEX="68717b"
  export BASE24_COLOR_05_HEX="8c939a"
  export BASE24_COLOR_06_HEX="b0b6ba"
  export BASE24_COLOR_07_HEX="e7eced"
  export BASE24_COLOR_08_HEX="a82320"
  export BASE24_COLOR_09_HEX="e58d11"
  export BASE24_COLOR_0A_HEX="3c7dd2"
  export BASE24_COLOR_0B_HEX="2d9440"
  export BASE24_COLOR_0C_HEX="2c9370"
  export BASE24_COLOR_0D_HEX="3167ac"
  export BASE24_COLOR_0E_HEX="781aa0"
  export BASE24_COLOR_0F_HEX="541110"
  export BASE24_COLOR_10_HEX="002240"
  export BASE24_COLOR_11_HEX="001629"
  export BASE24_COLOR_12_HEX="d4312e"
  export BASE24_COLOR_13_HEX="e5be0c"
  export BASE24_COLOR_14_HEX="32a548"
  export BASE24_COLOR_15_HEX="35b387"
  export BASE24_COLOR_16_HEX="3c7dd2"
  export BASE24_COLOR_17_HEX="8230a7"
fi
