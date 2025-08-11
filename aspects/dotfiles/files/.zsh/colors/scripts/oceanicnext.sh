#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: OceanicNext
# Scheme author: https://github.com/voronianski/oceanic-next-color-scheme
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="oceanicnext"

color00="1B/2B/34" # Base 00 - Black
color01="EC/5f/67" # Base 08 - Red
color02="99/C7/94" # Base 0B - Green
color03="FA/C8/63" # Base 0A - Yellow
color04="66/99/CC" # Base 0D - Blue
color05="C5/94/C5" # Base 0E - Magenta
color06="5F/B3/B3" # Base 0C - Cyan
color07="C0/C5/CE" # Base 05 - White
color08="65/73/7E" # Base 03 - Bright Black
color09="EC/5f/67" # Base 12 - Bright Red
color10="99/C7/94" # Base 14 - Bright Green
color11="FA/C8/63" # Base 13 - Bright Yellow
color12="66/99/CC" # Base 16 - Bright Blue
color13="C5/94/C5" # Base 17 - Bright Magenta
color14="5F/B3/B3" # Base 15 - Bright Cyan
color15="D8/DE/E9" # Base 07 - Bright White
color16="F9/91/57" # Base 09
color17="AB/79/67" # Base 0F
color18="34/3D/46" # Base 01
color19="4F/5B/66" # Base 02
color20="A7/AD/BA" # Base 04
color21="CD/D3/DE" # Base 06
color_foreground="C0/C5/CE" # Base 05
color_background="1B/2B/34" # Base 00


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
  put_template_custom Pg C0C5CE # foreground
  put_template_custom Ph 1B2B34 # background
  put_template_custom Pi C0C5CE # bold color
  put_template_custom Pj 4F5B66 # selection color
  put_template_custom Pk C0C5CE # selected text color
  put_template_custom Pl C0C5CE # cursor
  put_template_custom Pm 1B2B34 # cursor text
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
  export BASE24_COLOR_00_HEX="1B2B34"
  export BASE24_COLOR_01_HEX="343D46"
  export BASE24_COLOR_02_HEX="4F5B66"
  export BASE24_COLOR_03_HEX="65737E"
  export BASE24_COLOR_04_HEX="A7ADBA"
  export BASE24_COLOR_05_HEX="C0C5CE"
  export BASE24_COLOR_06_HEX="CDD3DE"
  export BASE24_COLOR_07_HEX="D8DEE9"
  export BASE24_COLOR_08_HEX="EC5f67"
  export BASE24_COLOR_09_HEX="F99157"
  export BASE24_COLOR_0A_HEX="FAC863"
  export BASE24_COLOR_0B_HEX="99C794"
  export BASE24_COLOR_0C_HEX="5FB3B3"
  export BASE24_COLOR_0D_HEX="6699CC"
  export BASE24_COLOR_0E_HEX="C594C5"
  export BASE24_COLOR_0F_HEX="AB7967"
  export BASE24_COLOR_10_HEX="1B2B34"
  export BASE24_COLOR_11_HEX="1B2B34"
  export BASE24_COLOR_12_HEX="EC5f67"
  export BASE24_COLOR_13_HEX="FAC863"
  export BASE24_COLOR_14_HEX="99C794"
  export BASE24_COLOR_15_HEX="5FB3B3"
  export BASE24_COLOR_16_HEX="6699CC"
  export BASE24_COLOR_17_HEX="C594C5"
fi
