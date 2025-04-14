#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Fish Tank 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="fish-tank"

color00="22/24/36" # Base 00 - Black
color01="c6/00/49" # Base 08 - Red
color02="ab/f1/57" # Base 0B - Green
color03="b1/bd/f9" # Base 0A - Yellow
color04="52/5f/b8" # Base 0D - Blue
color05="97/6f/81" # Base 0E - Magenta
color06="96/86/62" # Base 0C - Cyan
color07="ec/ef/fc" # Base 06 - White
color08="6c/5a/30" # Base 02 - Bright Black
color09="d9/4a/8a" # Base 12 - Bright Red
color10="da/ff/a8" # Base 14 - Bright Green
color11="fe/e6/a8" # Base 13 - Bright Yellow
color12="b1/bd/f9" # Base 16 - Bright Blue
color13="fd/a4/cc" # Base 17 - Bright Magenta
color14="a4/bc/86" # Base 15 - Bright Cyan
color15="f6/ff/ec" # Base 07 - Bright White
color16="fd/cd/5e" # Base 09
color17="63/00/24" # Base 0F
color18="03/06/3c" # Base 01
color19="6c/5a/30" # Base 02
color20="ac/a4/96" # Base 04
color21="ec/ef/fc" # Base 06
color_foreground="cc/c9/c9" # Base 05
color_background="22/24/36" # Base 00


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
  put_template_custom Pg ccc9c9 # foreground
  put_template_custom Ph 222436 # background
  put_template_custom Pi ccc9c9 # bold color
  put_template_custom Pj 6c5a30 # selection color
  put_template_custom Pk ccc9c9 # selected text color
  put_template_custom Pl ccc9c9 # cursor
  put_template_custom Pm 222436 # cursor text
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
  export BASE24_COLOR_00_HEX="222436"
  export BASE24_COLOR_01_HEX="03063c"
  export BASE24_COLOR_02_HEX="6c5a30"
  export BASE24_COLOR_03_HEX="8c7f63"
  export BASE24_COLOR_04_HEX="aca496"
  export BASE24_COLOR_05_HEX="ccc9c9"
  export BASE24_COLOR_06_HEX="eceffc"
  export BASE24_COLOR_07_HEX="f6ffec"
  export BASE24_COLOR_08_HEX="c60049"
  export BASE24_COLOR_09_HEX="fdcd5e"
  export BASE24_COLOR_0A_HEX="b1bdf9"
  export BASE24_COLOR_0B_HEX="abf157"
  export BASE24_COLOR_0C_HEX="968662"
  export BASE24_COLOR_0D_HEX="525fb8"
  export BASE24_COLOR_0E_HEX="976f81"
  export BASE24_COLOR_0F_HEX="630024"
  export BASE24_COLOR_10_HEX="483c20"
  export BASE24_COLOR_11_HEX="241e10"
  export BASE24_COLOR_12_HEX="d94a8a"
  export BASE24_COLOR_13_HEX="fee6a8"
  export BASE24_COLOR_14_HEX="daffa8"
  export BASE24_COLOR_15_HEX="a4bc86"
  export BASE24_COLOR_16_HEX="b1bdf9"
  export BASE24_COLOR_17_HEX="fda4cc"
fi
