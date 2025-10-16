#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Github Dark
# Scheme author: Tinted Theming (https://github.com/tinted-theming)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="github-dark"

color00="16/1b/22" # Base 00 - Black
color01="f8/51/49" # Base 08 - Red
color02="2e/a0/43" # Base 0B - Green
color03="bb/80/09" # Base 0A - Yellow
color04="38/8b/fd" # Base 0D - Blue
color05="a3/71/f7" # Base 0E - Magenta
color06="2a/9d/9a" # Base 0C - Cyan
color07="c9/d1/d9" # Base 05 - White
color08="6e/76/81" # Base 03 - Bright Black
color09="ff/7b/72" # Base 12 - Bright Red
color10="3f/b9/50" # Base 14 - Bright Green
color11="d2/99/22" # Base 13 - Bright Yellow
color12="58/a6/ff" # Base 16 - Bright Blue
color13="bc/8c/ff" # Base 17 - Bright Magenta
color14="33/b3/ae" # Base 15 - Bright Cyan
color15="ff/ff/ff" # Base 07 - Bright White
color16="db/6d/28" # Base 09
color17="3d/2f/00" # Base 0F
color18="30/36/3d" # Base 01
color19="48/4f/58" # Base 02
color20="8b/94/9e" # Base 04
color21="f0/f6/fc" # Base 06
color_foreground="c9/d1/d9" # Base 05
color_background="16/1b/22" # Base 00


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
  put_template_custom Pg c9d1d9 # foreground
  put_template_custom Ph 161b22 # background
  put_template_custom Pi c9d1d9 # bold color
  put_template_custom Pj 484f58 # selection color
  put_template_custom Pk c9d1d9 # selected text color
  put_template_custom Pl c9d1d9 # cursor
  put_template_custom Pm 161b22 # cursor text
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
  export BASE24_COLOR_00_HEX="161b22"
  export BASE24_COLOR_01_HEX="30363d"
  export BASE24_COLOR_02_HEX="484f58"
  export BASE24_COLOR_03_HEX="6e7681"
  export BASE24_COLOR_04_HEX="8b949e"
  export BASE24_COLOR_05_HEX="c9d1d9"
  export BASE24_COLOR_06_HEX="f0f6fc"
  export BASE24_COLOR_07_HEX="ffffff"
  export BASE24_COLOR_08_HEX="f85149"
  export BASE24_COLOR_09_HEX="db6d28"
  export BASE24_COLOR_0A_HEX="bb8009"
  export BASE24_COLOR_0B_HEX="2ea043"
  export BASE24_COLOR_0C_HEX="2a9d9a"
  export BASE24_COLOR_0D_HEX="388bfd"
  export BASE24_COLOR_0E_HEX="a371f7"
  export BASE24_COLOR_0F_HEX="3d2f00"
  export BASE24_COLOR_10_HEX="1f2328"
  export BASE24_COLOR_11_HEX="000000"
  export BASE24_COLOR_12_HEX="ff7b72"
  export BASE24_COLOR_13_HEX="d29922"
  export BASE24_COLOR_14_HEX="3fb950"
  export BASE24_COLOR_15_HEX="33b3ae"
  export BASE24_COLOR_16_HEX="58a6ff"
  export BASE24_COLOR_17_HEX="bc8cff"
fi
