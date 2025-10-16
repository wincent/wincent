#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Front End Delight
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="front-end-delight"

color00="1b/1b/1d" # Base 00 - Black
color01="f8/50/1a" # Base 08 - Red
color02="56/57/46" # Base 0B - Green
color03="33/93/c9" # Base 0A - Yellow
color04="2c/70/b7" # Base 0D - Blue
color05="f0/2d/4e" # Base 0E - Magenta
color06="3b/a0/a5" # Base 0C - Cyan
color07="98/ac/9c" # Base 05 - White
color08="71/ac/7c" # Base 03 - Bright Black
color09="f6/43/19" # Base 12 - Bright Red
color10="74/eb/4c" # Base 14 - Bright Green
color11="fc/c2/24" # Base 13 - Bright Yellow
color12="33/93/c9" # Base 16 - Bright Blue
color13="e7/5e/4e" # Base 17 - Bright Magenta
color14="4e/bc/e5" # Base 15 - Bright Cyan
color15="8b/73/5a" # Base 07 - Bright White
color16="f9/76/1d" # Base 09
color17="7c/28/0d" # Base 0F
color18="24/24/26" # Base 01
color19="5e/ac/6c" # Base 02
color20="85/ac/8c" # Base 04
color21="ac/ac/ac" # Base 06
color_foreground="98/ac/9c" # Base 05
color_background="1b/1b/1d" # Base 00


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
  put_template_custom Pg 98ac9c # foreground
  put_template_custom Ph 1b1b1d # background
  put_template_custom Pi 98ac9c # bold color
  put_template_custom Pj 5eac6c # selection color
  put_template_custom Pk 98ac9c # selected text color
  put_template_custom Pl 98ac9c # cursor
  put_template_custom Pm 1b1b1d # cursor text
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
  export BASE24_COLOR_00_HEX="1b1b1d"
  export BASE24_COLOR_01_HEX="242426"
  export BASE24_COLOR_02_HEX="5eac6c"
  export BASE24_COLOR_03_HEX="71ac7c"
  export BASE24_COLOR_04_HEX="85ac8c"
  export BASE24_COLOR_05_HEX="98ac9c"
  export BASE24_COLOR_06_HEX="acacac"
  export BASE24_COLOR_07_HEX="8b735a"
  export BASE24_COLOR_08_HEX="f8501a"
  export BASE24_COLOR_09_HEX="f9761d"
  export BASE24_COLOR_0A_HEX="3393c9"
  export BASE24_COLOR_0B_HEX="565746"
  export BASE24_COLOR_0C_HEX="3ba0a5"
  export BASE24_COLOR_0D_HEX="2c70b7"
  export BASE24_COLOR_0E_HEX="f02d4e"
  export BASE24_COLOR_0F_HEX="7c280d"
  export BASE24_COLOR_10_HEX="3e7248"
  export BASE24_COLOR_11_HEX="1f3924"
  export BASE24_COLOR_12_HEX="f64319"
  export BASE24_COLOR_13_HEX="fcc224"
  export BASE24_COLOR_14_HEX="74eb4c"
  export BASE24_COLOR_15_HEX="4ebce5"
  export BASE24_COLOR_16_HEX="3393c9"
  export BASE24_COLOR_17_HEX="e75e4e"
fi
