#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Seafoam Pastel
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="seafoam-pastel"

color00="24/34/34" # Base 00 - Black
color01="82/5d/4d" # Base 08 - Red
color02="71/8c/61" # Base 0B - Green
color03="79/c3/cf" # Base 0A - Yellow
color04="4d/7b/82" # Base 0D - Blue
color05="8a/71/67" # Base 0E - Magenta
color06="71/93/93" # Base 0C - Cyan
color07="ca/ca/ca" # Base 05 - White
color08="9f/9f/9f" # Base 03 - Bright Black
color09="cf/93/79" # Base 12 - Bright Red
color10="98/d9/aa" # Base 14 - Bright Green
color11="fa/e7/9d" # Base 13 - Bright Yellow
color12="79/c3/cf" # Base 16 - Bright Blue
color13="d6/b2/a1" # Base 17 - Bright Magenta
color14="ad/e0/e0" # Base 15 - Bright Cyan
color15="e0/e0/e0" # Base 07 - Bright White
color16="ad/a1/6d" # Base 09
color17="41/2e/26" # Base 0F
color18="75/75/75" # Base 01
color19="8a/8a/8a" # Base 02
color20="b5/b5/b5" # Base 04
color21="e0/e0/e0" # Base 06
color_foreground="ca/ca/ca" # Base 05
color_background="24/34/34" # Base 00


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

# foreground / background / cursor color
if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  put_template_custom Pg cacaca # foreground
  put_template_custom Ph 243434 # background
  put_template_custom Pi cacaca # bold color
  put_template_custom Pj 8a8a8a # selection color
  put_template_custom Pk cacaca # selected text color
  put_template_custom Pl cacaca # cursor
  put_template_custom Pm 243434 # cursor text
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
  export BASE24_COLOR_00_HEX="243434"
  export BASE24_COLOR_01_HEX="757575"
  export BASE24_COLOR_02_HEX="8a8a8a"
  export BASE24_COLOR_03_HEX="9f9f9f"
  export BASE24_COLOR_04_HEX="b5b5b5"
  export BASE24_COLOR_05_HEX="cacaca"
  export BASE24_COLOR_06_HEX="e0e0e0"
  export BASE24_COLOR_07_HEX="e0e0e0"
  export BASE24_COLOR_08_HEX="825d4d"
  export BASE24_COLOR_09_HEX="ada16d"
  export BASE24_COLOR_0A_HEX="79c3cf"
  export BASE24_COLOR_0B_HEX="718c61"
  export BASE24_COLOR_0C_HEX="719393"
  export BASE24_COLOR_0D_HEX="4d7b82"
  export BASE24_COLOR_0E_HEX="8a7167"
  export BASE24_COLOR_0F_HEX="412e26"
  export BASE24_COLOR_10_HEX="5c5c5c"
  export BASE24_COLOR_11_HEX="2e2e2e"
  export BASE24_COLOR_12_HEX="cf9379"
  export BASE24_COLOR_13_HEX="fae79d"
  export BASE24_COLOR_14_HEX="98d9aa"
  export BASE24_COLOR_15_HEX="ade0e0"
  export BASE24_COLOR_16_HEX="79c3cf"
  export BASE24_COLOR_17_HEX="d6b2a1"
fi
