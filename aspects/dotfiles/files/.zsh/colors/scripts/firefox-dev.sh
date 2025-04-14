#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Firefox Dev 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="firefox-dev"

color00="0e/10/11" # Base 00 - Black
color01="e6/38/53" # Base 08 - Red
color02="5e/b8/3c" # Base 0B - Green
color03="00/6f/c0" # Base 0A - Yellow
color04="35/9d/df" # Base 0D - Blue
color05="d7/5c/ff" # Base 0E - Magenta
color06="4b/73/a2" # Base 0C - Cyan
color07="dc/dc/dc" # Base 06 - White
color08="00/1e/26" # Base 02 - Bright Black
color09="e1/00/3f" # Base 12 - Bright Red
color10="1d/90/00" # Base 14 - Bright Green
color11="cc/93/08" # Base 13 - Bright Yellow
color12="00/6f/c0" # Base 16 - Bright Blue
color13="a2/00/da" # Base 17 - Bright Magenta
color14="00/57/94" # Base 15 - Bright Cyan
color15="e2/e2/e2" # Base 07 - Bright White
color16="a5/77/05" # Base 09
color17="73/1c/29" # Base 0F
color18="00/27/31" # Base 01
color19="00/1e/26" # Base 02
color20="6e/7d/81" # Base 04
color21="dc/dc/dc" # Base 06
color_foreground="a5/ac/ae" # Base 05
color_background="0e/10/11" # Base 00


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
  put_template_custom Pg a5acae # foreground
  put_template_custom Ph 0e1011 # background
  put_template_custom Pi a5acae # bold color
  put_template_custom Pj 001e26 # selection color
  put_template_custom Pk a5acae # selected text color
  put_template_custom Pl a5acae # cursor
  put_template_custom Pm 0e1011 # cursor text
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
  export BASE24_COLOR_00_HEX="0e1011"
  export BASE24_COLOR_01_HEX="002731"
  export BASE24_COLOR_02_HEX="001e26"
  export BASE24_COLOR_03_HEX="374d53"
  export BASE24_COLOR_04_HEX="6e7d81"
  export BASE24_COLOR_05_HEX="a5acae"
  export BASE24_COLOR_06_HEX="dcdcdc"
  export BASE24_COLOR_07_HEX="e2e2e2"
  export BASE24_COLOR_08_HEX="e63853"
  export BASE24_COLOR_09_HEX="a57705"
  export BASE24_COLOR_0A_HEX="006fc0"
  export BASE24_COLOR_0B_HEX="5eb83c"
  export BASE24_COLOR_0C_HEX="4b73a2"
  export BASE24_COLOR_0D_HEX="359ddf"
  export BASE24_COLOR_0E_HEX="d75cff"
  export BASE24_COLOR_0F_HEX="731c29"
  export BASE24_COLOR_10_HEX="001419"
  export BASE24_COLOR_11_HEX="000a0c"
  export BASE24_COLOR_12_HEX="e1003f"
  export BASE24_COLOR_13_HEX="cc9308"
  export BASE24_COLOR_14_HEX="1d9000"
  export BASE24_COLOR_15_HEX="005794"
  export BASE24_COLOR_16_HEX="006fc0"
  export BASE24_COLOR_17_HEX="a200da"
fi
