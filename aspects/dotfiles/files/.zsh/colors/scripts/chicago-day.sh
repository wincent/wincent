#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Chicago Day 
# Scheme author: Wendell, Ryan <ryanjwendell@gmail.com>
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="chicago-day"

color00="e8/f0/ea" # Base 00 - Black
color01="c6/0c/30" # Base 08 - Red
color02="00/9b/3a" # Base 0B - Green
color03="96/84/00" # Base 0A - Yellow
color04="52/23/98" # Base 0D - Blue
color05="e2/7e/a6" # Base 0E - Magenta
color06="00/a1/de" # Base 0C - Cyan
color07="2a/3b/32" # Base 06 - White
color08="b9/d0/c3" # Base 02 - Bright Black
color09="c6/0c/30" # Base 12 - Bright Red
color10="00/9b/3a" # Base 14 - Bright Green
color11="96/84/00" # Base 13 - Bright Yellow
color12="52/23/98" # Base 16 - Bright Blue
color13="e2/7e/a6" # Base 17 - Bright Magenta
color14="00/a1/de" # Base 15 - Bright Cyan
color15="1e/2a/24" # Base 07 - Bright White
color16="f9/46/1c" # Base 09
color17="62/36/1b" # Base 0F
color18="d1/e0/d7" # Base 01
color19="b9/d0/c3" # Base 02
color20="4b/5a/51" # Base 04
color21="2a/3b/32" # Base 06
color_foreground="36/4c/40" # Base 05
color_background="e8/f0/ea" # Base 00


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
  put_template_custom Pg 364c40 # foreground
  put_template_custom Ph e8f0ea # background
  put_template_custom Pi 364c40 # bold color
  put_template_custom Pj b9d0c3 # selection color
  put_template_custom Pk 364c40 # selected text color
  put_template_custom Pl 364c40 # cursor
  put_template_custom Pm e8f0ea # cursor text
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
  export BASE24_COLOR_00_HEX="e8f0ea"
  export BASE24_COLOR_01_HEX="d1e0d7"
  export BASE24_COLOR_02_HEX="b9d0c3"
  export BASE24_COLOR_03_HEX="8a9a91"
  export BASE24_COLOR_04_HEX="4b5a51"
  export BASE24_COLOR_05_HEX="364c40"
  export BASE24_COLOR_06_HEX="2a3b32"
  export BASE24_COLOR_07_HEX="1e2a24"
  export BASE24_COLOR_08_HEX="c60c30"
  export BASE24_COLOR_09_HEX="f9461c"
  export BASE24_COLOR_0A_HEX="968400"
  export BASE24_COLOR_0B_HEX="009b3a"
  export BASE24_COLOR_0C_HEX="00a1de"
  export BASE24_COLOR_0D_HEX="522398"
  export BASE24_COLOR_0E_HEX="e27ea6"
  export BASE24_COLOR_0F_HEX="62361b"
  export BASE24_COLOR_10_HEX="e8f0ea"
  export BASE24_COLOR_11_HEX="e8f0ea"
  export BASE24_COLOR_12_HEX="c60c30"
  export BASE24_COLOR_13_HEX="968400"
  export BASE24_COLOR_14_HEX="009b3a"
  export BASE24_COLOR_15_HEX="00a1de"
  export BASE24_COLOR_16_HEX="522398"
  export BASE24_COLOR_17_HEX="e27ea6"
fi
