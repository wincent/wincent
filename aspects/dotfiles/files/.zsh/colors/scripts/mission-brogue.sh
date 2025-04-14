#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Mission Brogue 
# Scheme author: Thomas Leon Highbaugh
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="mission-brogue"

color00="28/31/39" # Base 00 - Black
color01="EF/A9/A9" # Base 08 - Red
color02="8C/D4/B0" # Base 0B - Green
color03="E0/B8/8A" # Base 0A - Yellow
color04="A2/C5/FD" # Base 0D - Blue
color05="CC/B7/DB" # Base 0E - Magenta
color06="93/DF/EC" # Base 0C - Cyan
color07="AB/B9/C4" # Base 06 - White
color08="4D/60/6F" # Base 02 - Bright Black
color09="F6/BF/BF" # Base 12 - Bright Red
color10="b5/E0/90" # Base 14 - Bright Green
color11="FF/F0/B2" # Base 13 - Bright Yellow
color12="C3/D9/FD" # Base 16 - Bright Blue
color13="E3/C3/E6" # Base 17 - Bright Magenta
color14="B2/F0/FD" # Base 15 - Bright Cyan
color15="E7/EB/EE" # Base 07 - Bright White
color16="F2/DB/78" # Base 09
color17="8E/9E/CB" # Base 0F
color18="3B/49/54" # Base 01
color19="4D/60/6F" # Base 02
color20="78/8E/A1" # Base 04
color21="AB/B9/C4" # Base 06
color_foreground="93/A5/B4" # Base 05
color_background="28/31/39" # Base 00


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
  put_template_custom Pg 93A5B4 # foreground
  put_template_custom Ph 283139 # background
  put_template_custom Pi 93A5B4 # bold color
  put_template_custom Pj 4D606F # selection color
  put_template_custom Pk 93A5B4 # selected text color
  put_template_custom Pl 93A5B4 # cursor
  put_template_custom Pm 283139 # cursor text
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
  export BASE24_COLOR_00_HEX="283139"
  export BASE24_COLOR_01_HEX="3B4954"
  export BASE24_COLOR_02_HEX="4D606F"
  export BASE24_COLOR_03_HEX="60778A"
  export BASE24_COLOR_04_HEX="788EA1"
  export BASE24_COLOR_05_HEX="93A5B4"
  export BASE24_COLOR_06_HEX="ABB9C4"
  export BASE24_COLOR_07_HEX="E7EBEE"
  export BASE24_COLOR_08_HEX="EFA9A9"
  export BASE24_COLOR_09_HEX="F2DB78"
  export BASE24_COLOR_0A_HEX="E0B88A"
  export BASE24_COLOR_0B_HEX="8CD4B0"
  export BASE24_COLOR_0C_HEX="93DFEC"
  export BASE24_COLOR_0D_HEX="A2C5FD"
  export BASE24_COLOR_0E_HEX="CCB7DB"
  export BASE24_COLOR_0F_HEX="8E9ECB"
  export BASE24_COLOR_10_HEX="3E3E3B"
  export BASE24_COLOR_11_HEX="79797A"
  export BASE24_COLOR_12_HEX="F6BFBF"
  export BASE24_COLOR_13_HEX="FFF0B2"
  export BASE24_COLOR_14_HEX="b5E090"
  export BASE24_COLOR_15_HEX="B2F0FD"
  export BASE24_COLOR_16_HEX="C3D9FD"
  export BASE24_COLOR_17_HEX="E3C3E6"
fi
