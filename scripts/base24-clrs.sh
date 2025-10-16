#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: CLRS
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="clrs"

color00="ff/ff/ff" # Base 00 - Black
color01="f7/27/29" # Base 08 - Red
color02="32/89/5c" # Base 0B - Green
color03="15/6f/fe" # Base 0A - Yellow
color04="12/5c/cf" # Base 0D - Blue
color05="9f/00/bc" # Base 0E - Magenta
color06="32/c2/c0" # Base 0C - Cyan
color07="9a/9b/9a" # Base 05 - White
color08="6b/6d/6a" # Base 03 - Bright Black
color09="fb/04/16" # Base 12 - Bright Red
color10="2c/c6/31" # Base 14 - Bright Green
color11="fc/d6/27" # Base 13 - Bright Yellow
color12="15/6f/fe" # Base 16 - Bright Blue
color13="e8/00/b0" # Base 17 - Bright Magenta
color14="39/d5/ce" # Base 15 - Bright Cyan
color15="ed/ed/ec" # Base 07 - Bright White
color16="f9/6f/1c" # Base 09
color17="7b/13/14" # Base 0F
color18="00/00/00" # Base 01
color19="54/57/53" # Base 02
color20="83/84/82" # Base 04
color21="b2/b2/b2" # Base 06
color_foreground="9a/9b/9a" # Base 05
color_background="ff/ff/ff" # Base 00


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
  put_template_custom Pg 9a9b9a # foreground
  put_template_custom Ph ffffff # background
  put_template_custom Pi 9a9b9a # bold color
  put_template_custom Pj 545753 # selection color
  put_template_custom Pk 9a9b9a # selected text color
  put_template_custom Pl 9a9b9a # cursor
  put_template_custom Pm ffffff # cursor text
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
  export BASE24_COLOR_00_HEX="ffffff"
  export BASE24_COLOR_01_HEX="000000"
  export BASE24_COLOR_02_HEX="545753"
  export BASE24_COLOR_03_HEX="6b6d6a"
  export BASE24_COLOR_04_HEX="838482"
  export BASE24_COLOR_05_HEX="9a9b9a"
  export BASE24_COLOR_06_HEX="b2b2b2"
  export BASE24_COLOR_07_HEX="ededec"
  export BASE24_COLOR_08_HEX="f72729"
  export BASE24_COLOR_09_HEX="f96f1c"
  export BASE24_COLOR_0A_HEX="156ffe"
  export BASE24_COLOR_0B_HEX="32895c"
  export BASE24_COLOR_0C_HEX="32c2c0"
  export BASE24_COLOR_0D_HEX="125ccf"
  export BASE24_COLOR_0E_HEX="9f00bc"
  export BASE24_COLOR_0F_HEX="7b1314"
  export BASE24_COLOR_10_HEX="383a37"
  export BASE24_COLOR_11_HEX="1c1d1b"
  export BASE24_COLOR_12_HEX="fb0416"
  export BASE24_COLOR_13_HEX="fcd627"
  export BASE24_COLOR_14_HEX="2cc631"
  export BASE24_COLOR_15_HEX="39d5ce"
  export BASE24_COLOR_16_HEX="156ffe"
  export BASE24_COLOR_17_HEX="e800b0"
fi
