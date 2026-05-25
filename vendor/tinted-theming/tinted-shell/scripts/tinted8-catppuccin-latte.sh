#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: tinted8 Catppuccin Latte
# Scheme author: https://github.com/catppuccin/catppuccin
# Template author: Tinted Theming (https://github.com/tinted-theming)
export TINTED8_THEME="catppuccin-latte"

color00="4c/4f/69"
color01="d2/0f/39"
color02="40/a0/2b"
color03="df/8e/1d"
color04="1e/66/f5"
color05="88/39/ef"
color06="17/92/99"
color07="dc/e0/e8"
color08="6c/6f/85"
color09="f8/26/53"
color10="53/d1/38"
color11="ee/aa/4b"
color12="59/8e/f8"
color13="aa/72/f4"
color14="18/cb/d5"
color15="ff/ff/ff"
color_foreground="4c/4f/69"
color_background="dc/e0/e8"

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
  put_template_custom Pg 4c4f69 # foreground
  put_template_custom Ph dce0e8 # background
  put_template_custom Pi 4c4f69 # bold color
  put_template_custom Pj b6bfd1 # selection color
  put_template_custom Pk 4c4f69 # selected text color
  put_template_custom Pl 4c4f69 # cursor
  put_template_custom Pm dce0e8 # cursor text
else
  put_template_var 10 "$color_foreground"
  if [ "$TINTED8_SHELL_SET_BACKGROUND" != false ]; then
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
if [ -n "$TINTED_SHELL_ENABLE_TINTED8_VARS" ]; then
  export TINTED8_COLOR_BLACK_NORMAL_HEX="4c4f69"
  export TINTED8_COLOR_BLACK_RED_HEX="d20f39"
  export TINTED8_COLOR_BLACK_GREEN_HEX="40a02b"
  export TINTED8_COLOR_YELLOW_NORMAL_HEX="df8e1d"
  export TINTED8_COLOR_BLUE_NORMAL_HEX="1e66f5"
  export TINTED8_COLOR_MAGENTA_NORMAL_HEX="8839ef"
  export TINTED8_COLOR_CYAN_NORMAL_HEX="179299"
  export TINTED8_COLOR_WHITE_NORMAL_HEX="dce0e8"

  export TINTED8_COLOR_BLACK_BRIGHT_HEX="6c6f85"
  export TINTED8_COLOR_RED_BRIGHT_HEX="f82653"
  export TINTED8_COLOR_GREEN_BRIGHT_HEX="53d138"
  export TINTED8_COLOR_YELLOW_BRIGHT_HEX="eeaa4b"
  export TINTED8_COLOR_BLUE_BRIGHT_HEX="598ef8"
  export TINTED8_COLOR_MAGENTA_BRIGHT_HEX="aa72f4"
  export TINTED8_COLOR_CYAN_BRIGHT_HEX="18cbd5"
  export TINTED8_COLOR_WHITE_BRIGHT_HEX="ffffff"

  export TINTED8_COLOR_BLACK_DIM_HEX="323446"
  export TINTED8_COLOR_RED_DIM_HEX="9e0627"
  export TINTED8_COLOR_GREEN_DIM_HEX="2c711c"
  export TINTED8_COLOR_YELLOW_DIM_HEX="ae6c11"
  export TINTED8_COLOR_BLUE_DIM_HEX="0248d4"
  export TINTED8_COLOR_MAGENTA_DIM_HEX="670be0"
  export TINTED8_COLOR_CYAN_DIM_HEX="04a5e5"
  export TINTED8_COLOR_WHITE_DIM_HEX="b6bfd1"
fi
