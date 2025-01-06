#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Brogrammer 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="brogrammer"

color00="13/13/13" # Base 00 - Black
color01="f7/11/18" # Base 08 - Red
color02="2c/c5/5d" # Base 0B - Green
color03="0f/80/d5" # Base 0A - Yellow
color04="2a/84/d2" # Base 0D - Blue
color05="4e/59/b7" # Base 0E - Magenta
color06="0f/80/d5" # Base 0C - Cyan
color07="e3/e6/ed" # Base 06 - White
color08="2a/31/41" # Base 02 - Bright Black
color09="de/34/2e" # Base 12 - Bright Red
color10="1d/d2/60" # Base 14 - Bright Green
color11="f2/bd/09" # Base 13 - Bright Yellow
color12="50/9b/dc" # Base 16 - Bright Blue
color13="52/4f/b9" # Base 17 - Bright Magenta
color14="28/9a/f0" # Base 15 - Bright Cyan
color15="ff/ff/ff" # Base 07 - Bright White
color16="ec/b9/0f" # Base 09
color17="7b/08/0c" # Base 0F
color18="1f/1f/1f" # Base 01
color19="2a/31/41" # Base 02
color20="d6/da/e4" # Base 04
color21="e3/e6/ed" # Base 06
color_foreground="c1/c8/d7" # Base 05
color_background="13/13/13" # Base 00


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
  put_template_custom Pg c1c8d7 # foreground
  put_template_custom Ph 131313 # background
  put_template_custom Pi c1c8d7 # bold color
  put_template_custom Pj 2a3141 # selection color
  put_template_custom Pk c1c8d7 # selected text color
  put_template_custom Pl c1c8d7 # cursor
  put_template_custom Pm 131313 # cursor text
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
  export BASE24_COLOR_00_HEX="131313"
  export BASE24_COLOR_01_HEX="1f1f1f"
  export BASE24_COLOR_02_HEX="2a3141"
  export BASE24_COLOR_03_HEX="343d50"
  export BASE24_COLOR_04_HEX="d6dae4"
  export BASE24_COLOR_05_HEX="c1c8d7"
  export BASE24_COLOR_06_HEX="e3e6ed"
  export BASE24_COLOR_07_HEX="ffffff"
  export BASE24_COLOR_08_HEX="f71118"
  export BASE24_COLOR_09_HEX="ecb90f"
  export BASE24_COLOR_0A_HEX="0f80d5"
  export BASE24_COLOR_0B_HEX="2cc55d"
  export BASE24_COLOR_0C_HEX="0f80d5"
  export BASE24_COLOR_0D_HEX="2a84d2"
  export BASE24_COLOR_0E_HEX="4e59b7"
  export BASE24_COLOR_0F_HEX="7b080c"
  export BASE24_COLOR_10_HEX="0a0a0a"
  export BASE24_COLOR_11_HEX="020202"
  export BASE24_COLOR_12_HEX="de342e"
  export BASE24_COLOR_13_HEX="f2bd09"
  export BASE24_COLOR_14_HEX="1dd260"
  export BASE24_COLOR_15_HEX="289af0"
  export BASE24_COLOR_16_HEX="509bdc"
  export BASE24_COLOR_17_HEX="524fb9"
fi
