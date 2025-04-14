#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Builtin Tango Light 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="builtin-tango-light"

color00="ff/ff/ff" # Base 00 - Black
color01="cc/00/00" # Base 08 - Red
color02="4e/9a/05" # Base 0B - Green
color03="71/9e/cf" # Base 0A - Yellow
color04="34/64/a4" # Base 0D - Blue
color05="74/50/7a" # Base 0E - Magenta
color06="05/98/9a" # Base 0C - Cyan
color07="d3/d7/cf" # Base 06 - White
color08="54/57/53" # Base 02 - Bright Black
color09="ef/28/28" # Base 12 - Bright Red
color10="8a/e2/34" # Base 14 - Bright Green
color11="fc/e9/4e" # Base 13 - Bright Yellow
color12="71/9e/cf" # Base 16 - Bright Blue
color13="ad/7e/a7" # Base 17 - Bright Magenta
color14="34/e2/e2" # Base 15 - Bright Cyan
color15="ed/ed/ec" # Base 07 - Bright White
color16="c4/a0/00" # Base 09
color17="66/00/00" # Base 0F
color18="00/00/00" # Base 01
color19="54/57/53" # Base 02
color20="93/97/91" # Base 04
color21="d3/d7/cf" # Base 06
color_foreground="b3/b7/b0" # Base 05
color_background="ff/ff/ff" # Base 00


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
  put_template_custom Pg b3b7b0 # foreground
  put_template_custom Ph ffffff # background
  put_template_custom Pi b3b7b0 # bold color
  put_template_custom Pj 545753 # selection color
  put_template_custom Pk b3b7b0 # selected text color
  put_template_custom Pl b3b7b0 # cursor
  put_template_custom Pm ffffff # cursor text
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
  export BASE24_COLOR_00_HEX="ffffff"
  export BASE24_COLOR_01_HEX="000000"
  export BASE24_COLOR_02_HEX="545753"
  export BASE24_COLOR_03_HEX="737772"
  export BASE24_COLOR_04_HEX="939791"
  export BASE24_COLOR_05_HEX="b3b7b0"
  export BASE24_COLOR_06_HEX="d3d7cf"
  export BASE24_COLOR_07_HEX="ededec"
  export BASE24_COLOR_08_HEX="cc0000"
  export BASE24_COLOR_09_HEX="c4a000"
  export BASE24_COLOR_0A_HEX="719ecf"
  export BASE24_COLOR_0B_HEX="4e9a05"
  export BASE24_COLOR_0C_HEX="05989a"
  export BASE24_COLOR_0D_HEX="3464a4"
  export BASE24_COLOR_0E_HEX="74507a"
  export BASE24_COLOR_0F_HEX="660000"
  export BASE24_COLOR_10_HEX="383a37"
  export BASE24_COLOR_11_HEX="1c1d1b"
  export BASE24_COLOR_12_HEX="ef2828"
  export BASE24_COLOR_13_HEX="fce94e"
  export BASE24_COLOR_14_HEX="8ae234"
  export BASE24_COLOR_15_HEX="34e2e2"
  export BASE24_COLOR_16_HEX="719ecf"
  export BASE24_COLOR_17_HEX="ad7ea7"
fi
