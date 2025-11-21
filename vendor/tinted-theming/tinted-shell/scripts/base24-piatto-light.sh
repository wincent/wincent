#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Piatto Light
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="piatto-light"

color00="ff/ff/ff" # Base 00 - Black
color01="b2/37/71" # Base 08 - Red
color02="66/78/1e" # Base 0B - Green
color03="cd/a4/34" # Base 0A - Yellow
color04="3c/5e/a8" # Base 0D - Blue
color05="a4/54/b2" # Base 0E - Magenta
color06="1e/78/78" # Base 0C - Cyan
color07="51/51/51" # Base 05 - White
color08="c1/c1/c1" # Base 03 - Bright Black
color09="db/33/65" # Base 12 - Bright Red
color10="82/94/29" # Base 14 - Bright Green
color11="cd/6f/34" # Base 13 - Bright Yellow
color12="3c/5e/a8" # Base 16 - Bright Blue
color13="a4/54/b2" # Base 17 - Bright Magenta
color14="17/5e/5e" # Base 15 - Bright Cyan
color15="21/21/21" # Base 07 - Bright White
color16="cd/6f/34" # Base 09
color17="59/1b/38" # Base 0F
color18="f1/f1/f1" # Base 01
color19="e1/e1/e1" # Base 02
color20="71/71/71" # Base 04
color21="41/41/41" # Base 06
color_foreground="51/51/51" # Base 05
color_background="ff/ff/ff" # Base 00


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
  put_template_custom Pg 515151 # foreground
  put_template_custom Ph ffffff # background
  put_template_custom Pi 515151 # bold color
  put_template_custom Pj e1e1e1 # selection color
  put_template_custom Pk 515151 # selected text color
  put_template_custom Pl 515151 # cursor
  put_template_custom Pm ffffff # cursor text
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
  export BASE24_COLOR_00_HEX="ffffff"
  export BASE24_COLOR_01_HEX="f1f1f1"
  export BASE24_COLOR_02_HEX="e1e1e1"
  export BASE24_COLOR_03_HEX="c1c1c1"
  export BASE24_COLOR_04_HEX="717171"
  export BASE24_COLOR_05_HEX="515151"
  export BASE24_COLOR_06_HEX="414141"
  export BASE24_COLOR_07_HEX="212121"
  export BASE24_COLOR_08_HEX="b23771"
  export BASE24_COLOR_09_HEX="cd6f34"
  export BASE24_COLOR_0A_HEX="cda434"
  export BASE24_COLOR_0B_HEX="66781e"
  export BASE24_COLOR_0C_HEX="1e7878"
  export BASE24_COLOR_0D_HEX="3c5ea8"
  export BASE24_COLOR_0E_HEX="a454b2"
  export BASE24_COLOR_0F_HEX="591b38"
  export BASE24_COLOR_10_HEX="2a2a2a"
  export BASE24_COLOR_11_HEX="151515"
  export BASE24_COLOR_12_HEX="db3365"
  export BASE24_COLOR_13_HEX="cd6f34"
  export BASE24_COLOR_14_HEX="829429"
  export BASE24_COLOR_15_HEX="175e5e"
  export BASE24_COLOR_16_HEX="3c5ea8"
  export BASE24_COLOR_17_HEX="a454b2"
fi
