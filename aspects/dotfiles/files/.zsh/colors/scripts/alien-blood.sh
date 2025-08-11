#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Alien Blood
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="alien-blood"

color00="0f/16/0f" # Base 00 - Black
color01="7f/2b/26" # Base 08 - Red
color02="2f/7e/25" # Base 0B - Green
color03="00/a9/df" # Base 0A - Yellow
color04="2f/69/7f" # Base 0D - Blue
color05="47/57/7e" # Base 0E - Magenta
color06="31/7f/76" # Base 0C - Cyan
color07="5a/6f/5c" # Base 05 - White
color08="46/54/2a" # Base 03 - Bright Black
color09="df/80/08" # Base 12 - Bright Red
color10="18/e0/00" # Base 14 - Bright Green
color11="bd/e0/00" # Base 13 - Bright Yellow
color12="00/a9/df" # Base 16 - Bright Blue
color13="00/58/df" # Base 17 - Bright Magenta
color14="00/df/c3" # Base 15 - Bright Cyan
color15="73/f9/90" # Base 07 - Bright White
color16="70/7f/23" # Base 09
color17="3f/15/13" # Base 0F
color18="11/26/15" # Base 01
color19="3c/47/11" # Base 02
color20="50/62/43" # Base 04
color21="64/7d/75" # Base 06
color_foreground="5a/6f/5c" # Base 05
color_background="0f/16/0f" # Base 00


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
  put_template_custom Pg 5a6f5c # foreground
  put_template_custom Ph 0f160f # background
  put_template_custom Pi 5a6f5c # bold color
  put_template_custom Pj 3c4711 # selection color
  put_template_custom Pk 5a6f5c # selected text color
  put_template_custom Pl 5a6f5c # cursor
  put_template_custom Pm 0f160f # cursor text
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
  export BASE24_COLOR_00_HEX="0f160f"
  export BASE24_COLOR_01_HEX="112615"
  export BASE24_COLOR_02_HEX="3c4711"
  export BASE24_COLOR_03_HEX="46542a"
  export BASE24_COLOR_04_HEX="506243"
  export BASE24_COLOR_05_HEX="5a6f5c"
  export BASE24_COLOR_06_HEX="647d75"
  export BASE24_COLOR_07_HEX="73f990"
  export BASE24_COLOR_08_HEX="7f2b26"
  export BASE24_COLOR_09_HEX="707f23"
  export BASE24_COLOR_0A_HEX="00a9df"
  export BASE24_COLOR_0B_HEX="2f7e25"
  export BASE24_COLOR_0C_HEX="317f76"
  export BASE24_COLOR_0D_HEX="2f697f"
  export BASE24_COLOR_0E_HEX="47577e"
  export BASE24_COLOR_0F_HEX="3f1513"
  export BASE24_COLOR_10_HEX="282f0b"
  export BASE24_COLOR_11_HEX="141705"
  export BASE24_COLOR_12_HEX="df8008"
  export BASE24_COLOR_13_HEX="bde000"
  export BASE24_COLOR_14_HEX="18e000"
  export BASE24_COLOR_15_HEX="00dfc3"
  export BASE24_COLOR_16_HEX="00a9df"
  export BASE24_COLOR_17_HEX="0058df"
fi
