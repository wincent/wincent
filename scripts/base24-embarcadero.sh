#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Embarcadero
# Scheme author: Thomas Leon Highbaugh
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="embarcadero"

color00="25/2a/2f" # Base 00 - Black
color01="ed/5d/86" # Base 08 - Red
color02="20/c2/90" # Base 0B - Green
color03="eb/82/4d" # Base 0A - Yellow
color04="40/80/d0" # Base 0D - Blue
color05="a0/70/d0" # Base 0E - Magenta
color06="02/ef/ef" # Base 0C - Cyan
color07="bc/bd/c0" # Base 05 - White
color08="7f/82/85" # Base 03 - Bright Black
color09="f5/7d/9a" # Base 12 - Bright Red
color10="a0/d0/a0" # Base 14 - Bright Green
color11="ff/e0/89" # Base 13 - Bright Yellow
color12="80/b0/f0" # Base 16 - Bright Blue
color13="c0/90/f0" # Base 17 - Bright Magenta
color14="40/c0/c0" # Base 15 - Bright Cyan
color15="f8/f8/f8" # Base 07 - Bright White
color16="ff/cb/3d" # Base 09
color17="50/50/9f" # Base 0F
color18="43/47/4c" # Base 01
color19="61/65/68" # Base 02
color20="9e/a0/a2" # Base 04
color21="da/db/db" # Base 06
color_foreground="bc/bd/c0" # Base 05
color_background="25/2a/2f" # Base 00


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
  put_template_custom Pg bcbdc0 # foreground
  put_template_custom Ph 252a2f # background
  put_template_custom Pi bcbdc0 # bold color
  put_template_custom Pj 616568 # selection color
  put_template_custom Pk bcbdc0 # selected text color
  put_template_custom Pl bcbdc0 # cursor
  put_template_custom Pm 252a2f # cursor text
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
  export BASE24_COLOR_00_HEX="252a2f"
  export BASE24_COLOR_01_HEX="43474c"
  export BASE24_COLOR_02_HEX="616568"
  export BASE24_COLOR_03_HEX="7f8285"
  export BASE24_COLOR_04_HEX="9ea0a2"
  export BASE24_COLOR_05_HEX="bcbdc0"
  export BASE24_COLOR_06_HEX="dadbdb"
  export BASE24_COLOR_07_HEX="f8f8f8"
  export BASE24_COLOR_08_HEX="ed5d86"
  export BASE24_COLOR_09_HEX="ffcb3d"
  export BASE24_COLOR_0A_HEX="eb824d"
  export BASE24_COLOR_0B_HEX="20c290"
  export BASE24_COLOR_0C_HEX="02efef"
  export BASE24_COLOR_0D_HEX="4080d0"
  export BASE24_COLOR_0E_HEX="a070d0"
  export BASE24_COLOR_0F_HEX="50509f"
  export BASE24_COLOR_10_HEX="373742"
  export BASE24_COLOR_11_HEX="717188"
  export BASE24_COLOR_12_HEX="f57d9a"
  export BASE24_COLOR_13_HEX="ffe089"
  export BASE24_COLOR_14_HEX="a0d0a0"
  export BASE24_COLOR_15_HEX="40c0c0"
  export BASE24_COLOR_16_HEX="80b0f0"
  export BASE24_COLOR_17_HEX="c090f0"
fi
