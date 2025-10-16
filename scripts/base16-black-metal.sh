#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Black Metal
# Scheme author: metalelf0 (https://github.com/metalelf0)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE16_THEME=black-metal

color00="00/00/00" # Base 00 - Black
color01="5f/87/87" # Base 08 - Red
color02="dd/99/99" # Base 0B - Green
color03="a0/66/66" # Base 0A - Yellow
color04="88/88/88" # Base 0D - Blue
color05="99/99/99" # Base 0E - Magenta
color06="aa/aa/aa" # Base 0C - Cyan
color07="c1/c1/c1" # Base 05 - White
color08="33/33/33" # Base 03 - Bright Black
color09="$color01" # Base 08 - Bright Red
color10="$color02" # Base 0B - Bright Green
color11="$color03" # Base 0A - Bright Yellow
color12="$color04" # Base 0D - Bright Blue
color13="$color05" # Base 0E - Bright Magenta
color14="$color06" # Base 0C - Bright Cyan
color15="c1/c1/c1" # Base 07 - Bright White
color16="aa/aa/aa" # Base 09
color17="44/44/44" # Base 0F
color18="12/12/12" # Base 01
color19="22/22/22" # Base 02
color20="99/99/99" # Base 04
color21="99/99/99" # Base 06
color_foreground="c1/c1/c1" # Base 05
color_background="00/00/00" # Base 00

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
  put_template_custom Pg c1c1c1 # foreground
  put_template_custom Ph 000000 # background
  put_template_custom Pi c1c1c1 # bold color
  put_template_custom Pj 222222 # selection color
  put_template_custom Pk c1c1c1 # selected text color
  put_template_custom Pl c1c1c1 # cursor
  put_template_custom Pm 000000 # cursor text
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
  export BASE16_COLOR_00_HEX="000000"
  export BASE16_COLOR_01_HEX="121212"
  export BASE16_COLOR_02_HEX="222222"
  export BASE16_COLOR_03_HEX="333333"
  export BASE16_COLOR_04_HEX="999999"
  export BASE16_COLOR_05_HEX="c1c1c1"
  export BASE16_COLOR_06_HEX="999999"
  export BASE16_COLOR_07_HEX="c1c1c1"
  export BASE16_COLOR_08_HEX="5f8787"
  export BASE16_COLOR_09_HEX="aaaaaa"
  export BASE16_COLOR_0A_HEX="a06666"
  export BASE16_COLOR_0B_HEX="dd9999"
  export BASE16_COLOR_0C_HEX="aaaaaa"
  export BASE16_COLOR_0D_HEX="888888"
  export BASE16_COLOR_0E_HEX="999999"
  export BASE16_COLOR_0F_HEX="444444"
fi
