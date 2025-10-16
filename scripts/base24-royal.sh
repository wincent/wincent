#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Royal
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="royal"

color00="10/08/14" # Base 00 - Black
color01="90/27/4b" # Base 08 - Red
color02="23/80/1c" # Base 0B - Green
color03="8f/b9/f9" # Base 0A - Yellow
color04="64/80/af" # Base 0D - Blue
color05="66/4d/96" # Base 0E - Magenta
color06="8a/aa/bd" # Base 0C - Cyan
color07="49/42/5a" # Base 05 - White
color08="39/34/46" # Base 03 - Bright Black
color09="d4/34/6c" # Base 12 - Bright Red
color10="2c/d8/45" # Base 14 - Bright Green
color11="fd/e8/3a" # Base 13 - Bright Yellow
color12="8f/b9/f9" # Base 16 - Bright Blue
color13="a4/79/e2" # Base 17 - Bright Magenta
color14="ab/d3/eb" # Base 15 - Bright Cyan
color15="9d/8b/bd" # Base 07 - Bright White
color16="b4/9d/27" # Base 09
color17="48/13/25" # Base 0F
color18="24/1f/2a" # Base 01
color19="31/2d/3c" # Base 02
color20="41/3b/50" # Base 04
color21="51/49/65" # Base 06
color_foreground="49/42/5a" # Base 05
color_background="10/08/14" # Base 00


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
  put_template_custom Pg 49425a # foreground
  put_template_custom Ph 100814 # background
  put_template_custom Pi 49425a # bold color
  put_template_custom Pj 312d3c # selection color
  put_template_custom Pk 49425a # selected text color
  put_template_custom Pl 49425a # cursor
  put_template_custom Pm 100814 # cursor text
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
  export BASE24_COLOR_00_HEX="100814"
  export BASE24_COLOR_01_HEX="241f2a"
  export BASE24_COLOR_02_HEX="312d3c"
  export BASE24_COLOR_03_HEX="393446"
  export BASE24_COLOR_04_HEX="413b50"
  export BASE24_COLOR_05_HEX="49425a"
  export BASE24_COLOR_06_HEX="514965"
  export BASE24_COLOR_07_HEX="9d8bbd"
  export BASE24_COLOR_08_HEX="90274b"
  export BASE24_COLOR_09_HEX="b49d27"
  export BASE24_COLOR_0A_HEX="8fb9f9"
  export BASE24_COLOR_0B_HEX="23801c"
  export BASE24_COLOR_0C_HEX="8aaabd"
  export BASE24_COLOR_0D_HEX="6480af"
  export BASE24_COLOR_0E_HEX="664d96"
  export BASE24_COLOR_0F_HEX="481325"
  export BASE24_COLOR_10_HEX="201e28"
  export BASE24_COLOR_11_HEX="100f14"
  export BASE24_COLOR_12_HEX="d4346c"
  export BASE24_COLOR_13_HEX="fde83a"
  export BASE24_COLOR_14_HEX="2cd845"
  export BASE24_COLOR_15_HEX="abd3eb"
  export BASE24_COLOR_16_HEX="8fb9f9"
  export BASE24_COLOR_17_HEX="a479e2"
fi
