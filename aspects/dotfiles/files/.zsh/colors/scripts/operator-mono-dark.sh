#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Operator Mono Dark 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="operator-mono-dark"

color00="19/19/19" # Base 00 - Black
color01="ca/37/2d" # Base 08 - Red
color02="4d/7b/3a" # Base 0B - Green
color03="89/d3/f6" # Base 0A - Yellow
color04="43/87/cf" # Base 0D - Blue
color05="b8/6c/b4" # Base 0E - Magenta
color06="72/d4/c6" # Base 0C - Cyan
color07="cd/d3/cd" # Base 06 - White
color08="9a/9a/99" # Base 02 - Bright Black
color09="c3/7d/62" # Base 12 - Bright Red
color10="83/d0/a2" # Base 14 - Bright Green
color11="fd/fd/c5" # Base 13 - Bright Yellow
color12="89/d3/f6" # Base 16 - Bright Blue
color13="fe/2c/79" # Base 17 - Bright Magenta
color14="82/e9/da" # Base 15 - Bright Cyan
color15="fd/fd/f6" # Base 07 - Bright White
color16="d4/d6/97" # Base 09
color17="65/1b/16" # Base 0F
color18="5a/5a/5a" # Base 01
color19="9a/9a/99" # Base 02
color20="b3/b6/b3" # Base 04
color21="cd/d3/cd" # Base 06
color_foreground="c0/c4/c0" # Base 05
color_background="19/19/19" # Base 00


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
  put_template_custom Pg c0c4c0 # foreground
  put_template_custom Ph 191919 # background
  put_template_custom Pi c0c4c0 # bold color
  put_template_custom Pj 9a9a99 # selection color
  put_template_custom Pk c0c4c0 # selected text color
  put_template_custom Pl c0c4c0 # cursor
  put_template_custom Pm 191919 # cursor text
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
  export BASE24_COLOR_00_HEX="191919"
  export BASE24_COLOR_01_HEX="5a5a5a"
  export BASE24_COLOR_02_HEX="9a9a99"
  export BASE24_COLOR_03_HEX="a6a8a6"
  export BASE24_COLOR_04_HEX="b3b6b3"
  export BASE24_COLOR_05_HEX="c0c4c0"
  export BASE24_COLOR_06_HEX="cdd3cd"
  export BASE24_COLOR_07_HEX="fdfdf6"
  export BASE24_COLOR_08_HEX="ca372d"
  export BASE24_COLOR_09_HEX="d4d697"
  export BASE24_COLOR_0A_HEX="89d3f6"
  export BASE24_COLOR_0B_HEX="4d7b3a"
  export BASE24_COLOR_0C_HEX="72d4c6"
  export BASE24_COLOR_0D_HEX="4387cf"
  export BASE24_COLOR_0E_HEX="b86cb4"
  export BASE24_COLOR_0F_HEX="651b16"
  export BASE24_COLOR_10_HEX="666666"
  export BASE24_COLOR_11_HEX="333333"
  export BASE24_COLOR_12_HEX="c37d62"
  export BASE24_COLOR_13_HEX="fdfdc5"
  export BASE24_COLOR_14_HEX="83d0a2"
  export BASE24_COLOR_15_HEX="82e9da"
  export BASE24_COLOR_16_HEX="89d3f6"
  export BASE24_COLOR_17_HEX="fe2c79"
fi
