#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: tinted8 Gruvbox Dark
# Scheme author: Tinted Theming (https://github.com/tinted-theming)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export TINTED8_THEME="gruvbox-dark"

color00="28/28/28"
color01="cc/24/1d"
color02="98/97/1a"
color03="d7/99/21"
color04="45/85/88"
color05="b1/62/86"
color06="68/9d/6a"
color07="eb/db/b2"
color08="3c/38/36"
color09="fb/49/34"
color10="b8/bb/26"
color11="fa/bd/2f"
color12="83/a5/98"
color13="d3/86/9b"
color14="8e/c0/7c"
color15="fb/f1/c7"
color_foreground="eb/db/b2"
color_background="28/28/28"

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
  put_template_custom Pg ebdbb2 # foreground
  put_template_custom Ph 282828 # background
  put_template_custom Pi ebdbb2 # bold color
  put_template_custom Pj 3c3836 # selection color
  put_template_custom Pk ebdbb2 # selected text color
  put_template_custom Pl ebdbb2 # cursor
  put_template_custom Pm 282828 # cursor text
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
  export TINTED8_COLOR_BLACK_NORMAL_HEX="282828"
  export TINTED8_COLOR_BLACK_RED_HEX="cc241d"
  export TINTED8_COLOR_BLACK_GREEN_HEX="98971a"
  export TINTED8_COLOR_YELLOW_NORMAL_HEX="d79921"
  export TINTED8_COLOR_BLUE_NORMAL_HEX="458588"
  export TINTED8_COLOR_MAGENTA_NORMAL_HEX="b16286"
  export TINTED8_COLOR_CYAN_NORMAL_HEX="689d6a"
  export TINTED8_COLOR_WHITE_NORMAL_HEX="ebdbb2"

  export TINTED8_COLOR_BLACK_BRIGHT_HEX="3c3836"
  export TINTED8_COLOR_RED_BRIGHT_HEX="fb4934"
  export TINTED8_COLOR_GREEN_BRIGHT_HEX="b8bb26"
  export TINTED8_COLOR_YELLOW_BRIGHT_HEX="fabd2f"
  export TINTED8_COLOR_BLUE_BRIGHT_HEX="83a598"
  export TINTED8_COLOR_MAGENTA_BRIGHT_HEX="d3869b"
  export TINTED8_COLOR_CYAN_BRIGHT_HEX="8ec07c"
  export TINTED8_COLOR_WHITE_BRIGHT_HEX="fbf1c7"

  export TINTED8_COLOR_BLACK_DIM_HEX="1d2021"
  export TINTED8_COLOR_RED_DIM_HEX="9b1611"
  export TINTED8_COLOR_GREEN_DIM_HEX="65650f"
  export TINTED8_COLOR_YELLOW_DIM_HEX="a77514"
  export TINTED8_COLOR_BLUE_DIM_HEX="2f5f61"
  export TINTED8_COLOR_MAGENTA_DIM_HEX="914467"
  export TINTED8_COLOR_CYAN_DIM_HEX="4d7b4f"
  export TINTED8_COLOR_WHITE_DIM_HEX="e3c67d"
fi
