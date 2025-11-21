#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Night Owlish Light
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="night-owlish-light"

color00="ff/ff/ff" # Base 00 - Black
color01="d3/42/3e" # Base 08 - Red
color02="2a/a2/98" # Base 0B - Green
color03="da/c8/01" # Base 0A - Yellow
color04="48/76/d6" # Base 0D - Blue
color05="40/3f/53" # Base 0E - Magenta
color06="08/91/6a" # Base 0C - Cyan
color07="58/5b/5b" # Base 05 - White
color08="b1/b4/b4" # Base 03 - Bright Black
color09="f7/6e/6e" # Base 12 - Bright Red
color10="49/d0/c5" # Base 14 - Bright Green
color11="da/c2/6b" # Base 13 - Bright Yellow
color12="5c/a7/e4" # Base 16 - Bright Blue
color13="69/70/98" # Base 17 - Bright Magenta
color14="00/c9/90" # Base 15 - Bright Cyan
color15="01/16/27" # Base 07 - Bright White
color16="da/aa/01" # Base 09
color17="69/21/1f" # Base 0F
color18="e5/e6/e6" # Base 01
color19="cb/cd/cd" # Base 02
color20="71/75/75" # Base 04
color21="3f/41/41" # Base 06
color_foreground="58/5b/5b" # Base 05
color_background="ff/ff/ff" # Base 00


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
  put_template_custom Pg 585b5b # foreground
  put_template_custom Ph ffffff # background
  put_template_custom Pi 585b5b # bold color
  put_template_custom Pj cbcdcd # selection color
  put_template_custom Pk 585b5b # selected text color
  put_template_custom Pl 585b5b # cursor
  put_template_custom Pm ffffff # cursor text
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
  export BASE24_COLOR_00_HEX="ffffff"
  export BASE24_COLOR_01_HEX="e5e6e6"
  export BASE24_COLOR_02_HEX="cbcdcd"
  export BASE24_COLOR_03_HEX="b1b4b4"
  export BASE24_COLOR_04_HEX="717575"
  export BASE24_COLOR_05_HEX="585b5b"
  export BASE24_COLOR_06_HEX="3f4141"
  export BASE24_COLOR_07_HEX="011627"
  export BASE24_COLOR_08_HEX="d3423e"
  export BASE24_COLOR_09_HEX="daaa01"
  export BASE24_COLOR_0A_HEX="dac801"
  export BASE24_COLOR_0B_HEX="2aa298"
  export BASE24_COLOR_0C_HEX="08916a"
  export BASE24_COLOR_0D_HEX="4876d6"
  export BASE24_COLOR_0E_HEX="403f53"
  export BASE24_COLOR_0F_HEX="69211f"
  export BASE24_COLOR_10_HEX="515656"
  export BASE24_COLOR_11_HEX="282b2b"
  export BASE24_COLOR_12_HEX="f76e6e"
  export BASE24_COLOR_13_HEX="dac26b"
  export BASE24_COLOR_14_HEX="49d0c5"
  export BASE24_COLOR_15_HEX="00c990"
  export BASE24_COLOR_16_HEX="5ca7e4"
  export BASE24_COLOR_17_HEX="697098"
fi
