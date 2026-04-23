#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Swamp Dark
# Scheme author: Masroof Maindak (https://github.com/masroof-maindak)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="swamp-dark"

color00="24/20/15" # Base 00 - Black
color01="DB/93/0D" # Base 08 - Red
color02="7A/76/53" # Base 0B - Green
color03="A8/2D/56" # Base 0A - Yellow
color04="C1/66/6B" # Base 0D - Blue
color05="91/50/6C" # Base 0E - Magenta
color06="DB/93/0D" # Base 0C - Cyan
color07="D2/C3/A4" # Base 05 - White
color08="5F/4E/41" # Base 03 - Bright Black
color09="DB/93/0D" # Base 12 - Bright Red
color10="7A/76/53" # Base 14 - Bright Green
color11="A8/2D/56" # Base 13 - Bright Yellow
color12="C1/66/6B" # Base 16 - Bright Blue
color13="91/50/6C" # Base 17 - Bright Magenta
color14="DB/93/0D" # Base 15 - Bright Cyan
color15="F1/E9/D0" # Base 07 - Bright White
color16="EB/E0/BB" # Base 09
color17="61/A0/A8" # Base 0F
color18="3A/31/24" # Base 01
color19="4D/3F/32" # Base 02
color20="B8/A5/8C" # Base 04
color21="EB/E0/BB" # Base 06
color_foreground="D2/C3/A4" # Base 05
color_background="24/20/15" # Base 00


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
  put_template_custom Pg D2C3A4 # foreground
  put_template_custom Ph 242015 # background
  put_template_custom Pi D2C3A4 # bold color
  put_template_custom Pj 4D3F32 # selection color
  put_template_custom Pk D2C3A4 # selected text color
  put_template_custom Pl D2C3A4 # cursor
  put_template_custom Pm 242015 # cursor text
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
  export BASE24_COLOR_00_HEX="242015"
  export BASE24_COLOR_01_HEX="3A3124"
  export BASE24_COLOR_02_HEX="4D3F32"
  export BASE24_COLOR_03_HEX="5F4E41"
  export BASE24_COLOR_04_HEX="B8A58C"
  export BASE24_COLOR_05_HEX="D2C3A4"
  export BASE24_COLOR_06_HEX="EBE0BB"
  export BASE24_COLOR_07_HEX="F1E9D0"
  export BASE24_COLOR_08_HEX="DB930D"
  export BASE24_COLOR_09_HEX="EBE0BB"
  export BASE24_COLOR_0A_HEX="A82D56"
  export BASE24_COLOR_0B_HEX="7A7653"
  export BASE24_COLOR_0C_HEX="DB930D"
  export BASE24_COLOR_0D_HEX="C1666B"
  export BASE24_COLOR_0E_HEX="91506C"
  export BASE24_COLOR_0F_HEX="61A0A8"
  export BASE24_COLOR_10_HEX="242015"
  export BASE24_COLOR_11_HEX="242015"
  export BASE24_COLOR_12_HEX="DB930D"
  export BASE24_COLOR_13_HEX="A82D56"
  export BASE24_COLOR_14_HEX="7A7653"
  export BASE24_COLOR_15_HEX="DB930D"
  export BASE24_COLOR_16_HEX="C1666B"
  export BASE24_COLOR_17_HEX="91506C"
fi
