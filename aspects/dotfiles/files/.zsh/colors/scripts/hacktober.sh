#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Hacktober 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="hacktober"

color00="14/14/14" # Base 00 - Black
color01="b3/45/38" # Base 08 - Red
color02="58/77/44" # Base 0B - Green
color03="53/89/c5" # Base 0A - Yellow
color04="20/6e/c5" # Base 0D - Blue
color05="86/46/51" # Base 0E - Magenta
color06="ac/91/66" # Base 0C - Cyan
color07="f1/ee/e7" # Base 06 - White
color08="2c/2b/2a" # Base 02 - Bright Black
color09="b3/33/23" # Base 12 - Bright Red
color10="42/82/4a" # Base 14 - Bright Green
color11="c7/5a/22" # Base 13 - Bright Yellow
color12="53/89/c5" # Base 16 - Bright Blue
color13="e7/95/a5" # Base 17 - Bright Magenta
color14="eb/c5/87" # Base 15 - Bright Cyan
color15="ff/ff/ff" # Base 07 - Bright White
color16="d0/89/49" # Base 09
color17="59/22/1c" # Base 0F
color18="19/19/18" # Base 01
color19="2c/2b/2a" # Base 02
color20="8e/8c/88" # Base 04
color21="f1/ee/e7" # Base 06
color_foreground="bf/bd/b7" # Base 05
color_background="14/14/14" # Base 00


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
  put_template_custom Pg bfbdb7 # foreground
  put_template_custom Ph 141414 # background
  put_template_custom Pi bfbdb7 # bold color
  put_template_custom Pj 2c2b2a # selection color
  put_template_custom Pk bfbdb7 # selected text color
  put_template_custom Pl bfbdb7 # cursor
  put_template_custom Pm 141414 # cursor text
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
  export BASE24_COLOR_00_HEX="141414"
  export BASE24_COLOR_01_HEX="191918"
  export BASE24_COLOR_02_HEX="2c2b2a"
  export BASE24_COLOR_03_HEX="5d5b59"
  export BASE24_COLOR_04_HEX="8e8c88"
  export BASE24_COLOR_05_HEX="bfbdb7"
  export BASE24_COLOR_06_HEX="f1eee7"
  export BASE24_COLOR_07_HEX="ffffff"
  export BASE24_COLOR_08_HEX="b34538"
  export BASE24_COLOR_09_HEX="d08949"
  export BASE24_COLOR_0A_HEX="5389c5"
  export BASE24_COLOR_0B_HEX="587744"
  export BASE24_COLOR_0C_HEX="ac9166"
  export BASE24_COLOR_0D_HEX="206ec5"
  export BASE24_COLOR_0E_HEX="864651"
  export BASE24_COLOR_0F_HEX="59221c"
  export BASE24_COLOR_10_HEX="1d1c1c"
  export BASE24_COLOR_11_HEX="0e0e0e"
  export BASE24_COLOR_12_HEX="b33323"
  export BASE24_COLOR_13_HEX="c75a22"
  export BASE24_COLOR_14_HEX="42824a"
  export BASE24_COLOR_15_HEX="ebc587"
  export BASE24_COLOR_16_HEX="5389c5"
  export BASE24_COLOR_17_HEX="e795a5"
fi
