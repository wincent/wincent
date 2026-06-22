#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Brasa
# Scheme author: Teshre
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="brasa"

color00="1A/0F/0A" # Base 00 - Black
color01="F2/68/5A" # Base 08 - Red
color02="B8/C2/4A" # Base 0B - Green
color03="F0/B2/3A" # Base 0A - Yellow
color04="9A/A6/E0" # Base 0D - Blue
color05="E6/8A/A2" # Base 0E - Magenta
color06="6B/C8/B8" # Base 0C - Cyan
color07="F0/D8/C0" # Base 05 - White
color08="7A/61/50" # Base 03 - Bright Black
color09="F2/68/5A" # Base 12 - Bright Red
color10="B8/C2/4A" # Base 14 - Bright Green
color11="F0/B2/3A" # Base 13 - Bright Yellow
color12="9A/A6/E0" # Base 16 - Bright Blue
color13="E6/8A/A2" # Base 17 - Bright Magenta
color14="6B/C8/B8" # Base 15 - Bright Cyan
color15="FB/EA/D8" # Base 07 - Bright White
color16="FF/7A/4D" # Base 09
color17="5A/3A/28" # Base 0F
color18="2B/1C/14" # Base 01
color19="45/26/1A" # Base 02
color20="B5/9D/88" # Base 04
color21="F6/E1/CC" # Base 06
color_foreground="F0/D8/C0" # Base 05
color_background="1A/0F/0A" # Base 00


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
  put_template_custom Pg F0D8C0 # foreground
  put_template_custom Ph 1A0F0A # background
  put_template_custom Pi F0D8C0 # bold color
  put_template_custom Pj 45261A # selection color
  put_template_custom Pk F0D8C0 # selected text color
  put_template_custom Pl F0D8C0 # cursor
  put_template_custom Pm 1A0F0A # cursor text
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
  export BASE24_COLOR_00_HEX="1A0F0A"
  export BASE24_COLOR_01_HEX="2B1C14"
  export BASE24_COLOR_02_HEX="45261A"
  export BASE24_COLOR_03_HEX="7A6150"
  export BASE24_COLOR_04_HEX="B59D88"
  export BASE24_COLOR_05_HEX="F0D8C0"
  export BASE24_COLOR_06_HEX="F6E1CC"
  export BASE24_COLOR_07_HEX="FBEAD8"
  export BASE24_COLOR_08_HEX="F2685A"
  export BASE24_COLOR_09_HEX="FF7A4D"
  export BASE24_COLOR_0A_HEX="F0B23A"
  export BASE24_COLOR_0B_HEX="B8C24A"
  export BASE24_COLOR_0C_HEX="6BC8B8"
  export BASE24_COLOR_0D_HEX="9AA6E0"
  export BASE24_COLOR_0E_HEX="E68AA2"
  export BASE24_COLOR_0F_HEX="5A3A28"
  export BASE24_COLOR_10_HEX="1A0F0A"
  export BASE24_COLOR_11_HEX="1A0F0A"
  export BASE24_COLOR_12_HEX="F2685A"
  export BASE24_COLOR_13_HEX="F0B23A"
  export BASE24_COLOR_14_HEX="B8C24A"
  export BASE24_COLOR_15_HEX="6BC8B8"
  export BASE24_COLOR_16_HEX="9AA6E0"
  export BASE24_COLOR_17_HEX="E68AA2"
fi
