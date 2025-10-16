#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Sparky
# Scheme author: Leila Sother (https://github.com/mixcoac)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="sparky"

color00="07/2b/31" # Base 00 - Black
color01="ff/58/5d" # Base 08 - Red
color02="78/d6/4b" # Base 0B - Green
color03="fb/dd/40" # Base 0A - Yellow
color04="46/98/cb" # Base 0D - Blue
color05="d5/9e/d7" # Base 0E - Magenta
color06="2d/cc/d3" # Base 0C - Cyan
color07="f4/f5/f0" # Base 05 - White
color08="00/3b/49" # Base 03 - Bright Black
color09="ff/72/76" # Base 12 - Bright Red
color10="8e/dd/65" # Base 14 - Bright Green
color11="f6/eb/61" # Base 13 - Bright Yellow
color12="69/b3/e7" # Base 16 - Bright Blue
color13="f9/9f/c9" # Base 17 - Bright Magenta
color14="00/c1/d5" # Base 15 - Bright Cyan
color15="ff/ff/ff" # Base 07 - Bright White
color16="ff/8f/1c" # Base 09
color17="9b/70/4d" # Base 0F
color18="00/31/3c" # Base 01
color19="00/3c/46" # Base 02
color20="00/77/8b" # Base 04
color21="f5/f5/f1" # Base 06
color_foreground="f4/f5/f0" # Base 05
color_background="07/2b/31" # Base 00


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
  put_template_custom Pg f4f5f0 # foreground
  put_template_custom Ph 072b31 # background
  put_template_custom Pi f4f5f0 # bold color
  put_template_custom Pj 003c46 # selection color
  put_template_custom Pk f4f5f0 # selected text color
  put_template_custom Pl f4f5f0 # cursor
  put_template_custom Pm 072b31 # cursor text
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
  export BASE24_COLOR_00_HEX="072b31"
  export BASE24_COLOR_01_HEX="00313c"
  export BASE24_COLOR_02_HEX="003c46"
  export BASE24_COLOR_03_HEX="003b49"
  export BASE24_COLOR_04_HEX="00778b"
  export BASE24_COLOR_05_HEX="f4f5f0"
  export BASE24_COLOR_06_HEX="f5f5f1"
  export BASE24_COLOR_07_HEX="ffffff"
  export BASE24_COLOR_08_HEX="ff585d"
  export BASE24_COLOR_09_HEX="ff8f1c"
  export BASE24_COLOR_0A_HEX="fbdd40"
  export BASE24_COLOR_0B_HEX="78d64b"
  export BASE24_COLOR_0C_HEX="2dccd3"
  export BASE24_COLOR_0D_HEX="4698cb"
  export BASE24_COLOR_0E_HEX="d59ed7"
  export BASE24_COLOR_0F_HEX="9b704d"
  export BASE24_COLOR_10_HEX="4b4f54"
  export BASE24_COLOR_11_HEX="212322"
  export BASE24_COLOR_12_HEX="ff7276"
  export BASE24_COLOR_13_HEX="f6eb61"
  export BASE24_COLOR_14_HEX="8edd65"
  export BASE24_COLOR_15_HEX="00c1d5"
  export BASE24_COLOR_16_HEX="69b3e7"
  export BASE24_COLOR_17_HEX="f99fc9"
fi
