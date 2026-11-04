#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Lumina Canopy Light
# Scheme author: Razik Ikhlef (https://github.com/RazikSF)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="lumina-canopy-light"

color00="f1/f9/ef" # Base 00 - Black
color01="86/0c/2c" # Base 08 - Red
color02="33/75/45" # Base 0B - Green
color03="90/57/05" # Base 0A - Yellow
color04="04/6a/a7" # Base 0D - Blue
color05="65/59/9e" # Base 0E - Magenta
color06="00/71/84" # Base 0C - Cyan
color07="1e/33/23" # Base 05 - White
color08="cd/d7/cb" # Base 03 - Bright Black
color09="5b/1d/26" # Base 12 - Bright Red
color10="20/60/33" # Base 14 - Bright Green
color11="76/46/00" # Base 13 - Bright Yellow
color12="0e/56/86" # Base 16 - Bright Blue
color13="70/39/6c" # Base 17 - Bright Magenta
color14="00/5b/6b" # Base 15 - Bright Cyan
color15="1e/33/23" # Base 07 - Bright White
color16="7b/3c/12" # Base 09
color17="86/4c/82" # Base 0F
color18="e9/f3/e6" # Base 01
color19="dd/e8/db" # Base 02
color20="80/8a/7d" # Base 04
color21="42/4b/3f" # Base 06
color_foreground="1e/33/23" # Base 05
color_background="f1/f9/ef" # Base 00


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
  put_template_custom Pg 1e3323 # foreground
  put_template_custom Ph f1f9ef # background
  put_template_custom Pi 1e3323 # bold color
  put_template_custom Pj dde8db # selection color
  put_template_custom Pk 1e3323 # selected text color
  put_template_custom Pl 1e3323 # cursor
  put_template_custom Pm f1f9ef # cursor text
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
  export BASE24_COLOR_00_HEX="f1f9ef"
  export BASE24_COLOR_01_HEX="e9f3e6"
  export BASE24_COLOR_02_HEX="dde8db"
  export BASE24_COLOR_03_HEX="cdd7cb"
  export BASE24_COLOR_04_HEX="808a7d"
  export BASE24_COLOR_05_HEX="1e3323"
  export BASE24_COLOR_06_HEX="424b3f"
  export BASE24_COLOR_07_HEX="1e3323"
  export BASE24_COLOR_08_HEX="860c2c"
  export BASE24_COLOR_09_HEX="7b3c12"
  export BASE24_COLOR_0A_HEX="905705"
  export BASE24_COLOR_0B_HEX="337545"
  export BASE24_COLOR_0C_HEX="007184"
  export BASE24_COLOR_0D_HEX="046aa7"
  export BASE24_COLOR_0E_HEX="65599e"
  export BASE24_COLOR_0F_HEX="864c82"
  export BASE24_COLOR_10_HEX="fcfffb"
  export BASE24_COLOR_11_HEX="eaf2e8"
  export BASE24_COLOR_12_HEX="5b1d26"
  export BASE24_COLOR_13_HEX="764600"
  export BASE24_COLOR_14_HEX="206033"
  export BASE24_COLOR_15_HEX="005b6b"
  export BASE24_COLOR_16_HEX="0e5686"
  export BASE24_COLOR_17_HEX="70396c"
fi
