#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Darktooth
# Scheme author: Jason Milkins (https://github.com/jasonm23)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="darktooth"

color00="1D/20/21" # Base 00 - Black
color01="FB/54/3F" # Base 08 - Red
color02="95/C0/85" # Base 0B - Green
color03="FA/C0/3B" # Base 0A - Yellow
color04="0D/66/78" # Base 0D - Blue
color05="8F/46/73" # Base 0E - Magenta
color06="8B/A5/9B" # Base 0C - Cyan
color07="A8/99/84" # Base 05 - White
color08="66/5C/54" # Base 03 - Bright Black
color09="FB/54/3F" # Base 12 - Bright Red
color10="95/C0/85" # Base 14 - Bright Green
color11="FA/C0/3B" # Base 13 - Bright Yellow
color12="0D/66/78" # Base 16 - Bright Blue
color13="8F/46/73" # Base 17 - Bright Magenta
color14="8B/A5/9B" # Base 15 - Bright Cyan
color15="FD/F4/C1" # Base 07 - Bright White
color16="FE/86/25" # Base 09
color17="A8/73/22" # Base 0F
color18="32/30/2F" # Base 01
color19="50/49/45" # Base 02
color20="92/83/74" # Base 04
color21="D5/C4/A1" # Base 06
color_foreground="A8/99/84" # Base 05
color_background="1D/20/21" # Base 00


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
  put_template_custom Pg A89984 # foreground
  put_template_custom Ph 1D2021 # background
  put_template_custom Pi A89984 # bold color
  put_template_custom Pj 504945 # selection color
  put_template_custom Pk A89984 # selected text color
  put_template_custom Pl A89984 # cursor
  put_template_custom Pm 1D2021 # cursor text
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
  export BASE24_COLOR_00_HEX="1D2021"
  export BASE24_COLOR_01_HEX="32302F"
  export BASE24_COLOR_02_HEX="504945"
  export BASE24_COLOR_03_HEX="665C54"
  export BASE24_COLOR_04_HEX="928374"
  export BASE24_COLOR_05_HEX="A89984"
  export BASE24_COLOR_06_HEX="D5C4A1"
  export BASE24_COLOR_07_HEX="FDF4C1"
  export BASE24_COLOR_08_HEX="FB543F"
  export BASE24_COLOR_09_HEX="FE8625"
  export BASE24_COLOR_0A_HEX="FAC03B"
  export BASE24_COLOR_0B_HEX="95C085"
  export BASE24_COLOR_0C_HEX="8BA59B"
  export BASE24_COLOR_0D_HEX="0D6678"
  export BASE24_COLOR_0E_HEX="8F4673"
  export BASE24_COLOR_0F_HEX="A87322"
  export BASE24_COLOR_10_HEX="1D2021"
  export BASE24_COLOR_11_HEX="1D2021"
  export BASE24_COLOR_12_HEX="FB543F"
  export BASE24_COLOR_13_HEX="FAC03B"
  export BASE24_COLOR_14_HEX="95C085"
  export BASE24_COLOR_15_HEX="8BA59B"
  export BASE24_COLOR_16_HEX="0D6678"
  export BASE24_COLOR_17_HEX="8F4673"
fi
