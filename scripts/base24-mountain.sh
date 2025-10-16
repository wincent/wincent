#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Mountain
# Scheme author: Stefan Weigl-Bosker (https://github.com/sweiglbosker), based on Mountain Theme (https://github.com/mountain-theme/Mountain)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="mountain"

color00="0f/0f/0f" # Base 00 - Black
color01="ac/8a/8c" # Base 08 - Red
color02="8a/ac/8b" # Base 0B - Green
color03="ac/a9/8a" # Base 0A - Yellow
color04="8f/8a/ac" # Base 0D - Blue
color05="ac/8a/ac" # Base 0E - Magenta
color06="8a/ab/ac" # Base 0C - Cyan
color07="ca/ca/ca" # Base 05 - White
color08="39/39/39" # Base 03 - Bright Black
color09="c4/9e/a0" # Base 12 - Bright Red
color10="9e/c4/9f" # Base 14 - Bright Green
color11="c4/c1/9e" # Base 13 - Bright Yellow
color12="a3/9e/c4" # Base 16 - Bright Blue
color13="c4/9e/c4" # Base 17 - Bright Magenta
color14="9e/c3/c4" # Base 15 - Bright Cyan
color15="f0/f0/f0" # Base 07 - Bright White
color16="c6/a6/79" # Base 09
color17="ac/8a/8c" # Base 0F
color18="19/19/19" # Base 01
color19="26/26/26" # Base 02
color20="4c/4c/4c" # Base 04
color21="e7/e7/e7" # Base 06
color_foreground="ca/ca/ca" # Base 05
color_background="0f/0f/0f" # Base 00


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
  put_template_custom Pg cacaca # foreground
  put_template_custom Ph 0f0f0f # background
  put_template_custom Pi cacaca # bold color
  put_template_custom Pj 262626 # selection color
  put_template_custom Pk cacaca # selected text color
  put_template_custom Pl cacaca # cursor
  put_template_custom Pm 0f0f0f # cursor text
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
  export BASE24_COLOR_00_HEX="0f0f0f"
  export BASE24_COLOR_01_HEX="191919"
  export BASE24_COLOR_02_HEX="262626"
  export BASE24_COLOR_03_HEX="393939"
  export BASE24_COLOR_04_HEX="4c4c4c"
  export BASE24_COLOR_05_HEX="cacaca"
  export BASE24_COLOR_06_HEX="e7e7e7"
  export BASE24_COLOR_07_HEX="f0f0f0"
  export BASE24_COLOR_08_HEX="ac8a8c"
  export BASE24_COLOR_09_HEX="c6a679"
  export BASE24_COLOR_0A_HEX="aca98a"
  export BASE24_COLOR_0B_HEX="8aac8b"
  export BASE24_COLOR_0C_HEX="8aabac"
  export BASE24_COLOR_0D_HEX="8f8aac"
  export BASE24_COLOR_0E_HEX="ac8aac"
  export BASE24_COLOR_0F_HEX="ac8a8c"
  export BASE24_COLOR_10_HEX="0d0d0d"
  export BASE24_COLOR_11_HEX="0a0a0a"
  export BASE24_COLOR_12_HEX="c49ea0"
  export BASE24_COLOR_13_HEX="c4c19e"
  export BASE24_COLOR_14_HEX="9ec49f"
  export BASE24_COLOR_15_HEX="9ec3c4"
  export BASE24_COLOR_16_HEX="a39ec4"
  export BASE24_COLOR_17_HEX="c49ec4"
fi
