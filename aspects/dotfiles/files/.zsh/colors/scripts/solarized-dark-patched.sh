#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Solarized Dark Patched
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="solarized-dark-patched"

color00="00/1e/26" # Base 00 - Black
color01="d0/1b/24" # Base 08 - Red
color02="72/89/05" # Base 0B - Green
color03="70/81/83" # Base 0A - Yellow
color04="20/75/c7" # Base 0D - Blue
color05="c6/1b/6e" # Base 0E - Magenta
color06="25/91/85" # Base 0C - Cyan
color07="c0/c0/b0" # Base 05 - White
color08="6e/7c/7b" # Base 03 - Bright Black
color09="bd/36/12" # Base 12 - Bright Red
color10="46/5a/61" # Base 14 - Bright Green
color11="52/67/6f" # Base 13 - Bright Yellow
color12="70/81/83" # Base 16 - Bright Blue
color13="58/56/b9" # Base 17 - Bright Magenta
color14="81/90/8f" # Base 15 - Bright Cyan
color15="fc/f4/dc" # Base 07 - Bright White
color16="a5/77/05" # Base 09
color17="68/0d/12" # Base 0F
color18="00/27/31" # Base 01
color19="46/5a/61" # Base 02
color20="97/9e/96" # Base 04
color21="e9/e2/cb" # Base 06
color_foreground="c0/c0/b0" # Base 05
color_background="00/1e/26" # Base 00


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
  put_template_custom Pg c0c0b0 # foreground
  put_template_custom Ph 001e26 # background
  put_template_custom Pi c0c0b0 # bold color
  put_template_custom Pj 465a61 # selection color
  put_template_custom Pk c0c0b0 # selected text color
  put_template_custom Pl c0c0b0 # cursor
  put_template_custom Pm 001e26 # cursor text
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
  export BASE24_COLOR_00_HEX="001e26"
  export BASE24_COLOR_01_HEX="002731"
  export BASE24_COLOR_02_HEX="465a61"
  export BASE24_COLOR_03_HEX="6e7c7b"
  export BASE24_COLOR_04_HEX="979e96"
  export BASE24_COLOR_05_HEX="c0c0b0"
  export BASE24_COLOR_06_HEX="e9e2cb"
  export BASE24_COLOR_07_HEX="fcf4dc"
  export BASE24_COLOR_08_HEX="d01b24"
  export BASE24_COLOR_09_HEX="a57705"
  export BASE24_COLOR_0A_HEX="708183"
  export BASE24_COLOR_0B_HEX="728905"
  export BASE24_COLOR_0C_HEX="259185"
  export BASE24_COLOR_0D_HEX="2075c7"
  export BASE24_COLOR_0E_HEX="c61b6e"
  export BASE24_COLOR_0F_HEX="680d12"
  export BASE24_COLOR_10_HEX="2e3c40"
  export BASE24_COLOR_11_HEX="171e20"
  export BASE24_COLOR_12_HEX="bd3612"
  export BASE24_COLOR_13_HEX="52676f"
  export BASE24_COLOR_14_HEX="465a61"
  export BASE24_COLOR_15_HEX="81908f"
  export BASE24_COLOR_16_HEX="708183"
  export BASE24_COLOR_17_HEX="5856b9"
fi
