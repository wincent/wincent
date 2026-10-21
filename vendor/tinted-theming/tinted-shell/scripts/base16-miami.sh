#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Miami
# Scheme author: xscriptor (https://github.com/xscriptor)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE16_THEME=miami

color00="00/00/00" # Base 00 - Black
color01="ff/4c/8b" # Base 08 - Red
color02="7f/ff/d4" # Base 0B - Green
color03="ff/d8/4c" # Base 0A - Yellow
color04="00/ff/a8" # Base 0D - Blue
color05="d3/6c/ff" # Base 0E - Magenta
color06="47/cf/ff" # Base 0C - Cyan
color07="f7/f1/ff" # Base 05 - White
color08="69/67/6c" # Base 03 - Bright Black
color09="$color01" # Base 08 - Bright Red
color10="$color02" # Base 0B - Bright Green
color11="$color03" # Base 0A - Bright Yellow
color12="$color04" # Base 0D - Bright Blue
color13="$color05" # Base 0E - Bright Magenta
color14="$color06" # Base 0C - Bright Cyan
color15="f7/f1/ff" # Base 07 - Bright White
color16="ff/92/6c" # Base 09
color17="a6/5f/46" # Base 0F
color18="11/11/12" # Base 01
color19="1e/1d/1f" # Base 02
color20="88/85/8c" # Base 04
color21="f9/f4/ff" # Base 06
color_foreground="f7/f1/ff" # Base 05
color_background="00/00/00" # Base 00

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
  put_template_custom Pg f7f1ff # foreground
  put_template_custom Ph 000000 # background
  put_template_custom Pi f7f1ff # bold color
  put_template_custom Pj 1e1d1f # selection color
  put_template_custom Pk f7f1ff # selected text color
  put_template_custom Pl f7f1ff # cursor
  put_template_custom Pm 000000 # cursor text
else
  put_template_var 10 "$color_foreground"
  if [ "$BASE16_SHELL_SET_BACKGROUND" != false ]; then
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
if [ -n "$TINTED_SHELL_ENABLE_BASE16_VARS" ] || [ -n "$BASE16_SHELL_ENABLE_VARS" ]; then
  export BASE16_COLOR_00_HEX="000000"
  export BASE16_COLOR_01_HEX="111112"
  export BASE16_COLOR_02_HEX="1e1d1f"
  export BASE16_COLOR_03_HEX="69676c"
  export BASE16_COLOR_04_HEX="88858c"
  export BASE16_COLOR_05_HEX="f7f1ff"
  export BASE16_COLOR_06_HEX="f9f4ff"
  export BASE16_COLOR_07_HEX="f7f1ff"
  export BASE16_COLOR_08_HEX="ff4c8b"
  export BASE16_COLOR_09_HEX="ff926c"
  export BASE16_COLOR_0A_HEX="ffd84c"
  export BASE16_COLOR_0B_HEX="7fffd4"
  export BASE16_COLOR_0C_HEX="47cfff"
  export BASE16_COLOR_0D_HEX="00ffa8"
  export BASE16_COLOR_0E_HEX="d36cff"
  export BASE16_COLOR_0F_HEX="a65f46"
fi
