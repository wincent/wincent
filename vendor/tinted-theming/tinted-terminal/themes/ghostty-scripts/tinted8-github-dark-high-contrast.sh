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

ghostty_palette_color_0="#2f3742"
ghostty_palette_color_1="#ff9492"
ghostty_palette_color_2="#28d751"
ghostty_palette_color_3="#f0b72f"
ghostty_palette_color_4="#71b7ff"
ghostty_palette_color_5="#cb9eff"
ghostty_palette_color_6="#39c5cf"
ghostty_palette_color_7="#f0f6fc"
ghostty_palette_color_8="#656c76"
ghostty_palette_color_9="#ffb1af"
ghostty_palette_color_10="#4ae168"
ghostty_palette_color_11="#f7c843"
ghostty_palette_color_12="#91cbff"
ghostty_palette_color_13="#dbb7ff"
ghostty_palette_color_14="#56d4dd"
ghostty_palette_color_15="#ffffff"

ghostty_ui_background_color="#010409"
ghostty_ui_foreground_color="#ffffff"
ghostty_ui_cursorcolor_color="#ffffff"
ghostty_ui_selectionbackground_color="#656c76"
ghostty_ui_selectionforeground_color="#f0f6fc"
ghostty_ui_searchbackground_color="#656c76"
ghostty_ui_searchforeground_color="#f0b72f"
ghostty_ui_searchselectedbackground_color="#484e55"
ghostty_ui_searchselectedforeground_color="#f0b72f"

_theme_file() {
cat <<EOF
# vim: ft=ghostty
# Github Dark High Contrast theme for Ghostty
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
search-background = $ghostty_ui_searchbackground_color
search-foreground = $ghostty_ui_searchforeground_color
search-selected-background = $ghostty_ui_searchselectedbackground_color
search-selected-foreground = $ghostty_ui_searchselectedforeground_color

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
