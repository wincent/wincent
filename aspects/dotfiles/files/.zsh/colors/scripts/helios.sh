#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Helios 
# Scheme author: Alex Meyer (https://github.com/reyemxela)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="helios"

color00="1d/20/21" # Base 00 - Black
color01="d7/26/38" # Base 08 - Red
color02="88/b9/2d" # Base 0B - Green
color03="f1/9d/1a" # Base 0A - Yellow
color04="1e/8b/ac" # Base 0D - Blue
color05="be/42/64" # Base 0E - Magenta
color06="1b/a5/95" # Base 0C - Cyan
color07="dd/dd/dd" # Base 06 - White
color08="53/58/5b" # Base 02 - Bright Black
color09="d7/26/38" # Base 12 - Bright Red
color10="88/b9/2d" # Base 14 - Bright Green
color11="f1/9d/1a" # Base 13 - Bright Yellow
color12="1e/8b/ac" # Base 16 - Bright Blue
color13="be/42/64" # Base 17 - Bright Magenta
color14="1b/a5/95" # Base 15 - Bright Cyan
color15="e5/e5/e5" # Base 07 - Bright White
color16="eb/84/13" # Base 09
color17="c8/5e/0d" # Base 0F
color18="38/3c/3e" # Base 01
color19="53/58/5b" # Base 02
color20="cd/cd/cd" # Base 04
color21="dd/dd/dd" # Base 06
color_foreground="d5/d5/d5" # Base 05
color_background="1d/20/21" # Base 00


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
  put_template_custom Pg d5d5d5 # foreground
  put_template_custom Ph 1d2021 # background
  put_template_custom Pi d5d5d5 # bold color
  put_template_custom Pj 53585b # selection color
  put_template_custom Pk d5d5d5 # selected text color
  put_template_custom Pl d5d5d5 # cursor
  put_template_custom Pm 1d2021 # cursor text
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
  export BASE24_COLOR_00_HEX="1d2021"
  export BASE24_COLOR_01_HEX="383c3e"
  export BASE24_COLOR_02_HEX="53585b"
  export BASE24_COLOR_03_HEX="6f7579"
  export BASE24_COLOR_04_HEX="cdcdcd"
  export BASE24_COLOR_05_HEX="d5d5d5"
  export BASE24_COLOR_06_HEX="dddddd"
  export BASE24_COLOR_07_HEX="e5e5e5"
  export BASE24_COLOR_08_HEX="d72638"
  export BASE24_COLOR_09_HEX="eb8413"
  export BASE24_COLOR_0A_HEX="f19d1a"
  export BASE24_COLOR_0B_HEX="88b92d"
  export BASE24_COLOR_0C_HEX="1ba595"
  export BASE24_COLOR_0D_HEX="1e8bac"
  export BASE24_COLOR_0E_HEX="be4264"
  export BASE24_COLOR_0F_HEX="c85e0d"
  export BASE24_COLOR_10_HEX="1d2021"
  export BASE24_COLOR_11_HEX="1d2021"
  export BASE24_COLOR_12_HEX="d72638"
  export BASE24_COLOR_13_HEX="f19d1a"
  export BASE24_COLOR_14_HEX="88b92d"
  export BASE24_COLOR_15_HEX="1ba595"
  export BASE24_COLOR_16_HEX="1e8bac"
  export BASE24_COLOR_17_HEX="be4264"
fi
