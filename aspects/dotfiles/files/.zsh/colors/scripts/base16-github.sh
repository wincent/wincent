#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Github 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="github"

color00="f4/f4/f4" # Base 00 - Black
color01="97/0b/16" # Base 08 - Red
color02="07/96/2a" # Base 0B - Green
color03="2e/6c/ba" # Base 0A - Yellow
color04="00/3e/8a" # Base 0D - Blue
color05="e9/46/91" # Base 0E - Magenta
color06="89/d1/ec" # Base 0C - Cyan
color07="ff/ff/ff" # Base 06 - White
color08="66/66/66" # Base 02 - Bright Black
color09="de/00/00" # Base 12 - Bright Red
color10="87/d5/a2" # Base 14 - Bright Green
color11="f1/d0/07" # Base 13 - Bright Yellow
color12="2e/6c/ba" # Base 16 - Bright Blue
color13="ff/a2/9f" # Base 17 - Bright Magenta
color14="1c/fa/fe" # Base 15 - Bright Cyan
color15="ff/ff/ff" # Base 07 - Bright White
color16="f8/ee/c7" # Base 09
color17="4b/05/0b" # Base 0F
color18="3e/3e/3e" # Base 01
color19="66/66/66" # Base 02
color20="b2/b2/b2" # Base 04
color21="ff/ff/ff" # Base 06
color_foreground="d8/d8/d8" # Base 05
color_background="f4/f4/f4" # Base 00


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
  put_template_custom Pg d8d8d8 # foreground
  put_template_custom Ph f4f4f4 # background
  put_template_custom Pi d8d8d8 # bold color
  put_template_custom Pj 666666 # selection color
  put_template_custom Pk d8d8d8 # selected text color
  put_template_custom Pl d8d8d8 # cursor
  put_template_custom Pm f4f4f4 # cursor text
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
  export BASE24_COLOR_00_HEX="f4f4f4"
  export BASE24_COLOR_01_HEX="3e3e3e"
  export BASE24_COLOR_02_HEX="666666"
  export BASE24_COLOR_03_HEX="8c8c8c"
  export BASE24_COLOR_04_HEX="b2b2b2"
  export BASE24_COLOR_05_HEX="d8d8d8"
  export BASE24_COLOR_06_HEX="ffffff"
  export BASE24_COLOR_07_HEX="ffffff"
  export BASE24_COLOR_08_HEX="970b16"
  export BASE24_COLOR_09_HEX="f8eec7"
  export BASE24_COLOR_0A_HEX="2e6cba"
  export BASE24_COLOR_0B_HEX="07962a"
  export BASE24_COLOR_0C_HEX="89d1ec"
  export BASE24_COLOR_0D_HEX="003e8a"
  export BASE24_COLOR_0E_HEX="e94691"
  export BASE24_COLOR_0F_HEX="4b050b"
  export BASE24_COLOR_10_HEX="444444"
  export BASE24_COLOR_11_HEX="222222"
  export BASE24_COLOR_12_HEX="de0000"
  export BASE24_COLOR_13_HEX="f1d007"
  export BASE24_COLOR_14_HEX="87d5a2"
  export BASE24_COLOR_15_HEX="1cfafe"
  export BASE24_COLOR_16_HEX="2e6cba"
  export BASE24_COLOR_17_HEX="ffa29f"
fi
