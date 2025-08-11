#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Fun Forrest
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="fun-forrest"

color00="24/12/00" # Base 00 - Black
color01="d5/25/2b" # Base 08 - Red
color02="90/9b/00" # Base 0B - Green
color03="7c/c9/ce" # Base 0A - Yellow
color04="46/98/a2" # Base 0D - Blue
color05="8c/42/31" # Base 0E - Magenta
color06="d9/81/12" # Base 0C - Cyan
color07="c5/ab/60" # Base 05 - White
color08="95/7f/58" # Base 03 - Bright Black
color09="e4/59/1b" # Base 12 - Bright Red
color10="bf/c6/59" # Base 14 - Bright Green
color11="ff/ca/1b" # Base 13 - Bright Yellow
color12="7c/c9/ce" # Base 16 - Bright Blue
color13="d1/63/49" # Base 17 - Bright Magenta
color14="e6/a9/6b" # Base 15 - Bright Cyan
color15="ff/e9/a3" # Base 07 - Bright White
color16="bd/8a/13" # Base 09
color17="6a/12/15" # Base 0F
color18="00/00/00" # Base 01
color19="7e/69/54" # Base 02
color20="ad/95/5c" # Base 04
color21="dd/c1/65" # Base 06
color_foreground="c5/ab/60" # Base 05
color_background="24/12/00" # Base 00


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
  put_template_custom Pg c5ab60 # foreground
  put_template_custom Ph 241200 # background
  put_template_custom Pi c5ab60 # bold color
  put_template_custom Pj 7e6954 # selection color
  put_template_custom Pk c5ab60 # selected text color
  put_template_custom Pl c5ab60 # cursor
  put_template_custom Pm 241200 # cursor text
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
  export BASE24_COLOR_00_HEX="241200"
  export BASE24_COLOR_01_HEX="000000"
  export BASE24_COLOR_02_HEX="7e6954"
  export BASE24_COLOR_03_HEX="957f58"
  export BASE24_COLOR_04_HEX="ad955c"
  export BASE24_COLOR_05_HEX="c5ab60"
  export BASE24_COLOR_06_HEX="ddc165"
  export BASE24_COLOR_07_HEX="ffe9a3"
  export BASE24_COLOR_08_HEX="d5252b"
  export BASE24_COLOR_09_HEX="bd8a13"
  export BASE24_COLOR_0A_HEX="7cc9ce"
  export BASE24_COLOR_0B_HEX="909b00"
  export BASE24_COLOR_0C_HEX="d98112"
  export BASE24_COLOR_0D_HEX="4698a2"
  export BASE24_COLOR_0E_HEX="8c4231"
  export BASE24_COLOR_0F_HEX="6a1215"
  export BASE24_COLOR_10_HEX="544638"
  export BASE24_COLOR_11_HEX="2a231c"
  export BASE24_COLOR_12_HEX="e4591b"
  export BASE24_COLOR_13_HEX="ffca1b"
  export BASE24_COLOR_14_HEX="bfc659"
  export BASE24_COLOR_15_HEX="e6a96b"
  export BASE24_COLOR_16_HEX="7cc9ce"
  export BASE24_COLOR_17_HEX="d16349"
fi
