#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Tokyo Night Dark
# Scheme author: Michaël Ball, based on Tokyo Night by enkia (https://github.com/enkia/tokyo-night-vscode-theme)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="tokyo-night-dark"

color00="1a/1b/26" # Base 00 - Black
color01="c0/ca/f5" # Base 08 - Red
color02="9e/ce/6a" # Base 0B - Green
color03="0d/b9/d7" # Base 0A - Yellow
color04="2a/c3/de" # Base 0D - Blue
color05="bb/9a/f7" # Base 0E - Magenta
color06="b4/f9/f8" # Base 0C - Cyan
color07="a9/b1/d6" # Base 05 - White
color08="44/4b/6a" # Base 03 - Bright Black
color09="ff/7a/93" # Base 12 - Bright Red
color10="73/da/ca" # Base 14 - Bright Green
color11="ff/9e/64" # Base 13 - Bright Yellow
color12="89/dd/ff" # Base 16 - Bright Blue
color13="bb/9a/f7" # Base 17 - Bright Magenta
color14="7d/cf/ff" # Base 15 - Bright Cyan
color15="d5/d6/db" # Base 07 - Bright White
color16="a9/b1/d6" # Base 09
color17="f7/76/8e" # Base 0F
color18="16/16/1e" # Base 01
color19="2f/35/49" # Base 02
color20="78/7c/99" # Base 04
color21="cb/cc/d1" # Base 06
color_foreground="a9/b1/d6" # Base 05
color_background="1a/1b/26" # Base 00


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
  put_template_custom Pg a9b1d6 # foreground
  put_template_custom Ph 1a1b26 # background
  put_template_custom Pi a9b1d6 # bold color
  put_template_custom Pj 2f3549 # selection color
  put_template_custom Pk a9b1d6 # selected text color
  put_template_custom Pl a9b1d6 # cursor
  put_template_custom Pm 1a1b26 # cursor text
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
  export BASE24_COLOR_00_HEX="1a1b26"
  export BASE24_COLOR_01_HEX="16161e"
  export BASE24_COLOR_02_HEX="2f3549"
  export BASE24_COLOR_03_HEX="444b6a"
  export BASE24_COLOR_04_HEX="787c99"
  export BASE24_COLOR_05_HEX="a9b1d6"
  export BASE24_COLOR_06_HEX="cbccd1"
  export BASE24_COLOR_07_HEX="d5d6db"
  export BASE24_COLOR_08_HEX="c0caf5"
  export BASE24_COLOR_09_HEX="a9b1d6"
  export BASE24_COLOR_0A_HEX="0db9d7"
  export BASE24_COLOR_0B_HEX="9ece6a"
  export BASE24_COLOR_0C_HEX="b4f9f8"
  export BASE24_COLOR_0D_HEX="2ac3de"
  export BASE24_COLOR_0E_HEX="bb9af7"
  export BASE24_COLOR_0F_HEX="f7768e"
  export BASE24_COLOR_10_HEX="16161e"
  export BASE24_COLOR_11_HEX="0f0f14"
  export BASE24_COLOR_12_HEX="ff7a93"
  export BASE24_COLOR_13_HEX="ff9e64"
  export BASE24_COLOR_14_HEX="73daca"
  export BASE24_COLOR_15_HEX="7dcfff"
  export BASE24_COLOR_16_HEX="89ddff"
  export BASE24_COLOR_17_HEX="bb9af7"
fi
