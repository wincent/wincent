#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Slate 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="slate"

color00="21/21/21" # Base 00 - Black
color01="e1/a7/bf" # Base 08 - Red
color02="80/d7/78" # Base 0B - Green
color03="79/af/d2" # Base 0A - Yellow
color04="25/4a/49" # Base 0D - Blue
color05="a3/80/d3" # Base 0E - Magenta
color06="14/ab/9c" # Base 0C - Cyan
color07="02/c4/e0" # Base 06 - White
color08="ff/ff/ff" # Base 02 - Bright Black
color09="ff/cc/d8" # Base 12 - Bright Red
color10="bd/ff/a8" # Base 14 - Bright Green
color11="d0/cb/c9" # Base 13 - Bright Yellow
color12="79/af/d2" # Base 16 - Bright Blue
color13="c4/a7/d8" # Base 17 - Bright Magenta
color14="8b/de/e0" # Base 15 - Bright Cyan
color15="e0/e0/e0" # Base 07 - Bright White
color16="c4/c9/bf" # Base 09
color17="70/53/5f" # Base 0F
color18="21/21/21" # Base 01
color19="ff/ff/ff" # Base 02
color20="81/e2/f0" # Base 04
color21="02/c4/e0" # Base 06
color_foreground="42/d3/e8" # Base 05
color_background="21/21/21" # Base 00


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
  put_template_custom Pg 42d3e8 # foreground
  put_template_custom Ph 212121 # background
  put_template_custom Pi 42d3e8 # bold color
  put_template_custom Pj ffffff # selection color
  put_template_custom Pk 42d3e8 # selected text color
  put_template_custom Pl 42d3e8 # cursor
  put_template_custom Pm 212121 # cursor text
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
  export BASE24_COLOR_00_HEX="212121"
  export BASE24_COLOR_01_HEX="212121"
  export BASE24_COLOR_02_HEX="ffffff"
  export BASE24_COLOR_03_HEX="c0f1f8"
  export BASE24_COLOR_04_HEX="81e2f0"
  export BASE24_COLOR_05_HEX="42d3e8"
  export BASE24_COLOR_06_HEX="02c4e0"
  export BASE24_COLOR_07_HEX="e0e0e0"
  export BASE24_COLOR_08_HEX="e1a7bf"
  export BASE24_COLOR_09_HEX="c4c9bf"
  export BASE24_COLOR_0A_HEX="79afd2"
  export BASE24_COLOR_0B_HEX="80d778"
  export BASE24_COLOR_0C_HEX="14ab9c"
  export BASE24_COLOR_0D_HEX="254a49"
  export BASE24_COLOR_0E_HEX="a380d3"
  export BASE24_COLOR_0F_HEX="70535f"
  export BASE24_COLOR_10_HEX="aaaaaa"
  export BASE24_COLOR_11_HEX="555555"
  export BASE24_COLOR_12_HEX="ffccd8"
  export BASE24_COLOR_13_HEX="d0cbc9"
  export BASE24_COLOR_14_HEX="bdffa8"
  export BASE24_COLOR_15_HEX="8bdee0"
  export BASE24_COLOR_16_HEX="79afd2"
  export BASE24_COLOR_17_HEX="c4a7d8"
fi
