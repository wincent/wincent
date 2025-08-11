#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Mocha
# Scheme author: Chris Kempson (https://github.com/chriskempson)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="mocha"

color00="3B/32/28" # Base 00 - Black
color01="cb/60/77" # Base 08 - Red
color02="be/b5/5b" # Base 0B - Green
color03="f4/bc/87" # Base 0A - Yellow
color04="8a/b3/b5" # Base 0D - Blue
color05="a8/9b/b9" # Base 0E - Magenta
color06="7b/bd/a4" # Base 0C - Cyan
color07="d0/c8/c6" # Base 05 - White
color08="7e/70/5a" # Base 03 - Bright Black
color09="cb/60/77" # Base 12 - Bright Red
color10="be/b5/5b" # Base 14 - Bright Green
color11="f4/bc/87" # Base 13 - Bright Yellow
color12="8a/b3/b5" # Base 16 - Bright Blue
color13="a8/9b/b9" # Base 17 - Bright Magenta
color14="7b/bd/a4" # Base 15 - Bright Cyan
color15="f5/ee/eb" # Base 07 - Bright White
color16="d2/8b/71" # Base 09
color17="bb/95/84" # Base 0F
color18="53/46/36" # Base 01
color19="64/52/40" # Base 02
color20="b8/af/ad" # Base 04
color21="e9/e1/dd" # Base 06
color_foreground="d0/c8/c6" # Base 05
color_background="3B/32/28" # Base 00


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
  put_template_custom Pg d0c8c6 # foreground
  put_template_custom Ph 3B3228 # background
  put_template_custom Pi d0c8c6 # bold color
  put_template_custom Pj 645240 # selection color
  put_template_custom Pk d0c8c6 # selected text color
  put_template_custom Pl d0c8c6 # cursor
  put_template_custom Pm 3B3228 # cursor text
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
  export BASE24_COLOR_00_HEX="3B3228"
  export BASE24_COLOR_01_HEX="534636"
  export BASE24_COLOR_02_HEX="645240"
  export BASE24_COLOR_03_HEX="7e705a"
  export BASE24_COLOR_04_HEX="b8afad"
  export BASE24_COLOR_05_HEX="d0c8c6"
  export BASE24_COLOR_06_HEX="e9e1dd"
  export BASE24_COLOR_07_HEX="f5eeeb"
  export BASE24_COLOR_08_HEX="cb6077"
  export BASE24_COLOR_09_HEX="d28b71"
  export BASE24_COLOR_0A_HEX="f4bc87"
  export BASE24_COLOR_0B_HEX="beb55b"
  export BASE24_COLOR_0C_HEX="7bbda4"
  export BASE24_COLOR_0D_HEX="8ab3b5"
  export BASE24_COLOR_0E_HEX="a89bb9"
  export BASE24_COLOR_0F_HEX="bb9584"
  export BASE24_COLOR_10_HEX="3B3228"
  export BASE24_COLOR_11_HEX="3B3228"
  export BASE24_COLOR_12_HEX="cb6077"
  export BASE24_COLOR_13_HEX="f4bc87"
  export BASE24_COLOR_14_HEX="beb55b"
  export BASE24_COLOR_15_HEX="7bbda4"
  export BASE24_COLOR_16_HEX="8ab3b5"
  export BASE24_COLOR_17_HEX="a89bb9"
fi
