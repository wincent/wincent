#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: tinted8 Github Light High Contrast
# Scheme author: Tinted Theming (https://github.com/tinted-theming)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export TINTED8_THEME="github-light-high-contrast"

color00="01/04/09"
color01="a0/11/1f"
color02="02/4c/1a"
color03="3f/22/00"
color04="03/49/b4"
color05="62/2c/bc"
color06="1b/7c/83"
color07="59/63/6e"
color08="39/3f/46"
color09="86/06/1d"
color10="05/5d/20"
color11="4e/2c/00"
color12="11/68/e3"
color13="84/4a/e7"
color14="31/92/aa"
color15="81/8b/98"
color_foreground="01/04/09"
color_background="ff/ff/ff"

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
  put_template_custom Pg 010409 # foreground
  put_template_custom Ph ffffff # background
  put_template_custom Pi 010409 # bold color
  put_template_custom Pj 3d454c # selection color
  put_template_custom Pk 010409 # selected text color
  put_template_custom Pl 010409 # cursor
  put_template_custom Pm ffffff # cursor text
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
  export TINTED8_COLOR_BLACK_NORMAL_HEX="010409"
  export TINTED8_COLOR_BLACK_RED_HEX="a0111f"
  export TINTED8_COLOR_BLACK_GREEN_HEX="024c1a"
  export TINTED8_COLOR_YELLOW_NORMAL_HEX="3f2200"
  export TINTED8_COLOR_BLUE_NORMAL_HEX="0349b4"
  export TINTED8_COLOR_MAGENTA_NORMAL_HEX="622cbc"
  export TINTED8_COLOR_CYAN_NORMAL_HEX="1b7c83"
  export TINTED8_COLOR_WHITE_NORMAL_HEX="59636e"

  export TINTED8_COLOR_BLACK_BRIGHT_HEX="393f46"
  export TINTED8_COLOR_RED_BRIGHT_HEX="86061d"
  export TINTED8_COLOR_GREEN_BRIGHT_HEX="055d20"
  export TINTED8_COLOR_YELLOW_BRIGHT_HEX="4e2c00"
  export TINTED8_COLOR_BLUE_BRIGHT_HEX="1168e3"
  export TINTED8_COLOR_MAGENTA_BRIGHT_HEX="844ae7"
  export TINTED8_COLOR_CYAN_BRIGHT_HEX="3192aa"
  export TINTED8_COLOR_WHITE_BRIGHT_HEX="818b98"

  export TINTED8_COLOR_BLACK_DIM_HEX="000000"
  export TINTED8_COLOR_RED_DIM_HEX="6b0913"
  export TINTED8_COLOR_GREEN_DIM_HEX="001105"
  export TINTED8_COLOR_YELLOW_DIM_HEX="020100"
  export TINTED8_COLOR_BLUE_DIM_HEX="00307a"
  export TINTED8_COLOR_MAGENTA_DIM_HEX="471d8e"
  export TINTED8_COLOR_CYAN_DIM_HEX="0f4d52"
  export TINTED8_COLOR_WHITE_DIM_HEX="3d454c"
fi
