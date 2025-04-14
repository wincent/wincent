#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Bluloco Light 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="bluloco-light"

color00="f7/f7/f7" # Base 00 - Black
color01="c8/0d/41" # Base 08 - Red
color02="20/88/39" # Base 0B - Green
color03="10/85/d9" # Base 0A - Yellow
color04="1d/44/dd" # Base 0D - Blue
color05="6d/1b/ed" # Base 0E - Magenta
color06="1e/4d/7a" # Base 0C - Cyan
color07="00/00/00" # Base 06 - White
color08="dd/de/e8" # Base 02 - Bright Black
color09="fb/49/6d" # Base 12 - Bright Red
color10="34/b2/53" # Base 14 - Bright Green
color11="b7/93/26" # Base 13 - Bright Yellow
color12="10/85/d9" # Base 16 - Bright Blue
color13="c0/0c/b2" # Base 17 - Bright Magenta
color14="5a/7f/ac" # Base 15 - Bright Cyan
color15="1c/1d/21" # Base 07 - Bright White
color16="d4/4d/16" # Base 09
color17="64/06/20" # Base 0F
color18="cb/cc/d4" # Base 01
color19="dd/de/e8" # Base 02
color20="6f/6f/74" # Base 04
color21="00/00/00" # Base 06
color_foreground="38/38/3a" # Base 05
color_background="f7/f7/f7" # Base 00


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
  put_template_custom Pg 38383a # foreground
  put_template_custom Ph f7f7f7 # background
  put_template_custom Pi 38383a # bold color
  put_template_custom Pj dddee8 # selection color
  put_template_custom Pk 38383a # selected text color
  put_template_custom Pl 38383a # cursor
  put_template_custom Pm f7f7f7 # cursor text
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
  export BASE24_COLOR_00_HEX="f7f7f7"
  export BASE24_COLOR_01_HEX="cbccd4"
  export BASE24_COLOR_02_HEX="dddee8"
  export BASE24_COLOR_03_HEX="a6a7ae"
  export BASE24_COLOR_04_HEX="6f6f74"
  export BASE24_COLOR_05_HEX="38383a"
  export BASE24_COLOR_06_HEX="000000"
  export BASE24_COLOR_07_HEX="1c1d21"
  export BASE24_COLOR_08_HEX="c80d41"
  export BASE24_COLOR_09_HEX="d44d16"
  export BASE24_COLOR_0A_HEX="1085d9"
  export BASE24_COLOR_0B_HEX="208839"
  export BASE24_COLOR_0C_HEX="1e4d7a"
  export BASE24_COLOR_0D_HEX="1d44dd"
  export BASE24_COLOR_0E_HEX="6d1bed"
  export BASE24_COLOR_0F_HEX="640620"
  export BASE24_COLOR_10_HEX="93949a"
  export BASE24_COLOR_11_HEX="494a4d"
  export BASE24_COLOR_12_HEX="fb496d"
  export BASE24_COLOR_13_HEX="b79326"
  export BASE24_COLOR_14_HEX="34b253"
  export BASE24_COLOR_15_HEX="5a7fac"
  export BASE24_COLOR_16_HEX="1085d9"
  export BASE24_COLOR_17_HEX="c00cb2"
fi
