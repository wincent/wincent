#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Unikitty
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="unikitty"

color00="ff/8c/d9" # Base 00 - Black
color01="a8/0f/20" # Base 08 - Red
color02="ba/fc/8b" # Base 0B - Green
color03="00/74/ea" # Base 0A - Yellow
color04="14/5f/cd" # Base 0D - Blue
color05="ff/36/a2" # Base 0E - Magenta
color06="6b/d0/bc" # Base 0C - Cyan
color07="b9/b1/b8" # Base 05 - White
color08="69/67/69" # Base 03 - Bright Black
color09="d8/13/29" # Base 12 - Bright Red
color10="d2/ff/af" # Base 14 - Bright Green
color11="ff/ee/50" # Base 13 - Bright Yellow
color12="00/74/ea" # Base 16 - Bright Blue
color13="fd/d5/e5" # Base 17 - Bright Magenta
color14="79/eb/d5" # Base 15 - Bright Cyan
color15="ff/f2/fd" # Base 07 - Bright White
color16="ee/df/4b" # Base 09
color17="54/07/10" # Base 0F
color18="0c/0c/0c" # Base 01
color19="42/42/42" # Base 02
color20="91/8c/91" # Base 04
color21="e1/d6/e0" # Base 06
color_foreground="b9/b1/b8" # Base 05
color_background="ff/8c/d9" # Base 00


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
  put_template_custom Pg b9b1b8 # foreground
  put_template_custom Ph ff8cd9 # background
  put_template_custom Pi b9b1b8 # bold color
  put_template_custom Pj 424242 # selection color
  put_template_custom Pk b9b1b8 # selected text color
  put_template_custom Pl b9b1b8 # cursor
  put_template_custom Pm ff8cd9 # cursor text
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
  export BASE24_COLOR_00_HEX="ff8cd9"
  export BASE24_COLOR_01_HEX="0c0c0c"
  export BASE24_COLOR_02_HEX="424242"
  export BASE24_COLOR_03_HEX="696769"
  export BASE24_COLOR_04_HEX="918c91"
  export BASE24_COLOR_05_HEX="b9b1b8"
  export BASE24_COLOR_06_HEX="e1d6e0"
  export BASE24_COLOR_07_HEX="fff2fd"
  export BASE24_COLOR_08_HEX="a80f20"
  export BASE24_COLOR_09_HEX="eedf4b"
  export BASE24_COLOR_0A_HEX="0074ea"
  export BASE24_COLOR_0B_HEX="bafc8b"
  export BASE24_COLOR_0C_HEX="6bd0bc"
  export BASE24_COLOR_0D_HEX="145fcd"
  export BASE24_COLOR_0E_HEX="ff36a2"
  export BASE24_COLOR_0F_HEX="540710"
  export BASE24_COLOR_10_HEX="2c2c2c"
  export BASE24_COLOR_11_HEX="161616"
  export BASE24_COLOR_12_HEX="d81329"
  export BASE24_COLOR_13_HEX="ffee50"
  export BASE24_COLOR_14_HEX="d2ffaf"
  export BASE24_COLOR_15_HEX="79ebd5"
  export BASE24_COLOR_16_HEX="0074ea"
  export BASE24_COLOR_17_HEX="fdd5e5"
fi
