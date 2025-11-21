#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Monokai Vivid
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="monokai-vivid"

color00="12/12/12" # Base 00 - Black
color01="fa/28/34" # Base 08 - Red
color02="97/e1/23" # Base 0B - Green
color03="fe/f2/0a" # Base 0A - Yellow
color04="04/42/fe" # Base 0D - Blue
color05="f8/00/f8" # Base 0E - Magenta
color06="01/b6/ed" # Base 0C - Cyan
color07="df/df/df" # Base 05 - White
color08="52/52/52" # Base 03 - Bright Black
color09="f5/66/9c" # Base 12 - Bright Red
color10="b0/e0/5e" # Base 14 - Bright Green
color11="fe/f2/6c" # Base 13 - Bright Yellow
color12="04/42/fe" # Base 16 - Bright Blue
color13="f2/00/f5" # Base 17 - Bright Magenta
color14="50/cd/fe" # Base 15 - Bright Cyan
color15="ff/ff/ff" # Base 07 - Bright White
color16="fe/c5/0a" # Base 09
color17="7d/14/1a" # Base 0F
color18="32/32/32" # Base 01
color19="42/42/42" # Base 02
color20="c0/c0/c0" # Base 04
color21="f1/f1/f1" # Base 06
color_foreground="df/df/df" # Base 05
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
  put_template_custom Pg dfdfdf # foreground
  put_template_custom Ph 121212 # background
  put_template_custom Pi dfdfdf # bold color
  put_template_custom Pj 424242 # selection color
  put_template_custom Pk dfdfdf # selected text color
  put_template_custom Pl dfdfdf # cursor
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
  export BASE24_COLOR_01_HEX="323232"
  export BASE24_COLOR_02_HEX="424242"
  export BASE24_COLOR_03_HEX="525252"
  export BASE24_COLOR_04_HEX="c0c0c0"
  export BASE24_COLOR_05_HEX="dfdfdf"
  export BASE24_COLOR_06_HEX="f1f1f1"
  export BASE24_COLOR_07_HEX="ffffff"
  export BASE24_COLOR_08_HEX="fa2834"
  export BASE24_COLOR_09_HEX="fec50a"
  export BASE24_COLOR_0A_HEX="fef20a"
  export BASE24_COLOR_0B_HEX="97e123"
  export BASE24_COLOR_0C_HEX="01b6ed"
  export BASE24_COLOR_0D_HEX="0442fe"
  export BASE24_COLOR_0E_HEX="f800f8"
  export BASE24_COLOR_0F_HEX="7d141a"
  export BASE24_COLOR_10_HEX="565656"
  export BASE24_COLOR_11_HEX="2b2b2b"
  export BASE24_COLOR_12_HEX="f5669c"
  export BASE24_COLOR_13_HEX="fef26c"
  export BASE24_COLOR_14_HEX="b0e05e"
  export BASE24_COLOR_15_HEX="50cdfe"
  export BASE24_COLOR_16_HEX="0442fe"
  export BASE24_COLOR_17_HEX="f200f5"
fi
