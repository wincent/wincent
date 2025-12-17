#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: PaperColor Dark
# Scheme author: Nguyen Nguyen (https://github.com/NLKNguyen/papercolor-theme)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="papercolor-dark"

color00="1c/1c/1c" # Base 00 - Black
color01="af/00/5f" # Base 08 - Red
color02="5f/af/00" # Base 0B - Green
color03="d7/af/5f" # Base 0A - Yellow
color04="5f/af/d7" # Base 0D - Blue
color05="af/87/d7" # Base 0E - Magenta
color06="ff/af/00" # Base 0C - Cyan
color07="d0/d0/d0" # Base 05 - White
color08="80/80/80" # Base 03 - Bright Black
color09="d7/00/5f" # Base 12 - Bright Red
color10="ff/d7/5f" # Base 14 - Bright Green
color11="87/d7/5f" # Base 13 - Bright Yellow
color12="ff/d7/00" # Base 16 - Bright Blue
color13="87/d7/ff" # Base 17 - Bright Magenta
color14="87/d7/00" # Base 15 - Bright Cyan
color15="c6/c6/c6" # Base 07 - Bright White
color16="5f/af/5f" # Base 09
color17="ff/5f/af" # Base 0F
color18="30/30/30" # Base 01
color19="3a/3a/3a" # Base 02
color20="58/58/58" # Base 04
color21="bc/bc/bc" # Base 06
color_foreground="d0/d0/d0" # Base 05
color_background="1c/1c/1c" # Base 00


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
  put_template_custom Pg d0d0d0 # foreground
  put_template_custom Ph 1c1c1c # background
  put_template_custom Pi d0d0d0 # bold color
  put_template_custom Pj 3a3a3a # selection color
  put_template_custom Pk d0d0d0 # selected text color
  put_template_custom Pl d0d0d0 # cursor
  put_template_custom Pm 1c1c1c # cursor text
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
  export BASE24_COLOR_00_HEX="1c1c1c"
  export BASE24_COLOR_01_HEX="303030"
  export BASE24_COLOR_02_HEX="3a3a3a"
  export BASE24_COLOR_03_HEX="808080"
  export BASE24_COLOR_04_HEX="585858"
  export BASE24_COLOR_05_HEX="d0d0d0"
  export BASE24_COLOR_06_HEX="bcbcbc"
  export BASE24_COLOR_07_HEX="c6c6c6"
  export BASE24_COLOR_08_HEX="af005f"
  export BASE24_COLOR_09_HEX="5faf5f"
  export BASE24_COLOR_0A_HEX="d7af5f"
  export BASE24_COLOR_0B_HEX="5faf00"
  export BASE24_COLOR_0C_HEX="ffaf00"
  export BASE24_COLOR_0D_HEX="5fafd7"
  export BASE24_COLOR_0E_HEX="af87d7"
  export BASE24_COLOR_0F_HEX="ff5faf"
  export BASE24_COLOR_10_HEX="121212"
  export BASE24_COLOR_11_HEX="080808"
  export BASE24_COLOR_12_HEX="d7005f"
  export BASE24_COLOR_13_HEX="87d75f"
  export BASE24_COLOR_14_HEX="ffd75f"
  export BASE24_COLOR_15_HEX="87d700"
  export BASE24_COLOR_16_HEX="ffd700"
  export BASE24_COLOR_17_HEX="87d7ff"
fi
