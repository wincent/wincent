#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Birds Of Paradise
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="birds-of-paradise"

color00="2a/1e/1d" # Base 00 - Black
color01="be/2d/26" # Base 08 - Red
color02="6b/a0/8a" # Base 0B - Green
color03="b8/d3/ed" # Base 0A - Yellow
color04="5a/86/ac" # Base 0D - Blue
color05="ab/80/a6" # Base 0E - Magenta
color06="74/a5/ac" # Base 0C - Cyan
color07="cd/be/9b" # Base 05 - White
color08="ab/86/64" # Base 03 - Bright Black
color09="e8/45/26" # Base 12 - Bright Red
color10="94/d7/ba" # Base 14 - Bright Green
color11="d0/d0/4f" # Base 13 - Bright Yellow
color12="b8/d3/ed" # Base 16 - Bright Blue
color13="d0/9d/ca" # Base 17 - Bright Magenta
color14="92/ce/d6" # Base 15 - Bright Cyan
color15="ff/f9/d4" # Base 07 - Bright White
color16="e9/9c/29" # Base 09
color17="5f/16/13" # Base 0F
color18="57/3d/25" # Base 01
color19="9a/6b/49" # Base 02
color20="bc/a2/80" # Base 04
color21="df/da/b7" # Base 06
color_foreground="cd/be/9b" # Base 05
color_background="2a/1e/1d" # Base 00


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
  put_template_custom Pg cdbe9b # foreground
  put_template_custom Ph 2a1e1d # background
  put_template_custom Pi cdbe9b # bold color
  put_template_custom Pj 9a6b49 # selection color
  put_template_custom Pk cdbe9b # selected text color
  put_template_custom Pl cdbe9b # cursor
  put_template_custom Pm 2a1e1d # cursor text
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
  export BASE24_COLOR_00_HEX="2a1e1d"
  export BASE24_COLOR_01_HEX="573d25"
  export BASE24_COLOR_02_HEX="9a6b49"
  export BASE24_COLOR_03_HEX="ab8664"
  export BASE24_COLOR_04_HEX="bca280"
  export BASE24_COLOR_05_HEX="cdbe9b"
  export BASE24_COLOR_06_HEX="dfdab7"
  export BASE24_COLOR_07_HEX="fff9d4"
  export BASE24_COLOR_08_HEX="be2d26"
  export BASE24_COLOR_09_HEX="e99c29"
  export BASE24_COLOR_0A_HEX="b8d3ed"
  export BASE24_COLOR_0B_HEX="6ba08a"
  export BASE24_COLOR_0C_HEX="74a5ac"
  export BASE24_COLOR_0D_HEX="5a86ac"
  export BASE24_COLOR_0E_HEX="ab80a6"
  export BASE24_COLOR_0F_HEX="5f1613"
  export BASE24_COLOR_10_HEX="664730"
  export BASE24_COLOR_11_HEX="332318"
  export BASE24_COLOR_12_HEX="e84526"
  export BASE24_COLOR_13_HEX="d0d04f"
  export BASE24_COLOR_14_HEX="94d7ba"
  export BASE24_COLOR_15_HEX="92ced6"
  export BASE24_COLOR_16_HEX="b8d3ed"
  export BASE24_COLOR_17_HEX="d09dca"
fi
