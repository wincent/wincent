#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Hivacruz 
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="hivacruz"

color00="13/25/37" # Base 00 - Black
color01="c9/49/22" # Base 08 - Red
color02="ac/97/39" # Base 0B - Green
color03="89/8e/a4" # Base 0A - Yellow
color04="3d/8f/d1" # Base 0D - Blue
color05="66/79/cc" # Base 0E - Magenta
color06="22/a2/c9" # Base 0C - Cyan
color07="97/9d/b4" # Base 06 - White
color08="6b/73/94" # Base 02 - Bright Black
color09="c7/6b/29" # Base 12 - Bright Red
color10="73/ad/43" # Base 14 - Bright Green
color11="5e/66/87" # Base 13 - Bright Yellow
color12="89/8e/a4" # Base 16 - Bright Blue
color13="df/e2/f1" # Base 17 - Bright Magenta
color14="9c/63/7a" # Base 15 - Bright Cyan
color15="f5/f7/ff" # Base 07 - Bright White
color16="c0/8b/30" # Base 09
color17="64/24/11" # Base 0F
color18="20/27/46" # Base 01
color19="6b/73/94" # Base 02
color20="81/88/a4" # Base 04
color21="97/9d/b4" # Base 06
color_foreground="8c/92/ac" # Base 05
color_background="13/25/37" # Base 00


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
  put_template_custom Pg 8c92ac # foreground
  put_template_custom Ph 132537 # background
  put_template_custom Pi 8c92ac # bold color
  put_template_custom Pj 6b7394 # selection color
  put_template_custom Pk 8c92ac # selected text color
  put_template_custom Pl 8c92ac # cursor
  put_template_custom Pm 132537 # cursor text
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
  export BASE24_COLOR_00_HEX="132537"
  export BASE24_COLOR_01_HEX="202746"
  export BASE24_COLOR_02_HEX="6b7394"
  export BASE24_COLOR_03_HEX="767d9c"
  export BASE24_COLOR_04_HEX="8188a4"
  export BASE24_COLOR_05_HEX="8c92ac"
  export BASE24_COLOR_06_HEX="979db4"
  export BASE24_COLOR_07_HEX="f5f7ff"
  export BASE24_COLOR_08_HEX="c94922"
  export BASE24_COLOR_09_HEX="c08b30"
  export BASE24_COLOR_0A_HEX="898ea4"
  export BASE24_COLOR_0B_HEX="ac9739"
  export BASE24_COLOR_0C_HEX="22a2c9"
  export BASE24_COLOR_0D_HEX="3d8fd1"
  export BASE24_COLOR_0E_HEX="6679cc"
  export BASE24_COLOR_0F_HEX="642411"
  export BASE24_COLOR_10_HEX="474c62"
  export BASE24_COLOR_11_HEX="232631"
  export BASE24_COLOR_12_HEX="c76b29"
  export BASE24_COLOR_13_HEX="5e6687"
  export BASE24_COLOR_14_HEX="73ad43"
  export BASE24_COLOR_15_HEX="9c637a"
  export BASE24_COLOR_16_HEX="898ea4"
  export BASE24_COLOR_17_HEX="dfe2f1"
fi
