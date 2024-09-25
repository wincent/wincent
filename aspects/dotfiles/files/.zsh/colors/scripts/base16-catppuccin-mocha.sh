#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Catppuccin Mocha 
# Scheme author: https://github.com/catppuccin/catppuccin
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE16_THEME=catppuccin-mocha

color00="1e/1e/2e" # Base 00 - Black
color01="f3/8b/a8" # Base 08 - Red
color02="a6/e3/a1" # Base 0B - Green
color03="f9/e2/af" # Base 0A - Yellow
color04="89/b4/fa" # Base 0D - Blue
color05="cb/a6/f7" # Base 0E - Magenta
color06="94/e2/d5" # Base 0C - Cyan
color07="cd/d6/f4" # Base 05 - White
color08="31/32/44" # Base 03 - Bright Black
color09="$color01" # Base 08 - Bright Red
color10="$color02" # Base 0B - Bright Green
color11="$color03" # Base 0A - Bright Yellow
color12="$color04" # Base 0D - Bright Blue
color13="$color05" # Base 0E - Bright Magenta
color14="$color06" # Base 0C - Bright Cyan
color15="b4/be/fe" # Base 07 - Bright White
color16="fa/b3/87" # Base 09
color17="f2/cd/cd" # Base 0F
color18="18/18/25" # Base 01
color19="31/32/44" # Base 02
color20="58/5b/70" # Base 04
color21="f5/e0/dc" # Base 06
color_foreground="cd/d6/f4" # Base 05
color_background="1e/1e/2e" # Base 00

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
  put_template_custom Pg cdd6f4 # foreground
  put_template_custom Ph 1e1e2e # background
  put_template_custom Pi cdd6f4 # bold color
  put_template_custom Pj 313244 # selection color
  put_template_custom Pk cdd6f4 # selected text color
  put_template_custom Pl cdd6f4 # cursor
  put_template_custom Pm 1e1e2e # cursor text
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
  export BASE16_COLOR_00_HEX="1e1e2e"
  export BASE16_COLOR_01_HEX="181825"
  export BASE16_COLOR_02_HEX="313244"
  export BASE16_COLOR_03_HEX="45475a"
  export BASE16_COLOR_04_HEX="585b70"
  export BASE16_COLOR_05_HEX="cdd6f4"
  export BASE16_COLOR_06_HEX="f5e0dc"
  export BASE16_COLOR_07_HEX="b4befe"
  export BASE16_COLOR_08_HEX="f38ba8"
  export BASE16_COLOR_09_HEX="fab387"
  export BASE16_COLOR_0A_HEX="f9e2af"
  export BASE16_COLOR_0B_HEX="a6e3a1"
  export BASE16_COLOR_0C_HEX="94e2d5"
  export BASE16_COLOR_0D_HEX="89b4fa"
  export BASE16_COLOR_0E_HEX="cba6f7"
  export BASE16_COLOR_0F_HEX="f2cdcd"
fi
