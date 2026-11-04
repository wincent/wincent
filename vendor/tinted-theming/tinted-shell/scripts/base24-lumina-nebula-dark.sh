#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Lumina Nebula Dark
# Scheme author: Razik Ikhlef (https://github.com/RazikSF)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="lumina-nebula-dark"

color00="16/18/26" # Base 00 - Black
color01="d5/70/68" # Base 08 - Red
color02="8f/dc/ba" # Base 0B - Green
color03="f3/c0/85" # Base 0A - Yellow
color04="c6/d6/e8" # Base 0D - Blue
color05="b0/a4/f8" # Base 0E - Magenta
color06="88/d2/da" # Base 0C - Cyan
color07="dd/e1/ec" # Base 05 - White
color08="2d/30/41" # Base 03 - Bright Black
color09="e2/92/8a" # Base 12 - Bright Red
color10="b0/f5/d5" # Base 14 - Bright Green
color11="ff/df/ba" # Base 13 - Bright Yellow
color12="d8/ea/ff" # Base 16 - Bright Blue
color13="ff/c8/f9" # Base 17 - Bright Magenta
color14="a1/ec/f5" # Base 15 - Bright Cyan
color15="dd/e1/ec" # Base 07 - Bright White
color16="fa/b1/7e" # Base 09
color17="e5/ae/df" # Base 0F
color18="1a/1c/2c" # Base 01
color19="24/26/36" # Base 02
color20="66/6b/7e" # Base 04
color21="ae/b0/be" # Base 06
color_foreground="dd/e1/ec" # Base 05
color_background="16/18/26" # Base 00


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

# 256 color space
put_template 16 "$color16"
put_template 17 "$color17"
put_template 18 "$color18"
put_template 19 "$color19"
put_template 20 "$color20"
put_template 21 "$color21"

# foreground / background / cursor color
if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  put_template_custom Pg dde1ec # foreground
  put_template_custom Ph 161826 # background
  put_template_custom Pi dde1ec # bold color
  put_template_custom Pj 242636 # selection color
  put_template_custom Pk dde1ec # selected text color
  put_template_custom Pl dde1ec # cursor
  put_template_custom Pm 161826 # cursor text
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
unset color15
unset color16
unset color17
unset color18
unset color19
unset color20
unset color21
unset color_foreground
unset color_background

# Optionally export variables
if [ -n "$TINTED_SHELL_ENABLE_BASE24_VARS" ]; then
  export BASE24_COLOR_00_HEX="161826"
  export BASE24_COLOR_01_HEX="1a1c2c"
  export BASE24_COLOR_02_HEX="242636"
  export BASE24_COLOR_03_HEX="2d3041"
  export BASE24_COLOR_04_HEX="666b7e"
  export BASE24_COLOR_05_HEX="dde1ec"
  export BASE24_COLOR_06_HEX="aeb0be"
  export BASE24_COLOR_07_HEX="dde1ec"
  export BASE24_COLOR_08_HEX="d57068"
  export BASE24_COLOR_09_HEX="fab17e"
  export BASE24_COLOR_0A_HEX="f3c085"
  export BASE24_COLOR_0B_HEX="8fdcba"
  export BASE24_COLOR_0C_HEX="88d2da"
  export BASE24_COLOR_0D_HEX="c6d6e8"
  export BASE24_COLOR_0E_HEX="b0a4f8"
  export BASE24_COLOR_0F_HEX="e5aedf"
  export BASE24_COLOR_10_HEX="0b0d19"
  export BASE24_COLOR_11_HEX="0f111f"
  export BASE24_COLOR_12_HEX="e2928a"
  export BASE24_COLOR_13_HEX="ffdfba"
  export BASE24_COLOR_14_HEX="b0f5d5"
  export BASE24_COLOR_15_HEX="a1ecf5"
  export BASE24_COLOR_16_HEX="d8eaff"
  export BASE24_COLOR_17_HEX="ffc8f9"
fi
