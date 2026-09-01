#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Pastelón de Amarillos
# Scheme author: Richard Martinez (https://sonofmartinus.com)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="pastelon-de-amarillos"

color00="ff/f4/d6" # Base 00 - Black
color01="a6/3d/4a" # Base 08 - Red
color02="32/70/56" # Base 0B - Green
color03="84/66/00" # Base 0A - Yellow
color04="36/5f/91" # Base 0D - Blue
color05="78/4a/78" # Base 0E - Magenta
color06="27/6e/6c" # Base 0C - Cyan
color07="43/2c/3b" # Base 05 - White
color08="80/61/6b" # Base 03 - Bright Black
color09="a8/6e/00" # Base 12 - Bright Red
color10="00/7b/78" # Base 14 - Bright Green
color11="00/7b/4e" # Base 13 - Bright Yellow
color12="9b/33/95" # Base 16 - Bright Blue
color13="87/30/1f" # Base 17 - Bright Magenta
color14="00/5e/b8" # Base 15 - Bright Cyan
color15="1c/0f/20" # Base 07 - Bright White
color16="9b/5b/19" # Base 09
color17="70/40/35" # Base 0F
color18="f2/d0/83" # Base 01
color19="d6/9b/45" # Base 02
color20="68/46/53" # Base 04
color21="2f/1c/2e" # Base 06
color_foreground="43/2c/3b" # Base 05
color_background="ff/f4/d6" # Base 00


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
  put_template_custom Pg 432c3b # foreground
  put_template_custom Ph fff4d6 # background
  put_template_custom Pi 432c3b # bold color
  put_template_custom Pj d69b45 # selection color
  put_template_custom Pk 432c3b # selected text color
  put_template_custom Pl 432c3b # cursor
  put_template_custom Pm fff4d6 # cursor text
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
  export BASE24_COLOR_00_HEX="fff4d6"
  export BASE24_COLOR_01_HEX="f2d083"
  export BASE24_COLOR_02_HEX="d69b45"
  export BASE24_COLOR_03_HEX="80616b"
  export BASE24_COLOR_04_HEX="684653"
  export BASE24_COLOR_05_HEX="432c3b"
  export BASE24_COLOR_06_HEX="2f1c2e"
  export BASE24_COLOR_07_HEX="1c0f20"
  export BASE24_COLOR_08_HEX="a63d4a"
  export BASE24_COLOR_09_HEX="9b5b19"
  export BASE24_COLOR_0A_HEX="846600"
  export BASE24_COLOR_0B_HEX="327056"
  export BASE24_COLOR_0C_HEX="276e6c"
  export BASE24_COLOR_0D_HEX="365f91"
  export BASE24_COLOR_0E_HEX="784a78"
  export BASE24_COLOR_0F_HEX="704035"
  export BASE24_COLOR_10_HEX="cf2944"
  export BASE24_COLOR_11_HEX="c85d00"
  export BASE24_COLOR_12_HEX="a86e00"
  export BASE24_COLOR_13_HEX="007b4e"
  export BASE24_COLOR_14_HEX="007b78"
  export BASE24_COLOR_15_HEX="005eb8"
  export BASE24_COLOR_16_HEX="9b3395"
  export BASE24_COLOR_17_HEX="87301f"
fi
