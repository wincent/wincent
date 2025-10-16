#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Batman
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="batman"

color00="1b/1d/1e" # Base 00 - Black
color01="e6/db/43" # Base 08 - Red
color02="c8/be/46" # Base 0B - Green
color03="90/94/95" # Base 0A - Yellow
color04="73/70/74" # Base 0D - Blue
color05="73/72/71" # Base 0E - Magenta
color06="61/5f/5e" # Base 0C - Cyan
color07="a7/a8/a3" # Base 05 - White
color08="6d/6f/6e" # Base 03 - Bright Black
color09="ff/f6/8d" # Base 12 - Bright Red
color10="ff/f2/7c" # Base 14 - Bright Green
color11="fe/ed/6c" # Base 13 - Bright Yellow
color12="90/94/95" # Base 16 - Bright Blue
color13="9a/99/9d" # Base 17 - Bright Magenta
color14="a2/a2/a5" # Base 15 - Bright Cyan
color15="da/da/d5" # Base 07 - Bright White
color16="f3/fd/21" # Base 09
color17="73/6d/21" # Base 0F
color18="1b/1d/1e" # Base 01
color19="50/53/54" # Base 02
color20="8a/8c/89" # Base 04
color21="c5/c5/be" # Base 06
color_foreground="a7/a8/a3" # Base 05
color_background="1b/1d/1e" # Base 00


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
  put_template_custom Pg a7a8a3 # foreground
  put_template_custom Ph 1b1d1e # background
  put_template_custom Pi a7a8a3 # bold color
  put_template_custom Pj 505354 # selection color
  put_template_custom Pk a7a8a3 # selected text color
  put_template_custom Pl a7a8a3 # cursor
  put_template_custom Pm 1b1d1e # cursor text
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
  export BASE24_COLOR_00_HEX="1b1d1e"
  export BASE24_COLOR_01_HEX="1b1d1e"
  export BASE24_COLOR_02_HEX="505354"
  export BASE24_COLOR_03_HEX="6d6f6e"
  export BASE24_COLOR_04_HEX="8a8c89"
  export BASE24_COLOR_05_HEX="a7a8a3"
  export BASE24_COLOR_06_HEX="c5c5be"
  export BASE24_COLOR_07_HEX="dadad5"
  export BASE24_COLOR_08_HEX="e6db43"
  export BASE24_COLOR_09_HEX="f3fd21"
  export BASE24_COLOR_0A_HEX="909495"
  export BASE24_COLOR_0B_HEX="c8be46"
  export BASE24_COLOR_0C_HEX="615f5e"
  export BASE24_COLOR_0D_HEX="737074"
  export BASE24_COLOR_0E_HEX="737271"
  export BASE24_COLOR_0F_HEX="736d21"
  export BASE24_COLOR_10_HEX="353738"
  export BASE24_COLOR_11_HEX="1a1b1c"
  export BASE24_COLOR_12_HEX="fff68d"
  export BASE24_COLOR_13_HEX="feed6c"
  export BASE24_COLOR_14_HEX="fff27c"
  export BASE24_COLOR_15_HEX="a2a2a5"
  export BASE24_COLOR_16_HEX="909495"
  export BASE24_COLOR_17_HEX="9a999d"
fi
