#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Lumina Cherenkov Light
# Scheme author: Razik Ikhlef (https://github.com/RazikSF)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="lumina-cherenkov-light"

color00="f5/f8/ff" # Base 00 - Black
color01="a3/22/24" # Base 08 - Red
color02="22/7a/3e" # Base 0B - Green
color03="a3/5f/00" # Base 0A - Yellow
color04="0a/4f/cc" # Base 0D - Blue
color05="78/49/c1" # Base 0E - Magenta
color06="08/71/81" # Base 0C - Cyan
color07="1f/2e/53" # Base 05 - White
color08="d1/d5/df" # Base 03 - Bright Black
color09="79/28/25" # Base 12 - Bright Red
color10="07/65/2c" # Base 14 - Bright Green
color11="87/4e/00" # Base 13 - Bright Yellow
color12="1d/44/8f" # Base 16 - Bright Blue
color13="79/34/74" # Base 17 - Bright Magenta
color14="00/5c/69" # Base 15 - Bright Cyan
color15="1f/2e/53" # Base 07 - Bright White
color16="b5/4a/04" # Base 09
color17="90/47/8a" # Base 0F
color18="ed/f1/fb" # Base 01
color19="e2/e6/ef" # Base 02
color20="82/86/8f" # Base 04
color21="44/48/4f" # Base 06
color_foreground="1f/2e/53" # Base 05
color_background="f5/f8/ff" # Base 00


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
  put_template_custom Pg 1f2e53 # foreground
  put_template_custom Ph f5f8ff # background
  put_template_custom Pi 1f2e53 # bold color
  put_template_custom Pj e2e6ef # selection color
  put_template_custom Pk 1f2e53 # selected text color
  put_template_custom Pl 1f2e53 # cursor
  put_template_custom Pm f5f8ff # cursor text
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
  export BASE24_COLOR_00_HEX="f5f8ff"
  export BASE24_COLOR_01_HEX="edf1fb"
  export BASE24_COLOR_02_HEX="e2e6ef"
  export BASE24_COLOR_03_HEX="d1d5df"
  export BASE24_COLOR_04_HEX="82868f"
  export BASE24_COLOR_05_HEX="1f2e53"
  export BASE24_COLOR_06_HEX="44484f"
  export BASE24_COLOR_07_HEX="1f2e53"
  export BASE24_COLOR_08_HEX="a32224"
  export BASE24_COLOR_09_HEX="b54a04"
  export BASE24_COLOR_0A_HEX="a35f00"
  export BASE24_COLOR_0B_HEX="227a3e"
  export BASE24_COLOR_0C_HEX="087181"
  export BASE24_COLOR_0D_HEX="0a4fcc"
  export BASE24_COLOR_0E_HEX="7849c1"
  export BASE24_COLOR_0F_HEX="90478a"
  export BASE24_COLOR_10_HEX="feffff"
  export BASE24_COLOR_11_HEX="eef1f8"
  export BASE24_COLOR_12_HEX="792825"
  export BASE24_COLOR_13_HEX="874e00"
  export BASE24_COLOR_14_HEX="07652c"
  export BASE24_COLOR_15_HEX="005c69"
  export BASE24_COLOR_16_HEX="1d448f"
  export BASE24_COLOR_17_HEX="793474"
fi
