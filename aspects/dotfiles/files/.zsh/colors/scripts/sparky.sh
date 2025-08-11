#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Sparky
# Scheme author: Leila Sother (https://github.com/mixcoac)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="sparky"

color00="07/2B/31" # Base 00 - Black
color01="FF/58/5D" # Base 08 - Red
color02="78/D6/4B" # Base 0B - Green
color03="FB/DD/40" # Base 0A - Yellow
color04="46/98/CB" # Base 0D - Blue
color05="D5/9E/D7" # Base 0E - Magenta
color06="2D/CC/D3" # Base 0C - Cyan
color07="F4/F5/F0" # Base 05 - White
color08="00/3B/49" # Base 03 - Bright Black
color09="FF/72/76" # Base 12 - Bright Red
color10="8E/DD/65" # Base 14 - Bright Green
color11="F6/EB/61" # Base 13 - Bright Yellow
color12="69/B3/E7" # Base 16 - Bright Blue
color13="F9/9F/C9" # Base 17 - Bright Magenta
color14="00/C1/D5" # Base 15 - Bright Cyan
color15="FF/FF/FF" # Base 07 - Bright White
color16="FF/8F/1C" # Base 09
color17="9B/70/4D" # Base 0F
color18="00/31/3C" # Base 01
color19="00/3C/46" # Base 02
color20="00/77/8B" # Base 04
color21="F5/F5/F1" # Base 06
color_foreground="F4/F5/F0" # Base 05
color_background="07/2B/31" # Base 00


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
  put_template_custom Pg F4F5F0 # foreground
  put_template_custom Ph 072B31 # background
  put_template_custom Pi F4F5F0 # bold color
  put_template_custom Pj 003C46 # selection color
  put_template_custom Pk F4F5F0 # selected text color
  put_template_custom Pl F4F5F0 # cursor
  put_template_custom Pm 072B31 # cursor text
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
  export BASE24_COLOR_00_HEX="072B31"
  export BASE24_COLOR_01_HEX="00313C"
  export BASE24_COLOR_02_HEX="003C46"
  export BASE24_COLOR_03_HEX="003B49"
  export BASE24_COLOR_04_HEX="00778B"
  export BASE24_COLOR_05_HEX="F4F5F0"
  export BASE24_COLOR_06_HEX="F5F5F1"
  export BASE24_COLOR_07_HEX="FFFFFF"
  export BASE24_COLOR_08_HEX="FF585D"
  export BASE24_COLOR_09_HEX="FF8F1C"
  export BASE24_COLOR_0A_HEX="FBDD40"
  export BASE24_COLOR_0B_HEX="78D64B"
  export BASE24_COLOR_0C_HEX="2DCCD3"
  export BASE24_COLOR_0D_HEX="4698CB"
  export BASE24_COLOR_0E_HEX="D59ED7"
  export BASE24_COLOR_0F_HEX="9B704D"
  export BASE24_COLOR_10_HEX="4B4F54"
  export BASE24_COLOR_11_HEX="212322"
  export BASE24_COLOR_12_HEX="FF7276"
  export BASE24_COLOR_13_HEX="F6EB61"
  export BASE24_COLOR_14_HEX="8EDD65"
  export BASE24_COLOR_15_HEX="00C1D5"
  export BASE24_COLOR_16_HEX="69B3E7"
  export BASE24_COLOR_17_HEX="F99FC9"
fi
