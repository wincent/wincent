#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Arroz con Dulce Dark
# Scheme author: Richard Martinez
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="arroz-con-dulce-dark"

color00="21/14/0F" # Base 00 - Black
color01="E0/7A/8A" # Base 08 - Red
color02="D4/7A/50" # Base 0B - Green
color03="D9/A4/41" # Base 0A - Yellow
color04="B9/9A/C8" # Base 0D - Blue
color05="D5/8A/B4" # Base 0E - Magenta
color06="D9/82/76" # Base 0C - Cyan
color07="F2/DF/C0" # Base 05 - White
color08="A9/85/68" # Base 03 - Bright Black
color09="E0/7A/8A" # Base 12 - Bright Red
color10="D4/7A/50" # Base 14 - Bright Green
color11="D9/A4/41" # Base 13 - Bright Yellow
color12="B9/9A/C8" # Base 16 - Bright Blue
color13="D5/8A/B4" # Base 17 - Bright Magenta
color14="D9/82/76" # Base 15 - Bright Cyan
color15="FF/F8/E7" # Base 07 - Bright White
color16="E6/8A/4A" # Base 09
color17="B9/77/55" # Base 0F
color18="2C/1A/13" # Base 01
color19="3B/24/1A" # Base 02
color20="C8/A7/7A" # Base 04
color21="F8/EB/D3" # Base 06
color_foreground="F2/DF/C0" # Base 05
color_background="21/14/0F" # Base 00


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
  put_template_custom Pg F2DFC0 # foreground
  put_template_custom Ph 21140F # background
  put_template_custom Pi F2DFC0 # bold color
  put_template_custom Pj 3B241A # selection color
  put_template_custom Pk F2DFC0 # selected text color
  put_template_custom Pl F2DFC0 # cursor
  put_template_custom Pm 21140F # cursor text
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
  export BASE24_COLOR_00_HEX="21140F"
  export BASE24_COLOR_01_HEX="2C1A13"
  export BASE24_COLOR_02_HEX="3B241A"
  export BASE24_COLOR_03_HEX="A98568"
  export BASE24_COLOR_04_HEX="C8A77A"
  export BASE24_COLOR_05_HEX="F2DFC0"
  export BASE24_COLOR_06_HEX="F8EBD3"
  export BASE24_COLOR_07_HEX="FFF8E7"
  export BASE24_COLOR_08_HEX="E07A8A"
  export BASE24_COLOR_09_HEX="E68A4A"
  export BASE24_COLOR_0A_HEX="D9A441"
  export BASE24_COLOR_0B_HEX="D47A50"
  export BASE24_COLOR_0C_HEX="D98276"
  export BASE24_COLOR_0D_HEX="B99AC8"
  export BASE24_COLOR_0E_HEX="D58AB4"
  export BASE24_COLOR_0F_HEX="B97755"
  export BASE24_COLOR_10_HEX="21140F"
  export BASE24_COLOR_11_HEX="21140F"
  export BASE24_COLOR_12_HEX="E07A8A"
  export BASE24_COLOR_13_HEX="D9A441"
  export BASE24_COLOR_14_HEX="D47A50"
  export BASE24_COLOR_15_HEX="D98276"
  export BASE24_COLOR_16_HEX="B99AC8"
  export BASE24_COLOR_17_HEX="D58AB4"
fi
