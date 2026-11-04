#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Lumina Parchment Light
# Scheme author: Razik Ikhlef (https://github.com/RazikSF)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="lumina-parchment-light"

color00="f9/ef/da" # Base 00 - Black
color01="91/29/18" # Base 08 - Red
color02="2d/73/41" # Base 0B - Green
color03="65/49/35" # Base 0A - Yellow
color04="2e/5f/b0" # Base 0D - Blue
color05="62/55/9d" # Base 0E - Magenta
color06="00/6e/81" # Base 0C - Cyan
color07="35/25/16" # Base 05 - White
color08="d3/cd/bf" # Base 03 - Bright Black
color09="6b/28/1c" # Base 12 - Bright Red
color10="19/5e/2f" # Base 14 - Bright Green
color11="5f/2f/00" # Base 13 - Bright Yellow
color12="28/4d/8a" # Base 16 - Bright Blue
color13="6b/37/70" # Base 17 - Bright Magenta
color14="00/58/68" # Base 15 - Bright Cyan
color15="35/25/16" # Base 07 - Bright White
color16="65/49/35" # Base 09
color17="87/41/8e" # Base 0F
color18="ef/e9/db" # Base 01
color19="e4/dd/cf" # Base 02
color20="90/83/69" # Base 04
color21="52/46/2d" # Base 06
color_foreground="35/25/16" # Base 05
color_background="f9/ef/da" # Base 00


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

# 256 color space
put_template 16 "$color16"
put_template 17 "$color17"
put_template 18 "$color18"
put_template 19 "$color19"
put_template 20 "$color20"
put_template 21 "$color21"

# foreground / background / cursor color
if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  put_template_custom Pg 352516 # foreground
  put_template_custom Ph f9efda # background
  put_template_custom Pi 352516 # bold color
  put_template_custom Pj e4ddcf # selection color
  put_template_custom Pk 352516 # selected text color
  put_template_custom Pl 352516 # cursor
  put_template_custom Pm f9efda # cursor text
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
unset color15
unset color16
unset color17
unset color18
unset color19
unset color20
unset color21
unset color_foreground
unset color_background

# Optionally export variables
if [ -n "$TINTED_SHELL_ENABLE_BASE24_VARS" ]; then
  export BASE24_COLOR_00_HEX="f9efda"
  export BASE24_COLOR_01_HEX="efe9db"
  export BASE24_COLOR_02_HEX="e4ddcf"
  export BASE24_COLOR_03_HEX="d3cdbf"
  export BASE24_COLOR_04_HEX="908369"
  export BASE24_COLOR_05_HEX="352516"
  export BASE24_COLOR_06_HEX="52462d"
  export BASE24_COLOR_07_HEX="352516"
  export BASE24_COLOR_08_HEX="912918"
  export BASE24_COLOR_09_HEX="654935"
  export BASE24_COLOR_0A_HEX="654935"
  export BASE24_COLOR_0B_HEX="2d7341"
  export BASE24_COLOR_0C_HEX="006e81"
  export BASE24_COLOR_0D_HEX="2e5fb0"
  export BASE24_COLOR_0E_HEX="62559d"
  export BASE24_COLOR_0F_HEX="87418e"
  export BASE24_COLOR_10_HEX="fdf8ed"
  export BASE24_COLOR_11_HEX="f2e8d3"
  export BASE24_COLOR_12_HEX="6b281c"
  export BASE24_COLOR_13_HEX="5f2f00"
  export BASE24_COLOR_14_HEX="195e2f"
  export BASE24_COLOR_15_HEX="005868"
  export BASE24_COLOR_16_HEX="284d8a"
  export BASE24_COLOR_17_HEX="6b3770"
fi
