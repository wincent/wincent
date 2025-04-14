#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: 3024 Day 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="3024-day"

color00="f7/f7/f7" # Base 00 - Black
color01="db/2d/20" # Base 08 - Red
color02="01/a2/52" # Base 0B - Green
color03="80/7d/7c" # Base 0A - Yellow
color04="01/a0/e4" # Base 0D - Blue
color05="a1/6a/94" # Base 0E - Magenta
color06="b5/e4/f4" # Base 0C - Cyan
color07="a5/a2/a2" # Base 06 - White
color08="5c/58/55" # Base 02 - Bright Black
color09="e8/bb/d0" # Base 12 - Bright Red
color10="3a/34/32" # Base 14 - Bright Green
color11="4a/45/43" # Base 13 - Bright Yellow
color12="80/7d/7c" # Base 16 - Bright Blue
color13="d6/d5/d4" # Base 17 - Bright Magenta
color14="cd/ab/53" # Base 15 - Bright Cyan
color15="f7/f7/f7" # Base 07 - Bright White
color16="fd/ed/02" # Base 09
color17="6d/16/10" # Base 0F
color18="09/03/00" # Base 01
color19="5c/58/55" # Base 02
color20="80/7d/7b" # Base 04
color21="a5/a2/a2" # Base 06
color_foreground="92/8f/8e" # Base 05
color_background="f7/f7/f7" # Base 00


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
  put_template_custom Pg 928f8e # foreground
  put_template_custom Ph f7f7f7 # background
  put_template_custom Pi 928f8e # bold color
  put_template_custom Pj 5c5855 # selection color
  put_template_custom Pk 928f8e # selected text color
  put_template_custom Pl 928f8e # cursor
  put_template_custom Pm f7f7f7 # cursor text
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
  export BASE24_COLOR_00_HEX="f7f7f7"
  export BASE24_COLOR_01_HEX="090300"
  export BASE24_COLOR_02_HEX="5c5855"
  export BASE24_COLOR_03_HEX="6e6a68"
  export BASE24_COLOR_04_HEX="807d7b"
  export BASE24_COLOR_05_HEX="928f8e"
  export BASE24_COLOR_06_HEX="a5a2a2"
  export BASE24_COLOR_07_HEX="f7f7f7"
  export BASE24_COLOR_08_HEX="db2d20"
  export BASE24_COLOR_09_HEX="fded02"
  export BASE24_COLOR_0A_HEX="807d7c"
  export BASE24_COLOR_0B_HEX="01a252"
  export BASE24_COLOR_0C_HEX="b5e4f4"
  export BASE24_COLOR_0D_HEX="01a0e4"
  export BASE24_COLOR_0E_HEX="a16a94"
  export BASE24_COLOR_0F_HEX="6d1610"
  export BASE24_COLOR_10_HEX="3d3a38"
  export BASE24_COLOR_11_HEX="1e1d1c"
  export BASE24_COLOR_12_HEX="e8bbd0"
  export BASE24_COLOR_13_HEX="4a4543"
  export BASE24_COLOR_14_HEX="3a3432"
  export BASE24_COLOR_15_HEX="cdab53"
  export BASE24_COLOR_16_HEX="807d7c"
  export BASE24_COLOR_17_HEX="d6d5d4"
fi
