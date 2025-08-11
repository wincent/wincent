#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: One Half Light
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="one-half-light"

color00="fa/fa/fa" # Base 00 - Black
color01="e4/56/49" # Base 08 - Red
color02="4f/a1/4f" # Base 0B - Green
color03="61/af/ef" # Base 0A - Yellow
color04="00/84/bc" # Base 0D - Blue
color05="a6/25/a4" # Base 0E - Magenta
color06="09/96/b3" # Base 0C - Cyan
color07="cf/d0/d2" # Base 05 - White
color08="79/7c/84" # Base 03 - Bright Black
color09="df/6c/75" # Base 12 - Bright Red
color10="98/c3/79" # Base 14 - Bright Green
color11="e4/c0/7a" # Base 13 - Bright Yellow
color12="61/af/ef" # Base 16 - Bright Blue
color13="c5/77/dd" # Base 17 - Bright Magenta
color14="56/b5/c1" # Base 15 - Bright Cyan
color15="ff/ff/ff" # Base 07 - Bright White
color16="c0/84/00" # Base 09
color17="72/2b/24" # Base 0F
color18="37/39/42" # Base 01
color19="4f/52/5d" # Base 02
color20="a4/a6/ab" # Base 04
color21="fa/fa/fa" # Base 06
color_foreground="cf/d0/d2" # Base 05
color_background="fa/fa/fa" # Base 00


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
  put_template_custom Pg cfd0d2 # foreground
  put_template_custom Ph fafafa # background
  put_template_custom Pi cfd0d2 # bold color
  put_template_custom Pj 4f525d # selection color
  put_template_custom Pk cfd0d2 # selected text color
  put_template_custom Pl cfd0d2 # cursor
  put_template_custom Pm fafafa # cursor text
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
  export BASE24_COLOR_00_HEX="fafafa"
  export BASE24_COLOR_01_HEX="373942"
  export BASE24_COLOR_02_HEX="4f525d"
  export BASE24_COLOR_03_HEX="797c84"
  export BASE24_COLOR_04_HEX="a4a6ab"
  export BASE24_COLOR_05_HEX="cfd0d2"
  export BASE24_COLOR_06_HEX="fafafa"
  export BASE24_COLOR_07_HEX="ffffff"
  export BASE24_COLOR_08_HEX="e45649"
  export BASE24_COLOR_09_HEX="c08400"
  export BASE24_COLOR_0A_HEX="61afef"
  export BASE24_COLOR_0B_HEX="4fa14f"
  export BASE24_COLOR_0C_HEX="0996b3"
  export BASE24_COLOR_0D_HEX="0084bc"
  export BASE24_COLOR_0E_HEX="a625a4"
  export BASE24_COLOR_0F_HEX="722b24"
  export BASE24_COLOR_10_HEX="34363e"
  export BASE24_COLOR_11_HEX="1a1b1f"
  export BASE24_COLOR_12_HEX="df6c75"
  export BASE24_COLOR_13_HEX="e4c07a"
  export BASE24_COLOR_14_HEX="98c379"
  export BASE24_COLOR_15_HEX="56b5c1"
  export BASE24_COLOR_16_HEX="61afef"
  export BASE24_COLOR_17_HEX="c577dd"
fi
