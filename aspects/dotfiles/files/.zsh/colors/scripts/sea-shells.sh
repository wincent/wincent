#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Sea Shells 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="sea-shells"

color00="08/13/1a" # Base 00 - Black
color01="d1/50/23" # Base 08 - Red
color02="02/7c/9b" # Base 0B - Green
color03="1b/bc/dd" # Base 0A - Yellow
color04="1e/49/50" # Base 0D - Blue
color05="68/d3/f1" # Base 0E - Magenta
color06="50/a3/b5" # Base 0C - Cyan
color07="de/b8/8d" # Base 06 - White
color08="42/4b/52" # Base 02 - Bright Black
color09="d3/86/77" # Base 12 - Bright Red
color10="61/8c/98" # Base 14 - Bright Green
color11="fd/d2/9e" # Base 13 - Bright Yellow
color12="1b/bc/dd" # Base 16 - Bright Blue
color13="bb/e3/ee" # Base 17 - Bright Magenta
color14="86/ab/b3" # Base 15 - Bright Cyan
color15="fe/e3/cd" # Base 07 - Bright White
color16="fc/a0/2f" # Base 09
color17="68/28/11" # Base 0F
color18="17/38/4c" # Base 01
color19="42/4b/52" # Base 02
color20="90/81/6f" # Base 04
color21="de/b8/8d" # Base 06
color_foreground="b7/9c/7e" # Base 05
color_background="08/13/1a" # Base 00


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
  put_template_custom Pg b79c7e # foreground
  put_template_custom Ph 08131a # background
  put_template_custom Pi b79c7e # bold color
  put_template_custom Pj 424b52 # selection color
  put_template_custom Pk b79c7e # selected text color
  put_template_custom Pl b79c7e # cursor
  put_template_custom Pm 08131a # cursor text
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
  export BASE24_COLOR_00_HEX="08131a"
  export BASE24_COLOR_01_HEX="17384c"
  export BASE24_COLOR_02_HEX="424b52"
  export BASE24_COLOR_03_HEX="696660"
  export BASE24_COLOR_04_HEX="90816f"
  export BASE24_COLOR_05_HEX="b79c7e"
  export BASE24_COLOR_06_HEX="deb88d"
  export BASE24_COLOR_07_HEX="fee3cd"
  export BASE24_COLOR_08_HEX="d15023"
  export BASE24_COLOR_09_HEX="fca02f"
  export BASE24_COLOR_0A_HEX="1bbcdd"
  export BASE24_COLOR_0B_HEX="027c9b"
  export BASE24_COLOR_0C_HEX="50a3b5"
  export BASE24_COLOR_0D_HEX="1e4950"
  export BASE24_COLOR_0E_HEX="68d3f1"
  export BASE24_COLOR_0F_HEX="682811"
  export BASE24_COLOR_10_HEX="2c3236"
  export BASE24_COLOR_11_HEX="16191b"
  export BASE24_COLOR_12_HEX="d38677"
  export BASE24_COLOR_13_HEX="fdd29e"
  export BASE24_COLOR_14_HEX="618c98"
  export BASE24_COLOR_15_HEX="86abb3"
  export BASE24_COLOR_16_HEX="1bbcdd"
  export BASE24_COLOR_17_HEX="bbe3ee"
fi
