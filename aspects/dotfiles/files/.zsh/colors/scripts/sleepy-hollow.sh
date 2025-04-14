#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Sleepy Hollow 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="sleepy-hollow"

color00="12/12/13" # Base 00 - Black
color01="b9/39/34" # Base 08 - Red
color02="90/77/3e" # Base 0B - Green
color03="80/85/ef" # Base 0A - Yellow
color04="5e/62/b4" # Base 0D - Blue
color05="a0/7c/7b" # Base 0E - Magenta
color06="8e/ae/a9" # Base 0C - Cyan
color07="af/9a/91" # Base 06 - White
color08="4e/4b/60" # Base 02 - Bright Black
color09="d9/44/3e" # Base 12 - Bright Red
color10="d6/b0/4e" # Base 14 - Bright Green
color11="f6/67/13" # Base 13 - Bright Yellow
color12="80/85/ef" # Base 16 - Bright Blue
color13="e1/c2/ba" # Base 17 - Bright Magenta
color14="a4/db/e7" # Base 15 - Bright Cyan
color15="d1/c7/a9" # Base 07 - Bright White
color16="b4/56/00" # Base 09
color17="5c/1c/1a" # Base 0F
color18="57/20/00" # Base 01
color19="4e/4b/60" # Base 02
color20="7e/72/78" # Base 04
color21="af/9a/91" # Base 06
color_foreground="96/86/84" # Base 05
color_background="12/12/13" # Base 00


if [ -z "$TTY" ] && ! TTY=$(tty); then
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
  put_template_custom Pg 968684 # foreground
  put_template_custom Ph 121213 # background
  put_template_custom Pi 968684 # bold color
  put_template_custom Pj 4e4b60 # selection color
  put_template_custom Pk 968684 # selected text color
  put_template_custom Pl 968684 # cursor
  put_template_custom Pm 121213 # cursor text
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
  export BASE24_COLOR_00_HEX="121213"
  export BASE24_COLOR_01_HEX="572000"
  export BASE24_COLOR_02_HEX="4e4b60"
  export BASE24_COLOR_03_HEX="665e6c"
  export BASE24_COLOR_04_HEX="7e7278"
  export BASE24_COLOR_05_HEX="968684"
  export BASE24_COLOR_06_HEX="af9a91"
  export BASE24_COLOR_07_HEX="d1c7a9"
  export BASE24_COLOR_08_HEX="b93934"
  export BASE24_COLOR_09_HEX="b45600"
  export BASE24_COLOR_0A_HEX="8085ef"
  export BASE24_COLOR_0B_HEX="90773e"
  export BASE24_COLOR_0C_HEX="8eaea9"
  export BASE24_COLOR_0D_HEX="5e62b4"
  export BASE24_COLOR_0E_HEX="a07c7b"
  export BASE24_COLOR_0F_HEX="5c1c1a"
  export BASE24_COLOR_10_HEX="343240"
  export BASE24_COLOR_11_HEX="1a1920"
  export BASE24_COLOR_12_HEX="d9443e"
  export BASE24_COLOR_13_HEX="f66713"
  export BASE24_COLOR_14_HEX="d6b04e"
  export BASE24_COLOR_15_HEX="a4dbe7"
  export BASE24_COLOR_16_HEX="8085ef"
  export BASE24_COLOR_17_HEX="e1c2ba"
fi
