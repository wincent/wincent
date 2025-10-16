#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Adventure Time
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="adventure-time"

color00="1e/1c/44" # Base 00 - Black
color01="bc/00/13" # Base 08 - Red
color02="49/b1/17" # Base 0B - Green
color03="18/96/c6" # Base 0A - Yellow
color04="0f/49/c6" # Base 0D - Blue
color05="66/59/92" # Base 0E - Magenta
color06="6f/a4/97" # Base 0C - Cyan
color07="cd/c3/bf" # Base 05 - White
color08="78/93/bf" # Base 03 - Bright Black
color09="fc/5e/59" # Base 12 - Bright Red
color10="9d/ff/6e" # Base 14 - Bright Green
color11="ef/c1/1a" # Base 13 - Bright Yellow
color12="18/96/c6" # Base 16 - Bright Blue
color13="9a/59/52" # Base 17 - Bright Magenta
color14="c8/f9/f3" # Base 15 - Bright Cyan
color15="f5/f4/fb" # Base 07 - Bright White
color16="e6/74/1d" # Base 09
color17="5e/00/09" # Base 0F
color18="05/04/04" # Base 01
color19="4e/7b/bf" # Base 02
color20="a3/ab/bf" # Base 04
color21="f8/db/c0" # Base 06
color_foreground="cd/c3/bf" # Base 05
color_background="1e/1c/44" # Base 00


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
  put_template_custom Pg cdc3bf # foreground
  put_template_custom Ph 1e1c44 # background
  put_template_custom Pi cdc3bf # bold color
  put_template_custom Pj 4e7bbf # selection color
  put_template_custom Pk cdc3bf # selected text color
  put_template_custom Pl cdc3bf # cursor
  put_template_custom Pm 1e1c44 # cursor text
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
  export BASE24_COLOR_00_HEX="1e1c44"
  export BASE24_COLOR_01_HEX="050404"
  export BASE24_COLOR_02_HEX="4e7bbf"
  export BASE24_COLOR_03_HEX="7893bf"
  export BASE24_COLOR_04_HEX="a3abbf"
  export BASE24_COLOR_05_HEX="cdc3bf"
  export BASE24_COLOR_06_HEX="f8dbc0"
  export BASE24_COLOR_07_HEX="f5f4fb"
  export BASE24_COLOR_08_HEX="bc0013"
  export BASE24_COLOR_09_HEX="e6741d"
  export BASE24_COLOR_0A_HEX="1896c6"
  export BASE24_COLOR_0B_HEX="49b117"
  export BASE24_COLOR_0C_HEX="6fa497"
  export BASE24_COLOR_0D_HEX="0f49c6"
  export BASE24_COLOR_0E_HEX="665992"
  export BASE24_COLOR_0F_HEX="5e0009"
  export BASE24_COLOR_10_HEX="34527f"
  export BASE24_COLOR_11_HEX="1a293f"
  export BASE24_COLOR_12_HEX="fc5e59"
  export BASE24_COLOR_13_HEX="efc11a"
  export BASE24_COLOR_14_HEX="9dff6e"
  export BASE24_COLOR_15_HEX="c8f9f3"
  export BASE24_COLOR_16_HEX="1896c6"
  export BASE24_COLOR_17_HEX="9a5952"
fi
