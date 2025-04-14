#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Molokai 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="molokai"

color00="12/12/12" # Base 00 - Black
color01="fa/25/73" # Base 08 - Red
color02="97/e1/23" # Base 0B - Green
color03="00/af/ff" # Base 0A - Yellow
color04="0f/7f/cf" # Base 0D - Blue
color05="87/00/ff" # Base 0E - Magenta
color06="42/a7/cf" # Base 0C - Cyan
color07="bb/bb/bb" # Base 06 - White
color08="55/55/55" # Base 02 - Bright Black
color09="f5/66/9c" # Base 12 - Bright Red
color10="b0/e0/5e" # Base 14 - Bright Green
color11="fe/f2/6c" # Base 13 - Bright Yellow
color12="00/af/ff" # Base 16 - Bright Blue
color13="af/87/ff" # Base 17 - Bright Magenta
color14="50/cd/fe" # Base 15 - Bright Cyan
color15="ff/ff/ff" # Base 07 - Bright White
color16="df/d4/60" # Base 09
color17="7d/12/39" # Base 0F
color18="12/12/12" # Base 01
color19="55/55/55" # Base 02
color20="88/88/88" # Base 04
color21="bb/bb/bb" # Base 06
color_foreground="a1/a1/a1" # Base 05
color_background="12/12/12" # Base 00


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
  put_template_custom Pg a1a1a1 # foreground
  put_template_custom Ph 121212 # background
  put_template_custom Pi a1a1a1 # bold color
  put_template_custom Pj 555555 # selection color
  put_template_custom Pk a1a1a1 # selected text color
  put_template_custom Pl a1a1a1 # cursor
  put_template_custom Pm 121212 # cursor text
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
  export BASE24_COLOR_00_HEX="121212"
  export BASE24_COLOR_01_HEX="121212"
  export BASE24_COLOR_02_HEX="555555"
  export BASE24_COLOR_03_HEX="6e6e6e"
  export BASE24_COLOR_04_HEX="888888"
  export BASE24_COLOR_05_HEX="a1a1a1"
  export BASE24_COLOR_06_HEX="bbbbbb"
  export BASE24_COLOR_07_HEX="ffffff"
  export BASE24_COLOR_08_HEX="fa2573"
  export BASE24_COLOR_09_HEX="dfd460"
  export BASE24_COLOR_0A_HEX="00afff"
  export BASE24_COLOR_0B_HEX="97e123"
  export BASE24_COLOR_0C_HEX="42a7cf"
  export BASE24_COLOR_0D_HEX="0f7fcf"
  export BASE24_COLOR_0E_HEX="8700ff"
  export BASE24_COLOR_0F_HEX="7d1239"
  export BASE24_COLOR_10_HEX="383838"
  export BASE24_COLOR_11_HEX="1c1c1c"
  export BASE24_COLOR_12_HEX="f5669c"
  export BASE24_COLOR_13_HEX="fef26c"
  export BASE24_COLOR_14_HEX="b0e05e"
  export BASE24_COLOR_15_HEX="50cdfe"
  export BASE24_COLOR_16_HEX="00afff"
  export BASE24_COLOR_17_HEX="af87ff"
fi
