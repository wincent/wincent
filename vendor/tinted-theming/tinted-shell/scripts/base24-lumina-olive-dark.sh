#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Lumina Olive Dark
# Scheme author: Razik Ikhlef (https://github.com/RazikSF)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="lumina-olive-dark"

color00="1a/1b/0c" # Base 00 - Black
color01="d3/72/6a" # Base 08 - Red
color02="b5/d5/c6" # Base 0B - Green
color03="eb/c2/7c" # Base 0A - Yellow
color04="a2/c4/f0" # Base 0D - Blue
color05="c0/ba/f2" # Base 0E - Magenta
color06="8b/cf/d7" # Base 0C - Cyan
color07="e1/df/ce" # Base 05 - White
color08="32/34/22" # Base 03 - Bright Black
color09="e0/93/8c" # Base 12 - Bright Red
color10="b5/f7/da" # Base 14 - Bright Green
color11="ff/de/a7" # Base 13 - Bright Yellow
color12="c4/dd/ff" # Base 16 - Bright Blue
color13="f0/bb/eb" # Base 17 - Bright Magenta
color14="a3/e9/f2" # Base 15 - Bright Cyan
color15="e1/df/ce" # Base 07 - Bright White
color16="ff/c3/9b" # Base 09
color17="d5/a2/d0" # Base 0F
color18="1f/20/0f" # Base 01
color19="28/29/18" # Base 02
color20="6a/6e/58" # Base 04
color21="b1/b2/a5" # Base 06
color_foreground="e1/df/ce" # Base 05
color_background="1a/1b/0c" # Base 00


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
  put_template_custom Pg e1dfce # foreground
  put_template_custom Ph 1a1b0c # background
  put_template_custom Pi e1dfce # bold color
  put_template_custom Pj 282918 # selection color
  put_template_custom Pk e1dfce # selected text color
  put_template_custom Pl e1dfce # cursor
  put_template_custom Pm 1a1b0c # cursor text
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
  export BASE24_COLOR_00_HEX="1a1b0c"
  export BASE24_COLOR_01_HEX="1f200f"
  export BASE24_COLOR_02_HEX="282918"
  export BASE24_COLOR_03_HEX="323422"
  export BASE24_COLOR_04_HEX="6a6e58"
  export BASE24_COLOR_05_HEX="e1dfce"
  export BASE24_COLOR_06_HEX="b1b2a5"
  export BASE24_COLOR_07_HEX="e1dfce"
  export BASE24_COLOR_08_HEX="d3726a"
  export BASE24_COLOR_09_HEX="ffc39b"
  export BASE24_COLOR_0A_HEX="ebc27c"
  export BASE24_COLOR_0B_HEX="b5d5c6"
  export BASE24_COLOR_0C_HEX="8bcfd7"
  export BASE24_COLOR_0D_HEX="a2c4f0"
  export BASE24_COLOR_0E_HEX="c0baf2"
  export BASE24_COLOR_0F_HEX="d5a2d0"
  export BASE24_COLOR_10_HEX="0f1004"
  export BASE24_COLOR_11_HEX="131406"
  export BASE24_COLOR_12_HEX="e0938c"
  export BASE24_COLOR_13_HEX="ffdea7"
  export BASE24_COLOR_14_HEX="b5f7da"
  export BASE24_COLOR_15_HEX="a3e9f2"
  export BASE24_COLOR_16_HEX="c4ddff"
  export BASE24_COLOR_17_HEX="f0bbeb"
fi
