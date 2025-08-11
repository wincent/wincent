#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Solar Flare
# Scheme author: Chuck Harmston (https://chuck.harmston.ch)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="solarflare"

color00="18/26/2F" # Base 00 - Black
color01="EF/52/53" # Base 08 - Red
color02="7C/C8/44" # Base 0B - Green
color03="E4/B5/1C" # Base 0A - Yellow
color04="33/B5/E1" # Base 0D - Blue
color05="A3/63/D5" # Base 0E - Magenta
color06="52/CB/B0" # Base 0C - Cyan
color07="A6/AF/B8" # Base 05 - White
color08="66/75/81" # Base 03 - Bright Black
color09="EF/52/53" # Base 12 - Bright Red
color10="7C/C8/44" # Base 14 - Bright Green
color11="E4/B5/1C" # Base 13 - Bright Yellow
color12="33/B5/E1" # Base 16 - Bright Blue
color13="A3/63/D5" # Base 17 - Bright Magenta
color14="52/CB/B0" # Base 15 - Bright Cyan
color15="F5/F7/FA" # Base 07 - Bright White
color16="E6/6B/2B" # Base 09
color17="D7/3C/9A" # Base 0F
color18="22/2E/38" # Base 01
color19="58/68/75" # Base 02
color20="85/93/9E" # Base 04
color21="E8/E9/ED" # Base 06
color_foreground="A6/AF/B8" # Base 05
color_background="18/26/2F" # Base 00


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
  put_template_custom Pg A6AFB8 # foreground
  put_template_custom Ph 18262F # background
  put_template_custom Pi A6AFB8 # bold color
  put_template_custom Pj 586875 # selection color
  put_template_custom Pk A6AFB8 # selected text color
  put_template_custom Pl A6AFB8 # cursor
  put_template_custom Pm 18262F # cursor text
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
  export BASE24_COLOR_00_HEX="18262F"
  export BASE24_COLOR_01_HEX="222E38"
  export BASE24_COLOR_02_HEX="586875"
  export BASE24_COLOR_03_HEX="667581"
  export BASE24_COLOR_04_HEX="85939E"
  export BASE24_COLOR_05_HEX="A6AFB8"
  export BASE24_COLOR_06_HEX="E8E9ED"
  export BASE24_COLOR_07_HEX="F5F7FA"
  export BASE24_COLOR_08_HEX="EF5253"
  export BASE24_COLOR_09_HEX="E66B2B"
  export BASE24_COLOR_0A_HEX="E4B51C"
  export BASE24_COLOR_0B_HEX="7CC844"
  export BASE24_COLOR_0C_HEX="52CBB0"
  export BASE24_COLOR_0D_HEX="33B5E1"
  export BASE24_COLOR_0E_HEX="A363D5"
  export BASE24_COLOR_0F_HEX="D73C9A"
  export BASE24_COLOR_10_HEX="18262F"
  export BASE24_COLOR_11_HEX="18262F"
  export BASE24_COLOR_12_HEX="EF5253"
  export BASE24_COLOR_13_HEX="E4B51C"
  export BASE24_COLOR_14_HEX="7CC844"
  export BASE24_COLOR_15_HEX="52CBB0"
  export BASE24_COLOR_16_HEX="33B5E1"
  export BASE24_COLOR_17_HEX="A363D5"
fi
