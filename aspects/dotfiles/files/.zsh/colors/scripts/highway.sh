#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Highway 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="highway"

color00="21/22/24" # Base 00 - Black
color01="cf/0d/17" # Base 08 - Red
color02="12/80/33" # Base 0B - Green
color03="4f/c2/fd" # Base 0A - Yellow
color04="00/6a/b3" # Base 0D - Blue
color05="6a/26/74" # Base 0E - Magenta
color06="38/45/63" # Base 0C - Cyan
color07="ed/ed/ed" # Base 06 - White
color08="5c/4f/49" # Base 02 - Bright Black
color09="ef/7d/17" # Base 12 - Bright Red
color10="b1/d1/30" # Base 14 - Bright Green
color11="ff/f1/1f" # Base 13 - Bright Yellow
color12="4f/c2/fd" # Base 16 - Bright Blue
color13="de/00/70" # Base 17 - Bright Magenta
color14="5c/4f/49" # Base 15 - Bright Cyan
color15="fe/ff/fe" # Base 07 - Bright White
color16="ff/ca/3d" # Base 09
color17="67/06/0b" # Base 0F
color18="00/00/00" # Base 01
color19="5c/4f/49" # Base 02
color20="a4/9e/9b" # Base 04
color21="ed/ed/ed" # Base 06
color_foreground="c8/c5/c4" # Base 05
color_background="21/22/24" # Base 00


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
  put_template_custom Pg c8c5c4 # foreground
  put_template_custom Ph 212224 # background
  put_template_custom Pi c8c5c4 # bold color
  put_template_custom Pj 5c4f49 # selection color
  put_template_custom Pk c8c5c4 # selected text color
  put_template_custom Pl c8c5c4 # cursor
  put_template_custom Pm 212224 # cursor text
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
  export BASE24_COLOR_00_HEX="212224"
  export BASE24_COLOR_01_HEX="000000"
  export BASE24_COLOR_02_HEX="5c4f49"
  export BASE24_COLOR_03_HEX="807672"
  export BASE24_COLOR_04_HEX="a49e9b"
  export BASE24_COLOR_05_HEX="c8c5c4"
  export BASE24_COLOR_06_HEX="ededed"
  export BASE24_COLOR_07_HEX="fefffe"
  export BASE24_COLOR_08_HEX="cf0d17"
  export BASE24_COLOR_09_HEX="ffca3d"
  export BASE24_COLOR_0A_HEX="4fc2fd"
  export BASE24_COLOR_0B_HEX="128033"
  export BASE24_COLOR_0C_HEX="384563"
  export BASE24_COLOR_0D_HEX="006ab3"
  export BASE24_COLOR_0E_HEX="6a2674"
  export BASE24_COLOR_0F_HEX="67060b"
  export BASE24_COLOR_10_HEX="3d3430"
  export BASE24_COLOR_11_HEX="1e1a18"
  export BASE24_COLOR_12_HEX="ef7d17"
  export BASE24_COLOR_13_HEX="fff11f"
  export BASE24_COLOR_14_HEX="b1d130"
  export BASE24_COLOR_15_HEX="5c4f49"
  export BASE24_COLOR_16_HEX="4fc2fd"
  export BASE24_COLOR_17_HEX="de0070"
fi
