#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Material Lighter
# Scheme author: Nate Peterson
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="material-lighter"

color00="FA/FA/FA" # Base 00 - Black
color01="FF/53/70" # Base 08 - Red
color02="91/B8/59" # Base 0B - Green
color03="FF/B6/2C" # Base 0A - Yellow
color04="61/82/B8" # Base 0D - Blue
color05="7C/4D/FF" # Base 0E - Magenta
color06="39/AD/B5" # Base 0C - Cyan
color07="80/CB/C4" # Base 05 - White
color08="CC/D7/DA" # Base 03 - Bright Black
color09="FF/53/70" # Base 12 - Bright Red
color10="91/B8/59" # Base 14 - Bright Green
color11="FF/B6/2C" # Base 13 - Bright Yellow
color12="61/82/B8" # Base 16 - Bright Blue
color13="7C/4D/FF" # Base 17 - Bright Magenta
color14="39/AD/B5" # Base 15 - Bright Cyan
color15="FF/FF/FF" # Base 07 - Bright White
color16="F7/6D/47" # Base 09
color17="E5/39/35" # Base 0F
color18="E7/EA/EC" # Base 01
color19="CC/EA/E7" # Base 02
color20="87/96/B0" # Base 04
color21="80/CB/C4" # Base 06
color_foreground="80/CB/C4" # Base 05
color_background="FA/FA/FA" # Base 00


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
  put_template_custom Pg 80CBC4 # foreground
  put_template_custom Ph FAFAFA # background
  put_template_custom Pi 80CBC4 # bold color
  put_template_custom Pj CCEAE7 # selection color
  put_template_custom Pk 80CBC4 # selected text color
  put_template_custom Pl 80CBC4 # cursor
  put_template_custom Pm FAFAFA # cursor text
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
  export BASE24_COLOR_00_HEX="FAFAFA"
  export BASE24_COLOR_01_HEX="E7EAEC"
  export BASE24_COLOR_02_HEX="CCEAE7"
  export BASE24_COLOR_03_HEX="CCD7DA"
  export BASE24_COLOR_04_HEX="8796B0"
  export BASE24_COLOR_05_HEX="80CBC4"
  export BASE24_COLOR_06_HEX="80CBC4"
  export BASE24_COLOR_07_HEX="FFFFFF"
  export BASE24_COLOR_08_HEX="FF5370"
  export BASE24_COLOR_09_HEX="F76D47"
  export BASE24_COLOR_0A_HEX="FFB62C"
  export BASE24_COLOR_0B_HEX="91B859"
  export BASE24_COLOR_0C_HEX="39ADB5"
  export BASE24_COLOR_0D_HEX="6182B8"
  export BASE24_COLOR_0E_HEX="7C4DFF"
  export BASE24_COLOR_0F_HEX="E53935"
  export BASE24_COLOR_10_HEX="FAFAFA"
  export BASE24_COLOR_11_HEX="FAFAFA"
  export BASE24_COLOR_12_HEX="FF5370"
  export BASE24_COLOR_13_HEX="FFB62C"
  export BASE24_COLOR_14_HEX="91B859"
  export BASE24_COLOR_15_HEX="39ADB5"
  export BASE24_COLOR_16_HEX="6182B8"
  export BASE24_COLOR_17_HEX="7C4DFF"
fi
