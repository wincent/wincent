#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: IC-Green-PPL
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="ic-green-ppl"

color00="2c/2c/2c" # Base 00 - Black
color01="fe/26/35" # Base 08 - Red
color02="41/a6/38" # Base 0B - Green
color03="2e/fa/eb" # Base 0A - Yellow
color04="2e/c3/b9" # Base 0D - Blue
color05="50/a0/96" # Base 0E - Magenta
color06="3c/a0/78" # Base 0C - Cyan
color07="ad/d5/b6" # Base 05 - White
color08="3b/84/3e" # Base 03 - Bright Black
color09="b4/fa/5c" # Base 12 - Bright Red
color10="ae/fa/86" # Base 14 - Bright Green
color11="da/fa/87" # Base 13 - Bright Yellow
color12="2e/fa/eb" # Base 16 - Bright Blue
color13="50/fa/fa" # Base 17 - Bright Magenta
color14="3c/fa/c8" # Base 15 - Bright Cyan
color15="e0/f1/dc" # Base 07 - Bright White
color16="76/a8/30" # Base 09
color17="7f/13/1a" # Base 0F
color18="01/44/01" # Base 01
color19="02/5c/02" # Base 02
color20="74/ad/7a" # Base 04
color21="e6/fe/f2" # Base 06
color_foreground="ad/d5/b6" # Base 05
color_background="2c/2c/2c" # Base 00


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
  put_template_custom Pg add5b6 # foreground
  put_template_custom Ph 2c2c2c # background
  put_template_custom Pi add5b6 # bold color
  put_template_custom Pj 025c02 # selection color
  put_template_custom Pk add5b6 # selected text color
  put_template_custom Pl add5b6 # cursor
  put_template_custom Pm 2c2c2c # cursor text
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
  export BASE24_COLOR_00_HEX="2c2c2c"
  export BASE24_COLOR_01_HEX="014401"
  export BASE24_COLOR_02_HEX="025c02"
  export BASE24_COLOR_03_HEX="3b843e"
  export BASE24_COLOR_04_HEX="74ad7a"
  export BASE24_COLOR_05_HEX="add5b6"
  export BASE24_COLOR_06_HEX="e6fef2"
  export BASE24_COLOR_07_HEX="e0f1dc"
  export BASE24_COLOR_08_HEX="fe2635"
  export BASE24_COLOR_09_HEX="76a830"
  export BASE24_COLOR_0A_HEX="2efaeb"
  export BASE24_COLOR_0B_HEX="41a638"
  export BASE24_COLOR_0C_HEX="3ca078"
  export BASE24_COLOR_0D_HEX="2ec3b9"
  export BASE24_COLOR_0E_HEX="50a096"
  export BASE24_COLOR_0F_HEX="7f131a"
  export BASE24_COLOR_10_HEX="013d01"
  export BASE24_COLOR_11_HEX="001e00"
  export BASE24_COLOR_12_HEX="b4fa5c"
  export BASE24_COLOR_13_HEX="dafa87"
  export BASE24_COLOR_14_HEX="aefa86"
  export BASE24_COLOR_15_HEX="3cfac8"
  export BASE24_COLOR_16_HEX="2efaeb"
  export BASE24_COLOR_17_HEX="50fafa"
fi
