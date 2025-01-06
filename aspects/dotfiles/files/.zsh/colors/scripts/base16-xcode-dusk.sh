#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: XCode Dusk 
# Scheme author: Elsa Gonsiorowski (https://github.com/gonsie)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="xcode-dusk"

color00="28/2B/35" # Base 00 - Black
color01="B2/18/89" # Base 08 - Red
color02="DF/00/02" # Base 0B - Green
color03="43/82/88" # Base 0A - Yellow
color04="79/0E/AD" # Base 0D - Blue
color05="B2/18/89" # Base 0E - Magenta
color06="00/A0/BE" # Base 0C - Cyan
color07="A9/AA/AE" # Base 06 - White
color08="53/55/5D" # Base 02 - Bright Black
color09="B2/18/89" # Base 12 - Bright Red
color10="DF/00/02" # Base 14 - Bright Green
color11="43/82/88" # Base 13 - Bright Yellow
color12="79/0E/AD" # Base 16 - Bright Blue
color13="B2/18/89" # Base 17 - Bright Magenta
color14="00/A0/BE" # Base 15 - Bright Cyan
color15="BE/BF/C2" # Base 07 - Bright White
color16="78/6D/C5" # Base 09
color17="C7/7C/48" # Base 0F
color18="3D/40/48" # Base 01
color19="53/55/5D" # Base 02
color20="7E/80/86" # Base 04
color21="A9/AA/AE" # Base 06
color_foreground="93/95/99" # Base 05
color_background="28/2B/35" # Base 00


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
  put_template_custom Pg 939599 # foreground
  put_template_custom Ph 282B35 # background
  put_template_custom Pi 939599 # bold color
  put_template_custom Pj 53555D # selection color
  put_template_custom Pk 939599 # selected text color
  put_template_custom Pl 939599 # cursor
  put_template_custom Pm 282B35 # cursor text
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
  export BASE24_COLOR_00_HEX="282B35"
  export BASE24_COLOR_01_HEX="3D4048"
  export BASE24_COLOR_02_HEX="53555D"
  export BASE24_COLOR_03_HEX="686A71"
  export BASE24_COLOR_04_HEX="7E8086"
  export BASE24_COLOR_05_HEX="939599"
  export BASE24_COLOR_06_HEX="A9AAAE"
  export BASE24_COLOR_07_HEX="BEBFC2"
  export BASE24_COLOR_08_HEX="B21889"
  export BASE24_COLOR_09_HEX="786DC5"
  export BASE24_COLOR_0A_HEX="438288"
  export BASE24_COLOR_0B_HEX="DF0002"
  export BASE24_COLOR_0C_HEX="00A0BE"
  export BASE24_COLOR_0D_HEX="790EAD"
  export BASE24_COLOR_0E_HEX="B21889"
  export BASE24_COLOR_0F_HEX="C77C48"
  export BASE24_COLOR_10_HEX="282B35"
  export BASE24_COLOR_11_HEX="282B35"
  export BASE24_COLOR_12_HEX="B21889"
  export BASE24_COLOR_13_HEX="438288"
  export BASE24_COLOR_14_HEX="DF0002"
  export BASE24_COLOR_15_HEX="00A0BE"
  export BASE24_COLOR_16_HEX="790EAD"
  export BASE24_COLOR_17_HEX="B21889"
fi
