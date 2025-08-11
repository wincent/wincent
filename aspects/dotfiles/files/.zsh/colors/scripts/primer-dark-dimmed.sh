#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Primer Dark Dimmed
# Scheme author: Jimmy Lin
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="primer-dark-dimmed"

color00="1c/21/28" # Base 00 - Black
color01="f4/70/67" # Base 08 - Red
color02="57/ab/5a" # Base 0B - Green
color03="c6/90/26" # Base 0A - Yellow
color04="53/9b/f5" # Base 0D - Blue
color05="e2/75/ad" # Base 0E - Magenta
color06="96/d0/ff" # Base 0C - Cyan
color07="90/9d/ab" # Base 05 - White
color08="54/5d/68" # Base 03 - Bright Black
color09="f4/70/67" # Base 12 - Bright Red
color10="57/ab/5a" # Base 14 - Bright Green
color11="c6/90/26" # Base 13 - Bright Yellow
color12="53/9b/f5" # Base 16 - Bright Blue
color13="e2/75/ad" # Base 17 - Bright Magenta
color14="96/d0/ff" # Base 15 - Bright Cyan
color15="cd/d9/e5" # Base 07 - Bright White
color16="e0/82/3d" # Base 09
color17="ae/56/22" # Base 0F
color18="37/3e/47" # Base 01
color19="44/4c/56" # Base 02
color20="76/83/90" # Base 04
color21="ad/ba/c7" # Base 06
color_foreground="90/9d/ab" # Base 05
color_background="1c/21/28" # Base 00


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
  put_template_custom Pg 909dab # foreground
  put_template_custom Ph 1c2128 # background
  put_template_custom Pi 909dab # bold color
  put_template_custom Pj 444c56 # selection color
  put_template_custom Pk 909dab # selected text color
  put_template_custom Pl 909dab # cursor
  put_template_custom Pm 1c2128 # cursor text
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
  export BASE24_COLOR_00_HEX="1c2128"
  export BASE24_COLOR_01_HEX="373e47"
  export BASE24_COLOR_02_HEX="444c56"
  export BASE24_COLOR_03_HEX="545d68"
  export BASE24_COLOR_04_HEX="768390"
  export BASE24_COLOR_05_HEX="909dab"
  export BASE24_COLOR_06_HEX="adbac7"
  export BASE24_COLOR_07_HEX="cdd9e5"
  export BASE24_COLOR_08_HEX="f47067"
  export BASE24_COLOR_09_HEX="e0823d"
  export BASE24_COLOR_0A_HEX="c69026"
  export BASE24_COLOR_0B_HEX="57ab5a"
  export BASE24_COLOR_0C_HEX="96d0ff"
  export BASE24_COLOR_0D_HEX="539bf5"
  export BASE24_COLOR_0E_HEX="e275ad"
  export BASE24_COLOR_0F_HEX="ae5622"
  export BASE24_COLOR_10_HEX="1c2128"
  export BASE24_COLOR_11_HEX="1c2128"
  export BASE24_COLOR_12_HEX="f47067"
  export BASE24_COLOR_13_HEX="c69026"
  export BASE24_COLOR_14_HEX="57ab5a"
  export BASE24_COLOR_15_HEX="96d0ff"
  export BASE24_COLOR_16_HEX="539bf5"
  export BASE24_COLOR_17_HEX="e275ad"
fi
