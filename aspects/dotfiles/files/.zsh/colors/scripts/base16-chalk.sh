#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Chalk 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="chalk"

color00="15/15/15" # Base 00 - Black
color01="fa/85/9c" # Base 08 - Red
color02="a1/bb/54" # Base 0B - Green
color03="dd/b2/6f" # Base 0A - Yellow
color04="5a/b9/ed" # Base 0D - Blue
color05="db/8f/ea" # Base 0E - Magenta
color06="10/bc/ad" # Base 0C - Cyan
color07="e0/e0/e0" # Base 06 - White
color08="30/30/30" # Base 02 - Bright Black
color09="fb/9f/b1" # Base 12 - Bright Red
color10="ac/c2/67" # Base 14 - Bright Green
color11="ed/a9/87" # Base 13 - Bright Yellow
color12="6f/c2/ef" # Base 16 - Bright Blue
color13="e1/a3/ee" # Base 17 - Bright Magenta
color14="12/cf/c0" # Base 15 - Bright Cyan
color15="f5/f5/f5" # Base 07 - Bright White
color16="ea/99/71" # Base 09
color17="de/af/8f" # Base 0F
color18="20/20/20" # Base 01
color19="30/30/30" # Base 02
color20="b0/b0/b0" # Base 04
color21="e0/e0/e0" # Base 06
color_foreground="d0/d0/d0" # Base 05
color_background="15/15/15" # Base 00


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
  put_template_custom Pg d0d0d0 # foreground
  put_template_custom Ph 151515 # background
  put_template_custom Pi d0d0d0 # bold color
  put_template_custom Pj 303030 # selection color
  put_template_custom Pk d0d0d0 # selected text color
  put_template_custom Pl d0d0d0 # cursor
  put_template_custom Pm 151515 # cursor text
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
  export BASE24_COLOR_00_HEX="151515"
  export BASE24_COLOR_01_HEX="202020"
  export BASE24_COLOR_02_HEX="303030"
  export BASE24_COLOR_03_HEX="505050"
  export BASE24_COLOR_04_HEX="b0b0b0"
  export BASE24_COLOR_05_HEX="d0d0d0"
  export BASE24_COLOR_06_HEX="e0e0e0"
  export BASE24_COLOR_07_HEX="f5f5f5"
  export BASE24_COLOR_08_HEX="fa859c"
  export BASE24_COLOR_09_HEX="ea9971"
  export BASE24_COLOR_0A_HEX="ddb26f"
  export BASE24_COLOR_0B_HEX="a1bb54"
  export BASE24_COLOR_0C_HEX="10bcad"
  export BASE24_COLOR_0D_HEX="5ab9ed"
  export BASE24_COLOR_0E_HEX="db8fea"
  export BASE24_COLOR_0F_HEX="deaf8f"
  export BASE24_COLOR_10_HEX="0b0b0b"
  export BASE24_COLOR_11_HEX="060606"
  export BASE24_COLOR_12_HEX="fb9fb1"
  export BASE24_COLOR_13_HEX="eda987"
  export BASE24_COLOR_14_HEX="acc267"
  export BASE24_COLOR_15_HEX="12cfc0"
  export BASE24_COLOR_16_HEX="6fc2ef"
  export BASE24_COLOR_17_HEX="e1a3ee"
fi
