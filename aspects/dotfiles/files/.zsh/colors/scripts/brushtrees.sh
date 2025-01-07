#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Brush Trees 
# Scheme author: Abraham White <abelincoln.white@gmail.com>
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="brushtrees"

color00="E3/EF/EF" # Base 00 - Black
color01="b3/86/86" # Base 08 - Red
color02="87/b3/86" # Base 0B - Green
color03="aa/b3/86" # Base 0A - Yellow
color04="86/8c/b3" # Base 0D - Blue
color05="b3/86/b2" # Base 0E - Magenta
color06="86/b3/b3" # Base 0C - Cyan
color07="5A/6D/7A" # Base 06 - White
color08="B0/C5/C8" # Base 02 - Bright Black
color09="b3/86/86" # Base 12 - Bright Red
color10="87/b3/86" # Base 14 - Bright Green
color11="aa/b3/86" # Base 13 - Bright Yellow
color12="86/8c/b3" # Base 16 - Bright Blue
color13="b3/86/b2" # Base 17 - Bright Magenta
color14="86/b3/b3" # Base 15 - Bright Cyan
color15="48/58/67" # Base 07 - Bright White
color16="d8/bb/a2" # Base 09
color17="b3/9f/9f" # Base 0F
color18="C9/DB/DC" # Base 01
color19="B0/C5/C8" # Base 02
color20="82/99/A1" # Base 04
color21="5A/6D/7A" # Base 06
color_foreground="6D/82/8E" # Base 05
color_background="E3/EF/EF" # Base 00


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
  put_template_custom Pg 6D828E # foreground
  put_template_custom Ph E3EFEF # background
  put_template_custom Pi 6D828E # bold color
  put_template_custom Pj B0C5C8 # selection color
  put_template_custom Pk 6D828E # selected text color
  put_template_custom Pl 6D828E # cursor
  put_template_custom Pm E3EFEF # cursor text
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
  export BASE24_COLOR_00_HEX="E3EFEF"
  export BASE24_COLOR_01_HEX="C9DBDC"
  export BASE24_COLOR_02_HEX="B0C5C8"
  export BASE24_COLOR_03_HEX="98AFB5"
  export BASE24_COLOR_04_HEX="8299A1"
  export BASE24_COLOR_05_HEX="6D828E"
  export BASE24_COLOR_06_HEX="5A6D7A"
  export BASE24_COLOR_07_HEX="485867"
  export BASE24_COLOR_08_HEX="b38686"
  export BASE24_COLOR_09_HEX="d8bba2"
  export BASE24_COLOR_0A_HEX="aab386"
  export BASE24_COLOR_0B_HEX="87b386"
  export BASE24_COLOR_0C_HEX="86b3b3"
  export BASE24_COLOR_0D_HEX="868cb3"
  export BASE24_COLOR_0E_HEX="b386b2"
  export BASE24_COLOR_0F_HEX="b39f9f"
  export BASE24_COLOR_10_HEX="E3EFEF"
  export BASE24_COLOR_11_HEX="E3EFEF"
  export BASE24_COLOR_12_HEX="b38686"
  export BASE24_COLOR_13_HEX="aab386"
  export BASE24_COLOR_14_HEX="87b386"
  export BASE24_COLOR_15_HEX="86b3b3"
  export BASE24_COLOR_16_HEX="868cb3"
  export BASE24_COLOR_17_HEX="b386b2"
fi
