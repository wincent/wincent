#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Dimmed Monokai 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="dimmed-monokai"

color00="1e/1e/1e" # Base 00 - Black
color01="be/3e/48" # Base 08 - Red
color02="86/9a/3a" # Base 0B - Green
color03="17/6c/e3" # Base 0A - Yellow
color04="4e/76/a1" # Base 0D - Blue
color05="85/5b/8d" # Base 0E - Magenta
color06="56/8e/a3" # Base 0C - Cyan
color07="b8/bc/b9" # Base 06 - White
color08="88/89/87" # Base 02 - Bright Black
color09="fb/00/1e" # Base 12 - Bright Red
color10="0e/71/2e" # Base 14 - Bright Green
color11="c3/70/33" # Base 13 - Bright Yellow
color12="17/6c/e3" # Base 16 - Bright Blue
color13="fb/00/67" # Base 17 - Bright Magenta
color14="2d/6f/6c" # Base 15 - Bright Cyan
color15="fc/ff/b8" # Base 07 - Bright White
color16="c4/a5/35" # Base 09
color17="5f/1f/24" # Base 0F
color18="3a/3c/43" # Base 01
color19="88/89/87" # Base 02
color20="a0/a2/a0" # Base 04
color21="b8/bc/b9" # Base 06
color_foreground="ac/af/ac" # Base 05
color_background="1e/1e/1e" # Base 00


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
  put_template_custom Pg acafac # foreground
  put_template_custom Ph 1e1e1e # background
  put_template_custom Pi acafac # bold color
  put_template_custom Pj 888987 # selection color
  put_template_custom Pk acafac # selected text color
  put_template_custom Pl acafac # cursor
  put_template_custom Pm 1e1e1e # cursor text
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
  export BASE24_COLOR_00_HEX="1e1e1e"
  export BASE24_COLOR_01_HEX="3a3c43"
  export BASE24_COLOR_02_HEX="888987"
  export BASE24_COLOR_03_HEX="949593"
  export BASE24_COLOR_04_HEX="a0a2a0"
  export BASE24_COLOR_05_HEX="acafac"
  export BASE24_COLOR_06_HEX="b8bcb9"
  export BASE24_COLOR_07_HEX="fcffb8"
  export BASE24_COLOR_08_HEX="be3e48"
  export BASE24_COLOR_09_HEX="c4a535"
  export BASE24_COLOR_0A_HEX="176ce3"
  export BASE24_COLOR_0B_HEX="869a3a"
  export BASE24_COLOR_0C_HEX="568ea3"
  export BASE24_COLOR_0D_HEX="4e76a1"
  export BASE24_COLOR_0E_HEX="855b8d"
  export BASE24_COLOR_0F_HEX="5f1f24"
  export BASE24_COLOR_10_HEX="5a5b5a"
  export BASE24_COLOR_11_HEX="2d2d2d"
  export BASE24_COLOR_12_HEX="fb001e"
  export BASE24_COLOR_13_HEX="c37033"
  export BASE24_COLOR_14_HEX="0e712e"
  export BASE24_COLOR_15_HEX="2d6f6c"
  export BASE24_COLOR_16_HEX="176ce3"
  export BASE24_COLOR_17_HEX="fb0067"
fi
