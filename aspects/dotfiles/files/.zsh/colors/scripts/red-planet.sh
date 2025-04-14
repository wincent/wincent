#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Red Planet 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="red-planet"

color00="22/22/22" # Base 00 - Black
color01="8c/34/32" # Base 08 - Red
color02="72/82/71" # Base 0B - Green
color03="60/82/7e" # Base 0A - Yellow
color04="69/80/9e" # Base 0D - Blue
color05="89/64/92" # Base 0E - Magenta
color06="5b/83/90" # Base 0C - Cyan
color07="b9/aa/99" # Base 06 - White
color08="67/67/67" # Base 02 - Bright Black
color09="b5/52/42" # Base 12 - Bright Red
color10="86/99/85" # Base 14 - Bright Green
color11="eb/eb/91" # Base 13 - Bright Yellow
color12="60/82/7e" # Base 16 - Bright Blue
color13="de/48/73" # Base 17 - Bright Magenta
color14="38/ad/d8" # Base 15 - Bright Cyan
color15="d6/bf/b8" # Base 07 - Bright White
color16="e8/bf/6a" # Base 09
color17="46/1a/19" # Base 0F
color18="20/1f/1f" # Base 01
color19="67/67/67" # Base 02
color20="90/88/80" # Base 04
color21="b9/aa/99" # Base 06
color_foreground="a4/99/8c" # Base 05
color_background="22/22/22" # Base 00


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
  put_template_custom Pg a4998c # foreground
  put_template_custom Ph 222222 # background
  put_template_custom Pi a4998c # bold color
  put_template_custom Pj 676767 # selection color
  put_template_custom Pk a4998c # selected text color
  put_template_custom Pl a4998c # cursor
  put_template_custom Pm 222222 # cursor text
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
  export BASE24_COLOR_00_HEX="222222"
  export BASE24_COLOR_01_HEX="201f1f"
  export BASE24_COLOR_02_HEX="676767"
  export BASE24_COLOR_03_HEX="7b7773"
  export BASE24_COLOR_04_HEX="908880"
  export BASE24_COLOR_05_HEX="a4998c"
  export BASE24_COLOR_06_HEX="b9aa99"
  export BASE24_COLOR_07_HEX="d6bfb8"
  export BASE24_COLOR_08_HEX="8c3432"
  export BASE24_COLOR_09_HEX="e8bf6a"
  export BASE24_COLOR_0A_HEX="60827e"
  export BASE24_COLOR_0B_HEX="728271"
  export BASE24_COLOR_0C_HEX="5b8390"
  export BASE24_COLOR_0D_HEX="69809e"
  export BASE24_COLOR_0E_HEX="896492"
  export BASE24_COLOR_0F_HEX="461a19"
  export BASE24_COLOR_10_HEX="444444"
  export BASE24_COLOR_11_HEX="222222"
  export BASE24_COLOR_12_HEX="b55242"
  export BASE24_COLOR_13_HEX="ebeb91"
  export BASE24_COLOR_14_HEX="869985"
  export BASE24_COLOR_15_HEX="38add8"
  export BASE24_COLOR_16_HEX="60827e"
  export BASE24_COLOR_17_HEX="de4873"
fi
