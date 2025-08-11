#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Silk Light
# Scheme author: Gabriel Fontes (https://github.com/Misterio77)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="silk-light"

color00="E9/F1/EF" # Base 00 - Black
color01="CF/43/2E" # Base 08 - Red
color02="6C/A3/8C" # Base 0B - Green
color03="CF/AD/25" # Base 0A - Yellow
color04="39/AA/C9" # Base 0D - Blue
color05="6E/65/82" # Base 0E - Magenta
color06="32/9C/A2" # Base 0C - Cyan
color07="38/51/56" # Base 05 - White
color08="5C/78/7B" # Base 03 - Bright Black
color09="CF/43/2E" # Base 12 - Bright Red
color10="6C/A3/8C" # Base 14 - Bright Green
color11="CF/AD/25" # Base 13 - Bright Yellow
color12="39/AA/C9" # Base 16 - Bright Blue
color13="6E/65/82" # Base 17 - Bright Magenta
color14="32/9C/A2" # Base 15 - Bright Cyan
color15="D2/FA/FF" # Base 07 - Bright White
color16="D2/7F/46" # Base 09
color17="86/53/69" # Base 0F
color18="CC/D4/D3" # Base 01
color19="90/B7/B6" # Base 02
color20="4B/5B/5F" # Base 04
color21="0e/3c/46" # Base 06
color_foreground="38/51/56" # Base 05
color_background="E9/F1/EF" # Base 00


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
  put_template_custom Pg 385156 # foreground
  put_template_custom Ph E9F1EF # background
  put_template_custom Pi 385156 # bold color
  put_template_custom Pj 90B7B6 # selection color
  put_template_custom Pk 385156 # selected text color
  put_template_custom Pl 385156 # cursor
  put_template_custom Pm E9F1EF # cursor text
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
  export BASE24_COLOR_00_HEX="E9F1EF"
  export BASE24_COLOR_01_HEX="CCD4D3"
  export BASE24_COLOR_02_HEX="90B7B6"
  export BASE24_COLOR_03_HEX="5C787B"
  export BASE24_COLOR_04_HEX="4B5B5F"
  export BASE24_COLOR_05_HEX="385156"
  export BASE24_COLOR_06_HEX="0e3c46"
  export BASE24_COLOR_07_HEX="D2FAFF"
  export BASE24_COLOR_08_HEX="CF432E"
  export BASE24_COLOR_09_HEX="D27F46"
  export BASE24_COLOR_0A_HEX="CFAD25"
  export BASE24_COLOR_0B_HEX="6CA38C"
  export BASE24_COLOR_0C_HEX="329CA2"
  export BASE24_COLOR_0D_HEX="39AAC9"
  export BASE24_COLOR_0E_HEX="6E6582"
  export BASE24_COLOR_0F_HEX="865369"
  export BASE24_COLOR_10_HEX="E9F1EF"
  export BASE24_COLOR_11_HEX="E9F1EF"
  export BASE24_COLOR_12_HEX="CF432E"
  export BASE24_COLOR_13_HEX="CFAD25"
  export BASE24_COLOR_14_HEX="6CA38C"
  export BASE24_COLOR_15_HEX="329CA2"
  export BASE24_COLOR_16_HEX="39AAC9"
  export BASE24_COLOR_17_HEX="6E6582"
fi
