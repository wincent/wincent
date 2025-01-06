#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Aztec 
# Scheme author: TheNeverMan (github.com/TheNeverMan)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="aztec"

color00="10/16/00" # Base 00 - Black
color01="EE/2E/00" # Base 08 - Red
color02="63/D9/32" # Base 0B - Green
color03="EE/BB/00" # Base 0A - Yellow
color04="5B/4A/9F" # Base 0D - Blue
color05="88/3E/9F" # Base 0E - Magenta
color06="3D/94/A5" # Base 0C - Cyan
color07="FF/E1/78" # Base 06 - White
color08="24/26/04" # Base 02 - Bright Black
color09="EE/2E/00" # Base 12 - Bright Red
color10="63/D9/32" # Base 14 - Bright Green
color11="EE/BB/00" # Base 13 - Bright Yellow
color12="5B/4A/9F" # Base 16 - Bright Blue
color13="88/3E/9F" # Base 17 - Bright Magenta
color14="3D/94/A5" # Base 15 - Bright Cyan
color15="FF/EB/A0" # Base 07 - Bright White
color16="EE/88/00" # Base 09
color17="A9/28/B9" # Base 0F
color18="1A/1E/01" # Base 01
color19="24/26/04" # Base 02
color20="FF/D1/29" # Base 04
color21="FF/E1/78" # Base 06
color_foreground="FF/DA/51" # Base 05
color_background="10/16/00" # Base 00


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
  put_template_custom Pg FFDA51 # foreground
  put_template_custom Ph 101600 # background
  put_template_custom Pi FFDA51 # bold color
  put_template_custom Pj 242604 # selection color
  put_template_custom Pk FFDA51 # selected text color
  put_template_custom Pl FFDA51 # cursor
  put_template_custom Pm 101600 # cursor text
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
  export BASE24_COLOR_00_HEX="101600"
  export BASE24_COLOR_01_HEX="1A1E01"
  export BASE24_COLOR_02_HEX="242604"
  export BASE24_COLOR_03_HEX="2E2E05"
  export BASE24_COLOR_04_HEX="FFD129"
  export BASE24_COLOR_05_HEX="FFDA51"
  export BASE24_COLOR_06_HEX="FFE178"
  export BASE24_COLOR_07_HEX="FFEBA0"
  export BASE24_COLOR_08_HEX="EE2E00"
  export BASE24_COLOR_09_HEX="EE8800"
  export BASE24_COLOR_0A_HEX="EEBB00"
  export BASE24_COLOR_0B_HEX="63D932"
  export BASE24_COLOR_0C_HEX="3D94A5"
  export BASE24_COLOR_0D_HEX="5B4A9F"
  export BASE24_COLOR_0E_HEX="883E9F"
  export BASE24_COLOR_0F_HEX="A928B9"
  export BASE24_COLOR_10_HEX="101600"
  export BASE24_COLOR_11_HEX="101600"
  export BASE24_COLOR_12_HEX="EE2E00"
  export BASE24_COLOR_13_HEX="EEBB00"
  export BASE24_COLOR_14_HEX="63D932"
  export BASE24_COLOR_15_HEX="3D94A5"
  export BASE24_COLOR_16_HEX="5B4A9F"
  export BASE24_COLOR_17_HEX="883E9F"
fi
