#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Solar Flare Light
# Scheme author: Chuck Harmston (https://chuck.harmston.ch)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE16_THEME=solarflare-light

color00="f5/f7/fa" # Base 00 - Black
color01="ef/52/53" # Base 08 - Red
color02="7c/c8/44" # Base 0B - Green
color03="e4/b5/1c" # Base 0A - Yellow
color04="33/b5/e1" # Base 0D - Blue
color05="a3/63/d5" # Base 0E - Magenta
color06="52/cb/b0" # Base 0C - Cyan
color07="58/68/75" # Base 05 - White
color08="85/93/9e" # Base 03 - Bright Black
color09="$color01" # Base 08 - Bright Red
color10="$color02" # Base 0B - Bright Green
color11="$color03" # Base 0A - Bright Yellow
color12="$color04" # Base 0D - Bright Blue
color13="$color05" # Base 0E - Bright Magenta
color14="$color06" # Base 0C - Bright Cyan
color15="18/26/2f" # Base 07 - Bright White
color16="e6/6b/2b" # Base 09
color17="d7/3c/9a" # Base 0F
color18="e8/e9/ed" # Base 01
color19="a6/af/b8" # Base 02
color20="66/75/81" # Base 04
color21="22/2e/38" # Base 06
color_foreground="58/68/75" # Base 05
color_background="f5/f7/fa" # Base 00

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
  put_template_custom Pg 586875 # foreground
  put_template_custom Ph f5f7fa # background
  put_template_custom Pi 586875 # bold color
  put_template_custom Pj a6afb8 # selection color
  put_template_custom Pk 586875 # selected text color
  put_template_custom Pl 586875 # cursor
  put_template_custom Pm f5f7fa # cursor text
else
  put_template_var 10 "$color_foreground"
  if [ "$BASE16_SHELL_SET_BACKGROUND" != false ]; then
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
if [ -n "$TINTED_SHELL_ENABLE_BASE16_VARS" ] || [ -n "$BASE16_SHELL_ENABLE_VARS" ]; then
  export BASE16_COLOR_00_HEX="f5f7fa"
  export BASE16_COLOR_01_HEX="e8e9ed"
  export BASE16_COLOR_02_HEX="a6afb8"
  export BASE16_COLOR_03_HEX="85939e"
  export BASE16_COLOR_04_HEX="667581"
  export BASE16_COLOR_05_HEX="586875"
  export BASE16_COLOR_06_HEX="222e38"
  export BASE16_COLOR_07_HEX="18262f"
  export BASE16_COLOR_08_HEX="ef5253"
  export BASE16_COLOR_09_HEX="e66b2b"
  export BASE16_COLOR_0A_HEX="e4b51c"
  export BASE16_COLOR_0B_HEX="7cc844"
  export BASE16_COLOR_0C_HEX="52cbb0"
  export BASE16_COLOR_0D_HEX="33b5e1"
  export BASE16_COLOR_0E_HEX="a363d5"
  export BASE16_COLOR_0F_HEX="d73c9a"
fi
