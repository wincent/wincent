#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Ocote
# Scheme author: Teshre
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="ocote"

color00="14/10/0C" # Base 00 - Black
color01="E8/63/5A" # Base 08 - Red
color02="7D/C9/7A" # Base 0B - Green
color03="E8/B4/3A" # Base 0A - Yellow
color04="82/A6/E0" # Base 0D - Blue
color05="C5/8A/E0" # Base 0E - Magenta
color06="6D/D8/C8" # Base 0C - Cyan
color07="E7/DC/C6" # Base 05 - White
color08="6B/62/53" # Base 03 - Bright Black
color09="E8/63/5A" # Base 12 - Bright Red
color10="7D/C9/7A" # Base 14 - Bright Green
color11="E8/B4/3A" # Base 13 - Bright Yellow
color12="82/A6/E0" # Base 16 - Bright Blue
color13="C5/8A/E0" # Base 17 - Bright Magenta
color14="6D/D8/C8" # Base 15 - Bright Cyan
color15="FA/F6/EC" # Base 07 - Bright White
color16="E8/84/3A" # Base 09
color17="4A/3E/2C" # Base 0F
color18="21/1B/13" # Base 01
color19="3A/2E/1C" # Base 02
color20="A9/9F/8D" # Base 04
color21="F1/E9/D9" # Base 06
color_foreground="E7/DC/C6" # Base 05
color_background="14/10/0C" # Base 00


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
  put_template_custom Pg E7DCC6 # foreground
  put_template_custom Ph 14100C # background
  put_template_custom Pi E7DCC6 # bold color
  put_template_custom Pj 3A2E1C # selection color
  put_template_custom Pk E7DCC6 # selected text color
  put_template_custom Pl E7DCC6 # cursor
  put_template_custom Pm 14100C # cursor text
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
  export BASE24_COLOR_00_HEX="14100C"
  export BASE24_COLOR_01_HEX="211B13"
  export BASE24_COLOR_02_HEX="3A2E1C"
  export BASE24_COLOR_03_HEX="6B6253"
  export BASE24_COLOR_04_HEX="A99F8D"
  export BASE24_COLOR_05_HEX="E7DCC6"
  export BASE24_COLOR_06_HEX="F1E9D9"
  export BASE24_COLOR_07_HEX="FAF6EC"
  export BASE24_COLOR_08_HEX="E8635A"
  export BASE24_COLOR_09_HEX="E8843A"
  export BASE24_COLOR_0A_HEX="E8B43A"
  export BASE24_COLOR_0B_HEX="7DC97A"
  export BASE24_COLOR_0C_HEX="6DD8C8"
  export BASE24_COLOR_0D_HEX="82A6E0"
  export BASE24_COLOR_0E_HEX="C58AE0"
  export BASE24_COLOR_0F_HEX="4A3E2C"
  export BASE24_COLOR_10_HEX="14100C"
  export BASE24_COLOR_11_HEX="14100C"
  export BASE24_COLOR_12_HEX="E8635A"
  export BASE24_COLOR_13_HEX="E8B43A"
  export BASE24_COLOR_14_HEX="7DC97A"
  export BASE24_COLOR_15_HEX="6DD8C8"
  export BASE24_COLOR_16_HEX="82A6E0"
  export BASE24_COLOR_17_HEX="C58AE0"
fi
