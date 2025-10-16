#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Breeze
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="breeze"

color00="31/36/3b" # Base 00 - Black
color01="ed/15/15" # Base 08 - Red
color02="11/d1/16" # Base 0B - Green
color03="3d/ae/e9" # Base 0A - Yellow
color04="1d/99/f3" # Base 0D - Blue
color05="9b/59/b6" # Base 0E - Magenta
color06="1a/bc/9c" # Base 0C - Cyan
color07="d3/d7/d8" # Base 05 - White
color08="9b/a5/a6" # Base 03 - Bright Black
color09="c0/39/2b" # Base 12 - Bright Red
color10="1c/dc/9a" # Base 14 - Bright Green
color11="fd/bc/4b" # Base 13 - Bright Yellow
color12="3d/ae/e9" # Base 16 - Bright Blue
color13="8e/44/ad" # Base 17 - Bright Magenta
color14="16/a0/85" # Base 15 - Bright Cyan
color15="fc/fc/fc" # Base 07 - Bright White
color16="f6/74/00" # Base 09
color17="76/0a/0a" # Base 0F
color18="31/36/3b" # Base 01
color19="7f/8c/8d" # Base 02
color20="b7/be/bf" # Base 04
color21="ef/f0/f1" # Base 06
color_foreground="d3/d7/d8" # Base 05
color_background="31/36/3b" # Base 00


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
  put_template_custom Pg d3d7d8 # foreground
  put_template_custom Ph 31363b # background
  put_template_custom Pi d3d7d8 # bold color
  put_template_custom Pj 7f8c8d # selection color
  put_template_custom Pk d3d7d8 # selected text color
  put_template_custom Pl d3d7d8 # cursor
  put_template_custom Pm 31363b # cursor text
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
  export BASE24_COLOR_00_HEX="31363b"
  export BASE24_COLOR_01_HEX="31363b"
  export BASE24_COLOR_02_HEX="7f8c8d"
  export BASE24_COLOR_03_HEX="9ba5a6"
  export BASE24_COLOR_04_HEX="b7bebf"
  export BASE24_COLOR_05_HEX="d3d7d8"
  export BASE24_COLOR_06_HEX="eff0f1"
  export BASE24_COLOR_07_HEX="fcfcfc"
  export BASE24_COLOR_08_HEX="ed1515"
  export BASE24_COLOR_09_HEX="f67400"
  export BASE24_COLOR_0A_HEX="3daee9"
  export BASE24_COLOR_0B_HEX="11d116"
  export BASE24_COLOR_0C_HEX="1abc9c"
  export BASE24_COLOR_0D_HEX="1d99f3"
  export BASE24_COLOR_0E_HEX="9b59b6"
  export BASE24_COLOR_0F_HEX="760a0a"
  export BASE24_COLOR_10_HEX="545d5e"
  export BASE24_COLOR_11_HEX="2a2e2f"
  export BASE24_COLOR_12_HEX="c0392b"
  export BASE24_COLOR_13_HEX="fdbc4b"
  export BASE24_COLOR_14_HEX="1cdc9a"
  export BASE24_COLOR_15_HEX="16a085"
  export BASE24_COLOR_16_HEX="3daee9"
  export BASE24_COLOR_17_HEX="8e44ad"
fi
