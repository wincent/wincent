#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Square
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="square"

color00="1a/1a/1a" # Base 00 - Black
color01="e9/89/7c" # Base 08 - Red
color02="b6/37/7d" # Base 0B - Green
color03="b6/de/fb" # Base 0A - Yellow
color04="a9/cd/eb" # Base 0D - Blue
color05="75/50/7b" # Base 0E - Magenta
color06="c9/ca/ec" # Base 0C - Cyan
color07="ba/ba/ba" # Base 05 - White
color08="4b/4b/4b" # Base 03 - Bright Black
color09="f9/92/86" # Base 12 - Bright Red
color10="c3/f7/86" # Base 14 - Bright Green
color11="fc/fb/cc" # Base 13 - Bright Yellow
color12="b6/de/fb" # Base 16 - Bright Blue
color13="ad/7f/a8" # Base 17 - Bright Magenta
color14="d7/d9/fc" # Base 15 - Bright Cyan
color15="e2/e2/e2" # Base 07 - Bright White
color16="ec/eb/be" # Base 09
color17="74/44/3e" # Base 0F
color18="05/05/05" # Base 01
color19="14/14/14" # Base 02
color20="83/83/83" # Base 04
color21="f2/f2/f2" # Base 06
color_foreground="ba/ba/ba" # Base 05
color_background="1a/1a/1a" # Base 00


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
  put_template_custom Pg bababa # foreground
  put_template_custom Ph 1a1a1a # background
  put_template_custom Pi bababa # bold color
  put_template_custom Pj 141414 # selection color
  put_template_custom Pk bababa # selected text color
  put_template_custom Pl bababa # cursor
  put_template_custom Pm 1a1a1a # cursor text
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
  export BASE24_COLOR_00_HEX="1a1a1a"
  export BASE24_COLOR_01_HEX="050505"
  export BASE24_COLOR_02_HEX="141414"
  export BASE24_COLOR_03_HEX="4b4b4b"
  export BASE24_COLOR_04_HEX="838383"
  export BASE24_COLOR_05_HEX="bababa"
  export BASE24_COLOR_06_HEX="f2f2f2"
  export BASE24_COLOR_07_HEX="e2e2e2"
  export BASE24_COLOR_08_HEX="e9897c"
  export BASE24_COLOR_09_HEX="ecebbe"
  export BASE24_COLOR_0A_HEX="b6defb"
  export BASE24_COLOR_0B_HEX="b6377d"
  export BASE24_COLOR_0C_HEX="c9caec"
  export BASE24_COLOR_0D_HEX="a9cdeb"
  export BASE24_COLOR_0E_HEX="75507b"
  export BASE24_COLOR_0F_HEX="74443e"
  export BASE24_COLOR_10_HEX="0d0d0d"
  export BASE24_COLOR_11_HEX="060606"
  export BASE24_COLOR_12_HEX="f99286"
  export BASE24_COLOR_13_HEX="fcfbcc"
  export BASE24_COLOR_14_HEX="c3f786"
  export BASE24_COLOR_15_HEX="d7d9fc"
  export BASE24_COLOR_16_HEX="b6defb"
  export BASE24_COLOR_17_HEX="ad7fa8"
fi
