#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Noche
# Scheme author: Teshre
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="noche"

color00="0C/0E/16" # Base 00 - Black
color01="E2/72/7E" # Base 08 - Red
color02="7C/C5/96" # Base 0B - Green
color03="D8/C0/62" # Base 0A - Yellow
color04="7A/A0/E8" # Base 0D - Blue
color05="B7/9A/E0" # Base 0E - Magenta
color06="6D/D8/D0" # Base 0C - Cyan
color07="CB/D4/EC" # Base 05 - White
color08="5A/61/78" # Base 03 - Bright Black
color09="E2/72/7E" # Base 12 - Bright Red
color10="7C/C5/96" # Base 14 - Bright Green
color11="D8/C0/62" # Base 13 - Bright Yellow
color12="7A/A0/E8" # Base 16 - Bright Blue
color13="B7/9A/E0" # Base 17 - Bright Magenta
color14="6D/D8/D0" # Base 15 - Bright Cyan
color15="E6/EC/FA" # Base 07 - Bright White
color16="82/A6/E0" # Base 09
color17="3A/42/60" # Base 0F
color18="18/1C/2C" # Base 01
color19="23/2A/40" # Base 02
color20="93/9B/B2" # Base 04
color21="D9/E0/F3" # Base 06
color_foreground="CB/D4/EC" # Base 05
color_background="0C/0E/16" # Base 00


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

# 256 color space
put_template 16 "$color16"
put_template 17 "$color17"
put_template 18 "$color18"
put_template 19 "$color19"
put_template 20 "$color20"
put_template 21 "$color21"

# foreground / background / cursor color
if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  put_template_custom Pg CBD4EC # foreground
  put_template_custom Ph 0C0E16 # background
  put_template_custom Pi CBD4EC # bold color
  put_template_custom Pj 232A40 # selection color
  put_template_custom Pk CBD4EC # selected text color
  put_template_custom Pl CBD4EC # cursor
  put_template_custom Pm 0C0E16 # cursor text
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
unset color15
unset color16
unset color17
unset color18
unset color19
unset color20
unset color21
unset color_foreground
unset color_background

# Optionally export variables
if [ -n "$TINTED_SHELL_ENABLE_BASE24_VARS" ]; then
  export BASE24_COLOR_00_HEX="0C0E16"
  export BASE24_COLOR_01_HEX="181C2C"
  export BASE24_COLOR_02_HEX="232A40"
  export BASE24_COLOR_03_HEX="5A6178"
  export BASE24_COLOR_04_HEX="939BB2"
  export BASE24_COLOR_05_HEX="CBD4EC"
  export BASE24_COLOR_06_HEX="D9E0F3"
  export BASE24_COLOR_07_HEX="E6ECFA"
  export BASE24_COLOR_08_HEX="E2727E"
  export BASE24_COLOR_09_HEX="82A6E0"
  export BASE24_COLOR_0A_HEX="D8C062"
  export BASE24_COLOR_0B_HEX="7CC596"
  export BASE24_COLOR_0C_HEX="6DD8D0"
  export BASE24_COLOR_0D_HEX="7AA0E8"
  export BASE24_COLOR_0E_HEX="B79AE0"
  export BASE24_COLOR_0F_HEX="3A4260"
  export BASE24_COLOR_10_HEX="0C0E16"
  export BASE24_COLOR_11_HEX="0C0E16"
  export BASE24_COLOR_12_HEX="E2727E"
  export BASE24_COLOR_13_HEX="D8C062"
  export BASE24_COLOR_14_HEX="7CC596"
  export BASE24_COLOR_15_HEX="6DD8D0"
  export BASE24_COLOR_16_HEX="7AA0E8"
  export BASE24_COLOR_17_HEX="B79AE0"
fi
