#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: tinted8 Nord
# Scheme author: Tinted Theming (https://github.com/tinted-theming)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export TINTED8_THEME="nord"

color00="2e/34/40"
color01="bf/61/6a"
color02="a3/be/8c"
color03="eb/cb/8b"
color04="81/a1/c1"
color05="b4/8e/ad"
color06="88/c0/d0"
color07="e5/e9/f0"
color08="46/51/65"
color09="d1/8d/93"
color10="c2/d4/b3"
color11="f4/e2/bf"
color12="aa/c0/d5"
color13="cc/b3/c8"
color14="b4/d7/e1"
color15="ec/ef/f4"
color_foreground="e5/e9/f0"
color_background="2e/34/40"

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
  put_template_custom Pg e5e9f0 # foreground
  put_template_custom Ph 2e3440 # background
  put_template_custom Pi e5e9f0 # bold color
  put_template_custom Pj 465165 # selection color
  put_template_custom Pk e5e9f0 # selected text color
  put_template_custom Pl e5e9f0 # cursor
  put_template_custom Pm 2e3440 # cursor text
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
  export TINTED8_COLOR_BLACK_NORMAL_HEX="2e3440"
  export TINTED8_COLOR_BLACK_RED_HEX="bf616a"
  export TINTED8_COLOR_BLACK_GREEN_HEX="a3be8c"
  export TINTED8_COLOR_YELLOW_NORMAL_HEX="ebcb8b"
  export TINTED8_COLOR_BLUE_NORMAL_HEX="81a1c1"
  export TINTED8_COLOR_MAGENTA_NORMAL_HEX="b48ead"
  export TINTED8_COLOR_CYAN_NORMAL_HEX="88c0d0"
  export TINTED8_COLOR_WHITE_NORMAL_HEX="e5e9f0"

  export TINTED8_COLOR_BLACK_BRIGHT_HEX="465165"
  export TINTED8_COLOR_RED_BRIGHT_HEX="d18d93"
  export TINTED8_COLOR_GREEN_BRIGHT_HEX="c2d4b3"
  export TINTED8_COLOR_YELLOW_BRIGHT_HEX="f4e2bf"
  export TINTED8_COLOR_BLUE_BRIGHT_HEX="aac0d5"
  export TINTED8_COLOR_MAGENTA_BRIGHT_HEX="ccb3c8"
  export TINTED8_COLOR_CYAN_BRIGHT_HEX="b4d7e1"
  export TINTED8_COLOR_WHITE_BRIGHT_HEX="eceff4"

  export TINTED8_COLOR_BLACK_DIM_HEX="14171d"
  export TINTED8_COLOR_RED_DIM_HEX="a53e48"
  export TINTED8_COLOR_GREEN_DIM_HEX="84aa63"
  export TINTED8_COLOR_YELLOW_DIM_HEX="e9b650"
  export TINTED8_COLOR_BLUE_DIM_HEX="5e81ac"
  export TINTED8_COLOR_MAGENTA_DIM_HEX="9d6793"
  export TINTED8_COLOR_CYAN_DIM_HEX="59abc2"
  export TINTED8_COLOR_WHITE_DIM_HEX="d8dee9"
fi
