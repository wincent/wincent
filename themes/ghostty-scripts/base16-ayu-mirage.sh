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


ghostty_palette_color_0="#1f2430"
ghostty_palette_color_1="#f28779"
ghostty_palette_color_2="#d5ff80"
ghostty_palette_color_3="#ffd173"
ghostty_palette_color_4="#73d0ff"
ghostty_palette_color_5="#d4bfff"
ghostty_palette_color_6="#95e6cb"
ghostty_palette_color_7="#cccac2"
ghostty_palette_color_8="#323844"
ghostty_palette_color_9="#f28779"
ghostty_palette_color_10="#d5ff80"
ghostty_palette_color_11="#ffd173"
ghostty_palette_color_12="#73d0ff"
ghostty_palette_color_13="#d4bfff"
ghostty_palette_color_14="#95e6cb"
ghostty_palette_color_15="#f3f4f5"
ghostty_palette_color_16="#ffad66"
ghostty_palette_color_17="#f27983"
ghostty_palette_color_18="#242936"
ghostty_palette_color_19="#323844"
ghostty_palette_color_20="#707a8c"
ghostty_palette_color_21="#d9d7ce"

_theme_file() {
cat <<EOF
# vim: ft=ghostty
# Ayu Mirage theme for Ghostty
# Scheme Author: Tinted Theming (https://github.com/tinted-theming), Ayu Theme (https://github.com/ayu-theme)
# Scheme System: base16
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
palette = 16=$ghostty_palette_color_16
palette = 17=$ghostty_palette_color_17
palette = 18=$ghostty_palette_color_18
palette = 19=$ghostty_palette_color_19
palette = 20=$ghostty_palette_color_20
palette = 21=$ghostty_palette_color_21

# Foreground & background colors
background = $ghostty_palette_color_0
foreground = $ghostty_palette_color_7
cursor-color = $ghostty_palette_color_7
selection-background = $ghostty_palette_color_8
selection-foreground = $ghostty_palette_color_7

# Set \`macos-icon\` = custom-style in your main configuration file to enable theming of the app icon.
EOF
}

_palette_value() {
    # Indirect expansion is not POSIX-compliant. Writing this as a switch-case avoids using eval and injection risks that
    # comes with it.
    case "$1" in
        "0") echo $ghostty_palette_color_0
            break
            ;;
        "1") echo $ghostty_palette_color_1
            break
            ;;
        "2") echo $ghostty_palette_color_2
            break
            ;;
        "3") echo $ghostty_palette_color_3
            break
            ;;
        "4") echo $ghostty_palette_color_4
            break
            ;;
        "5") echo $ghostty_palette_color_5
            break
            ;;
        "6") echo $ghostty_palette_color_6
            break
            ;;
        "7") echo $ghostty_palette_color_7
            break
            ;;
        "8") echo $ghostty_palette_color_8
            break
            ;;
        "9") echo $ghostty_palette_color_9
            break
            ;;
        "10") echo $ghostty_palette_color_10
            break
            ;;
        "11") echo $ghostty_palette_color_11
            break
            ;;
        "12") echo $ghostty_palette_color_12
            break
            ;;
        "13") echo $ghostty_palette_color_13
            break
            ;;
        "14") echo $ghostty_palette_color_14
            break
            ;;
        "15") echo $ghostty_palette_color_15
            break
            ;;
        "16") echo $ghostty_palette_color_16
            break
            ;;
        "17") echo $ghostty_palette_color_17
            break
            ;;
        "18") echo $ghostty_palette_color_18
            break
            ;;
        "19") echo $ghostty_palette_color_19
            break
            ;;
        "20") echo $ghostty_palette_color_20
            break
            ;;
        "21") echo $ghostty_palette_color_21
            break
            ;;
    esac
}



OPTIND=1

OPTS=$(getopt g:s:h $*) || exit 2

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
        -h)
            _help
            exit 1
            ;;
    esac
done

screen_color_values=
ghost_color_value=$(_palette_value $ghost_color_arg)

_theme_file

if [ -n "$ghost_color_value" ]; then
    echo "# Extracted palette color $ghost_color_arg:"
    echo "macos-icon-ghost-color = $ghost_color_value"
fi

# Parse comma-separated string in POSIX-compliant way
# TODO: There has to be a better way to do this.
screen_color_values=$(
    o=
    echo $screen_colors_arg | tr ',' "\n" | while read c; do
        color_value=$(_palette_value $c)
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
