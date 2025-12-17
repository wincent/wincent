#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Flexoki Light
# Scheme author: Steph Ango (https://github.com/kepano/flexoki)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="flexoki-light"

color00="FF/FC/F0" # Base 00 - Black
color01="AF/30/29" # Base 08 - Red
color02="66/80/0B" # Base 0B - Green
color03="AD/83/01" # Base 0A - Yellow
color04="20/5E/A6" # Base 0D - Blue
color05="5E/40/9D" # Base 0E - Magenta
color06="24/83/7B" # Base 0C - Cyan
color07="40/3E/3C" # Base 05 - White
color08="CE/CD/C3" # Base 03 - Bright Black
color09="D1/4D/41" # Base 12 - Bright Red
color10="D0/A2/15" # Base 14 - Bright Green
color11="DA/70/2C" # Base 13 - Bright Yellow
color12="3A/A9/9F" # Base 16 - Bright Blue
color13="43/85/BE" # Base 17 - Bright Magenta
color14="87/9A/39" # Base 15 - Bright Cyan
color15="10/0F/0F" # Base 07 - Bright White
color16="BC/52/15" # Base 09
color17="A0/2F/6F" # Base 0F
color18="F2/F0/E5" # Base 01
color19="E6/E4/D9" # Base 02
color20="9F/9D/96" # Base 04
color21="28/27/26" # Base 06
color_foreground="40/3E/3C" # Base 05
color_background="FF/FC/F0" # Base 00


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
  put_template_custom Pg 403E3C # foreground
  put_template_custom Ph FFFCF0 # background
  put_template_custom Pi 403E3C # bold color
  put_template_custom Pj E6E4D9 # selection color
  put_template_custom Pk 403E3C # selected text color
  put_template_custom Pl 403E3C # cursor
  put_template_custom Pm FFFCF0 # cursor text
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
  export BASE24_COLOR_00_HEX="FFFCF0"
  export BASE24_COLOR_01_HEX="F2F0E5"
  export BASE24_COLOR_02_HEX="E6E4D9"
  export BASE24_COLOR_03_HEX="CECDC3"
  export BASE24_COLOR_04_HEX="9F9D96"
  export BASE24_COLOR_05_HEX="403E3C"
  export BASE24_COLOR_06_HEX="282726"
  export BASE24_COLOR_07_HEX="100F0F"
  export BASE24_COLOR_08_HEX="AF3029"
  export BASE24_COLOR_09_HEX="BC5215"
  export BASE24_COLOR_0A_HEX="AD8301"
  export BASE24_COLOR_0B_HEX="66800B"
  export BASE24_COLOR_0C_HEX="24837B"
  export BASE24_COLOR_0D_HEX="205EA6"
  export BASE24_COLOR_0E_HEX="5E409D"
  export BASE24_COLOR_0F_HEX="A02F6F"
  export BASE24_COLOR_10_HEX="F2F0E5"
  export BASE24_COLOR_11_HEX="FFFFFF"
  export BASE24_COLOR_12_HEX="D14D41"
  export BASE24_COLOR_13_HEX="DA702C"
  export BASE24_COLOR_14_HEX="D0A215"
  export BASE24_COLOR_15_HEX="879A39"
  export BASE24_COLOR_16_HEX="3AA99F"
  export BASE24_COLOR_17_HEX="4385BE"
fi
