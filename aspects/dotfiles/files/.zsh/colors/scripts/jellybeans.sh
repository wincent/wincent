#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Jellybeans
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="jellybeans"

color00="12/12/12" # Base 00 - Black
color01="e2/73/73" # Base 08 - Red
color02="93/b9/79" # Base 0B - Green
color03="b1/d8/f6" # Base 0A - Yellow
color04="97/be/dc" # Base 0D - Blue
color05="e1/c0/fa" # Base 0E - Magenta
color06="00/98/8e" # Base 0C - Cyan
color07="d5/d5/d5" # Base 05 - White
color08="c5/c5/c5" # Base 03 - Bright Black
color09="ff/a1/a1" # Base 12 - Bright Red
color10="bd/de/ab" # Base 14 - Bright Green
color11="ff/dc/a0" # Base 13 - Bright Yellow
color12="b1/d8/f6" # Base 16 - Bright Blue
color13="fb/da/ff" # Base 17 - Bright Magenta
color14="1a/b2/a8" # Base 15 - Bright Cyan
color15="ff/ff/ff" # Base 07 - Bright White
color16="ff/ba/7b" # Base 09
color17="71/39/39" # Base 0F
color18="92/92/92" # Base 01
color19="bd/bd/bd" # Base 02
color20="cd/cd/cd" # Base 04
color21="de/de/de" # Base 06
color_foreground="d5/d5/d5" # Base 05
color_background="12/12/12" # Base 00


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
  put_template_custom Pg d5d5d5 # foreground
  put_template_custom Ph 121212 # background
  put_template_custom Pi d5d5d5 # bold color
  put_template_custom Pj bdbdbd # selection color
  put_template_custom Pk d5d5d5 # selected text color
  put_template_custom Pl d5d5d5 # cursor
  put_template_custom Pm 121212 # cursor text
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
  export BASE24_COLOR_00_HEX="121212"
  export BASE24_COLOR_01_HEX="929292"
  export BASE24_COLOR_02_HEX="bdbdbd"
  export BASE24_COLOR_03_HEX="c5c5c5"
  export BASE24_COLOR_04_HEX="cdcdcd"
  export BASE24_COLOR_05_HEX="d5d5d5"
  export BASE24_COLOR_06_HEX="dedede"
  export BASE24_COLOR_07_HEX="ffffff"
  export BASE24_COLOR_08_HEX="e27373"
  export BASE24_COLOR_09_HEX="ffba7b"
  export BASE24_COLOR_0A_HEX="b1d8f6"
  export BASE24_COLOR_0B_HEX="93b979"
  export BASE24_COLOR_0C_HEX="00988e"
  export BASE24_COLOR_0D_HEX="97bedc"
  export BASE24_COLOR_0E_HEX="e1c0fa"
  export BASE24_COLOR_0F_HEX="713939"
  export BASE24_COLOR_10_HEX="7e7e7e"
  export BASE24_COLOR_11_HEX="3f3f3f"
  export BASE24_COLOR_12_HEX="ffa1a1"
  export BASE24_COLOR_13_HEX="ffdca0"
  export BASE24_COLOR_14_HEX="bddeab"
  export BASE24_COLOR_15_HEX="1ab2a8"
  export BASE24_COLOR_16_HEX="b1d8f6"
  export BASE24_COLOR_17_HEX="fbdaff"
fi
