#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Gruvbox Light 
# Scheme author: Tinted Theming (https://github.com/tinted-theming), morhetz (https://github.com/morhetz/gruvbox)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="gruvbox-light"

color00="fb/f1/c7" # Base 00 - Black
color01="cc/24/1d" # Base 08 - Red
color02="98/97/1a" # Base 0B - Green
color03="d7/99/21" # Base 0A - Yellow
color04="45/85/88" # Base 0D - Blue
color05="b1/62/86" # Base 0E - Magenta
color06="68/9d/6a" # Base 0C - Cyan
color07="28/28/28" # Base 06 - White
color08="d5/c4/a1" # Base 02 - Bright Black
color09="9d/00/06" # Base 12 - Bright Red
color10="79/74/0e" # Base 14 - Bright Green
color11="b5/76/14" # Base 13 - Bright Yellow
color12="07/66/78" # Base 16 - Bright Blue
color13="8f/3f/71" # Base 17 - Bright Magenta
color14="42/7b/58" # Base 15 - Bright Cyan
color15="1d/20/21" # Base 07 - Bright White
color16="d6/5d/0e" # Base 09
color17="9d/00/06" # Base 0F
color18="eb/db/b2" # Base 01
color19="d5/c4/a1" # Base 02
color20="7c/6f/64" # Base 04
color21="28/28/28" # Base 06
color_foreground="3c/38/36" # Base 05
color_background="fb/f1/c7" # Base 00


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
  put_template_custom Pg 3c3836 # foreground
  put_template_custom Ph fbf1c7 # background
  put_template_custom Pi 3c3836 # bold color
  put_template_custom Pj d5c4a1 # selection color
  put_template_custom Pk 3c3836 # selected text color
  put_template_custom Pl 3c3836 # cursor
  put_template_custom Pm fbf1c7 # cursor text
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
  export BASE24_COLOR_00_HEX="fbf1c7"
  export BASE24_COLOR_01_HEX="ebdbb2"
  export BASE24_COLOR_02_HEX="d5c4a1"
  export BASE24_COLOR_03_HEX="bdae93"
  export BASE24_COLOR_04_HEX="7c6f64"
  export BASE24_COLOR_05_HEX="3c3836"
  export BASE24_COLOR_06_HEX="282828"
  export BASE24_COLOR_07_HEX="1d2021"
  export BASE24_COLOR_08_HEX="cc241d"
  export BASE24_COLOR_09_HEX="d65d0e"
  export BASE24_COLOR_0A_HEX="d79921"
  export BASE24_COLOR_0B_HEX="98971a"
  export BASE24_COLOR_0C_HEX="689d6a"
  export BASE24_COLOR_0D_HEX="458588"
  export BASE24_COLOR_0E_HEX="b16286"
  export BASE24_COLOR_0F_HEX="9d0006"
  export BASE24_COLOR_10_HEX="f9f6d7"
  export BASE24_COLOR_11_HEX="fbf9e4"
  export BASE24_COLOR_12_HEX="9d0006"
  export BASE24_COLOR_13_HEX="b57614"
  export BASE24_COLOR_14_HEX="79740e"
  export BASE24_COLOR_15_HEX="427b58"
  export BASE24_COLOR_16_HEX="076678"
  export BASE24_COLOR_17_HEX="8f3f71"
fi
