#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: emil 
# Scheme author: limelier
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="emil"

color00="ef/ef/ef" # Base 00 - Black
color01="f4/39/79" # Base 08 - Red
color02="00/73/a8" # Base 0B - Green
color03="ff/66/9b" # Base 0A - Yellow
color04="47/13/97" # Base 0D - Blue
color05="69/16/b6" # Base 0E - Magenta
color06="21/55/d6" # Base 0C - Cyan
color07="22/22/3a" # Base 06 - White
color08="9e/9e/af" # Base 02 - Bright Black
color09="f4/39/79" # Base 12 - Bright Red
color10="00/73/a8" # Base 14 - Bright Green
color11="ff/66/9b" # Base 13 - Bright Yellow
color12="47/13/97" # Base 16 - Bright Blue
color13="69/16/b6" # Base 17 - Bright Magenta
color14="21/55/d6" # Base 15 - Bright Cyan
color15="1a/1a/2f" # Base 07 - Bright White
color16="d2/2a/8b" # Base 09
color17="8d/17/a5" # Base 0F
color18="be/be/d2" # Base 01
color19="9e/9e/af" # Base 02
color20="50/50/63" # Base 04
color21="22/22/3a" # Base 06
color_foreground="31/31/45" # Base 05
color_background="ef/ef/ef" # Base 00


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
  put_template_custom Pg 313145 # foreground
  put_template_custom Ph efefef # background
  put_template_custom Pi 313145 # bold color
  put_template_custom Pj 9e9eaf # selection color
  put_template_custom Pk 313145 # selected text color
  put_template_custom Pl 313145 # cursor
  put_template_custom Pm efefef # cursor text
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
  export BASE24_COLOR_00_HEX="efefef"
  export BASE24_COLOR_01_HEX="bebed2"
  export BASE24_COLOR_02_HEX="9e9eaf"
  export BASE24_COLOR_03_HEX="7c7c98"
  export BASE24_COLOR_04_HEX="505063"
  export BASE24_COLOR_05_HEX="313145"
  export BASE24_COLOR_06_HEX="22223a"
  export BASE24_COLOR_07_HEX="1a1a2f"
  export BASE24_COLOR_08_HEX="f43979"
  export BASE24_COLOR_09_HEX="d22a8b"
  export BASE24_COLOR_0A_HEX="ff669b"
  export BASE24_COLOR_0B_HEX="0073a8"
  export BASE24_COLOR_0C_HEX="2155d6"
  export BASE24_COLOR_0D_HEX="471397"
  export BASE24_COLOR_0E_HEX="6916b6"
  export BASE24_COLOR_0F_HEX="8d17a5"
  export BASE24_COLOR_10_HEX="efefef"
  export BASE24_COLOR_11_HEX="efefef"
  export BASE24_COLOR_12_HEX="f43979"
  export BASE24_COLOR_13_HEX="ff669b"
  export BASE24_COLOR_14_HEX="0073a8"
  export BASE24_COLOR_15_HEX="2155d6"
  export BASE24_COLOR_16_HEX="471397"
  export BASE24_COLOR_17_HEX="6916b6"
fi
