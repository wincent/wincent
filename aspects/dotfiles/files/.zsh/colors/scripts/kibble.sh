#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Kibble 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="kibble"

color00="0e/10/0a" # Base 00 - Black
color01="c7/00/31" # Base 08 - Red
color02="29/cf/13" # Base 0B - Green
color03="97/a4/f7" # Base 0A - Yellow
color04="34/49/d1" # Base 0D - Blue
color05="84/00/ff" # Base 0E - Magenta
color06="07/98/ab" # Base 0C - Cyan
color07="e2/d1/e3" # Base 06 - White
color08="5a/5a/5a" # Base 02 - Bright Black
color09="f0/15/78" # Base 12 - Bright Red
color10="6c/e0/5c" # Base 14 - Bright Green
color11="f3/f7/9e" # Base 13 - Bright Yellow
color12="97/a4/f7" # Base 16 - Bright Blue
color13="c4/95/f0" # Base 17 - Bright Magenta
color14="68/f2/e0" # Base 15 - Bright Cyan
color15="ff/ff/ff" # Base 07 - Bright White
color16="d8/e3/0e" # Base 09
color17="63/00/18" # Base 0F
color18="4d/4d/4d" # Base 01
color19="5a/5a/5a" # Base 02
color20="9e/95/9e" # Base 04
color21="e2/d1/e3" # Base 06
color_foreground="c0/b3/c0" # Base 05
color_background="0e/10/0a" # Base 00


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
  put_template_custom Pg c0b3c0 # foreground
  put_template_custom Ph 0e100a # background
  put_template_custom Pi c0b3c0 # bold color
  put_template_custom Pj 5a5a5a # selection color
  put_template_custom Pk c0b3c0 # selected text color
  put_template_custom Pl c0b3c0 # cursor
  put_template_custom Pm 0e100a # cursor text
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
  export BASE24_COLOR_00_HEX="0e100a"
  export BASE24_COLOR_01_HEX="4d4d4d"
  export BASE24_COLOR_02_HEX="5a5a5a"
  export BASE24_COLOR_03_HEX="7c777c"
  export BASE24_COLOR_04_HEX="9e959e"
  export BASE24_COLOR_05_HEX="c0b3c0"
  export BASE24_COLOR_06_HEX="e2d1e3"
  export BASE24_COLOR_07_HEX="ffffff"
  export BASE24_COLOR_08_HEX="c70031"
  export BASE24_COLOR_09_HEX="d8e30e"
  export BASE24_COLOR_0A_HEX="97a4f7"
  export BASE24_COLOR_0B_HEX="29cf13"
  export BASE24_COLOR_0C_HEX="0798ab"
  export BASE24_COLOR_0D_HEX="3449d1"
  export BASE24_COLOR_0E_HEX="8400ff"
  export BASE24_COLOR_0F_HEX="630018"
  export BASE24_COLOR_10_HEX="3c3c3c"
  export BASE24_COLOR_11_HEX="1e1e1e"
  export BASE24_COLOR_12_HEX="f01578"
  export BASE24_COLOR_13_HEX="f3f79e"
  export BASE24_COLOR_14_HEX="6ce05c"
  export BASE24_COLOR_15_HEX="68f2e0"
  export BASE24_COLOR_16_HEX="97a4f7"
  export BASE24_COLOR_17_HEX="c495f0"
fi
