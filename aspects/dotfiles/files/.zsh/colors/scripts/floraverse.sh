#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Floraverse 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="floraverse"

color00="0e/0c/15" # Base 00 - Black
color01="64/00/2c" # Base 08 - Red
color02="5d/73/1a" # Base 0B - Green
color03="40/a4/cf" # Base 0A - Yellow
color04="1d/6d/a1" # Base 0D - Blue
color05="b7/07/7e" # Base 0E - Magenta
color06="42/a3/8c" # Base 0C - Cyan
color07="f3/e0/b8" # Base 06 - White
color08="33/1e/4d" # Base 02 - Bright Black
color09="d0/20/63" # Base 12 - Bright Red
color10="b4/ce/59" # Base 14 - Bright Green
color11="fa/c3/57" # Base 13 - Bright Yellow
color12="40/a4/cf" # Base 16 - Bright Blue
color13="f1/2a/ae" # Base 17 - Bright Magenta
color14="62/ca/a8" # Base 15 - Bright Cyan
color15="ff/f5/db" # Base 07 - Bright White
color16="cd/75/1c" # Base 09
color17="32/00/16" # Base 0F
color18="08/00/2e" # Base 01
color19="33/1e/4d" # Base 02
color20="93/7f/82" # Base 04
color21="f3/e0/b8" # Base 06
color_foreground="c3/af/9d" # Base 05
color_background="0e/0c/15" # Base 00


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
  put_template_custom Pg c3af9d # foreground
  put_template_custom Ph 0e0c15 # background
  put_template_custom Pi c3af9d # bold color
  put_template_custom Pj 331e4d # selection color
  put_template_custom Pk c3af9d # selected text color
  put_template_custom Pl c3af9d # cursor
  put_template_custom Pm 0e0c15 # cursor text
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
  export BASE24_COLOR_00_HEX="0e0c15"
  export BASE24_COLOR_01_HEX="08002e"
  export BASE24_COLOR_02_HEX="331e4d"
  export BASE24_COLOR_03_HEX="634e67"
  export BASE24_COLOR_04_HEX="937f82"
  export BASE24_COLOR_05_HEX="c3af9d"
  export BASE24_COLOR_06_HEX="f3e0b8"
  export BASE24_COLOR_07_HEX="fff5db"
  export BASE24_COLOR_08_HEX="64002c"
  export BASE24_COLOR_09_HEX="cd751c"
  export BASE24_COLOR_0A_HEX="40a4cf"
  export BASE24_COLOR_0B_HEX="5d731a"
  export BASE24_COLOR_0C_HEX="42a38c"
  export BASE24_COLOR_0D_HEX="1d6da1"
  export BASE24_COLOR_0E_HEX="b7077e"
  export BASE24_COLOR_0F_HEX="320016"
  export BASE24_COLOR_10_HEX="221433"
  export BASE24_COLOR_11_HEX="110a19"
  export BASE24_COLOR_12_HEX="d02063"
  export BASE24_COLOR_13_HEX="fac357"
  export BASE24_COLOR_14_HEX="b4ce59"
  export BASE24_COLOR_15_HEX="62caa8"
  export BASE24_COLOR_16_HEX="40a4cf"
  export BASE24_COLOR_17_HEX="f12aae"
fi
