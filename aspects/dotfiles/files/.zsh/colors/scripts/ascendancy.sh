#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Ascendancy
# Scheme author: EmergentMind (https://github.com/emergentmind/ascendancy-scheme)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="ascendancy"

color00="28/28/28" # Base 00 - Black
color01="C0/39/00" # Base 08 - Red
color02="B8/BB/26" # Base 0B - Green
color03="FF/CC/1B" # Base 0A - Yellow
color04="45/85/88" # Base 0D - Blue
color05="FA/BD/2F" # Base 0E - Magenta
color06="8F/3F/71" # Base 0C - Cyan
color07="D5/C7/A1" # Base 05 - White
color08="92/83/74" # Base 03 - Bright Black
color09="C0/39/00" # Base 12 - Bright Red
color10="B8/BB/26" # Base 14 - Bright Green
color11="FF/CC/1B" # Base 13 - Bright Yellow
color12="45/85/88" # Base 16 - Bright Blue
color13="FA/BD/2F" # Base 17 - Bright Magenta
color14="8F/3F/71" # Base 15 - Bright Cyan
color15="fb/f1/c7" # Base 07 - Bright White
color16="FE/80/19" # Base 09
color17="B5/9B/4D" # Base 0F
color18="21/2F/3D" # Base 01
color19="50/49/45" # Base 02
color20="BD/AE/93" # Base 04
color21="EB/DB/B2" # Base 06
color_foreground="D5/C7/A1" # Base 05
color_background="28/28/28" # Base 00


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
  put_template_custom Pg D5C7A1 # foreground
  put_template_custom Ph 282828 # background
  put_template_custom Pi D5C7A1 # bold color
  put_template_custom Pj 504945 # selection color
  put_template_custom Pk D5C7A1 # selected text color
  put_template_custom Pl D5C7A1 # cursor
  put_template_custom Pm 282828 # cursor text
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
  export BASE24_COLOR_00_HEX="282828"
  export BASE24_COLOR_01_HEX="212F3D"
  export BASE24_COLOR_02_HEX="504945"
  export BASE24_COLOR_03_HEX="928374"
  export BASE24_COLOR_04_HEX="BDAE93"
  export BASE24_COLOR_05_HEX="D5C7A1"
  export BASE24_COLOR_06_HEX="EBDBB2"
  export BASE24_COLOR_07_HEX="fbf1c7"
  export BASE24_COLOR_08_HEX="C03900"
  export BASE24_COLOR_09_HEX="FE8019"
  export BASE24_COLOR_0A_HEX="FFCC1B"
  export BASE24_COLOR_0B_HEX="B8BB26"
  export BASE24_COLOR_0C_HEX="8F3F71"
  export BASE24_COLOR_0D_HEX="458588"
  export BASE24_COLOR_0E_HEX="FABD2F"
  export BASE24_COLOR_0F_HEX="B59B4D"
  export BASE24_COLOR_10_HEX="282828"
  export BASE24_COLOR_11_HEX="282828"
  export BASE24_COLOR_12_HEX="C03900"
  export BASE24_COLOR_13_HEX="FFCC1B"
  export BASE24_COLOR_14_HEX="B8BB26"
  export BASE24_COLOR_15_HEX="8F3F71"
  export BASE24_COLOR_16_HEX="458588"
  export BASE24_COLOR_17_HEX="FABD2F"
fi
