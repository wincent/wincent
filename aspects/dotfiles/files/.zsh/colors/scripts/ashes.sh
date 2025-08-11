#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Ashes
# Scheme author: Jannik Siebert (https://github.com/janniks)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="ashes"

color00="1C/20/23" # Base 00 - Black
color01="C7/AE/95" # Base 08 - Red
color02="95/C7/AE" # Base 0B - Green
color03="AE/C7/95" # Base 0A - Yellow
color04="AE/95/C7" # Base 0D - Blue
color05="C7/95/AE" # Base 0E - Magenta
color06="95/AE/C7" # Base 0C - Cyan
color07="C7/CC/D1" # Base 05 - White
color08="74/7C/84" # Base 03 - Bright Black
color09="C7/AE/95" # Base 12 - Bright Red
color10="95/C7/AE" # Base 14 - Bright Green
color11="AE/C7/95" # Base 13 - Bright Yellow
color12="AE/95/C7" # Base 16 - Bright Blue
color13="C7/95/AE" # Base 17 - Bright Magenta
color14="95/AE/C7" # Base 15 - Bright Cyan
color15="F3/F4/F5" # Base 07 - Bright White
color16="C7/C7/95" # Base 09
color17="C7/95/95" # Base 0F
color18="39/3F/45" # Base 01
color19="56/5E/65" # Base 02
color20="AD/B3/BA" # Base 04
color21="DF/E2/E5" # Base 06
color_foreground="C7/CC/D1" # Base 05
color_background="1C/20/23" # Base 00


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
  put_template_custom Pg C7CCD1 # foreground
  put_template_custom Ph 1C2023 # background
  put_template_custom Pi C7CCD1 # bold color
  put_template_custom Pj 565E65 # selection color
  put_template_custom Pk C7CCD1 # selected text color
  put_template_custom Pl C7CCD1 # cursor
  put_template_custom Pm 1C2023 # cursor text
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
  export BASE24_COLOR_00_HEX="1C2023"
  export BASE24_COLOR_01_HEX="393F45"
  export BASE24_COLOR_02_HEX="565E65"
  export BASE24_COLOR_03_HEX="747C84"
  export BASE24_COLOR_04_HEX="ADB3BA"
  export BASE24_COLOR_05_HEX="C7CCD1"
  export BASE24_COLOR_06_HEX="DFE2E5"
  export BASE24_COLOR_07_HEX="F3F4F5"
  export BASE24_COLOR_08_HEX="C7AE95"
  export BASE24_COLOR_09_HEX="C7C795"
  export BASE24_COLOR_0A_HEX="AEC795"
  export BASE24_COLOR_0B_HEX="95C7AE"
  export BASE24_COLOR_0C_HEX="95AEC7"
  export BASE24_COLOR_0D_HEX="AE95C7"
  export BASE24_COLOR_0E_HEX="C795AE"
  export BASE24_COLOR_0F_HEX="C79595"
  export BASE24_COLOR_10_HEX="1C2023"
  export BASE24_COLOR_11_HEX="1C2023"
  export BASE24_COLOR_12_HEX="C7AE95"
  export BASE24_COLOR_13_HEX="AEC795"
  export BASE24_COLOR_14_HEX="95C7AE"
  export BASE24_COLOR_15_HEX="95AEC7"
  export BASE24_COLOR_16_HEX="AE95C7"
  export BASE24_COLOR_17_HEX="C795AE"
fi
