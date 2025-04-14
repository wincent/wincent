#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Blue Berry Pie 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="blue-berry-pie"

color00="1c/0b/28" # Base 00 - Black
color01="99/23/6d" # Base 08 - Red
color02="5b/b0/b2" # Base 0B - Green
color03="38/16/3d" # Base 0A - Yellow
color04="90/a5/bc" # Base 0D - Blue
color05="9d/53/a7" # Base 0E - Magenta
color06="7e/82/cc" # Base 0C - Cyan
color07="f0/e7/d5" # Base 06 - White
color08="1f/16/37" # Base 02 - Bright Black
color09="c7/71/71" # Base 12 - Bright Red
color10="0a/6b/7e" # Base 14 - Bright Green
color11="79/31/88" # Base 13 - Bright Yellow
color12="38/16/3d" # Base 16 - Bright Blue
color13="bc/93/b6" # Base 17 - Bright Magenta
color14="5d/5f/71" # Base 15 - Bright Cyan
color15="0a/6b/7e" # Base 07 - Bright White
color16="e9/b8/a7" # Base 09
color17="4c/11/36" # Base 0F
color18="0a/4b/61" # Base 01
color19="1f/16/37" # Base 02
color20="87/7e/86" # Base 04
color21="f0/e7/d5" # Base 06
color_foreground="bb/b2/ad" # Base 05
color_background="1c/0b/28" # Base 00


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
  put_template_custom Pg bbb2ad # foreground
  put_template_custom Ph 1c0b28 # background
  put_template_custom Pi bbb2ad # bold color
  put_template_custom Pj 1f1637 # selection color
  put_template_custom Pk bbb2ad # selected text color
  put_template_custom Pl bbb2ad # cursor
  put_template_custom Pm 1c0b28 # cursor text
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
  export BASE24_COLOR_00_HEX="1c0b28"
  export BASE24_COLOR_01_HEX="0a4b61"
  export BASE24_COLOR_02_HEX="1f1637"
  export BASE24_COLOR_03_HEX="534a5e"
  export BASE24_COLOR_04_HEX="877e86"
  export BASE24_COLOR_05_HEX="bbb2ad"
  export BASE24_COLOR_06_HEX="f0e7d5"
  export BASE24_COLOR_07_HEX="0a6b7e"
  export BASE24_COLOR_08_HEX="99236d"
  export BASE24_COLOR_09_HEX="e9b8a7"
  export BASE24_COLOR_0A_HEX="38163d"
  export BASE24_COLOR_0B_HEX="5bb0b2"
  export BASE24_COLOR_0C_HEX="7e82cc"
  export BASE24_COLOR_0D_HEX="90a5bc"
  export BASE24_COLOR_0E_HEX="9d53a7"
  export BASE24_COLOR_0F_HEX="4c1136"
  export BASE24_COLOR_10_HEX="140e24"
  export BASE24_COLOR_11_HEX="0a0712"
  export BASE24_COLOR_12_HEX="c77171"
  export BASE24_COLOR_13_HEX="793188"
  export BASE24_COLOR_14_HEX="0a6b7e"
  export BASE24_COLOR_15_HEX="5d5f71"
  export BASE24_COLOR_16_HEX="38163d"
  export BASE24_COLOR_17_HEX="bc93b6"
fi
