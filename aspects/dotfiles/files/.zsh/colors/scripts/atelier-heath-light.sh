#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Atelier Heath Light 
# Scheme author: Bram de Haan (http://atelierbramdehaan.nl)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="atelier-heath-light"

color00="f7/f3/f7" # Base 00 - Black
color01="ca/40/2b" # Base 08 - Red
color02="91/8b/3b" # Base 0B - Green
color03="bb/8a/35" # Base 0A - Yellow
color04="51/6a/ec" # Base 0D - Blue
color05="7b/59/c0" # Base 0E - Magenta
color06="15/93/93" # Base 0C - Cyan
color07="29/23/29" # Base 06 - White
color08="ab/9b/ab" # Base 02 - Bright Black
color09="ca/40/2b" # Base 12 - Bright Red
color10="91/8b/3b" # Base 14 - Bright Green
color11="bb/8a/35" # Base 13 - Bright Yellow
color12="51/6a/ec" # Base 16 - Bright Blue
color13="7b/59/c0" # Base 17 - Bright Magenta
color14="15/93/93" # Base 15 - Bright Cyan
color15="1b/18/1b" # Base 07 - Bright White
color16="a6/59/26" # Base 09
color17="cc/33/cc" # Base 0F
color18="d8/ca/d8" # Base 01
color19="ab/9b/ab" # Base 02
color20="77/69/77" # Base 04
color21="29/23/29" # Base 06
color_foreground="69/5d/69" # Base 05
color_background="f7/f3/f7" # Base 00


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
  put_template_custom Pg 695d69 # foreground
  put_template_custom Ph f7f3f7 # background
  put_template_custom Pi 695d69 # bold color
  put_template_custom Pj ab9bab # selection color
  put_template_custom Pk 695d69 # selected text color
  put_template_custom Pl 695d69 # cursor
  put_template_custom Pm f7f3f7 # cursor text
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
  export BASE24_COLOR_00_HEX="f7f3f7"
  export BASE24_COLOR_01_HEX="d8cad8"
  export BASE24_COLOR_02_HEX="ab9bab"
  export BASE24_COLOR_03_HEX="9e8f9e"
  export BASE24_COLOR_04_HEX="776977"
  export BASE24_COLOR_05_HEX="695d69"
  export BASE24_COLOR_06_HEX="292329"
  export BASE24_COLOR_07_HEX="1b181b"
  export BASE24_COLOR_08_HEX="ca402b"
  export BASE24_COLOR_09_HEX="a65926"
  export BASE24_COLOR_0A_HEX="bb8a35"
  export BASE24_COLOR_0B_HEX="918b3b"
  export BASE24_COLOR_0C_HEX="159393"
  export BASE24_COLOR_0D_HEX="516aec"
  export BASE24_COLOR_0E_HEX="7b59c0"
  export BASE24_COLOR_0F_HEX="cc33cc"
  export BASE24_COLOR_10_HEX="f7f3f7"
  export BASE24_COLOR_11_HEX="f7f3f7"
  export BASE24_COLOR_12_HEX="ca402b"
  export BASE24_COLOR_13_HEX="bb8a35"
  export BASE24_COLOR_14_HEX="918b3b"
  export BASE24_COLOR_15_HEX="159393"
  export BASE24_COLOR_16_HEX="516aec"
  export BASE24_COLOR_17_HEX="7b59c0"
fi
