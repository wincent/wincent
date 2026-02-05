#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Yesterday Bright
# Scheme author: FroZnShiva (https://github.com/FroZnShiva)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="yesterday-bright"

color00="34/3D/46" # Base 00 - Black
color01="D5/4E/53" # Base 08 - Red
color02="B9/CA/4A" # Base 0B - Green
color03="E7/C5/47" # Base 0A - Yellow
color04="7A/A6/DA" # Base 0D - Blue
color05="C3/97/D8" # Base 0E - Magenta
color06="70/C0/B1" # Base 0C - Cyan
color07="DF/E1/E8" # Base 05 - White
color08="A7/AD/BA" # Base 03 - Bright Black
color09="D5/4E/53" # Base 12 - Bright Red
color10="B9/CA/4A" # Base 14 - Bright Green
color11="E7/C5/47" # Base 13 - Bright Yellow
color12="7A/A6/DA" # Base 16 - Bright Blue
color13="C3/97/D8" # Base 17 - Bright Magenta
color14="70/C0/B1" # Base 15 - Bright Cyan
color15="FF/FF/FF" # Base 07 - Bright White
color16="E7/8C/45" # Base 09
color17="9A/80/6D" # Base 0F
color18="4F/5B/66" # Base 01
color19="65/73/7E" # Base 02
color20="C0/C5/CE" # Base 04
color21="EF/F1/F5" # Base 06
color_foreground="DF/E1/E8" # Base 05
color_background="34/3D/46" # Base 00


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
  put_template_custom Pg DFE1E8 # foreground
  put_template_custom Ph 343D46 # background
  put_template_custom Pi DFE1E8 # bold color
  put_template_custom Pj 65737E # selection color
  put_template_custom Pk DFE1E8 # selected text color
  put_template_custom Pl DFE1E8 # cursor
  put_template_custom Pm 343D46 # cursor text
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
  export BASE24_COLOR_00_HEX="343D46"
  export BASE24_COLOR_01_HEX="4F5B66"
  export BASE24_COLOR_02_HEX="65737E"
  export BASE24_COLOR_03_HEX="A7ADBA"
  export BASE24_COLOR_04_HEX="C0C5CE"
  export BASE24_COLOR_05_HEX="DFE1E8"
  export BASE24_COLOR_06_HEX="EFF1F5"
  export BASE24_COLOR_07_HEX="FFFFFF"
  export BASE24_COLOR_08_HEX="D54E53"
  export BASE24_COLOR_09_HEX="E78C45"
  export BASE24_COLOR_0A_HEX="E7C547"
  export BASE24_COLOR_0B_HEX="B9CA4A"
  export BASE24_COLOR_0C_HEX="70C0B1"
  export BASE24_COLOR_0D_HEX="7AA6DA"
  export BASE24_COLOR_0E_HEX="C397D8"
  export BASE24_COLOR_0F_HEX="9A806D"
  export BASE24_COLOR_10_HEX="343D46"
  export BASE24_COLOR_11_HEX="343D46"
  export BASE24_COLOR_12_HEX="D54E53"
  export BASE24_COLOR_13_HEX="E7C547"
  export BASE24_COLOR_14_HEX="B9CA4A"
  export BASE24_COLOR_15_HEX="70C0B1"
  export BASE24_COLOR_16_HEX="7AA6DA"
  export BASE24_COLOR_17_HEX="C397D8"
fi
