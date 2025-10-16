#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Terracotta
# Scheme author: Alexander Rossell Hayes (https://github.com/rossellhayes)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE16_THEME=terracotta

color00="ef/ea/e8" # Base 00 - Black
color01="a7/50/45" # Base 08 - Red
color02="7a/89/4a" # Base 0B - Green
color03="ce/94/3e" # Base 0A - Yellow
color04="62/55/74" # Base 0D - Blue
color05="8d/59/68" # Base 0E - Magenta
color06="84/7f/9e" # Base 0C - Cyan
color07="47/37/31" # Base 05 - White
color08="c0/ac/a4" # Base 03 - Bright Black
color09="$color01" # Base 08 - Bright Red
color10="$color02" # Base 0B - Bright Green
color11="$color03" # Base 0A - Bright Yellow
color12="$color04" # Base 0D - Bright Blue
color13="$color05" # Base 0E - Bright Magenta
color14="$color06" # Base 0C - Bright Cyan
color15="24/1c/19" # Base 07 - Bright White
color16="bd/69/42" # Base 09
color17="b0/71/58" # Base 0F
color18="df/d6/d1" # Base 01
color19="d0/c1/bb" # Base 02
color20="59/45/3d" # Base 04
color21="35/2a/25" # Base 06
color_foreground="47/37/31" # Base 05
color_background="ef/ea/e8" # Base 00

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

# 256 color space
put_template 16 "$color16"
put_template 17 "$color17"
put_template 18 "$color18"
put_template 19 "$color19"
put_template 20 "$color20"
put_template 21 "$color21"

# foreground / background / cursor color
if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  put_template_custom Pg 473731 # foreground
  put_template_custom Ph efeae8 # background
  put_template_custom Pi 473731 # bold color
  put_template_custom Pj d0c1bb # selection color
  put_template_custom Pk 473731 # selected text color
  put_template_custom Pl 473731 # cursor
  put_template_custom Pm efeae8 # cursor text
else
  put_template_var 10 "$color_foreground"
  if [ "$BASE16_SHELL_SET_BACKGROUND" != false ]; then
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
if [ -n "$TINTED_SHELL_ENABLE_BASE16_VARS" ] || [ -n "$BASE16_SHELL_ENABLE_VARS" ]; then
  export BASE16_COLOR_00_HEX="efeae8"
  export BASE16_COLOR_01_HEX="dfd6d1"
  export BASE16_COLOR_02_HEX="d0c1bb"
  export BASE16_COLOR_03_HEX="c0aca4"
  export BASE16_COLOR_04_HEX="59453d"
  export BASE16_COLOR_05_HEX="473731"
  export BASE16_COLOR_06_HEX="352a25"
  export BASE16_COLOR_07_HEX="241c19"
  export BASE16_COLOR_08_HEX="a75045"
  export BASE16_COLOR_09_HEX="bd6942"
  export BASE16_COLOR_0A_HEX="ce943e"
  export BASE16_COLOR_0B_HEX="7a894a"
  export BASE16_COLOR_0C_HEX="847f9e"
  export BASE16_COLOR_0D_HEX="625574"
  export BASE16_COLOR_0E_HEX="8d5968"
  export BASE16_COLOR_0F_HEX="b07158"
fi
