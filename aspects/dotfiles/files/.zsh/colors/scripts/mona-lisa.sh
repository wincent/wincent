#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Mona Lisa 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="mona-lisa"

color00="11/0b/0d" # Base 00 - Black
color01="9b/28/1b" # Base 08 - Red
color02="62/61/32" # Base 0B - Green
color03="9e/b2/b3" # Base 0A - Yellow
color04="51/5b/5c" # Base 0D - Blue
color05="9b/1d/29" # Base 0E - Magenta
color06="58/80/56" # Base 0C - Cyan
color07="f6/d7/5c" # Base 06 - White
color08="87/42/27" # Base 02 - Bright Black
color09="ff/42/30" # Base 12 - Bright Red
color10="b3/b1/63" # Base 14 - Bright Green
color11="ff/95/65" # Base 13 - Bright Yellow
color12="9e/b2/b3" # Base 16 - Bright Blue
color13="ff/5b/6a" # Base 17 - Bright Magenta
color14="89/cc/8e" # Base 15 - Bright Cyan
color15="ff/e5/97" # Base 07 - Bright White
color16="c2/6e/27" # Base 09
color17="4d/14/0d" # Base 0F
color18="34/1a/0d" # Base 01
color19="87/42/27" # Base 02
color20="be/8c/41" # Base 04
color21="f6/d7/5c" # Base 06
color_foreground="da/b1/4e" # Base 05
color_background="11/0b/0d" # Base 00


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
  put_template_custom Pg dab14e # foreground
  put_template_custom Ph 110b0d # background
  put_template_custom Pi dab14e # bold color
  put_template_custom Pj 874227 # selection color
  put_template_custom Pk dab14e # selected text color
  put_template_custom Pl dab14e # cursor
  put_template_custom Pm 110b0d # cursor text
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
  export BASE24_COLOR_00_HEX="110b0d"
  export BASE24_COLOR_01_HEX="341a0d"
  export BASE24_COLOR_02_HEX="874227"
  export BASE24_COLOR_03_HEX="a26734"
  export BASE24_COLOR_04_HEX="be8c41"
  export BASE24_COLOR_05_HEX="dab14e"
  export BASE24_COLOR_06_HEX="f6d75c"
  export BASE24_COLOR_07_HEX="ffe597"
  export BASE24_COLOR_08_HEX="9b281b"
  export BASE24_COLOR_09_HEX="c26e27"
  export BASE24_COLOR_0A_HEX="9eb2b3"
  export BASE24_COLOR_0B_HEX="626132"
  export BASE24_COLOR_0C_HEX="588056"
  export BASE24_COLOR_0D_HEX="515b5c"
  export BASE24_COLOR_0E_HEX="9b1d29"
  export BASE24_COLOR_0F_HEX="4d140d"
  export BASE24_COLOR_10_HEX="5a2c1a"
  export BASE24_COLOR_11_HEX="2d160d"
  export BASE24_COLOR_12_HEX="ff4230"
  export BASE24_COLOR_13_HEX="ff9565"
  export BASE24_COLOR_14_HEX="b3b163"
  export BASE24_COLOR_15_HEX="89cc8e"
  export BASE24_COLOR_16_HEX="9eb2b3"
  export BASE24_COLOR_17_HEX="ff5b6a"
fi
