#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Tokyo City Dark 
# Scheme author: Michaël Ball
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="tokyo-city-dark"

color00="17/1D/23" # Base 00 - Black
color01="F7/76/8E" # Base 08 - Red
color02="9E/CE/6A" # Base 0B - Green
color03="B7/C5/D3" # Base 0A - Yellow
color04="7A/A2/F7" # Base 0D - Blue
color05="BB/9A/F7" # Base 0E - Magenta
color06="89/DD/FF" # Base 0C - Cyan
color07="F6/F6/F8" # Base 06 - White
color08="28/32/3A" # Base 02 - Bright Black
color09="F7/76/8E" # Base 12 - Bright Red
color10="9E/CE/6A" # Base 14 - Bright Green
color11="B7/C5/D3" # Base 13 - Bright Yellow
color12="7A/A2/F7" # Base 16 - Bright Blue
color13="BB/9A/F7" # Base 17 - Bright Magenta
color14="89/DD/FF" # Base 15 - Bright Cyan
color15="FB/FB/FD" # Base 07 - Bright White
color16="FF/9E/64" # Base 09
color17="BB/9A/F7" # Base 0F
color18="1D/25/2C" # Base 01
color19="28/32/3A" # Base 02
color20="B7/C5/D3" # Base 04
color21="F6/F6/F8" # Base 06
color_foreground="D8/E2/EC" # Base 05
color_background="17/1D/23" # Base 00


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
  put_template_custom Pg D8E2EC # foreground
  put_template_custom Ph 171D23 # background
  put_template_custom Pi D8E2EC # bold color
  put_template_custom Pj 28323A # selection color
  put_template_custom Pk D8E2EC # selected text color
  put_template_custom Pl D8E2EC # cursor
  put_template_custom Pm 171D23 # cursor text
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
  export BASE24_COLOR_00_HEX="171D23"
  export BASE24_COLOR_01_HEX="1D252C"
  export BASE24_COLOR_02_HEX="28323A"
  export BASE24_COLOR_03_HEX="526270"
  export BASE24_COLOR_04_HEX="B7C5D3"
  export BASE24_COLOR_05_HEX="D8E2EC"
  export BASE24_COLOR_06_HEX="F6F6F8"
  export BASE24_COLOR_07_HEX="FBFBFD"
  export BASE24_COLOR_08_HEX="F7768E"
  export BASE24_COLOR_09_HEX="FF9E64"
  export BASE24_COLOR_0A_HEX="B7C5D3"
  export BASE24_COLOR_0B_HEX="9ECE6A"
  export BASE24_COLOR_0C_HEX="89DDFF"
  export BASE24_COLOR_0D_HEX="7AA2F7"
  export BASE24_COLOR_0E_HEX="BB9AF7"
  export BASE24_COLOR_0F_HEX="BB9AF7"
  export BASE24_COLOR_10_HEX="171D23"
  export BASE24_COLOR_11_HEX="171D23"
  export BASE24_COLOR_12_HEX="F7768E"
  export BASE24_COLOR_13_HEX="B7C5D3"
  export BASE24_COLOR_14_HEX="9ECE6A"
  export BASE24_COLOR_15_HEX="89DDFF"
  export BASE24_COLOR_16_HEX="7AA2F7"
  export BASE24_COLOR_17_HEX="BB9AF7"
fi
