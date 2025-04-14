#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: IC-Orange-PPL 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="ic-orange-ppl"

color00="26/26/26" # Base 00 - Black
color01="c0/39/00" # Base 08 - Red
color02="a3/a9/00" # Base 0B - Green
color03="ff/bd/54" # Base 0A - Yellow
color04="bd/6c/00" # Base 0D - Blue
color05="fb/5d/00" # Base 0E - Magenta
color06="f7/94/00" # Base 0C - Cyan
color07="ff/c8/8a" # Base 06 - White
color08="6a/4e/29" # Base 02 - Bright Black
color09="ff/8b/67" # Base 12 - Bright Red
color10="f6/ff/3f" # Base 14 - Bright Green
color11="ff/e3/6e" # Base 13 - Bright Yellow
color12="ff/bd/54" # Base 16 - Bright Blue
color13="fc/87/4f" # Base 17 - Bright Magenta
color14="c5/97/52" # Base 15 - Bright Cyan
color15="f9/f9/fe" # Base 07 - Bright White
color16="ca/ae/00" # Base 09
color17="60/1c/00" # Base 0F
color18="00/00/00" # Base 01
color19="6a/4e/29" # Base 02
color20="b4/8b/59" # Base 04
color21="ff/c8/8a" # Base 06
color_foreground="d9/a9/71" # Base 05
color_background="26/26/26" # Base 00


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
  put_template_custom Pg d9a971 # foreground
  put_template_custom Ph 262626 # background
  put_template_custom Pi d9a971 # bold color
  put_template_custom Pj 6a4e29 # selection color
  put_template_custom Pk d9a971 # selected text color
  put_template_custom Pl d9a971 # cursor
  put_template_custom Pm 262626 # cursor text
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
  export BASE24_COLOR_00_HEX="262626"
  export BASE24_COLOR_01_HEX="000000"
  export BASE24_COLOR_02_HEX="6a4e29"
  export BASE24_COLOR_03_HEX="8f6c41"
  export BASE24_COLOR_04_HEX="b48b59"
  export BASE24_COLOR_05_HEX="d9a971"
  export BASE24_COLOR_06_HEX="ffc88a"
  export BASE24_COLOR_07_HEX="f9f9fe"
  export BASE24_COLOR_08_HEX="c03900"
  export BASE24_COLOR_09_HEX="caae00"
  export BASE24_COLOR_0A_HEX="ffbd54"
  export BASE24_COLOR_0B_HEX="a3a900"
  export BASE24_COLOR_0C_HEX="f79400"
  export BASE24_COLOR_0D_HEX="bd6c00"
  export BASE24_COLOR_0E_HEX="fb5d00"
  export BASE24_COLOR_0F_HEX="601c00"
  export BASE24_COLOR_10_HEX="46341b"
  export BASE24_COLOR_11_HEX="231a0d"
  export BASE24_COLOR_12_HEX="ff8b67"
  export BASE24_COLOR_13_HEX="ffe36e"
  export BASE24_COLOR_14_HEX="f6ff3f"
  export BASE24_COLOR_15_HEX="c59752"
  export BASE24_COLOR_16_HEX="ffbd54"
  export BASE24_COLOR_17_HEX="fc874f"
fi
