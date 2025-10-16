#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Mission Brogue
# Scheme author: Thomas Leon Highbaugh
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="mission-brogue"

color00="28/31/39" # Base 00 - Black
color01="ef/a9/a9" # Base 08 - Red
color02="8c/d4/b0" # Base 0B - Green
color03="e0/b8/8a" # Base 0A - Yellow
color04="a2/c5/fd" # Base 0D - Blue
color05="cc/b7/db" # Base 0E - Magenta
color06="93/df/ec" # Base 0C - Cyan
color07="93/a5/b4" # Base 05 - White
color08="60/77/8a" # Base 03 - Bright Black
color09="f6/bf/bf" # Base 12 - Bright Red
color10="b5/e0/90" # Base 14 - Bright Green
color11="ff/f0/b2" # Base 13 - Bright Yellow
color12="c3/d9/fd" # Base 16 - Bright Blue
color13="e3/c3/e6" # Base 17 - Bright Magenta
color14="b2/f0/fd" # Base 15 - Bright Cyan
color15="e7/eb/ee" # Base 07 - Bright White
color16="f2/db/78" # Base 09
color17="8e/9e/cb" # Base 0F
color18="3b/49/54" # Base 01
color19="4d/60/6f" # Base 02
color20="78/8e/a1" # Base 04
color21="ab/b9/c4" # Base 06
color_foreground="93/a5/b4" # Base 05
color_background="28/31/39" # Base 00


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
  put_template_custom Pg 93a5b4 # foreground
  put_template_custom Ph 283139 # background
  put_template_custom Pi 93a5b4 # bold color
  put_template_custom Pj 4d606f # selection color
  put_template_custom Pk 93a5b4 # selected text color
  put_template_custom Pl 93a5b4 # cursor
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
  export BASE24_COLOR_01_HEX="3b4954"
  export BASE24_COLOR_02_HEX="4d606f"
  export BASE24_COLOR_03_HEX="60778a"
  export BASE24_COLOR_04_HEX="788ea1"
  export BASE24_COLOR_05_HEX="93a5b4"
  export BASE24_COLOR_06_HEX="abb9c4"
  export BASE24_COLOR_07_HEX="e7ebee"
  export BASE24_COLOR_08_HEX="efa9a9"
  export BASE24_COLOR_09_HEX="f2db78"
  export BASE24_COLOR_0A_HEX="e0b88a"
  export BASE24_COLOR_0B_HEX="8cd4b0"
  export BASE24_COLOR_0C_HEX="93dfec"
  export BASE24_COLOR_0D_HEX="a2c5fd"
  export BASE24_COLOR_0E_HEX="ccb7db"
  export BASE24_COLOR_0F_HEX="8e9ecb"
  export BASE24_COLOR_10_HEX="3e3e3b"
  export BASE24_COLOR_11_HEX="79797a"
  export BASE24_COLOR_12_HEX="f6bfbf"
  export BASE24_COLOR_13_HEX="fff0b2"
  export BASE24_COLOR_14_HEX="b5e090"
  export BASE24_COLOR_15_HEX="b2f0fd"
  export BASE24_COLOR_16_HEX="c3d9fd"
  export BASE24_COLOR_17_HEX="e3c3e6"
fi
