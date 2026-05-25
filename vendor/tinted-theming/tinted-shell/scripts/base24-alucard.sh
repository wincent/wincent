#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Alucard
# Scheme author: clach04 (https://github.com/clach04)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="alucard"

color00="ff/fb/eb" # Base 00 - Black
color01="cb/3a/2a" # Base 08 - Red
color02="14/71/0a" # Base 0B - Green
color03="84/6e/15" # Base 0A - Yellow
color04="64/4a/c9" # Base 0D - Blue
color05="a3/14/4d" # Base 0E - Magenta
color06="03/6a/96" # Base 0C - Cyan
color07="1f/1f/1f" # Base 05 - White
color08="6c/66/4b" # Base 03 - Bright Black
color09="d7/4c/3d" # Base 12 - Bright Red
color10="19/8d/0c" # Base 14 - Bright Green
color11="9e/84/1a" # Base 13 - Bright Yellow
color12="78/62/d0" # Base 16 - Bright Blue
color13="bf/18/5a" # Base 17 - Bright Magenta
color14="04/7f/b4" # Base 15 - Bright Cyan
color15="2c/2b/31" # Base 07 - Bright White
color16="a3/4d/14" # Base 09
color17="79/22/19" # Base 0F
color18="ce/cc/c0" # Base 01
color19="cf/cf/de" # Base 02
color20="4c/4a/3d" # Base 04
color21="1f/1f/1f" # Base 06
color_foreground="1f/1f/1f" # Base 05
color_background="ff/fb/eb" # Base 00


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
  put_template_custom Pg 1f1f1f # foreground
  put_template_custom Ph fffbeb # background
  put_template_custom Pi 1f1f1f # bold color
  put_template_custom Pj cfcfde # selection color
  put_template_custom Pk 1f1f1f # selected text color
  put_template_custom Pl 1f1f1f # cursor
  put_template_custom Pm fffbeb # cursor text
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
if [ -n "$TINTED_SHELL_ENABLE_BASE24_VARS" ]; then
  export BASE24_COLOR_00_HEX="fffbeb"
  export BASE24_COLOR_01_HEX="ceccc0"
  export BASE24_COLOR_02_HEX="cfcfde"
  export BASE24_COLOR_03_HEX="6c664b"
  export BASE24_COLOR_04_HEX="4c4a3d"
  export BASE24_COLOR_05_HEX="1f1f1f"
  export BASE24_COLOR_06_HEX="1f1f1f"
  export BASE24_COLOR_07_HEX="2c2b31"
  export BASE24_COLOR_08_HEX="cb3a2a"
  export BASE24_COLOR_09_HEX="a34d14"
  export BASE24_COLOR_0A_HEX="846e15"
  export BASE24_COLOR_0B_HEX="14710a"
  export BASE24_COLOR_0C_HEX="036a96"
  export BASE24_COLOR_0D_HEX="644ac9"
  export BASE24_COLOR_0E_HEX="a3144d"
  export BASE24_COLOR_0F_HEX="792219"
  export BASE24_COLOR_10_HEX="fdf8e2"
  export BASE24_COLOR_11_HEX="f5f0da"
  export BASE24_COLOR_12_HEX="d74c3d"
  export BASE24_COLOR_13_HEX="9e841a"
  export BASE24_COLOR_14_HEX="198d0c"
  export BASE24_COLOR_15_HEX="047fb4"
  export BASE24_COLOR_16_HEX="7862d0"
  export BASE24_COLOR_17_HEX="bf185a"
fi
