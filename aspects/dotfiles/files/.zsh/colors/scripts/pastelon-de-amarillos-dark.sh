#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Pastelón de Amarillos Dark
# Scheme author: Richard Martinez (https://sonofmartinus.com)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="pastelon-de-amarillos-dark"

color00="18/0d/18" # Base 00 - Black
color01="d9/53/61" # Base 08 - Red
color02="36/aa/72" # Base 0B - Green
color03="d8/a9/3a" # Base 0A - Yellow
color04="4c/84/bd" # Base 0D - Blue
color05="b7/65/b0" # Base 0E - Magenta
color06="31/a9/9e" # Base 0C - Cyan
color07="ff/e0/a3" # Base 05 - White
color08="a0/74/7c" # Base 03 - Bright Black
color09="ff/d0/52" # Base 12 - Bright Red
color10="3e/d2/c3" # Base 14 - Bright Green
color11="43/d9/8d" # Base 13 - Bright Yellow
color12="e5/81/dc" # Base 16 - Bright Blue
color13="ed/7d/51" # Base 17 - Bright Magenta
color14="64/ab/f4" # Base 15 - Bright Cyan
color15="ff/f7/e6" # Base 07 - Bright White
color16="d9/83/28" # Base 09
color17="bd/62/42" # Base 0F
color18="2a/14/24" # Base 01
color19="43/20/31" # Base 02
color20="c3/9a/89" # Base 04
color21="ff/eb/c5" # Base 06
color_foreground="ff/e0/a3" # Base 05
color_background="18/0d/18" # Base 00


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
  put_template_custom Pg ffe0a3 # foreground
  put_template_custom Ph 180d18 # background
  put_template_custom Pi ffe0a3 # bold color
  put_template_custom Pj 432031 # selection color
  put_template_custom Pk ffe0a3 # selected text color
  put_template_custom Pl ffe0a3 # cursor
  put_template_custom Pm 180d18 # cursor text
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
if [ -n "$TINTED_SHELL_ENABLE_BASE24_VARS" ]; then
  export BASE24_COLOR_00_HEX="180d18"
  export BASE24_COLOR_01_HEX="2a1424"
  export BASE24_COLOR_02_HEX="432031"
  export BASE24_COLOR_03_HEX="a0747c"
  export BASE24_COLOR_04_HEX="c39a89"
  export BASE24_COLOR_05_HEX="ffe0a3"
  export BASE24_COLOR_06_HEX="ffebc5"
  export BASE24_COLOR_07_HEX="fff7e6"
  export BASE24_COLOR_08_HEX="d95361"
  export BASE24_COLOR_09_HEX="d98328"
  export BASE24_COLOR_0A_HEX="d8a93a"
  export BASE24_COLOR_0B_HEX="36aa72"
  export BASE24_COLOR_0C_HEX="31a99e"
  export BASE24_COLOR_0D_HEX="4c84bd"
  export BASE24_COLOR_0E_HEX="b765b0"
  export BASE24_COLOR_0F_HEX="bd6242"
  export BASE24_COLOR_10_HEX="ff6e79"
  export BASE24_COLOR_11_HEX="ff9f37"
  export BASE24_COLOR_12_HEX="ffd052"
  export BASE24_COLOR_13_HEX="43d98d"
  export BASE24_COLOR_14_HEX="3ed2c3"
  export BASE24_COLOR_15_HEX="64abf4"
  export BASE24_COLOR_16_HEX="e581dc"
  export BASE24_COLOR_17_HEX="ed7d51"
fi
