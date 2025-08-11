#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Stella
# Scheme author: Shrimpram
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="stella"

color00="2B/21/3C" # Base 00 - Black
color01="C7/99/87" # Base 08 - Red
color02="AC/C7/9B" # Base 0B - Green
color03="C7/C6/91" # Base 0A - Yellow
color04="A5/AA/D4" # Base 0D - Blue
color05="C5/94/FF" # Base 0E - Magenta
color06="9B/C7/BF" # Base 0C - Cyan
color07="99/8B/AD" # Base 05 - White
color08="65/59/78" # Base 03 - Bright Black
color09="C7/99/87" # Base 12 - Bright Red
color10="AC/C7/9B" # Base 14 - Bright Green
color11="C7/C6/91" # Base 13 - Bright Yellow
color12="A5/AA/D4" # Base 16 - Bright Blue
color13="C5/94/FF" # Base 17 - Bright Magenta
color14="9B/C7/BF" # Base 15 - Bright Cyan
color15="EB/DC/FF" # Base 07 - Bright White
color16="88/65/C6" # Base 09
color17="C7/AB/87" # Base 0F
color18="36/2B/48" # Base 01
color19="4D/41/60" # Base 02
color20="7F/71/92" # Base 04
color21="B4/A5/C8" # Base 06
color_foreground="99/8B/AD" # Base 05
color_background="2B/21/3C" # Base 00


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
  put_template_custom Pg 998BAD # foreground
  put_template_custom Ph 2B213C # background
  put_template_custom Pi 998BAD # bold color
  put_template_custom Pj 4D4160 # selection color
  put_template_custom Pk 998BAD # selected text color
  put_template_custom Pl 998BAD # cursor
  put_template_custom Pm 2B213C # cursor text
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
  export BASE24_COLOR_00_HEX="2B213C"
  export BASE24_COLOR_01_HEX="362B48"
  export BASE24_COLOR_02_HEX="4D4160"
  export BASE24_COLOR_03_HEX="655978"
  export BASE24_COLOR_04_HEX="7F7192"
  export BASE24_COLOR_05_HEX="998BAD"
  export BASE24_COLOR_06_HEX="B4A5C8"
  export BASE24_COLOR_07_HEX="EBDCFF"
  export BASE24_COLOR_08_HEX="C79987"
  export BASE24_COLOR_09_HEX="8865C6"
  export BASE24_COLOR_0A_HEX="C7C691"
  export BASE24_COLOR_0B_HEX="ACC79B"
  export BASE24_COLOR_0C_HEX="9BC7BF"
  export BASE24_COLOR_0D_HEX="A5AAD4"
  export BASE24_COLOR_0E_HEX="C594FF"
  export BASE24_COLOR_0F_HEX="C7AB87"
  export BASE24_COLOR_10_HEX="2B213C"
  export BASE24_COLOR_11_HEX="2B213C"
  export BASE24_COLOR_12_HEX="C79987"
  export BASE24_COLOR_13_HEX="C7C691"
  export BASE24_COLOR_14_HEX="ACC79B"
  export BASE24_COLOR_15_HEX="9BC7BF"
  export BASE24_COLOR_16_HEX="A5AAD4"
  export BASE24_COLOR_17_HEX="C594FF"
fi
