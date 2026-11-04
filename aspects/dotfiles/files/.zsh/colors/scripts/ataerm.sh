#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Aftertaerm
# Scheme author: Radek Polasek (https://github.com/radekp31), based on Taerminal by cozywigwam
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="ataerm"

color00="26/28/2a" # Base 00 - Black
color01="ff/88/78" # Base 08 - Red
color02="b4/fb/73" # Base 0B - Green
color03="ff/fc/b7" # Base 0A - Yellow
color04="8b/bc/e5" # Base 0D - Blue
color05="ff/b2/fe" # Base 0E - Magenta
color06="a2/e1/f8" # Base 0C - Cyan
color07="f0/f0/f0" # Base 05 - White
color08="6f/6f/6f" # Base 03 - Bright Black
color09="fe/97/8b" # Base 12 - Bright Red
color10="d6/fc/ba" # Base 14 - Bright Green
color11="ff/fe/d5" # Base 13 - Bright Yellow
color12="c2/e3/ff" # Base 16 - Bright Blue
color13="ff/c6/ff" # Base 17 - Bright Magenta
color14="c0/e9/f8" # Base 15 - Bright Cyan
color15="ff/ff/ff" # Base 07 - Bright White
color16="ff/b8/8a" # Base 09
color17="d6/9a/8a" # Base 0F
color18="30/32/34" # Base 01
color19="3c/3e/41" # Base 02
color20="a8/a8/a8" # Base 04
color21="f1/f1/f1" # Base 06
color_foreground="f0/f0/f0" # Base 05
color_background="26/28/2a" # Base 00


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
  put_template_custom Pg f0f0f0 # foreground
  put_template_custom Ph 26282a # background
  put_template_custom Pi f0f0f0 # bold color
  put_template_custom Pj 3c3e41 # selection color
  put_template_custom Pk f0f0f0 # selected text color
  put_template_custom Pl f0f0f0 # cursor
  put_template_custom Pm 26282a # cursor text
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
  export BASE24_COLOR_00_HEX="26282a"
  export BASE24_COLOR_01_HEX="303234"
  export BASE24_COLOR_02_HEX="3c3e41"
  export BASE24_COLOR_03_HEX="6f6f6f"
  export BASE24_COLOR_04_HEX="a8a8a8"
  export BASE24_COLOR_05_HEX="f0f0f0"
  export BASE24_COLOR_06_HEX="f1f1f1"
  export BASE24_COLOR_07_HEX="ffffff"
  export BASE24_COLOR_08_HEX="ff8878"
  export BASE24_COLOR_09_HEX="ffb88a"
  export BASE24_COLOR_0A_HEX="fffcb7"
  export BASE24_COLOR_0B_HEX="b4fb73"
  export BASE24_COLOR_0C_HEX="a2e1f8"
  export BASE24_COLOR_0D_HEX="8bbce5"
  export BASE24_COLOR_0E_HEX="ffb2fe"
  export BASE24_COLOR_0F_HEX="d69a8a"
  export BASE24_COLOR_10_HEX="1c1d1f"
  export BASE24_COLOR_11_HEX="161718"
  export BASE24_COLOR_12_HEX="fe978b"
  export BASE24_COLOR_13_HEX="fffed5"
  export BASE24_COLOR_14_HEX="d6fcba"
  export BASE24_COLOR_15_HEX="c0e9f8"
  export BASE24_COLOR_16_HEX="c2e3ff"
  export BASE24_COLOR_17_HEX="ffc6ff"
fi
