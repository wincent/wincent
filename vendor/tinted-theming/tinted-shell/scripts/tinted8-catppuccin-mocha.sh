#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: tinted8 Catppuccin Mocha
# Scheme author: https://github.com/catppuccin/catppuccin
# Template author: Tinted Theming (https://github.com/tinted-theming)
export TINTED8_THEME="catppuccin-mocha"

color00="1e/1e/2e"
color01="f3/8b/a8"
color02="a6/e3/a1"
color03="f9/e2/af"
color04="89/b4/fa"
color05="cb/a6/f7"
color06="94/e2/d5"
color07="cd/d6/f4"
color08="35/35/54"
color09="f9/c2/d2"
color10="d3/f1/d0"
color11="fc/f6/e9"
color12="c4/d9/fc"
color13="ec/e0/fb"
color14="c4/ef/e8"
color15="ff/ff/ff"
color_foreground="cd/d6/f4"
color_background="1e/1e/2e"

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
  put_template_custom Pg cdd6f4 # foreground
  put_template_custom Ph 1e1e2e # background
  put_template_custom Pi cdd6f4 # bold color
  put_template_custom Pj 353554 # selection color
  put_template_custom Pk cdd6f4 # selected text color
  put_template_custom Pl cdd6f4 # cursor
  put_template_custom Pm 1e1e2e # cursor text
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
  export TINTED8_COLOR_BLACK_NORMAL_HEX="1e1e2e"
  export TINTED8_COLOR_BLACK_RED_HEX="f38ba8"
  export TINTED8_COLOR_BLACK_GREEN_HEX="a6e3a1"
  export TINTED8_COLOR_YELLOW_NORMAL_HEX="f9e2af"
  export TINTED8_COLOR_BLUE_NORMAL_HEX="89b4fa"
  export TINTED8_COLOR_MAGENTA_NORMAL_HEX="cba6f7"
  export TINTED8_COLOR_CYAN_NORMAL_HEX="94e2d5"
  export TINTED8_COLOR_WHITE_NORMAL_HEX="cdd6f4"

  export TINTED8_COLOR_BLACK_BRIGHT_HEX="353554"
  export TINTED8_COLOR_RED_BRIGHT_HEX="f9c2d2"
  export TINTED8_COLOR_GREEN_BRIGHT_HEX="d3f1d0"
  export TINTED8_COLOR_YELLOW_BRIGHT_HEX="fcf6e9"
  export TINTED8_COLOR_BLUE_BRIGHT_HEX="c4d9fc"
  export TINTED8_COLOR_MAGENTA_BRIGHT_HEX="ece0fb"
  export TINTED8_COLOR_CYAN_BRIGHT_HEX="c4efe8"
  export TINTED8_COLOR_WHITE_BRIGHT_HEX="ffffff"

  export TINTED8_COLOR_BLACK_DIM_HEX="181825"
  export TINTED8_COLOR_RED_DIM_HEX="f54c7b"
  export TINTED8_COLOR_GREEN_DIM_HEX="75da6d"
  export TINTED8_COLOR_YELLOW_DIM_HEX="fbd070"
  export TINTED8_COLOR_BLUE_DIM_HEX="478dff"
  export TINTED8_COLOR_MAGENTA_DIM_HEX="aa67f9"
  export TINTED8_COLOR_CYAN_DIM_HEX="89dceb"
  export TINTED8_COLOR_WHITE_DIM_HEX="97abed"
fi
