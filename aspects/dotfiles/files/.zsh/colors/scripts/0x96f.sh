#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: 0x96f
# Scheme author: Filip Janevski (https://0x96f.dev/theme)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="0x96f"

color00="26/24/27" # Base 00 - Black
color01="ff/72/72" # Base 08 - Red
color02="bc/df/59" # Base 0B - Green
color03="ff/ca/58" # Base 0A - Yellow
color04="49/ca/e4" # Base 0D - Blue
color05="a0/93/e2" # Base 0E - Magenta
color06="ae/e8/f4" # Base 0C - Cyan
color07="fc/fc/fc" # Base 05 - White
color08="67/65/67" # Base 03 - Bright Black
color09="ff/87/87" # Base 12 - Bright Red
color10="c6/e4/72" # Base 14 - Bright Green
color11="ff/d2/71" # Base 13 - Bright Yellow
color12="64/d2/e8" # Base 16 - Bright Blue
color13="ae/a3/e6" # Base 17 - Bright Magenta
color14="ba/eb/f6" # Base 15 - Bright Cyan
color15="fc/fc/fc" # Base 07 - Bright White
color16="fc/9d/6f" # Base 09
color17="ff/87/87" # Base 0F
color18="3b/39/3c" # Base 01
color19="51/4f/52" # Base 02
color20="7c/7b/7d" # Base 04
color21="ea/e9/eb" # Base 06
color_foreground="fc/fc/fc" # Base 05
color_background="26/24/27" # Base 00


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
  put_template_custom Pg fcfcfc # foreground
  put_template_custom Ph 262427 # background
  put_template_custom Pi fcfcfc # bold color
  put_template_custom Pj 514f52 # selection color
  put_template_custom Pk fcfcfc # selected text color
  put_template_custom Pl fcfcfc # cursor
  put_template_custom Pm 262427 # cursor text
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
  export BASE24_COLOR_00_HEX="262427"
  export BASE24_COLOR_01_HEX="3b393c"
  export BASE24_COLOR_02_HEX="514f52"
  export BASE24_COLOR_03_HEX="676567"
  export BASE24_COLOR_04_HEX="7c7b7d"
  export BASE24_COLOR_05_HEX="fcfcfc"
  export BASE24_COLOR_06_HEX="eae9eb"
  export BASE24_COLOR_07_HEX="fcfcfc"
  export BASE24_COLOR_08_HEX="ff7272"
  export BASE24_COLOR_09_HEX="fc9d6f"
  export BASE24_COLOR_0A_HEX="ffca58"
  export BASE24_COLOR_0B_HEX="bcdf59"
  export BASE24_COLOR_0C_HEX="aee8f4"
  export BASE24_COLOR_0D_HEX="49cae4"
  export BASE24_COLOR_0E_HEX="a093e2"
  export BASE24_COLOR_0F_HEX="ff8787"
  export BASE24_COLOR_10_HEX="1e1d1f"
  export BASE24_COLOR_11_HEX="0f0e10"
  export BASE24_COLOR_12_HEX="ff8787"
  export BASE24_COLOR_13_HEX="ffd271"
  export BASE24_COLOR_14_HEX="c6e472"
  export BASE24_COLOR_15_HEX="baebf6"
  export BASE24_COLOR_16_HEX="64d2e8"
  export BASE24_COLOR_17_HEX="aea3e6"
fi
