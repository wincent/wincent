#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Unikitty Dark 
# Scheme author: Josh W Lewis (@joshwlewis)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="unikitty-dark"

color00="2e/2a/31" # Base 00 - Black
color01="d8/13/7f" # Base 08 - Red
color02="17/ad/98" # Base 0B - Green
color03="dc/8a/0e" # Base 0A - Yellow
color04="79/6a/f5" # Base 0D - Blue
color05="bb/60/ea" # Base 0E - Magenta
color06="14/9b/da" # Base 0C - Cyan
color07="d8/d7/da" # Base 06 - White
color08="66/63/69" # Base 02 - Bright Black
color09="d8/13/7f" # Base 12 - Bright Red
color10="17/ad/98" # Base 14 - Bright Green
color11="dc/8a/0e" # Base 13 - Bright Yellow
color12="79/6a/f5" # Base 16 - Bright Blue
color13="bb/60/ea" # Base 17 - Bright Magenta
color14="14/9b/da" # Base 15 - Bright Cyan
color15="f5/f4/f7" # Base 07 - Bright White
color16="d6/54/07" # Base 09
color17="c7/20/ca" # Base 0F
color18="4a/46/4d" # Base 01
color19="66/63/69" # Base 02
color20="9f/9d/a2" # Base 04
color21="d8/d7/da" # Base 06
color_foreground="bc/ba/be" # Base 05
color_background="2e/2a/31" # Base 00


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
  put_template_custom Pg bcbabe # foreground
  put_template_custom Ph 2e2a31 # background
  put_template_custom Pi bcbabe # bold color
  put_template_custom Pj 666369 # selection color
  put_template_custom Pk bcbabe # selected text color
  put_template_custom Pl bcbabe # cursor
  put_template_custom Pm 2e2a31 # cursor text
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
  export BASE24_COLOR_00_HEX="2e2a31"
  export BASE24_COLOR_01_HEX="4a464d"
  export BASE24_COLOR_02_HEX="666369"
  export BASE24_COLOR_03_HEX="838085"
  export BASE24_COLOR_04_HEX="9f9da2"
  export BASE24_COLOR_05_HEX="bcbabe"
  export BASE24_COLOR_06_HEX="d8d7da"
  export BASE24_COLOR_07_HEX="f5f4f7"
  export BASE24_COLOR_08_HEX="d8137f"
  export BASE24_COLOR_09_HEX="d65407"
  export BASE24_COLOR_0A_HEX="dc8a0e"
  export BASE24_COLOR_0B_HEX="17ad98"
  export BASE24_COLOR_0C_HEX="149bda"
  export BASE24_COLOR_0D_HEX="796af5"
  export BASE24_COLOR_0E_HEX="bb60ea"
  export BASE24_COLOR_0F_HEX="c720ca"
  export BASE24_COLOR_10_HEX="2e2a31"
  export BASE24_COLOR_11_HEX="2e2a31"
  export BASE24_COLOR_12_HEX="d8137f"
  export BASE24_COLOR_13_HEX="dc8a0e"
  export BASE24_COLOR_14_HEX="17ad98"
  export BASE24_COLOR_15_HEX="149bda"
  export BASE24_COLOR_16_HEX="796af5"
  export BASE24_COLOR_17_HEX="bb60ea"
fi
