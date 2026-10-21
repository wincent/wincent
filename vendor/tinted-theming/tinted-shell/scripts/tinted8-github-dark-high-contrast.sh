#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: tinted8 Github Dark High Contrast
# Scheme author: Tinted Theming (https://github.com/tinted-theming)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export TINTED8_THEME="github-dark-high-contrast"

color00="2f/37/42"
color01="ff/94/92"
color02="28/d7/51"
color03="f0/b7/2f"
color04="71/b7/ff"
color05="cb/9e/ff"
color06="39/c5/cf"
color07="f0/f6/fc"
color08="65/6c/76"
color09="ff/b1/af"
color10="4a/e1/68"
color11="f7/c8/43"
color12="91/cb/ff"
color13="db/b7/ff"
color14="56/d4/dd"
color15="ff/ff/ff"
color_foreground="ff/ff/ff"
color_background="01/04/09"

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
  put_template_custom Pg ffffff # foreground
  put_template_custom Ph 010409 # background
  put_template_custom Pi ffffff # bold color
  put_template_custom Pj 656c76 # selection color
  put_template_custom Pk f0f6fc # selected text color
  put_template_custom Pl ffffff # cursor
  put_template_custom Pm 010409 # cursor text
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
  export TINTED8_COLOR_BLACK_NORMAL_HEX="2f3742"
  export TINTED8_COLOR_BLACK_RED_HEX="ff9492"
  export TINTED8_COLOR_BLACK_GREEN_HEX="28d751"
  export TINTED8_COLOR_YELLOW_NORMAL_HEX="f0b72f"
  export TINTED8_COLOR_BLUE_NORMAL_HEX="71b7ff"
  export TINTED8_COLOR_MAGENTA_NORMAL_HEX="cb9eff"
  export TINTED8_COLOR_CYAN_NORMAL_HEX="39c5cf"
  export TINTED8_COLOR_WHITE_NORMAL_HEX="f0f6fc"

  export TINTED8_COLOR_BLACK_BRIGHT_HEX="656c76"
  export TINTED8_COLOR_RED_BRIGHT_HEX="ffb1af"
  export TINTED8_COLOR_GREEN_BRIGHT_HEX="4ae168"
  export TINTED8_COLOR_YELLOW_BRIGHT_HEX="f7c843"
  export TINTED8_COLOR_BLUE_BRIGHT_HEX="91cbff"
  export TINTED8_COLOR_MAGENTA_BRIGHT_HEX="dbb7ff"
  export TINTED8_COLOR_CYAN_BRIGHT_HEX="56d4dd"
  export TINTED8_COLOR_WHITE_BRIGHT_HEX="ffffff"

  export TINTED8_COLOR_BLACK_DIM_HEX="15191e"
  export TINTED8_COLOR_RED_DIM_HEX="ff5855"
  export TINTED8_COLOR_GREEN_DIM_HEX="1aa83b"
  export TINTED8_COLOR_YELLOW_DIM_HEX="d99c08"
  export TINTED8_COLOR_BLUE_DIM_HEX="3498ff"
  export TINTED8_COLOR_MAGENTA_DIM_HEX="aa61ff"
  export TINTED8_COLOR_CYAN_DIM_HEX="239fa8"
  export TINTED8_COLOR_WHITE_DIM_HEX="bad7f4"
fi
