#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Warm Neon 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="warm-neon"

color00="3f/3f/3f" # Base 00 - Black
color01="e2/43/45" # Base 08 - Red
color02="38/b1/39" # Base 0B - Green
color03="7a/90/d5" # Base 0A - Yellow
color04="42/60/c5" # Base 0D - Blue
color05="f8/1f/fb" # Base 0E - Magenta
color06="29/ba/d3" # Base 0C - Cyan
color07="d0/b8/a3" # Base 06 - White
color08="fd/fc/fc" # Base 02 - Bright Black
color09="e8/6f/71" # Base 12 - Bright Red
color10="9b/c0/8f" # Base 14 - Bright Green
color11="dd/d9/79" # Base 13 - Bright Yellow
color12="7a/90/d5" # Base 16 - Bright Blue
color13="f6/74/b9" # Base 17 - Bright Magenta
color14="5e/d1/e4" # Base 15 - Bright Cyan
color15="d8/c8/bb" # Base 07 - Bright White
color16="da/e1/45" # Base 09
color17="71/21/22" # Base 0F
color18="00/00/00" # Base 01
color19="fd/fc/fc" # Base 02
color20="e7/da/d0" # Base 04
color21="d0/b8/a3" # Base 06
color_foreground="dc/c9/ba" # Base 05
color_background="3f/3f/3f" # Base 00


if [ -z "$TTY" ] && ! TTY=$(tty); then
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
  put_template_custom Pg dcc9ba # foreground
  put_template_custom Ph 3f3f3f # background
  put_template_custom Pi dcc9ba # bold color
  put_template_custom Pj fdfcfc # selection color
  put_template_custom Pk dcc9ba # selected text color
  put_template_custom Pl dcc9ba # cursor
  put_template_custom Pm 3f3f3f # cursor text
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
  export BASE24_COLOR_00_HEX="3f3f3f"
  export BASE24_COLOR_01_HEX="000000"
  export BASE24_COLOR_02_HEX="fdfcfc"
  export BASE24_COLOR_03_HEX="f2ebe6"
  export BASE24_COLOR_04_HEX="e7dad0"
  export BASE24_COLOR_05_HEX="dcc9ba"
  export BASE24_COLOR_06_HEX="d0b8a3"
  export BASE24_COLOR_07_HEX="d8c8bb"
  export BASE24_COLOR_08_HEX="e24345"
  export BASE24_COLOR_09_HEX="dae145"
  export BASE24_COLOR_0A_HEX="7a90d5"
  export BASE24_COLOR_0B_HEX="38b139"
  export BASE24_COLOR_0C_HEX="29bad3"
  export BASE24_COLOR_0D_HEX="4260c5"
  export BASE24_COLOR_0E_HEX="f81ffb"
  export BASE24_COLOR_0F_HEX="712122"
  export BASE24_COLOR_10_HEX="a8a8a8"
  export BASE24_COLOR_11_HEX="545454"
  export BASE24_COLOR_12_HEX="e86f71"
  export BASE24_COLOR_13_HEX="ddd979"
  export BASE24_COLOR_14_HEX="9bc08f"
  export BASE24_COLOR_15_HEX="5ed1e4"
  export BASE24_COLOR_16_HEX="7a90d5"
  export BASE24_COLOR_17_HEX="f674b9"
fi
