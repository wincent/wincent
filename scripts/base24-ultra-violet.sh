#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Ultra Violet
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="ultra-violet"

color00="24/27/28" # Base 00 - Black
color01="ff/00/90" # Base 08 - Red
color02="b5/ff/00" # Base 0B - Green
color03="7f/eb/ff" # Base 0A - Yellow
color04="47/df/fb" # Base 0D - Blue
color05="d6/30/ff" # Base 0E - Magenta
color06="0e/ff/bb" # Base 0C - Cyan
color07="c1/c2/c2" # Base 05 - White
color08="81/84/84" # Base 03 - Bright Black
color09="fb/57/b4" # Base 12 - Bright Red
color10="de/ff/8b" # Base 14 - Bright Green
color11="eb/df/86" # Base 13 - Bright Yellow
color12="7f/eb/ff" # Base 16 - Bright Blue
color13="e6/81/ff" # Base 17 - Bright Magenta
color14="68/fc/d2" # Base 15 - Bright Cyan
color15="f9/f9/f4" # Base 07 - Bright White
color16="ff/f7/27" # Base 09
color17="7f/00/48" # Base 0F
color18="23/26/28" # Base 01
color19="62/65/66" # Base 02
color20="a1/a3/a3" # Base 04
color21="e1/e1/e1" # Base 06
color_foreground="c1/c2/c2" # Base 05
color_background="24/27/28" # Base 00


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
  put_template_custom Pg c1c2c2 # foreground
  put_template_custom Ph 242728 # background
  put_template_custom Pi c1c2c2 # bold color
  put_template_custom Pj 626566 # selection color
  put_template_custom Pk c1c2c2 # selected text color
  put_template_custom Pl c1c2c2 # cursor
  put_template_custom Pm 242728 # cursor text
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
  export BASE24_COLOR_00_HEX="242728"
  export BASE24_COLOR_01_HEX="232628"
  export BASE24_COLOR_02_HEX="626566"
  export BASE24_COLOR_03_HEX="818484"
  export BASE24_COLOR_04_HEX="a1a3a3"
  export BASE24_COLOR_05_HEX="c1c2c2"
  export BASE24_COLOR_06_HEX="e1e1e1"
  export BASE24_COLOR_07_HEX="f9f9f4"
  export BASE24_COLOR_08_HEX="ff0090"
  export BASE24_COLOR_09_HEX="fff727"
  export BASE24_COLOR_0A_HEX="7febff"
  export BASE24_COLOR_0B_HEX="b5ff00"
  export BASE24_COLOR_0C_HEX="0effbb"
  export BASE24_COLOR_0D_HEX="47dffb"
  export BASE24_COLOR_0E_HEX="d630ff"
  export BASE24_COLOR_0F_HEX="7f0048"
  export BASE24_COLOR_10_HEX="414344"
  export BASE24_COLOR_11_HEX="202122"
  export BASE24_COLOR_12_HEX="fb57b4"
  export BASE24_COLOR_13_HEX="ebdf86"
  export BASE24_COLOR_14_HEX="deff8b"
  export BASE24_COLOR_15_HEX="68fcd2"
  export BASE24_COLOR_16_HEX="7febff"
  export BASE24_COLOR_17_HEX="e681ff"
fi
