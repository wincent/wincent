#!/usr/bin/env sh
# tinted-shell (https://github.com/tinted-theming/tinted-shell)
# Scheme name: Banana Blueberry
# Scheme author: FredHappyface (https://github.com/fredHappyface)
# Template author: Tinted Theming (https://github.com/tinted-theming)
export BASE24_THEME="banana-blueberry"

color00="19/13/22" # Base 00 - Black
color01="ff/6a/7e" # Base 08 - Red
color02="00/bc/9b" # Base 0B - Green
color03="91/ff/f3" # Base 0A - Yellow
color04="22/e8/df" # Base 0D - Blue
color05="dc/39/69" # Base 0E - Magenta
color06="55/b6/c1" # Base 0C - Cyan
color07="c6/c9/cd" # Base 05 - White
color08="72/79/85" # Base 03 - Bright Black
color09="fd/9e/a1" # Base 12 - Bright Red
color10="97/c3/78" # Base 14 - Bright Green
color11="f9/e4/6a" # Base 13 - Bright Yellow
color12="91/ff/f3" # Base 16 - Bright Blue
color13="da/70/d5" # Base 17 - Bright Magenta
color14="bc/f2/fe" # Base 15 - Bright Cyan
color15="fe/ff/ff" # Base 07 - Bright White
color16="e5/c6/2f" # Base 09
color17="7f/35/3f" # Base 0F
color18="16/14/1e" # Base 01
color19="48/51/61" # Base 02
color20="9c/a1/a9" # Base 04
color21="f1/f1/f1" # Base 06
color_foreground="c6/c9/cd" # Base 05
color_background="19/13/22" # Base 00


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
  put_template_custom Pg c6c9cd # foreground
  put_template_custom Ph 191322 # background
  put_template_custom Pi c6c9cd # bold color
  put_template_custom Pj 485161 # selection color
  put_template_custom Pk c6c9cd # selected text color
  put_template_custom Pl c6c9cd # cursor
  put_template_custom Pm 191322 # cursor text
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
  export BASE24_COLOR_00_HEX="191322"
  export BASE24_COLOR_01_HEX="16141e"
  export BASE24_COLOR_02_HEX="485161"
  export BASE24_COLOR_03_HEX="727985"
  export BASE24_COLOR_04_HEX="9ca1a9"
  export BASE24_COLOR_05_HEX="c6c9cd"
  export BASE24_COLOR_06_HEX="f1f1f1"
  export BASE24_COLOR_07_HEX="feffff"
  export BASE24_COLOR_08_HEX="ff6a7e"
  export BASE24_COLOR_09_HEX="e5c62f"
  export BASE24_COLOR_0A_HEX="91fff3"
  export BASE24_COLOR_0B_HEX="00bc9b"
  export BASE24_COLOR_0C_HEX="55b6c1"
  export BASE24_COLOR_0D_HEX="22e8df"
  export BASE24_COLOR_0E_HEX="dc3969"
  export BASE24_COLOR_0F_HEX="7f353f"
  export BASE24_COLOR_10_HEX="303640"
  export BASE24_COLOR_11_HEX="181b20"
  export BASE24_COLOR_12_HEX="fd9ea1"
  export BASE24_COLOR_13_HEX="f9e46a"
  export BASE24_COLOR_14_HEX="97c378"
  export BASE24_COLOR_15_HEX="bcf2fe"
  export BASE24_COLOR_16_HEX="91fff3"
  export BASE24_COLOR_17_HEX="da70d5"
fi
