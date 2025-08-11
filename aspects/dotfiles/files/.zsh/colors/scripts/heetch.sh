#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Heetch Dark
# Scheme author: Geoffrey Teale (tealeg@gmail.com)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="heetch"

color00="19/01/34" # Base 00 - Black
color01="27/D9/D5" # Base 08 - Red
color02="C3/36/78" # Base 0B - Green
color03="8F/6C/97" # Base 0A - Yellow
color04="BD/01/52" # Base 0D - Blue
color05="82/03/4C" # Base 0E - Magenta
color06="F8/00/59" # Base 0C - Cyan
color07="BD/B6/C5" # Base 05 - White
color08="7B/6D/8B" # Base 03 - Bright Black
color09="27/D9/D5" # Base 12 - Bright Red
color10="C3/36/78" # Base 14 - Bright Green
color11="8F/6C/97" # Base 13 - Bright Yellow
color12="BD/01/52" # Base 16 - Bright Blue
color13="82/03/4C" # Base 17 - Bright Magenta
color14="F8/00/59" # Base 15 - Bright Cyan
color15="FE/FF/FF" # Base 07 - Bright White
color16="5B/A2/B6" # Base 09
color17="47/05/46" # Base 0F
color18="39/25/51" # Base 01
color19="5A/49/6E" # Base 02
color20="9C/92/A8" # Base 04
color21="DE/DA/E2" # Base 06
color_foreground="BD/B6/C5" # Base 05
color_background="19/01/34" # Base 00


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
  put_template_custom Pg BDB6C5 # foreground
  put_template_custom Ph 190134 # background
  put_template_custom Pi BDB6C5 # bold color
  put_template_custom Pj 5A496E # selection color
  put_template_custom Pk BDB6C5 # selected text color
  put_template_custom Pl BDB6C5 # cursor
  put_template_custom Pm 190134 # cursor text
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
  export BASE24_COLOR_00_HEX="190134"
  export BASE24_COLOR_01_HEX="392551"
  export BASE24_COLOR_02_HEX="5A496E"
  export BASE24_COLOR_03_HEX="7B6D8B"
  export BASE24_COLOR_04_HEX="9C92A8"
  export BASE24_COLOR_05_HEX="BDB6C5"
  export BASE24_COLOR_06_HEX="DEDAE2"
  export BASE24_COLOR_07_HEX="FEFFFF"
  export BASE24_COLOR_08_HEX="27D9D5"
  export BASE24_COLOR_09_HEX="5BA2B6"
  export BASE24_COLOR_0A_HEX="8F6C97"
  export BASE24_COLOR_0B_HEX="C33678"
  export BASE24_COLOR_0C_HEX="F80059"
  export BASE24_COLOR_0D_HEX="BD0152"
  export BASE24_COLOR_0E_HEX="82034C"
  export BASE24_COLOR_0F_HEX="470546"
  export BASE24_COLOR_10_HEX="190134"
  export BASE24_COLOR_11_HEX="190134"
  export BASE24_COLOR_12_HEX="27D9D5"
  export BASE24_COLOR_13_HEX="8F6C97"
  export BASE24_COLOR_14_HEX="C33678"
  export BASE24_COLOR_15_HEX="F80059"
  export BASE24_COLOR_16_HEX="BD0152"
  export BASE24_COLOR_17_HEX="82034C"
fi
