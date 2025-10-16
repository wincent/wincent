#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Lab Fox
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="lab-fox"

color00="2e/2e/2e" # Base 00 - Black
color01="fc/6d/26" # Base 08 - Red
color02="3e/b3/83" # Base 0B - Green
color03="db/50/1f" # Base 0A - Yellow
color04="db/3b/21" # Base 0D - Blue
color05="38/0d/75" # Base 0E - Magenta
color06="6e/49/cb" # Base 0C - Cyan
color07="cf/d0/d0" # Base 05 - White
color08="73/73/73" # Base 03 - Bright Black
color09="ff/65/17" # Base 12 - Bright Red
color10="52/e9/a8" # Base 14 - Bright Green
color11="fc/a0/12" # Base 13 - Bright Yellow
color12="db/50/1f" # Base 16 - Bright Blue
color13="44/10/90" # Base 17 - Bright Magenta
color14="7d/53/e7" # Base 15 - Bright Cyan
color15="fe/ff/ff" # Base 07 - Bright White
color16="fc/a1/21" # Base 09
color17="7e/36/13" # Base 0F
color18="2e/2e/2e" # Base 01
color19="45/45/45" # Base 02
color20="a1/a2/a2" # Base 04
color21="fe/ff/ff" # Base 06
color_foreground="cf/d0/d0" # Base 05
color_background="2e/2e/2e" # Base 00


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
  put_template_custom Pg cfd0d0 # foreground
  put_template_custom Ph 2e2e2e # background
  put_template_custom Pi cfd0d0 # bold color
  put_template_custom Pj 454545 # selection color
  put_template_custom Pk cfd0d0 # selected text color
  put_template_custom Pl cfd0d0 # cursor
  put_template_custom Pm 2e2e2e # cursor text
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
  export BASE24_COLOR_00_HEX="2e2e2e"
  export BASE24_COLOR_01_HEX="2e2e2e"
  export BASE24_COLOR_02_HEX="454545"
  export BASE24_COLOR_03_HEX="737373"
  export BASE24_COLOR_04_HEX="a1a2a2"
  export BASE24_COLOR_05_HEX="cfd0d0"
  export BASE24_COLOR_06_HEX="feffff"
  export BASE24_COLOR_07_HEX="feffff"
  export BASE24_COLOR_08_HEX="fc6d26"
  export BASE24_COLOR_09_HEX="fca121"
  export BASE24_COLOR_0A_HEX="db501f"
  export BASE24_COLOR_0B_HEX="3eb383"
  export BASE24_COLOR_0C_HEX="6e49cb"
  export BASE24_COLOR_0D_HEX="db3b21"
  export BASE24_COLOR_0E_HEX="380d75"
  export BASE24_COLOR_0F_HEX="7e3613"
  export BASE24_COLOR_10_HEX="2e2e2e"
  export BASE24_COLOR_11_HEX="171717"
  export BASE24_COLOR_12_HEX="ff6517"
  export BASE24_COLOR_13_HEX="fca012"
  export BASE24_COLOR_14_HEX="52e9a8"
  export BASE24_COLOR_15_HEX="7d53e7"
  export BASE24_COLOR_16_HEX="db501f"
  export BASE24_COLOR_17_HEX="441090"
fi
