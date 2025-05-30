#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: selenized-light 
# Scheme author: Jan Warchol (https://github.com/jan-warchol/selenized) / adapted to base16 by ali
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="selenized-light"

color00="fb/f3/db" # Base 00 - Black
color01="cc/17/29" # Base 08 - Red
color02="42/8b/00" # Base 0B - Green
color03="a7/83/00" # Base 0A - Yellow
color04="00/6d/ce" # Base 0D - Blue
color05="82/5d/c0" # Base 0E - Magenta
color06="00/97/8a" # Base 0C - Cyan
color07="3a/4d/53" # Base 06 - White
color08="d5/cd/b6" # Base 02 - Bright Black
color09="cc/17/29" # Base 12 - Bright Red
color10="42/8b/00" # Base 14 - Bright Green
color11="a7/83/00" # Base 13 - Bright Yellow
color12="00/6d/ce" # Base 16 - Bright Blue
color13="82/5d/c0" # Base 17 - Bright Magenta
color14="00/97/8a" # Base 15 - Bright Cyan
color15="3a/4d/53" # Base 07 - Bright White
color16="bc/58/19" # Base 09
color17="c4/43/92" # Base 0F
color18="ec/e3/cc" # Base 01
color19="d5/cd/b6" # Base 02
color20="90/99/95" # Base 04
color21="3a/4d/53" # Base 06
color_foreground="53/67/6d" # Base 05
color_background="fb/f3/db" # Base 00


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
  put_template_custom Pg 53676d # foreground
  put_template_custom Ph fbf3db # background
  put_template_custom Pi 53676d # bold color
  put_template_custom Pj d5cdb6 # selection color
  put_template_custom Pk 53676d # selected text color
  put_template_custom Pl 53676d # cursor
  put_template_custom Pm fbf3db # cursor text
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
  export BASE24_COLOR_00_HEX="fbf3db"
  export BASE24_COLOR_01_HEX="ece3cc"
  export BASE24_COLOR_02_HEX="d5cdb6"
  export BASE24_COLOR_03_HEX="909995"
  export BASE24_COLOR_04_HEX="909995"
  export BASE24_COLOR_05_HEX="53676d"
  export BASE24_COLOR_06_HEX="3a4d53"
  export BASE24_COLOR_07_HEX="3a4d53"
  export BASE24_COLOR_08_HEX="cc1729"
  export BASE24_COLOR_09_HEX="bc5819"
  export BASE24_COLOR_0A_HEX="a78300"
  export BASE24_COLOR_0B_HEX="428b00"
  export BASE24_COLOR_0C_HEX="00978a"
  export BASE24_COLOR_0D_HEX="006dce"
  export BASE24_COLOR_0E_HEX="825dc0"
  export BASE24_COLOR_0F_HEX="c44392"
  export BASE24_COLOR_10_HEX="fbf3db"
  export BASE24_COLOR_11_HEX="fbf3db"
  export BASE24_COLOR_12_HEX="cc1729"
  export BASE24_COLOR_13_HEX="a78300"
  export BASE24_COLOR_14_HEX="428b00"
  export BASE24_COLOR_15_HEX="00978a"
  export BASE24_COLOR_16_HEX="006dce"
  export BASE24_COLOR_17_HEX="825dc0"
fi
