#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Arthur
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="arthur"

color00="1c/1c/1c" # Base 00 - Black
color01="cd/5c/5c" # Base 08 - Red
color02="86/af/80" # Base 0B - Green
color03="87/ce/eb" # Base 0A - Yellow
color04="64/95/ed" # Base 0D - Blue
color05="de/b8/87" # Base 0E - Magenta
color06="b0/c4/de" # Base 0C - Cyan
color07="a1/90/83" # Base 05 - White
color08="6e/5d/59" # Base 03 - Bright Black
color09="cc/55/33" # Base 12 - Bright Red
color10="88/aa/22" # Base 14 - Bright Green
color11="ff/a7/5d" # Base 13 - Bright Yellow
color12="87/ce/eb" # Base 16 - Bright Blue
color13="99/66/00" # Base 17 - Bright Magenta
color14="b0/c4/de" # Base 15 - Bright Cyan
color15="dd/cc/bb" # Base 07 - Bright White
color16="e8/ae/5b" # Base 09
color17="66/2e/2e" # Base 0F
color18="3d/35/2a" # Base 01
color19="55/44/44" # Base 02
color20="88/77/6e" # Base 04
color21="bb/aa/99" # Base 06
color_foreground="a1/90/83" # Base 05
color_background="1c/1c/1c" # Base 00


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
  put_template_custom Pg a19083 # foreground
  put_template_custom Ph 1c1c1c # background
  put_template_custom Pi a19083 # bold color
  put_template_custom Pj 554444 # selection color
  put_template_custom Pk a19083 # selected text color
  put_template_custom Pl a19083 # cursor
  put_template_custom Pm 1c1c1c # cursor text
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
  export BASE24_COLOR_00_HEX="1c1c1c"
  export BASE24_COLOR_01_HEX="3d352a"
  export BASE24_COLOR_02_HEX="554444"
  export BASE24_COLOR_03_HEX="6e5d59"
  export BASE24_COLOR_04_HEX="88776e"
  export BASE24_COLOR_05_HEX="a19083"
  export BASE24_COLOR_06_HEX="bbaa99"
  export BASE24_COLOR_07_HEX="ddccbb"
  export BASE24_COLOR_08_HEX="cd5c5c"
  export BASE24_COLOR_09_HEX="e8ae5b"
  export BASE24_COLOR_0A_HEX="87ceeb"
  export BASE24_COLOR_0B_HEX="86af80"
  export BASE24_COLOR_0C_HEX="b0c4de"
  export BASE24_COLOR_0D_HEX="6495ed"
  export BASE24_COLOR_0E_HEX="deb887"
  export BASE24_COLOR_0F_HEX="662e2e"
  export BASE24_COLOR_10_HEX="382d2d"
  export BASE24_COLOR_11_HEX="1c1616"
  export BASE24_COLOR_12_HEX="cc5533"
  export BASE24_COLOR_13_HEX="ffa75d"
  export BASE24_COLOR_14_HEX="88aa22"
  export BASE24_COLOR_15_HEX="b0c4de"
  export BASE24_COLOR_16_HEX="87ceeb"
  export BASE24_COLOR_17_HEX="996600"
fi
