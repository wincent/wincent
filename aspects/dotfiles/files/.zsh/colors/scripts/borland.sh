#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Borland 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="borland"

color00="00/00/a4" # Base 00 - Black
color01="ff/6b/60" # Base 08 - Red
color02="a7/ff/60" # Base 0B - Green
color03="b5/dc/fe" # Base 0A - Yellow
color04="96/ca/fd" # Base 0D - Blue
color05="ff/73/fd" # Base 0E - Magenta
color06="c6/c4/fd" # Base 0C - Cyan
color07="ee/ee/ee" # Base 06 - White
color08="7c/7c/7c" # Base 02 - Bright Black
color09="ff/b6/b0" # Base 12 - Bright Red
color10="ce/ff/ab" # Base 14 - Bright Green
color11="ff/ff/cb" # Base 13 - Bright Yellow
color12="b5/dc/fe" # Base 16 - Bright Blue
color13="ff/9c/fe" # Base 17 - Bright Magenta
color14="df/df/fe" # Base 15 - Bright Cyan
color15="ff/ff/ff" # Base 07 - Bright White
color16="ff/ff/b6" # Base 09
color17="7f/35/30" # Base 0F
color18="4e/4e/4e" # Base 01
color19="7c/7c/7c" # Base 02
color20="b5/b5/b5" # Base 04
color21="ee/ee/ee" # Base 06
color_foreground="d1/d1/d1" # Base 05
color_background="00/00/a4" # Base 00


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
  put_template_custom Pg d1d1d1 # foreground
  put_template_custom Ph 0000a4 # background
  put_template_custom Pi d1d1d1 # bold color
  put_template_custom Pj 7c7c7c # selection color
  put_template_custom Pk d1d1d1 # selected text color
  put_template_custom Pl d1d1d1 # cursor
  put_template_custom Pm 0000a4 # cursor text
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
  export BASE24_COLOR_00_HEX="0000a4"
  export BASE24_COLOR_01_HEX="4e4e4e"
  export BASE24_COLOR_02_HEX="7c7c7c"
  export BASE24_COLOR_03_HEX="989898"
  export BASE24_COLOR_04_HEX="b5b5b5"
  export BASE24_COLOR_05_HEX="d1d1d1"
  export BASE24_COLOR_06_HEX="eeeeee"
  export BASE24_COLOR_07_HEX="ffffff"
  export BASE24_COLOR_08_HEX="ff6b60"
  export BASE24_COLOR_09_HEX="ffffb6"
  export BASE24_COLOR_0A_HEX="b5dcfe"
  export BASE24_COLOR_0B_HEX="a7ff60"
  export BASE24_COLOR_0C_HEX="c6c4fd"
  export BASE24_COLOR_0D_HEX="96cafd"
  export BASE24_COLOR_0E_HEX="ff73fd"
  export BASE24_COLOR_0F_HEX="7f3530"
  export BASE24_COLOR_10_HEX="525252"
  export BASE24_COLOR_11_HEX="292929"
  export BASE24_COLOR_12_HEX="ffb6b0"
  export BASE24_COLOR_13_HEX="ffffcb"
  export BASE24_COLOR_14_HEX="ceffab"
  export BASE24_COLOR_15_HEX="dfdffe"
  export BASE24_COLOR_16_HEX="b5dcfe"
  export BASE24_COLOR_17_HEX="ff9cfe"
fi
