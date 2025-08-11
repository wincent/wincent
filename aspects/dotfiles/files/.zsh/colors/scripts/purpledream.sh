#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Purpledream
# Scheme author: malet
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="purpledream"

color00="10/05/10" # Base 00 - Black
color01="FF/1D/0D" # Base 08 - Red
color02="14/CC/64" # Base 0B - Green
color03="F0/00/A0" # Base 0A - Yellow
color04="00/A0/F0" # Base 0D - Blue
color05="B0/00/D0" # Base 0E - Magenta
color06="00/75/B0" # Base 0C - Cyan
color07="dd/d0/dd" # Base 05 - White
color08="60/50/60" # Base 03 - Bright Black
color09="FF/1D/0D" # Base 12 - Bright Red
color10="14/CC/64" # Base 14 - Bright Green
color11="F0/00/A0" # Base 13 - Bright Yellow
color12="00/A0/F0" # Base 16 - Bright Blue
color13="B0/00/D0" # Base 17 - Bright Magenta
color14="00/75/B0" # Base 15 - Bright Cyan
color15="ff/f0/ff" # Base 07 - Bright White
color16="CC/AE/14" # Base 09
color17="6A/2A/3C" # Base 0F
color18="30/20/30" # Base 01
color19="40/30/40" # Base 02
color20="bb/b0/bb" # Base 04
color21="ee/e0/ee" # Base 06
color_foreground="dd/d0/dd" # Base 05
color_background="10/05/10" # Base 00


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
  put_template_custom Pg ddd0dd # foreground
  put_template_custom Ph 100510 # background
  put_template_custom Pi ddd0dd # bold color
  put_template_custom Pj 403040 # selection color
  put_template_custom Pk ddd0dd # selected text color
  put_template_custom Pl ddd0dd # cursor
  put_template_custom Pm 100510 # cursor text
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
  export BASE24_COLOR_00_HEX="100510"
  export BASE24_COLOR_01_HEX="302030"
  export BASE24_COLOR_02_HEX="403040"
  export BASE24_COLOR_03_HEX="605060"
  export BASE24_COLOR_04_HEX="bbb0bb"
  export BASE24_COLOR_05_HEX="ddd0dd"
  export BASE24_COLOR_06_HEX="eee0ee"
  export BASE24_COLOR_07_HEX="fff0ff"
  export BASE24_COLOR_08_HEX="FF1D0D"
  export BASE24_COLOR_09_HEX="CCAE14"
  export BASE24_COLOR_0A_HEX="F000A0"
  export BASE24_COLOR_0B_HEX="14CC64"
  export BASE24_COLOR_0C_HEX="0075B0"
  export BASE24_COLOR_0D_HEX="00A0F0"
  export BASE24_COLOR_0E_HEX="B000D0"
  export BASE24_COLOR_0F_HEX="6A2A3C"
  export BASE24_COLOR_10_HEX="100510"
  export BASE24_COLOR_11_HEX="100510"
  export BASE24_COLOR_12_HEX="FF1D0D"
  export BASE24_COLOR_13_HEX="F000A0"
  export BASE24_COLOR_14_HEX="14CC64"
  export BASE24_COLOR_15_HEX="0075B0"
  export BASE24_COLOR_16_HEX="00A0F0"
  export BASE24_COLOR_17_HEX="B000D0"
fi
