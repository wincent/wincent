#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Embarcadero
# Scheme author: Thomas Leon Highbaugh
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="embarcadero"

color00="25/2A/2F" # Base 00 - Black
color01="ED/5D/86" # Base 08 - Red
color02="20/C2/90" # Base 0B - Green
color03="EB/82/4D" # Base 0A - Yellow
color04="40/80/D0" # Base 0D - Blue
color05="A0/70/D0" # Base 0E - Magenta
color06="02/EF/EF" # Base 0C - Cyan
color07="BC/BD/C0" # Base 05 - White
color08="7F/82/85" # Base 03 - Bright Black
color09="F5/7D/9A" # Base 12 - Bright Red
color10="A0/D0/A0" # Base 14 - Bright Green
color11="FF/E0/89" # Base 13 - Bright Yellow
color12="80/B0/F0" # Base 16 - Bright Blue
color13="C0/90/F0" # Base 17 - Bright Magenta
color14="40/C0/C0" # Base 15 - Bright Cyan
color15="F8/F8/F8" # Base 07 - Bright White
color16="FF/CB/3D" # Base 09
color17="50/50/9F" # Base 0F
color18="43/47/4C" # Base 01
color19="61/65/68" # Base 02
color20="9E/A0/A2" # Base 04
color21="DA/DB/DB" # Base 06
color_foreground="BC/BD/C0" # Base 05
color_background="25/2A/2F" # Base 00


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
  put_template_custom Pg BCBDC0 # foreground
  put_template_custom Ph 252A2F # background
  put_template_custom Pi BCBDC0 # bold color
  put_template_custom Pj 616568 # selection color
  put_template_custom Pk BCBDC0 # selected text color
  put_template_custom Pl BCBDC0 # cursor
  put_template_custom Pm 252A2F # cursor text
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
  export BASE24_COLOR_00_HEX="252A2F"
  export BASE24_COLOR_01_HEX="43474C"
  export BASE24_COLOR_02_HEX="616568"
  export BASE24_COLOR_03_HEX="7F8285"
  export BASE24_COLOR_04_HEX="9EA0A2"
  export BASE24_COLOR_05_HEX="BCBDC0"
  export BASE24_COLOR_06_HEX="DADBDB"
  export BASE24_COLOR_07_HEX="F8F8F8"
  export BASE24_COLOR_08_HEX="ED5D86"
  export BASE24_COLOR_09_HEX="FFCB3D"
  export BASE24_COLOR_0A_HEX="EB824D"
  export BASE24_COLOR_0B_HEX="20C290"
  export BASE24_COLOR_0C_HEX="02EFEF"
  export BASE24_COLOR_0D_HEX="4080D0"
  export BASE24_COLOR_0E_HEX="A070D0"
  export BASE24_COLOR_0F_HEX="50509F"
  export BASE24_COLOR_10_HEX="373742"
  export BASE24_COLOR_11_HEX="717188"
  export BASE24_COLOR_12_HEX="F57D9A"
  export BASE24_COLOR_13_HEX="FFE089"
  export BASE24_COLOR_14_HEX="A0D0A0"
  export BASE24_COLOR_15_HEX="40C0C0"
  export BASE24_COLOR_16_HEX="80B0F0"
  export BASE24_COLOR_17_HEX="C090F0"
fi
