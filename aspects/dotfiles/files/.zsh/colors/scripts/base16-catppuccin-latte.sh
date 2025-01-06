#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Catppuccin Latte 
# Scheme author: https://github.com/catppuccin/catppuccin
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="catppuccin-latte"

color00="ef/f1/f5" # Base 00 - Black
color01="d2/0f/39" # Base 08 - Red
color02="40/a0/2b" # Base 0B - Green
color03="df/8e/1d" # Base 0A - Yellow
color04="1e/66/f5" # Base 0D - Blue
color05="88/39/ef" # Base 0E - Magenta
color06="17/92/99" # Base 0C - Cyan
color07="dc/8a/78" # Base 06 - White
color08="cc/d0/da" # Base 02 - Bright Black
color09="e6/45/53" # Base 12 - Bright Red
color10="40/a0/2b" # Base 14 - Bright Green
color11="dc/8a/78" # Base 13 - Bright Yellow
color12="20/9f/b5" # Base 16 - Bright Blue
color13="ea/76/cb" # Base 17 - Bright Magenta
color14="04/a5/e5" # Base 15 - Bright Cyan
color15="72/87/fd" # Base 07 - Bright White
color16="fe/64/0b" # Base 09
color17="dd/78/78" # Base 0F
color18="e6/e9/ef" # Base 01
color19="cc/d0/da" # Base 02
color20="ac/b0/be" # Base 04
color21="dc/8a/78" # Base 06
color_foreground="4c/4f/69" # Base 05
color_background="ef/f1/f5" # Base 00


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
  put_template_custom Pg 4c4f69 # foreground
  put_template_custom Ph eff1f5 # background
  put_template_custom Pi 4c4f69 # bold color
  put_template_custom Pj ccd0da # selection color
  put_template_custom Pk 4c4f69 # selected text color
  put_template_custom Pl 4c4f69 # cursor
  put_template_custom Pm eff1f5 # cursor text
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
  export BASE24_COLOR_00_HEX="eff1f5"
  export BASE24_COLOR_01_HEX="e6e9ef"
  export BASE24_COLOR_02_HEX="ccd0da"
  export BASE24_COLOR_03_HEX="bcc0cc"
  export BASE24_COLOR_04_HEX="acb0be"
  export BASE24_COLOR_05_HEX="4c4f69"
  export BASE24_COLOR_06_HEX="dc8a78"
  export BASE24_COLOR_07_HEX="7287fd"
  export BASE24_COLOR_08_HEX="d20f39"
  export BASE24_COLOR_09_HEX="fe640b"
  export BASE24_COLOR_0A_HEX="df8e1d"
  export BASE24_COLOR_0B_HEX="40a02b"
  export BASE24_COLOR_0C_HEX="179299"
  export BASE24_COLOR_0D_HEX="1e66f5"
  export BASE24_COLOR_0E_HEX="8839ef"
  export BASE24_COLOR_0F_HEX="dd7878"
  export BASE24_COLOR_10_HEX="e6e9ef"
  export BASE24_COLOR_11_HEX="dce0e8"
  export BASE24_COLOR_12_HEX="e64553"
  export BASE24_COLOR_13_HEX="dc8a78"
  export BASE24_COLOR_14_HEX="40a02b"
  export BASE24_COLOR_15_HEX="04a5e5"
  export BASE24_COLOR_16_HEX="209fb5"
  export BASE24_COLOR_17_HEX="ea76cb"
fi
