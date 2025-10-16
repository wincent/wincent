#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Tomorrow Night
# Scheme author: Cody Buell (https://github.com/codybuell)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="tomorrow-night"

color00="1d/1f/21" # Base 00 - Black
color01="cc/66/66" # Base 08 - Red
color02="b5/bd/68" # Base 0B - Green
color03="f0/c6/74" # Base 0A - Yellow
color04="81/a2/be" # Base 0D - Blue
color05="b2/94/bb" # Base 0E - Magenta
color06="8a/be/b7" # Base 0C - Cyan
color07="c5/c8/c6" # Base 05 - White
color08="96/98/96" # Base 03 - Bright Black
color09="e7/4c/3c" # Base 12 - Bright Red
color10="b8/d4/b3" # Base 14 - Bright Green
color11="f7/dc/6f" # Base 13 - Bright Yellow
color12="85/c1/e9" # Base 16 - Bright Blue
color13="d7/a3/ca" # Base 17 - Bright Magenta
color14="95/d3/ce" # Base 15 - Bright Cyan
color15="ff/ff/ff" # Base 07 - Bright White
color16="de/93/5f" # Base 09
color17="a3/68/5a" # Base 0F
color18="28/2a/2e" # Base 01
color19="37/3b/41" # Base 02
color20="b4/b7/b4" # Base 04
color21="e0/e0/e0" # Base 06
color_foreground="c5/c8/c6" # Base 05
color_background="1d/1f/21" # Base 00


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
  put_template_custom Pg c5c8c6 # foreground
  put_template_custom Ph 1d1f21 # background
  put_template_custom Pi c5c8c6 # bold color
  put_template_custom Pj 373b41 # selection color
  put_template_custom Pk c5c8c6 # selected text color
  put_template_custom Pl c5c8c6 # cursor
  put_template_custom Pm 1d1f21 # cursor text
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
  export BASE24_COLOR_00_HEX="1d1f21"
  export BASE24_COLOR_01_HEX="282a2e"
  export BASE24_COLOR_02_HEX="373b41"
  export BASE24_COLOR_03_HEX="969896"
  export BASE24_COLOR_04_HEX="b4b7b4"
  export BASE24_COLOR_05_HEX="c5c8c6"
  export BASE24_COLOR_06_HEX="e0e0e0"
  export BASE24_COLOR_07_HEX="ffffff"
  export BASE24_COLOR_08_HEX="cc6666"
  export BASE24_COLOR_09_HEX="de935f"
  export BASE24_COLOR_0A_HEX="f0c674"
  export BASE24_COLOR_0B_HEX="b5bd68"
  export BASE24_COLOR_0C_HEX="8abeb7"
  export BASE24_COLOR_0D_HEX="81a2be"
  export BASE24_COLOR_0E_HEX="b294bb"
  export BASE24_COLOR_0F_HEX="a3685a"
  export BASE24_COLOR_10_HEX="080909"
  export BASE24_COLOR_11_HEX="2d3135"
  export BASE24_COLOR_12_HEX="e74c3c"
  export BASE24_COLOR_13_HEX="f7dc6f"
  export BASE24_COLOR_14_HEX="b8d4b3"
  export BASE24_COLOR_15_HEX="95d3ce"
  export BASE24_COLOR_16_HEX="85c1e9"
  export BASE24_COLOR_17_HEX="d7a3ca"
fi
