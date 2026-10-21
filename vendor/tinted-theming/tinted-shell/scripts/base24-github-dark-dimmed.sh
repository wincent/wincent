#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Github Dark Dimmed
# Scheme author: Tinted Theming (https://github.com/tinted-theming)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="github-dark-dimmed"

color00="0d/11/17" # Base 00 - Black
color01="f4/70/67" # Base 08 - Red
color02="57/ab/5a" # Base 0B - Green
color03="c6/90/26" # Base 0A - Yellow
color04="53/9b/f5" # Base 0D - Blue
color05="b0/83/f0" # Base 0E - Magenta
color06="39/c5/cf" # Base 0C - Cyan
color07="d1/d7/e0" # Base 05 - White
color08="65/6c/76" # Base 03 - Bright Black
color09="ff/93/8a" # Base 12 - Bright Red
color10="6b/c4/6d" # Base 14 - Bright Green
color11="da/aa/3f" # Base 13 - Bright Yellow
color12="6c/b6/ff" # Base 16 - Bright Blue
color13="dc/bd/fb" # Base 17 - Bright Magenta
color14="56/d4/dd" # Base 15 - Bright Cyan
color15="cd/d9/e5" # Base 07 - Bright White
color16="f6/9d/50" # Base 09
color17="ff/93/8a" # Base 0F
color18="15/1b/23" # Base 01
color19="2f/37/42" # Base 02
color20="91/98/a1" # Base 04
color21="f0/f6/fc" # Base 06
color_foreground="d1/d7/e0" # Base 05
color_background="0d/11/17" # Base 00


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
  put_template_custom Pg d1d7e0 # foreground
  put_template_custom Ph 0d1117 # background
  put_template_custom Pi d1d7e0 # bold color
  put_template_custom Pj 2f3742 # selection color
  put_template_custom Pk d1d7e0 # selected text color
  put_template_custom Pl d1d7e0 # cursor
  put_template_custom Pm 0d1117 # cursor text
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
  export BASE24_COLOR_00_HEX="0d1117"
  export BASE24_COLOR_01_HEX="151b23"
  export BASE24_COLOR_02_HEX="2f3742"
  export BASE24_COLOR_03_HEX="656c76"
  export BASE24_COLOR_04_HEX="9198a1"
  export BASE24_COLOR_05_HEX="d1d7e0"
  export BASE24_COLOR_06_HEX="f0f6fc"
  export BASE24_COLOR_07_HEX="cdd9e5"
  export BASE24_COLOR_08_HEX="f47067"
  export BASE24_COLOR_09_HEX="f69d50"
  export BASE24_COLOR_0A_HEX="c69026"
  export BASE24_COLOR_0B_HEX="57ab5a"
  export BASE24_COLOR_0C_HEX="39c5cf"
  export BASE24_COLOR_0D_HEX="539bf5"
  export BASE24_COLOR_0E_HEX="b083f0"
  export BASE24_COLOR_0F_HEX="ff938a"
  export BASE24_COLOR_10_HEX="010409"
  export BASE24_COLOR_11_HEX="000000"
  export BASE24_COLOR_12_HEX="ff938a"
  export BASE24_COLOR_13_HEX="daaa3f"
  export BASE24_COLOR_14_HEX="6bc46d"
  export BASE24_COLOR_15_HEX="56d4dd"
  export BASE24_COLOR_16_HEX="6cb6ff"
  export BASE24_COLOR_17_HEX="dcbdfb"
fi
