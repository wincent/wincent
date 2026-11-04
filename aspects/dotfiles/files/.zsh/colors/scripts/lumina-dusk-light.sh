#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Lumina Dusk Light
# Scheme author: Razik Ikhlef (https://github.com/RazikSF)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="lumina-dusk-light"

color00="f6/f3/fe" # Base 00 - Black
color01="87/24/23" # Base 08 - Red
color02="35/75/45" # Base 0B - Green
color03="9e/61/1b" # Base 0A - Yellow
color04="31/63/ad" # Base 0D - Blue
color05="7b/46/a4" # Base 0E - Magenta
color06="00/71/85" # Base 0C - Cyan
color07="2e/29/45" # Base 05 - White
color08="d4/d0/de" # Base 03 - Bright Black
color09="62/23/20" # Base 12 - Bright Red
color10="21/60/33" # Base 14 - Bright Green
color11="85/4e/07" # Base 13 - Bright Yellow
color12="2b/50/88" # Base 16 - Bright Blue
color13="71/3a/6c" # Base 17 - Bright Magenta
color14="00/5b/6c" # Base 15 - Bright Cyan
color15="2e/29/45" # Base 07 - Bright White
color16="8c/49/1d" # Base 09
color17="87/4d/82" # Base 0F
color18="f0/ec/fa" # Base 01
color19="e4/e0/ef" # Base 02
color20="87/84/91" # Base 04
color21="49/45/52" # Base 06
color_foreground="2e/29/45" # Base 05
color_background="f6/f3/fe" # Base 00


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

# 256 color space
put_template 16 "$color16"
put_template 17 "$color17"
put_template 18 "$color18"
put_template 19 "$color19"
put_template 20 "$color20"
put_template 21 "$color21"

# foreground / background / cursor color
if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  put_template_custom Pg 2e2945 # foreground
  put_template_custom Ph f6f3fe # background
  put_template_custom Pi 2e2945 # bold color
  put_template_custom Pj e4e0ef # selection color
  put_template_custom Pk 2e2945 # selected text color
  put_template_custom Pl 2e2945 # cursor
  put_template_custom Pm f6f3fe # cursor text
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
unset color15
unset color16
unset color17
unset color18
unset color19
unset color20
unset color21
unset color_foreground
unset color_background

# Optionally export variables
if [ -n "$TINTED_SHELL_ENABLE_BASE24_VARS" ]; then
  export BASE24_COLOR_00_HEX="f6f3fe"
  export BASE24_COLOR_01_HEX="f0ecfa"
  export BASE24_COLOR_02_HEX="e4e0ef"
  export BASE24_COLOR_03_HEX="d4d0de"
  export BASE24_COLOR_04_HEX="878491"
  export BASE24_COLOR_05_HEX="2e2945"
  export BASE24_COLOR_06_HEX="494552"
  export BASE24_COLOR_07_HEX="2e2945"
  export BASE24_COLOR_08_HEX="872423"
  export BASE24_COLOR_09_HEX="8c491d"
  export BASE24_COLOR_0A_HEX="9e611b"
  export BASE24_COLOR_0B_HEX="357545"
  export BASE24_COLOR_0C_HEX="007185"
  export BASE24_COLOR_0D_HEX="3163ad"
  export BASE24_COLOR_0E_HEX="7b46a4"
  export BASE24_COLOR_0F_HEX="874d82"
  export BASE24_COLOR_10_HEX="fefcff"
  export BASE24_COLOR_11_HEX="efecf7"
  export BASE24_COLOR_12_HEX="622320"
  export BASE24_COLOR_13_HEX="854e07"
  export BASE24_COLOR_14_HEX="216033"
  export BASE24_COLOR_15_HEX="005b6c"
  export BASE24_COLOR_16_HEX="2b5088"
  export BASE24_COLOR_17_HEX="713a6c"
fi
