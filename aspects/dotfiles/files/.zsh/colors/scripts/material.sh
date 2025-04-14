#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Material 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="material"

color00="ea/ea/ea" # Base 00 - Black
color01="b7/14/1e" # Base 08 - Red
color02="45/7b/23" # Base 0B - Green
color03="53/a4/f3" # Base 0A - Yellow
color04="13/4e/b2" # Base 0D - Blue
color05="55/00/87" # Base 0E - Magenta
color06="0e/70/7c" # Base 0C - Cyan
color07="ee/ee/ee" # Base 06 - White
color08="42/42/42" # Base 02 - Bright Black
color09="e8/3a/3f" # Base 12 - Bright Red
color10="7a/ba/39" # Base 14 - Bright Green
color11="fe/e9/2e" # Base 13 - Bright Yellow
color12="53/a4/f3" # Base 16 - Bright Blue
color13="a9/4d/bb" # Base 17 - Bright Magenta
color14="26/ba/d1" # Base 15 - Bright Cyan
color15="d8/d8/d8" # Base 07 - Bright White
color16="f5/97/1d" # Base 09
color17="5b/0a/0f" # Base 0F
color18="21/21/21" # Base 01
color19="42/42/42" # Base 02
color20="98/98/98" # Base 04
color21="ee/ee/ee" # Base 06
color_foreground="c3/c3/c3" # Base 05
color_background="ea/ea/ea" # Base 00


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
  put_template_custom Pg c3c3c3 # foreground
  put_template_custom Ph eaeaea # background
  put_template_custom Pi c3c3c3 # bold color
  put_template_custom Pj 424242 # selection color
  put_template_custom Pk c3c3c3 # selected text color
  put_template_custom Pl c3c3c3 # cursor
  put_template_custom Pm eaeaea # cursor text
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
  export BASE24_COLOR_00_HEX="eaeaea"
  export BASE24_COLOR_01_HEX="212121"
  export BASE24_COLOR_02_HEX="424242"
  export BASE24_COLOR_03_HEX="6d6d6d"
  export BASE24_COLOR_04_HEX="989898"
  export BASE24_COLOR_05_HEX="c3c3c3"
  export BASE24_COLOR_06_HEX="eeeeee"
  export BASE24_COLOR_07_HEX="d8d8d8"
  export BASE24_COLOR_08_HEX="b7141e"
  export BASE24_COLOR_09_HEX="f5971d"
  export BASE24_COLOR_0A_HEX="53a4f3"
  export BASE24_COLOR_0B_HEX="457b23"
  export BASE24_COLOR_0C_HEX="0e707c"
  export BASE24_COLOR_0D_HEX="134eb2"
  export BASE24_COLOR_0E_HEX="550087"
  export BASE24_COLOR_0F_HEX="5b0a0f"
  export BASE24_COLOR_10_HEX="2c2c2c"
  export BASE24_COLOR_11_HEX="161616"
  export BASE24_COLOR_12_HEX="e83a3f"
  export BASE24_COLOR_13_HEX="fee92e"
  export BASE24_COLOR_14_HEX="7aba39"
  export BASE24_COLOR_15_HEX="26bad1"
  export BASE24_COLOR_16_HEX="53a4f3"
  export BASE24_COLOR_17_HEX="a94dbb"
fi
