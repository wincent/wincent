#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Lumina Quartz Light
# Scheme author: Razik Ikhlef (https://github.com/RazikSF)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="lumina-quartz-light"

color00="f5/f7/fa" # Base 00 - Black
color01="7d/2b/28" # Base 08 - Red
color02="21/75/50" # Base 0B - Green
color03="9a/64/2c" # Base 0A - Yellow
color04="44/68/94" # Base 0D - Blue
color05="76/53/a5" # Base 0E - Magenta
color06="00/70/92" # Base 0C - Cyan
color07="30/35/3b" # Base 05 - White
color08="d2/d4/d9" # Base 03 - Bright Black
color09="5a/25/22" # Base 12 - Bright Red
color10="21/5e/41" # Base 14 - Bright Green
color11="82/51/1c" # Base 13 - Bright Yellow
color12="31/54/7e" # Base 16 - Bright Blue
color13="6c/3f/69" # Base 17 - Bright Magenta
color14="11/5a/74" # Base 15 - Bright Cyan
color15="30/35/3b" # Base 07 - Bright White
color16="87/4c/2a" # Base 09
color17="82/52/7e" # Base 0F
color18="ee/f0/f5" # Base 01
color19="e2/e5/e9" # Base 02
color20="84/86/8a" # Base 04
color21="46/48/4b" # Base 06
color_foreground="30/35/3b" # Base 05
color_background="f5/f7/fa" # Base 00


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
  put_template_custom Pg 30353b # foreground
  put_template_custom Ph f5f7fa # background
  put_template_custom Pi 30353b # bold color
  put_template_custom Pj e2e5e9 # selection color
  put_template_custom Pk 30353b # selected text color
  put_template_custom Pl 30353b # cursor
  put_template_custom Pm f5f7fa # cursor text
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
  export BASE24_COLOR_00_HEX="f5f7fa"
  export BASE24_COLOR_01_HEX="eef0f5"
  export BASE24_COLOR_02_HEX="e2e5e9"
  export BASE24_COLOR_03_HEX="d2d4d9"
  export BASE24_COLOR_04_HEX="84868a"
  export BASE24_COLOR_05_HEX="30353b"
  export BASE24_COLOR_06_HEX="46484b"
  export BASE24_COLOR_07_HEX="30353b"
  export BASE24_COLOR_08_HEX="7d2b28"
  export BASE24_COLOR_09_HEX="874c2a"
  export BASE24_COLOR_0A_HEX="9a642c"
  export BASE24_COLOR_0B_HEX="217550"
  export BASE24_COLOR_0C_HEX="007092"
  export BASE24_COLOR_0D_HEX="446894"
  export BASE24_COLOR_0E_HEX="7653a5"
  export BASE24_COLOR_0F_HEX="82527e"
  export BASE24_COLOR_10_HEX="feffff"
  export BASE24_COLOR_11_HEX="eef0f3"
  export BASE24_COLOR_12_HEX="5a2522"
  export BASE24_COLOR_13_HEX="82511c"
  export BASE24_COLOR_14_HEX="215e41"
  export BASE24_COLOR_15_HEX="115a74"
  export BASE24_COLOR_16_HEX="31547e"
  export BASE24_COLOR_17_HEX="6c3f69"
fi
