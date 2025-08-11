#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Scarlet Protocol
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="scarlet-protocol"

color00="1b/15/3c" # Base 00 - Black
color01="ff/00/51" # Base 08 - Red
color02="00/dc/84" # Base 0B - Green
color03="68/71/ff" # Base 0A - Yellow
color04="02/71/b6" # Base 0D - Blue
color05="c9/30/c7" # Base 0E - Magenta
color06="00/c5/c7" # Base 0C - Cyan
color07="af/af/af" # Base 05 - White
color08="7f/7f/7f" # Base 03 - Bright Black
color09="ff/6d/67" # Base 12 - Bright Red
color10="5f/f9/67" # Base 14 - Bright Green
color11="fe/fb/67" # Base 13 - Bright Yellow
color12="68/71/ff" # Base 16 - Bright Blue
color13="bc/35/eb" # Base 17 - Bright Magenta
color14="5f/fd/ff" # Base 15 - Bright Cyan
color15="fe/ff/ff" # Base 07 - Bright White
color16="fa/f9/45" # Base 09
color17="7f/00/28" # Base 0F
color18="10/11/16" # Base 01
color19="67/67/67" # Base 02
color20="97/97/97" # Base 04
color21="c7/c7/c7" # Base 06
color_foreground="af/af/af" # Base 05
color_background="1b/15/3c" # Base 00


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
  put_template_custom Pg afafaf # foreground
  put_template_custom Ph 1b153c # background
  put_template_custom Pi afafaf # bold color
  put_template_custom Pj 676767 # selection color
  put_template_custom Pk afafaf # selected text color
  put_template_custom Pl afafaf # cursor
  put_template_custom Pm 1b153c # cursor text
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
  export BASE24_COLOR_00_HEX="1b153c"
  export BASE24_COLOR_01_HEX="101116"
  export BASE24_COLOR_02_HEX="676767"
  export BASE24_COLOR_03_HEX="7f7f7f"
  export BASE24_COLOR_04_HEX="979797"
  export BASE24_COLOR_05_HEX="afafaf"
  export BASE24_COLOR_06_HEX="c7c7c7"
  export BASE24_COLOR_07_HEX="feffff"
  export BASE24_COLOR_08_HEX="ff0051"
  export BASE24_COLOR_09_HEX="faf945"
  export BASE24_COLOR_0A_HEX="6871ff"
  export BASE24_COLOR_0B_HEX="00dc84"
  export BASE24_COLOR_0C_HEX="00c5c7"
  export BASE24_COLOR_0D_HEX="0271b6"
  export BASE24_COLOR_0E_HEX="c930c7"
  export BASE24_COLOR_0F_HEX="7f0028"
  export BASE24_COLOR_10_HEX="444444"
  export BASE24_COLOR_11_HEX="222222"
  export BASE24_COLOR_12_HEX="ff6d67"
  export BASE24_COLOR_13_HEX="fefb67"
  export BASE24_COLOR_14_HEX="5ff967"
  export BASE24_COLOR_15_HEX="5ffdff"
  export BASE24_COLOR_16_HEX="6871ff"
  export BASE24_COLOR_17_HEX="bc35eb"
fi
