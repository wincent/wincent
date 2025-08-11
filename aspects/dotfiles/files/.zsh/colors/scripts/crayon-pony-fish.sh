#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Crayon Pony Fish
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="crayon-pony-fish"

color00="14/06/07" # Base 00 - Black
color01="90/00/2a" # Base 08 - Red
color02="57/95/23" # Base 0B - Green
color03="cf/c9/ff" # Base 0A - Yellow
color04="8b/87/af" # Base 0D - Blue
color05="68/2e/50" # Base 0E - Magenta
color06="e8/a7/66" # Base 0C - Cyan
color07="5d/48/4e" # Base 05 - White
color08="47/34/38" # Base 03 - Bright Black
color09="c5/24/5c" # Base 12 - Bright Red
color10="8d/ff/56" # Base 14 - Bright Green
color11="c7/37/1d" # Base 13 - Bright Yellow
color12="cf/c9/ff" # Base 16 - Bright Blue
color13="fb/6c/b9" # Base 17 - Bright Magenta
color14="ff/ce/ae" # Base 15 - Bright Cyan
color15="af/94/9d" # Base 07 - Bright White
color16="aa/30/1b" # Base 09
color17="48/00/15" # Base 0F
color18="2a/1a/1c" # Base 01
color19="3c/2a/2e" # Base 02
color20="52/3e/43" # Base 04
color21="68/52/59" # Base 06
color_foreground="5d/48/4e" # Base 05
color_background="14/06/07" # Base 00


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
  put_template_custom Pg 5d484e # foreground
  put_template_custom Ph 140607 # background
  put_template_custom Pi 5d484e # bold color
  put_template_custom Pj 3c2a2e # selection color
  put_template_custom Pk 5d484e # selected text color
  put_template_custom Pl 5d484e # cursor
  put_template_custom Pm 140607 # cursor text
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
  export BASE24_COLOR_00_HEX="140607"
  export BASE24_COLOR_01_HEX="2a1a1c"
  export BASE24_COLOR_02_HEX="3c2a2e"
  export BASE24_COLOR_03_HEX="473438"
  export BASE24_COLOR_04_HEX="523e43"
  export BASE24_COLOR_05_HEX="5d484e"
  export BASE24_COLOR_06_HEX="685259"
  export BASE24_COLOR_07_HEX="af949d"
  export BASE24_COLOR_08_HEX="90002a"
  export BASE24_COLOR_09_HEX="aa301b"
  export BASE24_COLOR_0A_HEX="cfc9ff"
  export BASE24_COLOR_0B_HEX="579523"
  export BASE24_COLOR_0C_HEX="e8a766"
  export BASE24_COLOR_0D_HEX="8b87af"
  export BASE24_COLOR_0E_HEX="682e50"
  export BASE24_COLOR_0F_HEX="480015"
  export BASE24_COLOR_10_HEX="281c1e"
  export BASE24_COLOR_11_HEX="140e0f"
  export BASE24_COLOR_12_HEX="c5245c"
  export BASE24_COLOR_13_HEX="c7371d"
  export BASE24_COLOR_14_HEX="8dff56"
  export BASE24_COLOR_15_HEX="ffceae"
  export BASE24_COLOR_16_HEX="cfc9ff"
  export BASE24_COLOR_17_HEX="fb6cb9"
fi
