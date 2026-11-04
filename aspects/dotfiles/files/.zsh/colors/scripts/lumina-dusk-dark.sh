#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Lumina Dusk Dark
# Scheme author: Razik Ikhlef (https://github.com/RazikSF)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="lumina-dusk-dark"

color00="1a/18/25" # Base 00 - Black
color01="d0/74/6c" # Base 08 - Red
color02="a0/d1/a9" # Base 0B - Green
color03="ef/cb/7b" # Base 0A - Yellow
color04="9b/be/f2" # Base 0D - Blue
color05="c1/bb/f0" # Base 0E - Magenta
color06="90/cf/d7" # Base 0C - Cyan
color07="e0/dc/ea" # Base 05 - White
color08="32/30/40" # Base 03 - Bright Black
color09="de/95/8d" # Base 12 - Bright Red
color10="b9/ec/c2" # Base 14 - Bright Green
color11="ff/e5/ad" # Base 13 - Bright Yellow
color12="bd/d8/ff" # Base 16 - Bright Blue
color13="fc/c9/f7" # Base 17 - Bright Magenta
color14="a9/e9/f2" # Base 15 - Bright Cyan
color15="e0/dc/ea" # Base 07 - Bright White
color16="f5/b2/84" # Base 09
color17="e1/b0/dc" # Base 0F
color18="1f/1c/2b" # Base 01
color19="28/26/35" # Base 02
color20="6d/69/7d" # Base 04
color21="b1/af/bc" # Base 06
color_foreground="e0/dc/ea" # Base 05
color_background="1a/18/25" # Base 00


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
  put_template_custom Pg e0dcea # foreground
  put_template_custom Ph 1a1825 # background
  put_template_custom Pi e0dcea # bold color
  put_template_custom Pj 282635 # selection color
  put_template_custom Pk e0dcea # selected text color
  put_template_custom Pl e0dcea # cursor
  put_template_custom Pm 1a1825 # cursor text
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
  export BASE24_COLOR_00_HEX="1a1825"
  export BASE24_COLOR_01_HEX="1f1c2b"
  export BASE24_COLOR_02_HEX="282635"
  export BASE24_COLOR_03_HEX="323040"
  export BASE24_COLOR_04_HEX="6d697d"
  export BASE24_COLOR_05_HEX="e0dcea"
  export BASE24_COLOR_06_HEX="b1afbc"
  export BASE24_COLOR_07_HEX="e0dcea"
  export BASE24_COLOR_08_HEX="d0746c"
  export BASE24_COLOR_09_HEX="f5b284"
  export BASE24_COLOR_0A_HEX="efcb7b"
  export BASE24_COLOR_0B_HEX="a0d1a9"
  export BASE24_COLOR_0C_HEX="90cfd7"
  export BASE24_COLOR_0D_HEX="9bbef2"
  export BASE24_COLOR_0E_HEX="c1bbf0"
  export BASE24_COLOR_0F_HEX="e1b0dc"
  export BASE24_COLOR_10_HEX="0f0d18"
  export BASE24_COLOR_11_HEX="13111e"
  export BASE24_COLOR_12_HEX="de958d"
  export BASE24_COLOR_13_HEX="ffe5ad"
  export BASE24_COLOR_14_HEX="b9ecc2"
  export BASE24_COLOR_15_HEX="a9e9f2"
  export BASE24_COLOR_16_HEX="bdd8ff"
  export BASE24_COLOR_17_HEX="fcc9f7"
fi
