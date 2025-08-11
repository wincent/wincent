#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Pencil Light
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="pencil-light"

color00="f1/f1/f1" # Base 00 - Black
color01="c3/07/71" # Base 08 - Red
color02="10/a7/78" # Base 0B - Green
color03="20/bb/fc" # Base 0A - Yellow
color04="00/8e/c4" # Base 0D - Blue
color05="52/3c/79" # Base 0E - Magenta
color06="20/a5/ba" # Base 0C - Cyan
color07="b3/b3/b3" # Base 05 - White
color08="67/67/67" # Base 03 - Bright Black
color09="fb/00/7a" # Base 12 - Bright Red
color10="5f/d7/af" # Base 14 - Bright Green
color11="f3/e4/30" # Base 13 - Bright Yellow
color12="20/bb/fc" # Base 16 - Bright Blue
color13="68/55/de" # Base 17 - Bright Magenta
color14="4f/b8/cc" # Base 15 - Bright Cyan
color15="f1/f1/f1" # Base 07 - Bright White
color16="a8/9c/14" # Base 09
color17="61/03/38" # Base 0F
color18="21/21/21" # Base 01
color19="42/42/42" # Base 02
color20="8d/8d/8d" # Base 04
color21="d9/d9/d9" # Base 06
color_foreground="b3/b3/b3" # Base 05
color_background="f1/f1/f1" # Base 00


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
  put_template_custom Pg b3b3b3 # foreground
  put_template_custom Ph f1f1f1 # background
  put_template_custom Pi b3b3b3 # bold color
  put_template_custom Pj 424242 # selection color
  put_template_custom Pk b3b3b3 # selected text color
  put_template_custom Pl b3b3b3 # cursor
  put_template_custom Pm f1f1f1 # cursor text
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
  export BASE24_COLOR_00_HEX="f1f1f1"
  export BASE24_COLOR_01_HEX="212121"
  export BASE24_COLOR_02_HEX="424242"
  export BASE24_COLOR_03_HEX="676767"
  export BASE24_COLOR_04_HEX="8d8d8d"
  export BASE24_COLOR_05_HEX="b3b3b3"
  export BASE24_COLOR_06_HEX="d9d9d9"
  export BASE24_COLOR_07_HEX="f1f1f1"
  export BASE24_COLOR_08_HEX="c30771"
  export BASE24_COLOR_09_HEX="a89c14"
  export BASE24_COLOR_0A_HEX="20bbfc"
  export BASE24_COLOR_0B_HEX="10a778"
  export BASE24_COLOR_0C_HEX="20a5ba"
  export BASE24_COLOR_0D_HEX="008ec4"
  export BASE24_COLOR_0E_HEX="523c79"
  export BASE24_COLOR_0F_HEX="610338"
  export BASE24_COLOR_10_HEX="2c2c2c"
  export BASE24_COLOR_11_HEX="161616"
  export BASE24_COLOR_12_HEX="fb007a"
  export BASE24_COLOR_13_HEX="f3e430"
  export BASE24_COLOR_14_HEX="5fd7af"
  export BASE24_COLOR_15_HEX="4fb8cc"
  export BASE24_COLOR_16_HEX="20bbfc"
  export BASE24_COLOR_17_HEX="6855de"
fi
