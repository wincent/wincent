#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Builtin Solarized Light 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="builtin-solarized-light"

color00="fd/f6/e3" # Base 00 - Black
color01="dc/32/2f" # Base 08 - Red
color02="85/99/00" # Base 0B - Green
color03="83/94/96" # Base 0A - Yellow
color04="26/8b/d2" # Base 0D - Blue
color05="d3/36/82" # Base 0E - Magenta
color06="2a/a1/98" # Base 0C - Cyan
color07="ee/e8/d5" # Base 06 - White
color08="00/2b/36" # Base 02 - Bright Black
color09="cb/4b/16" # Base 12 - Bright Red
color10="58/6e/75" # Base 14 - Bright Green
color11="65/7b/83" # Base 13 - Bright Yellow
color12="83/94/96" # Base 16 - Bright Blue
color13="6c/71/c4" # Base 17 - Bright Magenta
color14="93/a1/a1" # Base 15 - Bright Cyan
color15="fd/f6/e3" # Base 07 - Bright White
color16="b5/89/00" # Base 09
color17="6e/19/17" # Base 0F
color18="07/36/42" # Base 01
color19="00/2b/36" # Base 02
color20="77/89/85" # Base 04
color21="ee/e8/d5" # Base 06
color_foreground="b2/b8/ad" # Base 05
color_background="fd/f6/e3" # Base 00


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
  put_template_custom Pg b2b8ad # foreground
  put_template_custom Ph fdf6e3 # background
  put_template_custom Pi b2b8ad # bold color
  put_template_custom Pj 002b36 # selection color
  put_template_custom Pk b2b8ad # selected text color
  put_template_custom Pl b2b8ad # cursor
  put_template_custom Pm fdf6e3 # cursor text
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
  export BASE24_COLOR_00_HEX="fdf6e3"
  export BASE24_COLOR_01_HEX="073642"
  export BASE24_COLOR_02_HEX="002b36"
  export BASE24_COLOR_03_HEX="3b5a5d"
  export BASE24_COLOR_04_HEX="778985"
  export BASE24_COLOR_05_HEX="b2b8ad"
  export BASE24_COLOR_06_HEX="eee8d5"
  export BASE24_COLOR_07_HEX="fdf6e3"
  export BASE24_COLOR_08_HEX="dc322f"
  export BASE24_COLOR_09_HEX="b58900"
  export BASE24_COLOR_0A_HEX="839496"
  export BASE24_COLOR_0B_HEX="859900"
  export BASE24_COLOR_0C_HEX="2aa198"
  export BASE24_COLOR_0D_HEX="268bd2"
  export BASE24_COLOR_0E_HEX="d33682"
  export BASE24_COLOR_0F_HEX="6e1917"
  export BASE24_COLOR_10_HEX="001c24"
  export BASE24_COLOR_11_HEX="000e12"
  export BASE24_COLOR_12_HEX="cb4b16"
  export BASE24_COLOR_13_HEX="657b83"
  export BASE24_COLOR_14_HEX="586e75"
  export BASE24_COLOR_15_HEX="93a1a1"
  export BASE24_COLOR_16_HEX="839496"
  export BASE24_COLOR_17_HEX="6c71c4"
fi
