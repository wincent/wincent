#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Lumina Lagoon Dark
# Scheme author: Razik Ikhlef (https://github.com/RazikSF)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="lumina-lagoon-dark"

color00="04/29/30" # Base 00 - Black
color01="d3/72/6a" # Base 08 - Red
color02="9f/d4/a9" # Base 0B - Green
color03="e7/cf/94" # Base 0A - Yellow
color04="8e/c3/f9" # Base 0D - Blue
color05="c8/ba/f6" # Base 0E - Magenta
color06="5a/d3/d6" # Base 0C - Cyan
color07="d7/e6/e7" # Base 05 - White
color08="1c/43/4b" # Base 03 - Bright Black
color09="e0/93/8c" # Base 12 - Bright Red
color10="b8/ef/c2" # Base 14 - Bright Green
color11="ff/e6/a7" # Base 13 - Bright Yellow
color12="ba/dc/ff" # Base 16 - Bright Blue
color13="ff/ca/f9" # Base 17 - Bright Magenta
color14="9f/e6/e8" # Base 15 - Bright Cyan
color15="d7/e6/e7" # Base 07 - Bright White
color16="f9/b2/83" # Base 09
color17="e5/b0/df" # Base 0F
color18="04/2e/36" # Base 01
color19="10/39/41" # Base 02
color20="54/7c/86" # Base 04
color21="9d/b6/bc" # Base 06
color_foreground="d7/e6/e7" # Base 05
color_background="04/29/30" # Base 00


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
  put_template_custom Pg d7e6e7 # foreground
  put_template_custom Ph 042930 # background
  put_template_custom Pi d7e6e7 # bold color
  put_template_custom Pj 103941 # selection color
  put_template_custom Pk d7e6e7 # selected text color
  put_template_custom Pl d7e6e7 # cursor
  put_template_custom Pm 042930 # cursor text
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
  export BASE24_COLOR_00_HEX="042930"
  export BASE24_COLOR_01_HEX="042e36"
  export BASE24_COLOR_02_HEX="103941"
  export BASE24_COLOR_03_HEX="1c434b"
  export BASE24_COLOR_04_HEX="547c86"
  export BASE24_COLOR_05_HEX="d7e6e7"
  export BASE24_COLOR_06_HEX="9db6bc"
  export BASE24_COLOR_07_HEX="d7e6e7"
  export BASE24_COLOR_08_HEX="d3726a"
  export BASE24_COLOR_09_HEX="f9b283"
  export BASE24_COLOR_0A_HEX="e7cf94"
  export BASE24_COLOR_0B_HEX="9fd4a9"
  export BASE24_COLOR_0C_HEX="5ad3d6"
  export BASE24_COLOR_0D_HEX="8ec3f9"
  export BASE24_COLOR_0E_HEX="c8baf6"
  export BASE24_COLOR_0F_HEX="e5b0df"
  export BASE24_COLOR_10_HEX="001c22"
  export BASE24_COLOR_11_HEX="002229"
  export BASE24_COLOR_12_HEX="e0938c"
  export BASE24_COLOR_13_HEX="ffe6a7"
  export BASE24_COLOR_14_HEX="b8efc2"
  export BASE24_COLOR_15_HEX="9fe6e8"
  export BASE24_COLOR_16_HEX="badcff"
  export BASE24_COLOR_17_HEX="ffcaf9"
fi
