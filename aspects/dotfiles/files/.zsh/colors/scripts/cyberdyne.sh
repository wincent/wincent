#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Cyberdyne 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="cyberdyne"

color00="15/11/44" # Base 00 - Black
color01="ff/82/72" # Base 08 - Red
color02="00/c1/72" # Base 0B - Green
color03="c1/e3/fe" # Base 0A - Yellow
color04="00/71/cf" # Base 0D - Blue
color05="ff/8f/fd" # Base 0E - Magenta
color06="6b/ff/dc" # Base 0C - Cyan
color07="f1/f1/f1" # Base 06 - White
color08="2d/2d/2d" # Base 02 - Bright Black
color09="ff/c4/bd" # Base 12 - Bright Red
color10="d6/fc/b9" # Base 14 - Bright Green
color11="fe/fd/d5" # Base 13 - Bright Yellow
color12="c1/e3/fe" # Base 16 - Bright Blue
color13="ff/b1/fe" # Base 17 - Bright Magenta
color14="e5/e6/fe" # Base 15 - Bright Cyan
color15="fe/ff/ff" # Base 07 - Bright White
color16="d2/a7/00" # Base 09
color17="7f/41/39" # Base 0F
color18="08/08/08" # Base 01
color19="2d/2d/2d" # Base 02
color20="8f/8f/8f" # Base 04
color21="f1/f1/f1" # Base 06
color_foreground="c0/c0/c0" # Base 05
color_background="15/11/44" # Base 00


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
  put_template_custom Pg c0c0c0 # foreground
  put_template_custom Ph 151144 # background
  put_template_custom Pi c0c0c0 # bold color
  put_template_custom Pj 2d2d2d # selection color
  put_template_custom Pk c0c0c0 # selected text color
  put_template_custom Pl c0c0c0 # cursor
  put_template_custom Pm 151144 # cursor text
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
  export BASE24_COLOR_00_HEX="151144"
  export BASE24_COLOR_01_HEX="080808"
  export BASE24_COLOR_02_HEX="2d2d2d"
  export BASE24_COLOR_03_HEX="5e5e5e"
  export BASE24_COLOR_04_HEX="8f8f8f"
  export BASE24_COLOR_05_HEX="c0c0c0"
  export BASE24_COLOR_06_HEX="f1f1f1"
  export BASE24_COLOR_07_HEX="feffff"
  export BASE24_COLOR_08_HEX="ff8272"
  export BASE24_COLOR_09_HEX="d2a700"
  export BASE24_COLOR_0A_HEX="c1e3fe"
  export BASE24_COLOR_0B_HEX="00c172"
  export BASE24_COLOR_0C_HEX="6bffdc"
  export BASE24_COLOR_0D_HEX="0071cf"
  export BASE24_COLOR_0E_HEX="ff8ffd"
  export BASE24_COLOR_0F_HEX="7f4139"
  export BASE24_COLOR_10_HEX="1e1e1e"
  export BASE24_COLOR_11_HEX="0f0f0f"
  export BASE24_COLOR_12_HEX="ffc4bd"
  export BASE24_COLOR_13_HEX="fefdd5"
  export BASE24_COLOR_14_HEX="d6fcb9"
  export BASE24_COLOR_15_HEX="e5e6fe"
  export BASE24_COLOR_16_HEX="c1e3fe"
  export BASE24_COLOR_17_HEX="ffb1fe"
fi
