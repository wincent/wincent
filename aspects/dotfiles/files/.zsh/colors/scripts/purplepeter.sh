#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Purplepeter
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="purplepeter"

color00="2a/1a/4a" # Base 00 - Black
color01="ff/78/6c" # Base 08 - Red
color02="98/b4/81" # Base 0B - Green
color03="79/da/ed" # Base 0A - Yellow
color04="66/d9/ef" # Base 0D - Blue
color05="e6/8e/cd" # Base 0E - Magenta
color06="b9/8c/ff" # Base 0C - Cyan
color07="c3/8e/69" # Base 05 - White
color08="4b/36/39" # Base 03 - Bright Black
color09="f8/9f/92" # Base 12 - Bright Red
color10="b4/bd/8e" # Base 14 - Bright Green
color11="f1/e9/bf" # Base 13 - Bright Yellow
color12="79/da/ed" # Base 16 - Bright Blue
color13="b9/91/d4" # Base 17 - Bright Magenta
color14="a0/a0/d6" # Base 15 - Bright Cyan
color15="b9/ae/d3" # Base 07 - Bright White
color16="ef/de/ab" # Base 09
color17="7f/3c/36" # Base 0F
color18="0a/04/1f" # Base 01
color19="10/0b/22" # Base 02
color20="87/62/51" # Base 04
color21="ff/ba/81" # Base 06
color_foreground="c3/8e/69" # Base 05
color_background="2a/1a/4a" # Base 00


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
  put_template_custom Pg c38e69 # foreground
  put_template_custom Ph 2a1a4a # background
  put_template_custom Pi c38e69 # bold color
  put_template_custom Pj 100b22 # selection color
  put_template_custom Pk c38e69 # selected text color
  put_template_custom Pl c38e69 # cursor
  put_template_custom Pm 2a1a4a # cursor text
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
  export BASE24_COLOR_00_HEX="2a1a4a"
  export BASE24_COLOR_01_HEX="0a041f"
  export BASE24_COLOR_02_HEX="100b22"
  export BASE24_COLOR_03_HEX="4b3639"
  export BASE24_COLOR_04_HEX="876251"
  export BASE24_COLOR_05_HEX="c38e69"
  export BASE24_COLOR_06_HEX="ffba81"
  export BASE24_COLOR_07_HEX="b9aed3"
  export BASE24_COLOR_08_HEX="ff786c"
  export BASE24_COLOR_09_HEX="efdeab"
  export BASE24_COLOR_0A_HEX="79daed"
  export BASE24_COLOR_0B_HEX="98b481"
  export BASE24_COLOR_0C_HEX="b98cff"
  export BASE24_COLOR_0D_HEX="66d9ef"
  export BASE24_COLOR_0E_HEX="e68ecd"
  export BASE24_COLOR_0F_HEX="7f3c36"
  export BASE24_COLOR_10_HEX="0a0716"
  export BASE24_COLOR_11_HEX="05030b"
  export BASE24_COLOR_12_HEX="f89f92"
  export BASE24_COLOR_13_HEX="f1e9bf"
  export BASE24_COLOR_14_HEX="b4bd8e"
  export BASE24_COLOR_15_HEX="a0a0d6"
  export BASE24_COLOR_16_HEX="79daed"
  export BASE24_COLOR_17_HEX="b991d4"
fi
