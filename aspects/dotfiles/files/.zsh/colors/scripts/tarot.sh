#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: tarot 
# Scheme author: ed (https://codeberg.org/ed)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="tarot"

color00="0e/09/1d" # Base 00 - Black
color01="c5/32/53" # Base 08 - Red
color02="a6/8e/5a" # Base 0B - Green
color03="ff/65/65" # Base 0A - Yellow
color04="6e/60/80" # Base 0D - Blue
color05="a4/57/82" # Base 0E - Magenta
color06="8c/97/85" # Base 0C - Cyan
color07="c4/68/6d" # Base 06 - White
color08="4b/20/54" # Base 02 - Bright Black
color09="c5/32/53" # Base 12 - Bright Red
color10="a6/8e/5a" # Base 14 - Bright Green
color11="ff/65/65" # Base 13 - Bright Yellow
color12="6e/60/80" # Base 16 - Bright Blue
color13="a4/57/82" # Base 17 - Bright Magenta
color14="8c/97/85" # Base 15 - Bright Cyan
color15="dc/8f/7c" # Base 07 - Bright White
color16="ea/4d/60" # Base 09
color17="98/4d/51" # Base 0F
color18="2a/15/3c" # Base 01
color19="4b/20/54" # Base 02
color20="8c/40/6f" # Base 04
color21="c4/68/6d" # Base 06
color_foreground="aa/55/6f" # Base 05
color_background="0e/09/1d" # Base 00


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
  put_template_custom Pg aa556f # foreground
  put_template_custom Ph 0e091d # background
  put_template_custom Pi aa556f # bold color
  put_template_custom Pj 4b2054 # selection color
  put_template_custom Pk aa556f # selected text color
  put_template_custom Pl aa556f # cursor
  put_template_custom Pm 0e091d # cursor text
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
  export BASE24_COLOR_00_HEX="0e091d"
  export BASE24_COLOR_01_HEX="2a153c"
  export BASE24_COLOR_02_HEX="4b2054"
  export BASE24_COLOR_03_HEX="74316b"
  export BASE24_COLOR_04_HEX="8c406f"
  export BASE24_COLOR_05_HEX="aa556f"
  export BASE24_COLOR_06_HEX="c4686d"
  export BASE24_COLOR_07_HEX="dc8f7c"
  export BASE24_COLOR_08_HEX="c53253"
  export BASE24_COLOR_09_HEX="ea4d60"
  export BASE24_COLOR_0A_HEX="ff6565"
  export BASE24_COLOR_0B_HEX="a68e5a"
  export BASE24_COLOR_0C_HEX="8c9785"
  export BASE24_COLOR_0D_HEX="6e6080"
  export BASE24_COLOR_0E_HEX="a45782"
  export BASE24_COLOR_0F_HEX="984d51"
  export BASE24_COLOR_10_HEX="0e091d"
  export BASE24_COLOR_11_HEX="0e091d"
  export BASE24_COLOR_12_HEX="c53253"
  export BASE24_COLOR_13_HEX="ff6565"
  export BASE24_COLOR_14_HEX="a68e5a"
  export BASE24_COLOR_15_HEX="8c9785"
  export BASE24_COLOR_16_HEX="6e6080"
  export BASE24_COLOR_17_HEX="a45782"
fi
