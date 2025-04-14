#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Ollie 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="ollie"

color00="21/20/24" # Base 00 - Black
color01="ab/2e/30" # Base 08 - Red
color02="31/ab/60" # Base 0B - Green
color03="44/87/ff" # Base 0A - Yellow
color04="2c/56/ab" # Base 0D - Blue
color05="af/84/27" # Base 0E - Magenta
color06="1f/a5/ab" # Base 0C - Cyan
color07="8a/8d/ab" # Base 06 - White
color08="5a/36/25" # Base 02 - Bright Black
color09="ff/3d/48" # Base 12 - Bright Red
color10="3b/ff/99" # Base 14 - Bright Green
color11="ff/5e/1e" # Base 13 - Bright Yellow
color12="44/87/ff" # Base 16 - Bright Blue
color13="ff/c2/1c" # Base 17 - Bright Magenta
color14="1e/fa/ff" # Base 15 - Bright Cyan
color15="5b/6d/a7" # Base 07 - Bright White
color16="ab/42/00" # Base 09
color17="55/17/18" # Base 0F
color18="00/00/00" # Base 01
color19="5a/36/25" # Base 02
color20="72/61/68" # Base 04
color21="8a/8d/ab" # Base 06
color_foreground="7e/77/89" # Base 05
color_background="21/20/24" # Base 00


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
  put_template_custom Pg 7e7789 # foreground
  put_template_custom Ph 212024 # background
  put_template_custom Pi 7e7789 # bold color
  put_template_custom Pj 5a3625 # selection color
  put_template_custom Pk 7e7789 # selected text color
  put_template_custom Pl 7e7789 # cursor
  put_template_custom Pm 212024 # cursor text
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
  export BASE24_COLOR_00_HEX="212024"
  export BASE24_COLOR_01_HEX="000000"
  export BASE24_COLOR_02_HEX="5a3625"
  export BASE24_COLOR_03_HEX="664b46"
  export BASE24_COLOR_04_HEX="726168"
  export BASE24_COLOR_05_HEX="7e7789"
  export BASE24_COLOR_06_HEX="8a8dab"
  export BASE24_COLOR_07_HEX="5b6da7"
  export BASE24_COLOR_08_HEX="ab2e30"
  export BASE24_COLOR_09_HEX="ab4200"
  export BASE24_COLOR_0A_HEX="4487ff"
  export BASE24_COLOR_0B_HEX="31ab60"
  export BASE24_COLOR_0C_HEX="1fa5ab"
  export BASE24_COLOR_0D_HEX="2c56ab"
  export BASE24_COLOR_0E_HEX="af8427"
  export BASE24_COLOR_0F_HEX="551718"
  export BASE24_COLOR_10_HEX="3c2418"
  export BASE24_COLOR_11_HEX="1e120c"
  export BASE24_COLOR_12_HEX="ff3d48"
  export BASE24_COLOR_13_HEX="ff5e1e"
  export BASE24_COLOR_14_HEX="3bff99"
  export BASE24_COLOR_15_HEX="1efaff"
  export BASE24_COLOR_16_HEX="4487ff"
  export BASE24_COLOR_17_HEX="ffc21c"
fi
