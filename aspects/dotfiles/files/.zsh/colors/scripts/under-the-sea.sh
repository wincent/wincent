#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Under The Sea 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="under-the-sea"

color00="00/10/15" # Base 00 - Black
color01="b1/2f/2c" # Base 08 - Red
color02="00/a9/40" # Base 0B - Green
color03="61/d4/b9" # Base 0A - Yellow
color04="44/99/85" # Base 0D - Blue
color05="00/59/9c" # Base 0E - Magenta
color06="5c/7e/19" # Base 0C - Cyan
color07="40/55/54" # Base 06 - White
color08="37/43/50" # Base 02 - Bright Black
color09="ff/42/42" # Base 12 - Bright Red
color10="2a/ea/5e" # Base 14 - Bright Green
color11="8d/d3/fd" # Base 13 - Bright Yellow
color12="61/d4/b9" # Base 16 - Bright Blue
color13="12/98/ff" # Base 17 - Bright Magenta
color14="98/cf/28" # Base 15 - Bright Cyan
color15="58/fa/d6" # Base 07 - Bright White
color16="58/80/9c" # Base 09
color17="58/17/16" # Base 0F
color18="02/20/26" # Base 01
color19="37/43/50" # Base 02
color20="3b/4c/52" # Base 04
color21="40/55/54" # Base 06
color_foreground="3d/50/53" # Base 05
color_background="00/10/15" # Base 00


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
  put_template_custom Pg 3d5053 # foreground
  put_template_custom Ph 001015 # background
  put_template_custom Pi 3d5053 # bold color
  put_template_custom Pj 374350 # selection color
  put_template_custom Pk 3d5053 # selected text color
  put_template_custom Pl 3d5053 # cursor
  put_template_custom Pm 001015 # cursor text
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
  export BASE24_COLOR_00_HEX="001015"
  export BASE24_COLOR_01_HEX="022026"
  export BASE24_COLOR_02_HEX="374350"
  export BASE24_COLOR_03_HEX="394751"
  export BASE24_COLOR_04_HEX="3b4c52"
  export BASE24_COLOR_05_HEX="3d5053"
  export BASE24_COLOR_06_HEX="405554"
  export BASE24_COLOR_07_HEX="58fad6"
  export BASE24_COLOR_08_HEX="b12f2c"
  export BASE24_COLOR_09_HEX="58809c"
  export BASE24_COLOR_0A_HEX="61d4b9"
  export BASE24_COLOR_0B_HEX="00a940"
  export BASE24_COLOR_0C_HEX="5c7e19"
  export BASE24_COLOR_0D_HEX="449985"
  export BASE24_COLOR_0E_HEX="00599c"
  export BASE24_COLOR_0F_HEX="581716"
  export BASE24_COLOR_10_HEX="242c35"
  export BASE24_COLOR_11_HEX="12161a"
  export BASE24_COLOR_12_HEX="ff4242"
  export BASE24_COLOR_13_HEX="8dd3fd"
  export BASE24_COLOR_14_HEX="2aea5e"
  export BASE24_COLOR_15_HEX="98cf28"
  export BASE24_COLOR_16_HEX="61d4b9"
  export BASE24_COLOR_17_HEX="1298ff"
fi
