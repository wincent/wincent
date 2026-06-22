#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Mezcal
# Scheme author: Teshre
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="mezcal"

color00="13/11/0E" # Base 00 - Black
color01="DA/6E/54" # Base 08 - Red
color02="A8/B8/4A" # Base 0B - Green
color03="D9/A4/41" # Base 0A - Yellow
color04="8A/A6/C0" # Base 0D - Blue
color05="C2/8A/A8" # Base 0E - Magenta
color06="6F/C8/AE" # Base 0C - Cyan
color07="E0/D8/C8" # Base 05 - White
color08="6E/64/50" # Base 03 - Bright Black
color09="DA/6E/54" # Base 12 - Bright Red
color10="A8/B8/4A" # Base 14 - Bright Green
color11="D9/A4/41" # Base 13 - Bright Yellow
color12="8A/A6/C0" # Base 16 - Bright Blue
color13="C2/8A/A8" # Base 17 - Bright Magenta
color14="6F/C8/AE" # Base 15 - Bright Cyan
color15="F2/EA/D6" # Base 07 - Bright White
color16="D9/A4/41" # Base 09
color17="4E/46/2C" # Base 0F
color18="22/1F/14" # Base 01
color19="36/30/1E" # Base 02
color20="A7/9E/8C" # Base 04
color21="E9/E1/CF" # Base 06
color_foreground="E0/D8/C8" # Base 05
color_background="13/11/0E" # Base 00


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
  put_template_custom Pg E0D8C8 # foreground
  put_template_custom Ph 13110E # background
  put_template_custom Pi E0D8C8 # bold color
  put_template_custom Pj 36301E # selection color
  put_template_custom Pk E0D8C8 # selected text color
  put_template_custom Pl E0D8C8 # cursor
  put_template_custom Pm 13110E # cursor text
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
  export BASE24_COLOR_00_HEX="13110E"
  export BASE24_COLOR_01_HEX="221F14"
  export BASE24_COLOR_02_HEX="36301E"
  export BASE24_COLOR_03_HEX="6E6450"
  export BASE24_COLOR_04_HEX="A79E8C"
  export BASE24_COLOR_05_HEX="E0D8C8"
  export BASE24_COLOR_06_HEX="E9E1CF"
  export BASE24_COLOR_07_HEX="F2EAD6"
  export BASE24_COLOR_08_HEX="DA6E54"
  export BASE24_COLOR_09_HEX="D9A441"
  export BASE24_COLOR_0A_HEX="D9A441"
  export BASE24_COLOR_0B_HEX="A8B84A"
  export BASE24_COLOR_0C_HEX="6FC8AE"
  export BASE24_COLOR_0D_HEX="8AA6C0"
  export BASE24_COLOR_0E_HEX="C28AA8"
  export BASE24_COLOR_0F_HEX="4E462C"
  export BASE24_COLOR_10_HEX="13110E"
  export BASE24_COLOR_11_HEX="13110E"
  export BASE24_COLOR_12_HEX="DA6E54"
  export BASE24_COLOR_13_HEX="D9A441"
  export BASE24_COLOR_14_HEX="A8B84A"
  export BASE24_COLOR_15_HEX="6FC8AE"
  export BASE24_COLOR_16_HEX="8AA6C0"
  export BASE24_COLOR_17_HEX="C28AA8"
fi
