#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Flatland
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="flatland"

color00="1c/1e/20" # Base 00 - Black
color01="f1/82/38" # Base 08 - Red
color02="9e/d2/64" # Base 0B - Green
color03="61/b8/d0" # Base 0A - Yellow
color04="4f/96/be" # Base 0D - Blue
color05="69/5a/bb" # Base 0E - Magenta
color06="d5/38/64" # Base 0C - Cyan
color07="c5/c6/c4" # Base 05 - White
color08="54/55/52" # Base 03 - Bright Black
color09="d1/2a/24" # Base 12 - Bright Red
color10="a7/d3/2c" # Base 14 - Bright Green
color11="ff/89/48" # Base 13 - Bright Yellow
color12="61/b8/d0" # Base 16 - Bright Blue
color13="69/5a/bb" # Base 17 - Bright Magenta
color14="d5/38/64" # Base 15 - Bright Cyan
color15="fe/ff/fe" # Base 07 - Bright White
color16="f3/ef/6d" # Base 09
color17="78/41/1c" # Base 0F
color18="1c/1d/19" # Base 01
color19="1c/1d/19" # Base 02
color20="8d/8e/8b" # Base 04
color21="fe/ff/fe" # Base 06
color_foreground="c5/c6/c4" # Base 05
color_background="1c/1e/20" # Base 00


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
  put_template_custom Pg c5c6c4 # foreground
  put_template_custom Ph 1c1e20 # background
  put_template_custom Pi c5c6c4 # bold color
  put_template_custom Pj 1c1d19 # selection color
  put_template_custom Pk c5c6c4 # selected text color
  put_template_custom Pl c5c6c4 # cursor
  put_template_custom Pm 1c1e20 # cursor text
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
  export BASE24_COLOR_00_HEX="1c1e20"
  export BASE24_COLOR_01_HEX="1c1d19"
  export BASE24_COLOR_02_HEX="1c1d19"
  export BASE24_COLOR_03_HEX="545552"
  export BASE24_COLOR_04_HEX="8d8e8b"
  export BASE24_COLOR_05_HEX="c5c6c4"
  export BASE24_COLOR_06_HEX="fefffe"
  export BASE24_COLOR_07_HEX="fefffe"
  export BASE24_COLOR_08_HEX="f18238"
  export BASE24_COLOR_09_HEX="f3ef6d"
  export BASE24_COLOR_0A_HEX="61b8d0"
  export BASE24_COLOR_0B_HEX="9ed264"
  export BASE24_COLOR_0C_HEX="d53864"
  export BASE24_COLOR_0D_HEX="4f96be"
  export BASE24_COLOR_0E_HEX="695abb"
  export BASE24_COLOR_0F_HEX="78411c"
  export BASE24_COLOR_10_HEX="121310"
  export BASE24_COLOR_11_HEX="090908"
  export BASE24_COLOR_12_HEX="d12a24"
  export BASE24_COLOR_13_HEX="ff8948"
  export BASE24_COLOR_14_HEX="a7d32c"
  export BASE24_COLOR_15_HEX="d53864"
  export BASE24_COLOR_16_HEX="61b8d0"
  export BASE24_COLOR_17_HEX="695abb"
fi
