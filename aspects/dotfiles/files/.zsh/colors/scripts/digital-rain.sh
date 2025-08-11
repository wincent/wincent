#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Digital Rain
# Scheme author: Nathan Byrd (https://github.com/cognitivegears)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="digital-rain"

color00="00/00/00" # Base 00 - Black
color01="C8/5A/46" # Base 08 - Red
color02="64/C8/3C" # Base 0B - Green
color03="A6/7A/50" # Base 0A - Yellow
color04="54/82/AF" # Base 0D - Blue
color05="94/72/B4" # Base 0E - Magenta
color06="46/8C/78" # Base 0C - Cyan
color07="00/FF/00" # Base 05 - White
color08="7C/8D/7C" # Base 03 - Bright Black
color09="C8/5A/46" # Base 12 - Bright Red
color10="64/C8/3C" # Base 14 - Bright Green
color11="A6/7A/50" # Base 13 - Bright Yellow
color12="54/82/AF" # Base 16 - Bright Blue
color13="94/72/B4" # Base 17 - Bright Magenta
color14="46/8C/78" # Base 15 - Bright Cyan
color15="D8/E2/DC" # Base 07 - Bright White
color16="C8/64/28" # Base 09
color17="B3/7C/5E" # Base 0F
color18="4A/80/6C" # Base 01
color19="4A/8D/7E" # Base 02
color20="91/98/93" # Base 04
color21="C4/CE/C4" # Base 06
color_foreground="00/FF/00" # Base 05
color_background="00/00/00" # Base 00


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
  put_template_custom Pg 00FF00 # foreground
  put_template_custom Ph 000000 # background
  put_template_custom Pi 00FF00 # bold color
  put_template_custom Pj 4A8D7E # selection color
  put_template_custom Pk 00FF00 # selected text color
  put_template_custom Pl 00FF00 # cursor
  put_template_custom Pm 000000 # cursor text
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
  export BASE24_COLOR_00_HEX="000000"
  export BASE24_COLOR_01_HEX="4A806C"
  export BASE24_COLOR_02_HEX="4A8D7E"
  export BASE24_COLOR_03_HEX="7C8D7C"
  export BASE24_COLOR_04_HEX="919893"
  export BASE24_COLOR_05_HEX="00FF00"
  export BASE24_COLOR_06_HEX="C4CEC4"
  export BASE24_COLOR_07_HEX="D8E2DC"
  export BASE24_COLOR_08_HEX="C85A46"
  export BASE24_COLOR_09_HEX="C86428"
  export BASE24_COLOR_0A_HEX="A67A50"
  export BASE24_COLOR_0B_HEX="64C83C"
  export BASE24_COLOR_0C_HEX="468C78"
  export BASE24_COLOR_0D_HEX="5482AF"
  export BASE24_COLOR_0E_HEX="9472B4"
  export BASE24_COLOR_0F_HEX="B37C5E"
  export BASE24_COLOR_10_HEX="000000"
  export BASE24_COLOR_11_HEX="000000"
  export BASE24_COLOR_12_HEX="C85A46"
  export BASE24_COLOR_13_HEX="A67A50"
  export BASE24_COLOR_14_HEX="64C83C"
  export BASE24_COLOR_15_HEX="468C78"
  export BASE24_COLOR_16_HEX="5482AF"
  export BASE24_COLOR_17_HEX="9472B4"
fi
