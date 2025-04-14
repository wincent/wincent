#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Spacedust 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="spacedust"

color00="0a/1e/24" # Base 00 - Black
color01="e3/5a/00" # Base 08 - Red
color02="5c/ab/96" # Base 0B - Green
color03="67/a0/cd" # Base 0A - Yellow
color04="0e/54/8b" # Base 0D - Blue
color05="e3/5a/00" # Base 0E - Magenta
color06="06/af/c7" # Base 0C - Cyan
color07="f0/f1/ce" # Base 06 - White
color08="67/4c/31" # Base 02 - Bright Black
color09="ff/8a/39" # Base 12 - Bright Red
color10="ad/ca/b8" # Base 14 - Bright Green
color11="ff/c7/77" # Base 13 - Bright Yellow
color12="67/a0/cd" # Base 16 - Bright Blue
color13="ff/8a/39" # Base 17 - Bright Magenta
color14="83/a6/b3" # Base 15 - Bright Cyan
color15="fe/ff/f0" # Base 07 - Bright White
color16="e3/cd/7b" # Base 09
color17="71/2d/00" # Base 0F
color18="6e/52/46" # Base 01
color19="67/4c/31" # Base 02
color20="ab/9e/7f" # Base 04
color21="f0/f1/ce" # Base 06
color_foreground="cd/c7/a6" # Base 05
color_background="0a/1e/24" # Base 00


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
  put_template_custom Pg cdc7a6 # foreground
  put_template_custom Ph 0a1e24 # background
  put_template_custom Pi cdc7a6 # bold color
  put_template_custom Pj 674c31 # selection color
  put_template_custom Pk cdc7a6 # selected text color
  put_template_custom Pl cdc7a6 # cursor
  put_template_custom Pm 0a1e24 # cursor text
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
  export BASE24_COLOR_00_HEX="0a1e24"
  export BASE24_COLOR_01_HEX="6e5246"
  export BASE24_COLOR_02_HEX="674c31"
  export BASE24_COLOR_03_HEX="897558"
  export BASE24_COLOR_04_HEX="ab9e7f"
  export BASE24_COLOR_05_HEX="cdc7a6"
  export BASE24_COLOR_06_HEX="f0f1ce"
  export BASE24_COLOR_07_HEX="fefff0"
  export BASE24_COLOR_08_HEX="e35a00"
  export BASE24_COLOR_09_HEX="e3cd7b"
  export BASE24_COLOR_0A_HEX="67a0cd"
  export BASE24_COLOR_0B_HEX="5cab96"
  export BASE24_COLOR_0C_HEX="06afc7"
  export BASE24_COLOR_0D_HEX="0e548b"
  export BASE24_COLOR_0E_HEX="e35a00"
  export BASE24_COLOR_0F_HEX="712d00"
  export BASE24_COLOR_10_HEX="443220"
  export BASE24_COLOR_11_HEX="221910"
  export BASE24_COLOR_12_HEX="ff8a39"
  export BASE24_COLOR_13_HEX="ffc777"
  export BASE24_COLOR_14_HEX="adcab8"
  export BASE24_COLOR_15_HEX="83a6b3"
  export BASE24_COLOR_16_HEX="67a0cd"
  export BASE24_COLOR_17_HEX="ff8a39"
fi
