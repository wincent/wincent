#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Horizon Terminal Light
# Scheme author: Michaël Ball (http://github.com/michael-ball/)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="horizon-terminal-light"

color00="FD/F0/ED" # Base 00 - Black
color01="E9/56/78" # Base 08 - Red
color02="29/D3/98" # Base 0B - Green
color03="FA/DA/D1" # Base 0A - Yellow
color04="26/BB/D9" # Base 0D - Blue
color05="EE/64/AC" # Base 0E - Magenta
color06="59/E1/E3" # Base 0C - Cyan
color07="40/3C/3D" # Base 05 - White
color08="BD/B3/B1" # Base 03 - Bright Black
color09="E9/56/78" # Base 12 - Bright Red
color10="29/D3/98" # Base 14 - Bright Green
color11="FA/DA/D1" # Base 13 - Bright Yellow
color12="26/BB/D9" # Base 16 - Bright Blue
color13="EE/64/AC" # Base 17 - Bright Magenta
color14="59/E1/E3" # Base 15 - Bright Cyan
color15="20/1C/1D" # Base 07 - Bright White
color16="F9/CE/C3" # Base 09
color17="F9/CB/BE" # Base 0F
color18="FA/DA/D1" # Base 01
color19="F9/CB/BE" # Base 02
color20="94/8C/8A" # Base 04
color21="30/2C/2D" # Base 06
color_foreground="40/3C/3D" # Base 05
color_background="FD/F0/ED" # Base 00


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
  put_template_custom Pg 403C3D # foreground
  put_template_custom Ph FDF0ED # background
  put_template_custom Pi 403C3D # bold color
  put_template_custom Pj F9CBBE # selection color
  put_template_custom Pk 403C3D # selected text color
  put_template_custom Pl 403C3D # cursor
  put_template_custom Pm FDF0ED # cursor text
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
  export BASE24_COLOR_00_HEX="FDF0ED"
  export BASE24_COLOR_01_HEX="FADAD1"
  export BASE24_COLOR_02_HEX="F9CBBE"
  export BASE24_COLOR_03_HEX="BDB3B1"
  export BASE24_COLOR_04_HEX="948C8A"
  export BASE24_COLOR_05_HEX="403C3D"
  export BASE24_COLOR_06_HEX="302C2D"
  export BASE24_COLOR_07_HEX="201C1D"
  export BASE24_COLOR_08_HEX="E95678"
  export BASE24_COLOR_09_HEX="F9CEC3"
  export BASE24_COLOR_0A_HEX="FADAD1"
  export BASE24_COLOR_0B_HEX="29D398"
  export BASE24_COLOR_0C_HEX="59E1E3"
  export BASE24_COLOR_0D_HEX="26BBD9"
  export BASE24_COLOR_0E_HEX="EE64AC"
  export BASE24_COLOR_0F_HEX="F9CBBE"
  export BASE24_COLOR_10_HEX="FDF0ED"
  export BASE24_COLOR_11_HEX="FDF0ED"
  export BASE24_COLOR_12_HEX="E95678"
  export BASE24_COLOR_13_HEX="FADAD1"
  export BASE24_COLOR_14_HEX="29D398"
  export BASE24_COLOR_15_HEX="59E1E3"
  export BASE24_COLOR_16_HEX="26BBD9"
  export BASE24_COLOR_17_HEX="EE64AC"
fi
