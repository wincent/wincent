#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Paraiso 
# Scheme author: Jan T. Sott
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="paraiso"

color00="2f/1e/2e" # Base 00 - Black
color01="ef/61/55" # Base 08 - Red
color02="48/b6/85" # Base 0B - Green
color03="fe/c4/18" # Base 0A - Yellow
color04="06/b6/ef" # Base 0D - Blue
color05="81/5b/a4" # Base 0E - Magenta
color06="5b/c4/bf" # Base 0C - Cyan
color07="b9/b6/b0" # Base 06 - White
color08="4f/42/4c" # Base 02 - Bright Black
color09="ef/61/55" # Base 12 - Bright Red
color10="48/b6/85" # Base 14 - Bright Green
color11="fe/c4/18" # Base 13 - Bright Yellow
color12="06/b6/ef" # Base 16 - Bright Blue
color13="81/5b/a4" # Base 17 - Bright Magenta
color14="5b/c4/bf" # Base 15 - Bright Cyan
color15="e7/e9/db" # Base 07 - Bright White
color16="f9/9b/15" # Base 09
color17="e9/6b/a8" # Base 0F
color18="41/32/3f" # Base 01
color19="4f/42/4c" # Base 02
color20="8d/86/87" # Base 04
color21="b9/b6/b0" # Base 06
color_foreground="a3/9e/9b" # Base 05
color_background="2f/1e/2e" # Base 00


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
  put_template_custom Pg a39e9b # foreground
  put_template_custom Ph 2f1e2e # background
  put_template_custom Pi a39e9b # bold color
  put_template_custom Pj 4f424c # selection color
  put_template_custom Pk a39e9b # selected text color
  put_template_custom Pl a39e9b # cursor
  put_template_custom Pm 2f1e2e # cursor text
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
  export BASE24_COLOR_00_HEX="2f1e2e"
  export BASE24_COLOR_01_HEX="41323f"
  export BASE24_COLOR_02_HEX="4f424c"
  export BASE24_COLOR_03_HEX="776e71"
  export BASE24_COLOR_04_HEX="8d8687"
  export BASE24_COLOR_05_HEX="a39e9b"
  export BASE24_COLOR_06_HEX="b9b6b0"
  export BASE24_COLOR_07_HEX="e7e9db"
  export BASE24_COLOR_08_HEX="ef6155"
  export BASE24_COLOR_09_HEX="f99b15"
  export BASE24_COLOR_0A_HEX="fec418"
  export BASE24_COLOR_0B_HEX="48b685"
  export BASE24_COLOR_0C_HEX="5bc4bf"
  export BASE24_COLOR_0D_HEX="06b6ef"
  export BASE24_COLOR_0E_HEX="815ba4"
  export BASE24_COLOR_0F_HEX="e96ba8"
  export BASE24_COLOR_10_HEX="2f1e2e"
  export BASE24_COLOR_11_HEX="2f1e2e"
  export BASE24_COLOR_12_HEX="ef6155"
  export BASE24_COLOR_13_HEX="fec418"
  export BASE24_COLOR_14_HEX="48b685"
  export BASE24_COLOR_15_HEX="5bc4bf"
  export BASE24_COLOR_16_HEX="06b6ef"
  export BASE24_COLOR_17_HEX="815ba4"
fi
