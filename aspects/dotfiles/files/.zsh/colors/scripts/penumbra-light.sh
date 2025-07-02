#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Penumbra Light 
# Scheme author: Zachary Weiss (https://github.com/zacharyweiss)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="penumbra-light"

color00="FF/FD/FB" # Base 00 - Black
color01="CA/73/6C" # Base 08 - Red
color02="47/A4/77" # Base 0B - Green
color03="8D/97/41" # Base 0A - Yellow
color04="57/94/D0" # Base 0D - Blue
color05="94/81/CC" # Base 0E - Magenta
color06="00/A2/AF" # Base 0C - Cyan
color07="30/33/38" # Base 06 - White
color08="F2/E6/D4" # Base 02 - Bright Black
color09="CA/73/6C" # Base 12 - Bright Red
color10="47/A4/77" # Base 14 - Bright Green
color11="8D/97/41" # Base 13 - Bright Yellow
color12="57/94/D0" # Base 16 - Bright Blue
color13="94/81/CC" # Base 17 - Bright Magenta
color14="00/A2/AF" # Base 15 - Bright Cyan
color15="24/27/2B" # Base 07 - Bright White
color16="BA/82/3A" # Base 09
color17="BC/73/A4" # Base 0F
color18="FF/F7/ED" # Base 01
color19="F2/E6/D4" # Base 02
color20="8F/8F/8F" # Base 04
color21="30/33/38" # Base 06
color_foreground="63/63/63" # Base 05
color_background="FF/FD/FB" # Base 00


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
  put_template_custom Pg 636363 # foreground
  put_template_custom Ph FFFDFB # background
  put_template_custom Pi 636363 # bold color
  put_template_custom Pj F2E6D4 # selection color
  put_template_custom Pk 636363 # selected text color
  put_template_custom Pl 636363 # cursor
  put_template_custom Pm FFFDFB # cursor text
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
  export BASE24_COLOR_00_HEX="FFFDFB"
  export BASE24_COLOR_01_HEX="FFF7ED"
  export BASE24_COLOR_02_HEX="F2E6D4"
  export BASE24_COLOR_03_HEX="BEBEBE"
  export BASE24_COLOR_04_HEX="8F8F8F"
  export BASE24_COLOR_05_HEX="636363"
  export BASE24_COLOR_06_HEX="303338"
  export BASE24_COLOR_07_HEX="24272B"
  export BASE24_COLOR_08_HEX="CA736C"
  export BASE24_COLOR_09_HEX="BA823A"
  export BASE24_COLOR_0A_HEX="8D9741"
  export BASE24_COLOR_0B_HEX="47A477"
  export BASE24_COLOR_0C_HEX="00A2AF"
  export BASE24_COLOR_0D_HEX="5794D0"
  export BASE24_COLOR_0E_HEX="9481CC"
  export BASE24_COLOR_0F_HEX="BC73A4"
  export BASE24_COLOR_10_HEX="FFFDFB"
  export BASE24_COLOR_11_HEX="FFFDFB"
  export BASE24_COLOR_12_HEX="CA736C"
  export BASE24_COLOR_13_HEX="8D9741"
  export BASE24_COLOR_14_HEX="47A477"
  export BASE24_COLOR_15_HEX="00A2AF"
  export BASE24_COLOR_16_HEX="5794D0"
  export BASE24_COLOR_17_HEX="9481CC"
fi
