#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Rebecca
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="rebecca"

color00="29/2a/44" # Base 00 - Black
color01="dd/76/55" # Base 08 - Red
color02="04/db/b4" # Base 0B - Green
color03="69/bf/fa" # Base 0A - Yellow
color04="7a/a5/ff" # Base 0D - Blue
color05="be/9b/f8" # Base 0E - Magenta
color06="56/d3/c1" # Base 0C - Cyan
color07="c3/c3/d4" # Base 05 - White
color08="85/85/ac" # Base 03 - Bright Black
color09="ff/91/cd" # Base 12 - Bright Red
color10="00/e9/c0" # Base 14 - Bright Green
color11="fe/fc/a8" # Base 13 - Bright Yellow
color12="69/bf/fa" # Base 16 - Bright Blue
color13="c0/7f/f8" # Base 17 - Bright Magenta
color14="8b/fc/e1" # Base 15 - Bright Cyan
color15="f3/f2/f8" # Base 07 - Bright White
color16="f2/e7/b7" # Base 09
color17="6e/3b/2a" # Base 0F
color18="12/13/1d" # Base 01
color19="66/66/99" # Base 02
color20="a4/a4/c0" # Base 04
color21="e3/e2/e8" # Base 06
color_foreground="c3/c3/d4" # Base 05
color_background="29/2a/44" # Base 00


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
  put_template_custom Pg c3c3d4 # foreground
  put_template_custom Ph 292a44 # background
  put_template_custom Pi c3c3d4 # bold color
  put_template_custom Pj 666699 # selection color
  put_template_custom Pk c3c3d4 # selected text color
  put_template_custom Pl c3c3d4 # cursor
  put_template_custom Pm 292a44 # cursor text
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
  export BASE24_COLOR_00_HEX="292a44"
  export BASE24_COLOR_01_HEX="12131d"
  export BASE24_COLOR_02_HEX="666699"
  export BASE24_COLOR_03_HEX="8585ac"
  export BASE24_COLOR_04_HEX="a4a4c0"
  export BASE24_COLOR_05_HEX="c3c3d4"
  export BASE24_COLOR_06_HEX="e3e2e8"
  export BASE24_COLOR_07_HEX="f3f2f8"
  export BASE24_COLOR_08_HEX="dd7655"
  export BASE24_COLOR_09_HEX="f2e7b7"
  export BASE24_COLOR_0A_HEX="69bffa"
  export BASE24_COLOR_0B_HEX="04dbb4"
  export BASE24_COLOR_0C_HEX="56d3c1"
  export BASE24_COLOR_0D_HEX="7aa5ff"
  export BASE24_COLOR_0E_HEX="be9bf8"
  export BASE24_COLOR_0F_HEX="6e3b2a"
  export BASE24_COLOR_10_HEX="444466"
  export BASE24_COLOR_11_HEX="222233"
  export BASE24_COLOR_12_HEX="ff91cd"
  export BASE24_COLOR_13_HEX="fefca8"
  export BASE24_COLOR_14_HEX="00e9c0"
  export BASE24_COLOR_15_HEX="8bfce1"
  export BASE24_COLOR_16_HEX="69bffa"
  export BASE24_COLOR_17_HEX="c07ff8"
fi
