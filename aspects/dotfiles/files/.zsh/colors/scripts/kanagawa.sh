#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Kanagawa
# Scheme author: Tommaso Laurenzi (https://github.com/rebelot)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="kanagawa"

color00="1F/1F/28" # Base 00 - Black
color01="C3/40/43" # Base 08 - Red
color02="76/94/6A" # Base 0B - Green
color03="C0/A3/6E" # Base 0A - Yellow
color04="7E/9C/D8" # Base 0D - Blue
color05="95/7F/B8" # Base 0E - Magenta
color06="6A/95/89" # Base 0C - Cyan
color07="DC/D7/BA" # Base 05 - White
color08="54/54/6D" # Base 03 - Bright Black
color09="C3/40/43" # Base 12 - Bright Red
color10="76/94/6A" # Base 14 - Bright Green
color11="C0/A3/6E" # Base 13 - Bright Yellow
color12="7E/9C/D8" # Base 16 - Bright Blue
color13="95/7F/B8" # Base 17 - Bright Magenta
color14="6A/95/89" # Base 15 - Bright Cyan
color15="71/7C/7C" # Base 07 - Bright White
color16="FF/A0/66" # Base 09
color17="D2/7E/99" # Base 0F
color18="16/16/1D" # Base 01
color19="22/32/49" # Base 02
color20="72/71/69" # Base 04
color21="C8/C0/93" # Base 06
color_foreground="DC/D7/BA" # Base 05
color_background="1F/1F/28" # Base 00


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
  put_template_custom Pg DCD7BA # foreground
  put_template_custom Ph 1F1F28 # background
  put_template_custom Pi DCD7BA # bold color
  put_template_custom Pj 223249 # selection color
  put_template_custom Pk DCD7BA # selected text color
  put_template_custom Pl DCD7BA # cursor
  put_template_custom Pm 1F1F28 # cursor text
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
  export BASE24_COLOR_00_HEX="1F1F28"
  export BASE24_COLOR_01_HEX="16161D"
  export BASE24_COLOR_02_HEX="223249"
  export BASE24_COLOR_03_HEX="54546D"
  export BASE24_COLOR_04_HEX="727169"
  export BASE24_COLOR_05_HEX="DCD7BA"
  export BASE24_COLOR_06_HEX="C8C093"
  export BASE24_COLOR_07_HEX="717C7C"
  export BASE24_COLOR_08_HEX="C34043"
  export BASE24_COLOR_09_HEX="FFA066"
  export BASE24_COLOR_0A_HEX="C0A36E"
  export BASE24_COLOR_0B_HEX="76946A"
  export BASE24_COLOR_0C_HEX="6A9589"
  export BASE24_COLOR_0D_HEX="7E9CD8"
  export BASE24_COLOR_0E_HEX="957FB8"
  export BASE24_COLOR_0F_HEX="D27E99"
  export BASE24_COLOR_10_HEX="1F1F28"
  export BASE24_COLOR_11_HEX="1F1F28"
  export BASE24_COLOR_12_HEX="C34043"
  export BASE24_COLOR_13_HEX="C0A36E"
  export BASE24_COLOR_14_HEX="76946A"
  export BASE24_COLOR_15_HEX="6A9589"
  export BASE24_COLOR_16_HEX="7E9CD8"
  export BASE24_COLOR_17_HEX="957FB8"
fi
