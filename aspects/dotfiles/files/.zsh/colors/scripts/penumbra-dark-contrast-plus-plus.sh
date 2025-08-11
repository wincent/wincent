#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Penumbra Dark Contrast Plus Plus
# Scheme author: Zachary Weiss (https://github.com/zacharyweiss)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="penumbra-dark-contrast-plus-plus"

color00="0D/0F/13" # Base 00 - Black
color01="F5/8C/81" # Base 08 - Red
color02="54/C7/94" # Base 0B - Green
color03="A9/B8/52" # Base 0A - Yellow
color04="6E/B2/FD" # Base 0D - Blue
color05="B6/9C/F6" # Base 0E - Magenta
color06="00/C4/D7" # Base 0C - Cyan
color07="DE/DE/DE" # Base 05 - White
color08="63/63/63" # Base 03 - Bright Black
color09="F5/8C/81" # Base 12 - Bright Red
color10="54/C7/94" # Base 14 - Bright Green
color11="A9/B8/52" # Base 13 - Bright Yellow
color12="6E/B2/FD" # Base 16 - Bright Blue
color13="B6/9C/F6" # Base 17 - Bright Magenta
color14="00/C4/D7" # Base 15 - Bright Cyan
color15="FF/FD/FB" # Base 07 - Bright White
color16="E0/9F/47" # Base 09
color17="E5/8C/C5" # Base 0F
color18="18/1B/1F" # Base 01
color19="3E/40/44" # Base 02
color20="AE/AE/AE" # Base 04
color21="FF/F7/ED" # Base 06
color_foreground="DE/DE/DE" # Base 05
color_background="0D/0F/13" # Base 00


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
  put_template_custom Pg DEDEDE # foreground
  put_template_custom Ph 0D0F13 # background
  put_template_custom Pi DEDEDE # bold color
  put_template_custom Pj 3E4044 # selection color
  put_template_custom Pk DEDEDE # selected text color
  put_template_custom Pl DEDEDE # cursor
  put_template_custom Pm 0D0F13 # cursor text
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
  export BASE24_COLOR_00_HEX="0D0F13"
  export BASE24_COLOR_01_HEX="181B1F"
  export BASE24_COLOR_02_HEX="3E4044"
  export BASE24_COLOR_03_HEX="636363"
  export BASE24_COLOR_04_HEX="AEAEAE"
  export BASE24_COLOR_05_HEX="DEDEDE"
  export BASE24_COLOR_06_HEX="FFF7ED"
  export BASE24_COLOR_07_HEX="FFFDFB"
  export BASE24_COLOR_08_HEX="F58C81"
  export BASE24_COLOR_09_HEX="E09F47"
  export BASE24_COLOR_0A_HEX="A9B852"
  export BASE24_COLOR_0B_HEX="54C794"
  export BASE24_COLOR_0C_HEX="00C4D7"
  export BASE24_COLOR_0D_HEX="6EB2FD"
  export BASE24_COLOR_0E_HEX="B69CF6"
  export BASE24_COLOR_0F_HEX="E58CC5"
  export BASE24_COLOR_10_HEX="0D0F13"
  export BASE24_COLOR_11_HEX="0D0F13"
  export BASE24_COLOR_12_HEX="F58C81"
  export BASE24_COLOR_13_HEX="A9B852"
  export BASE24_COLOR_14_HEX="54C794"
  export BASE24_COLOR_15_HEX="00C4D7"
  export BASE24_COLOR_16_HEX="6EB2FD"
  export BASE24_COLOR_17_HEX="B69CF6"
fi
