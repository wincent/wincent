#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Wild Cherry
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="wild-cherry"

color00="1f/16/26" # Base 00 - Black
color01="d9/40/85" # Base 08 - Red
color02="2a/b2/50" # Base 0B - Green
color03="2f/8b/b9" # Base 0A - Yellow
color04="88/3c/dc" # Base 0D - Blue
color05="ec/ec/ec" # Base 0E - Magenta
color06="c1/b8/b7" # Base 0C - Cyan
color07="bf/e1/d8" # Base 05 - White
color08="3f/b3/ce" # Base 03 - Bright Black
color09="da/6b/ab" # Base 12 - Bright Red
color10="f4/db/a5" # Base 14 - Bright Green
color11="ea/c0/66" # Base 13 - Bright Yellow
color12="2f/8b/b9" # Base 16 - Bright Blue
color13="ae/63/6b" # Base 17 - Bright Magenta
color14="ff/91/9d" # Base 15 - Bright Cyan
color15="e4/83/8d" # Base 07 - Bright White
color16="ff/d1/6f" # Base 09
color17="6c/20/42" # Base 0F
color18="00/05/06" # Base 01
color19="00/9c/c9" # Base 02
color20="7f/ca/d3" # Base 04
color21="ff/f8/dd" # Base 06
color_foreground="bf/e1/d8" # Base 05
color_background="1f/16/26" # Base 00


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
  put_template_custom Pg bfe1d8 # foreground
  put_template_custom Ph 1f1626 # background
  put_template_custom Pi bfe1d8 # bold color
  put_template_custom Pj 009cc9 # selection color
  put_template_custom Pk bfe1d8 # selected text color
  put_template_custom Pl bfe1d8 # cursor
  put_template_custom Pm 1f1626 # cursor text
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
  export BASE24_COLOR_00_HEX="1f1626"
  export BASE24_COLOR_01_HEX="000506"
  export BASE24_COLOR_02_HEX="009cc9"
  export BASE24_COLOR_03_HEX="3fb3ce"
  export BASE24_COLOR_04_HEX="7fcad3"
  export BASE24_COLOR_05_HEX="bfe1d8"
  export BASE24_COLOR_06_HEX="fff8dd"
  export BASE24_COLOR_07_HEX="e4838d"
  export BASE24_COLOR_08_HEX="d94085"
  export BASE24_COLOR_09_HEX="ffd16f"
  export BASE24_COLOR_0A_HEX="2f8bb9"
  export BASE24_COLOR_0B_HEX="2ab250"
  export BASE24_COLOR_0C_HEX="c1b8b7"
  export BASE24_COLOR_0D_HEX="883cdc"
  export BASE24_COLOR_0E_HEX="ececec"
  export BASE24_COLOR_0F_HEX="6c2042"
  export BASE24_COLOR_10_HEX="006886"
  export BASE24_COLOR_11_HEX="003443"
  export BASE24_COLOR_12_HEX="da6bab"
  export BASE24_COLOR_13_HEX="eac066"
  export BASE24_COLOR_14_HEX="f4dba5"
  export BASE24_COLOR_15_HEX="ff919d"
  export BASE24_COLOR_16_HEX="2f8bb9"
  export BASE24_COLOR_17_HEX="ae636b"
fi
