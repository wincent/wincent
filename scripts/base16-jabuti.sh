#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Jabuti
# Scheme author: https://github.com/notusknot
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE16_THEME=jabuti

color00="29/2a/37" # Base 00 - Black
color01="ec/6a/88" # Base 08 - Red
color02="3f/da/a4" # Base 0B - Green
color03="e1/c6/97" # Base 0A - Yellow
color04="3f/c6/de" # Base 0D - Blue
color05="be/95/ff" # Base 0E - Magenta
color06="ff/7e/b6" # Base 0C - Cyan
color07="c0/cb/e3" # Base 05 - White
color08="45/47/5d" # Base 03 - Bright Black
color09="$color01" # Base 08 - Bright Red
color10="$color02" # Base 0B - Bright Green
color11="$color03" # Base 0A - Bright Yellow
color12="$color04" # Base 0D - Bright Blue
color13="$color05" # Base 0E - Bright Magenta
color14="$color06" # Base 0C - Bright Cyan
color15="ff/ff/ff" # Base 07 - Bright White
color16="ef/b9/93" # Base 09
color17="8b/8d/a9" # Base 0F
color18="34/35/45" # Base 01
color19="3c/3e/51" # Base 02
color20="50/52/6b" # Base 04
color21="d9/e0/ee" # Base 06
color_foreground="c0/cb/e3" # Base 05
color_background="29/2a/37" # Base 00

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
  put_template_custom Pg c0cbe3 # foreground
  put_template_custom Ph 292a37 # background
  put_template_custom Pi c0cbe3 # bold color
  put_template_custom Pj 3c3e51 # selection color
  put_template_custom Pk c0cbe3 # selected text color
  put_template_custom Pl c0cbe3 # cursor
  put_template_custom Pm 292a37 # cursor text
else
  put_template_var 10 "$color_foreground"
  if [ "$BASE16_SHELL_SET_BACKGROUND" != false ]; then
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
if [ -n "$TINTED_SHELL_ENABLE_BASE16_VARS" ] || [ -n "$BASE16_SHELL_ENABLE_VARS" ]; then
  export BASE16_COLOR_00_HEX="292a37"
  export BASE16_COLOR_01_HEX="343545"
  export BASE16_COLOR_02_HEX="3c3e51"
  export BASE16_COLOR_03_HEX="45475d"
  export BASE16_COLOR_04_HEX="50526b"
  export BASE16_COLOR_05_HEX="c0cbe3"
  export BASE16_COLOR_06_HEX="d9e0ee"
  export BASE16_COLOR_07_HEX="ffffff"
  export BASE16_COLOR_08_HEX="ec6a88"
  export BASE16_COLOR_09_HEX="efb993"
  export BASE16_COLOR_0A_HEX="e1c697"
  export BASE16_COLOR_0B_HEX="3fdaa4"
  export BASE16_COLOR_0C_HEX="ff7eb6"
  export BASE16_COLOR_0D_HEX="3fc6de"
  export BASE16_COLOR_0E_HEX="be95ff"
  export BASE16_COLOR_0F_HEX="8b8da9"
fi
