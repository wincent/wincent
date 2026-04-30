#!/usr/bin/env sh
# vim: ft=sh

_help() {
    2>&1 cat <<EOF
Generates a Ghostty theme file with macos-icon-ghost-color and macos-icon-screen-color directives
based on an existing theme. This script is mainly designed to be used with tinted-theming/tinty.

OPTIONS:

    -g palette_index
    	Use palette[palette_index] as macos-icon-ghost-color

    -s palette_index|palette_indices

        Use palette[palette_index] as macos-icon-screen-color. 
        If you wish the screen color to be a gradient, specify a comma-separated list of 
        indices e.g. -s 12,6,2
EOF
}

ghostty_palette_color_0="#2e3440"
ghostty_palette_color_1="#bf616a"
ghostty_palette_color_2="#a3be8c"
ghostty_palette_color_3="#ebcb8b"
ghostty_palette_color_4="#81a1c1"
ghostty_palette_color_5="#b48ead"
ghostty_palette_color_6="#88c0d0"
ghostty_palette_color_7="#e5e9f0"
ghostty_palette_color_8="#465165"
ghostty_palette_color_9="#d18d93"
ghostty_palette_color_10="#c2d4b3"
ghostty_palette_color_11="#f4e2bf"
ghostty_palette_color_12="#aac0d5"
ghostty_palette_color_13="#ccb3c8"
ghostty_palette_color_14="#b4d7e1"
ghostty_palette_color_15="#eceff4"

ghostty_ui_background_color="#2e3440"
ghostty_ui_foreground_color="#e5e9f0"
ghostty_ui_cursorcolor_color="#2e3440"
ghostty_ui_selectionbackground_color="#465165"
ghostty_ui_selectionforeground_color="#e5e9f0"

_theme_file() {
cat <<EOF
# vim: ft=ghostty
# Nord theme for Ghostty
# Scheme Author: Tinted Theming (https://github.com/tinted-theming)
# Scheme System: tinted8
# Template Author: Tinted Terminal (https://github.com/tinted-theming/tinted-terminal)

# Color palette
palette = 0=$ghostty_palette_color_0
palette = 1=$ghostty_palette_color_1
palette = 2=$ghostty_palette_color_2
palette = 3=$ghostty_palette_color_3
palette = 4=$ghostty_palette_color_4
palette = 5=$ghostty_palette_color_5
palette = 6=$ghostty_palette_color_6
palette = 7=$ghostty_palette_color_7
palette = 8=$ghostty_palette_color_8
palette = 9=$ghostty_palette_color_9
palette = 10=$ghostty_palette_color_10
palette = 11=$ghostty_palette_color_11
palette = 12=$ghostty_palette_color_12
palette = 13=$ghostty_palette_color_13
palette = 14=$ghostty_palette_color_14
palette = 15=$ghostty_palette_color_15

# Foreground & background colors
background = $ghostty_ui_background_color
foreground = $ghostty_ui_foreground_color
cursor-color = $ghostty_ui_cursorcolor_color
selection-background = $ghostty_ui_selectionbackground_color
selection-foreground = $ghostty_ui_selectionforeground_color

# Set \`macos-icon\` = custom-style in your main configuration file to enable theming of the app icon.
EOF
}

_palette_value() {
    # Indirect expansion is not POSIX-compliant. Writing this as a switch-case avoids using eval and injection risks that
    # comes with it.
    case "$1" in
        "0") echo "$ghostty_palette_color_0"
            return
            ;;
        "1") echo "$ghostty_palette_color_1"
            return
            ;;
        "2") echo "$ghostty_palette_color_2"
            return
            ;;
        "3") echo "$ghostty_palette_color_3"
            return
            ;;
        "4") echo "$ghostty_palette_color_4"
            return
            ;;
        "5") echo "$ghostty_palette_color_5"
            return
            ;;
        "6") echo "$ghostty_palette_color_6"
            return
            ;;
        "7") echo "$ghostty_palette_color_7"
            return
            ;;
        "8") echo "$ghostty_palette_color_8"
            return
            ;;
        "9") echo "$ghostty_palette_color_9"
            return
            ;;
        "10") echo "$ghostty_palette_color_10"
            return
            ;;
        "11") echo "$ghostty_palette_color_11"
            return
            ;;
        "12") echo "$ghostty_palette_color_12"
            return
            ;;
        "13") echo "$ghostty_palette_color_13"
            return
            ;;
        "14") echo "$ghostty_palette_color_14"
            return
            ;;
        "15") echo "$ghostty_palette_color_15"
            return
            ;;
    esac
}



OPTIND=1

OPTS=$(getopt g:s:h "$*") || exit 2

eval set -- "$OPTS"

ghost_color_arg=15 # Default ghost color to Bright White
screen_colors_arg=12 # Default screen color to Bright Blue

while [ -n "$1" ]; do
    case "$1" in
        -g)
            ghost_color_arg="$2"
            shift 2
            ;;
        -s)
            screen_colors_arg="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        -h)
            shift
            _help
            exit 0
            ;;
    esac
done

screen_color_values=
ghost_color_value=$(_palette_value "$ghost_color_arg")

_theme_file

if [ -n "$ghost_color_value" ]; then
    echo "# Extracted palette color $ghost_color_arg:"
    echo "macos-icon-ghost-color = $ghost_color_value"
fi

# Parse comma-separated string in POSIX-compliant way
# TODO: There has to be a better way to do this.
screen_color_values=$(
    o=
    echo "$screen_colors_arg" | tr ',' "\n" | while read c; do
        color_value=$(_palette_value "$c")
        if [ -n "$color_value" ]; then
            if [ -n "$o" ]; then
                color_value=",$color_value"
            fi
            o="$o$color_value"
            echo "$o"
        fi
    done | tail -n 1
)

if [ -n "$screen_color_values" ]; then
    echo "# Extracted palette colors $screen_colors_arg:"
    echo "macos-icon-screen-color = $screen_color_values"
fi
