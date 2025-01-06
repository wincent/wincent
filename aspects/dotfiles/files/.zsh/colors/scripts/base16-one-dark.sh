#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: One Dark 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="one-dark"

color00="28/2c/34" # Base 00 - Black
color01="e0/55/61" # Base 08 - Red
color02="8c/c2/65" # Base 0B - Green
color03="e6/b9/65" # Base 0A - Yellow
color04="4a/a5/f0" # Base 0D - Blue
color05="c1/62/de" # Base 0E - Magenta
color06="42/b3/c2" # Base 0C - Cyan
color07="e6/e6/e6" # Base 06 - White
color08="4f/56/66" # Base 02 - Bright Black
color09="ff/61/6e" # Base 12 - Bright Red
color10="a5/e0/75" # Base 14 - Bright Green
color11="f0/a4/5d" # Base 13 - Bright Yellow
color12="4d/c4/ff" # Base 16 - Bright Blue
color13="de/73/ff" # Base 17 - Bright Magenta
color14="4c/d1/e0" # Base 15 - Bright Cyan
color15="ff/ff/ff" # Base 07 - Bright White
color16="d1/8f/52" # Base 09
color17="bf/40/34" # Base 0F
color18="3f/44/51" # Base 01
color19="4f/56/66" # Base 02
color20="91/96/a1" # Base 04
color21="e6/e6/e6" # Base 06
color_foreground="ab/b2/bf" # Base 05
color_background="28/2c/34" # Base 00


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
  put_template_custom Pg abb2bf # foreground
  put_template_custom Ph 282c34 # background
  put_template_custom Pi abb2bf # bold color
  put_template_custom Pj 4f5666 # selection color
  put_template_custom Pk abb2bf # selected text color
  put_template_custom Pl abb2bf # cursor
  put_template_custom Pm 282c34 # cursor text
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
  export BASE24_COLOR_00_HEX="282c34"
  export BASE24_COLOR_01_HEX="3f4451"
  export BASE24_COLOR_02_HEX="4f5666"
  export BASE24_COLOR_03_HEX="545862"
  export BASE24_COLOR_04_HEX="9196a1"
  export BASE24_COLOR_05_HEX="abb2bf"
  export BASE24_COLOR_06_HEX="e6e6e6"
  export BASE24_COLOR_07_HEX="ffffff"
  export BASE24_COLOR_08_HEX="e05561"
  export BASE24_COLOR_09_HEX="d18f52"
  export BASE24_COLOR_0A_HEX="e6b965"
  export BASE24_COLOR_0B_HEX="8cc265"
  export BASE24_COLOR_0C_HEX="42b3c2"
  export BASE24_COLOR_0D_HEX="4aa5f0"
  export BASE24_COLOR_0E_HEX="c162de"
  export BASE24_COLOR_0F_HEX="bf4034"
  export BASE24_COLOR_10_HEX="21252b"
  export BASE24_COLOR_11_HEX="181a1f"
  export BASE24_COLOR_12_HEX="ff616e"
  export BASE24_COLOR_13_HEX="f0a45d"
  export BASE24_COLOR_14_HEX="a5e075"
  export BASE24_COLOR_15_HEX="4cd1e0"
  export BASE24_COLOR_16_HEX="4dc4ff"
  export BASE24_COLOR_17_HEX="de73ff"
fi
