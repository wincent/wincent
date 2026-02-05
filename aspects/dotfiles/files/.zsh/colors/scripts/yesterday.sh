#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Yesterday
# Scheme author: FroZnShiva (https://github.com/FroZnShiva)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="yesterday"

color00="1D/1F/21" # Base 00 - Black
color01="C8/28/29" # Base 08 - Red
color02="71/8C/00" # Base 0B - Green
color03="EA/B7/00" # Base 0A - Yellow
color04="42/71/AE" # Base 0D - Blue
color05="89/59/A8" # Base 0E - Magenta
color06="3E/99/9F" # Base 0C - Cyan
color07="D6/D6/D6" # Base 05 - White
color08="96/98/96" # Base 03 - Bright Black
color09="C8/28/29" # Base 12 - Bright Red
color10="71/8C/00" # Base 14 - Bright Green
color11="EA/B7/00" # Base 13 - Bright Yellow
color12="42/71/AE" # Base 16 - Bright Blue
color13="89/59/A8" # Base 17 - Bright Magenta
color14="3E/99/9F" # Base 15 - Bright Cyan
color15="FF/FF/FF" # Base 07 - Bright White
color16="F5/87/1F" # Base 09
color17="7F/2A/1D" # Base 0F
color18="28/2A/2E" # Base 01
color19="4D/4D/4C" # Base 02
color20="8E/90/8C" # Base 04
color21="EF/EF/EF" # Base 06
color_foreground="D6/D6/D6" # Base 05
color_background="1D/1F/21" # Base 00


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
  put_template_custom Pg D6D6D6 # foreground
  put_template_custom Ph 1D1F21 # background
  put_template_custom Pi D6D6D6 # bold color
  put_template_custom Pj 4D4D4C # selection color
  put_template_custom Pk D6D6D6 # selected text color
  put_template_custom Pl D6D6D6 # cursor
  put_template_custom Pm 1D1F21 # cursor text
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
  export BASE24_COLOR_00_HEX="1D1F21"
  export BASE24_COLOR_01_HEX="282A2E"
  export BASE24_COLOR_02_HEX="4D4D4C"
  export BASE24_COLOR_03_HEX="969896"
  export BASE24_COLOR_04_HEX="8E908C"
  export BASE24_COLOR_05_HEX="D6D6D6"
  export BASE24_COLOR_06_HEX="EFEFEF"
  export BASE24_COLOR_07_HEX="FFFFFF"
  export BASE24_COLOR_08_HEX="C82829"
  export BASE24_COLOR_09_HEX="F5871F"
  export BASE24_COLOR_0A_HEX="EAB700"
  export BASE24_COLOR_0B_HEX="718C00"
  export BASE24_COLOR_0C_HEX="3E999F"
  export BASE24_COLOR_0D_HEX="4271AE"
  export BASE24_COLOR_0E_HEX="8959A8"
  export BASE24_COLOR_0F_HEX="7F2A1D"
  export BASE24_COLOR_10_HEX="1D1F21"
  export BASE24_COLOR_11_HEX="1D1F21"
  export BASE24_COLOR_12_HEX="C82829"
  export BASE24_COLOR_13_HEX="EAB700"
  export BASE24_COLOR_14_HEX="718C00"
  export BASE24_COLOR_15_HEX="3E999F"
  export BASE24_COLOR_16_HEX="4271AE"
  export BASE24_COLOR_17_HEX="8959A8"
fi
