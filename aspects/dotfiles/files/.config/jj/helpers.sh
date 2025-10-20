RESET="\033[0m"

# Convert jj color name to ANSI code.
color_to_ansi() {
  case "$1" in
    black) echo "30" ;;
    red) echo "31" ;;
    green) echo "32" ;;
    yellow) echo "33" ;;
    blue) echo "34" ;;
    magenta) echo "35" ;;
    cyan) echo "36" ;;
    white) echo "37" ;;
    default|*) echo "" ;;
  esac
}

# Get ANSI codes from jj config.
get_jj_style() {
  local CONFIG_KEY="$1"
  local FG=$(jj config get "colors.\"${CONFIG_KEY}\".fg" 2>/dev/null || echo "default")
  local BOLD=$(jj config get "colors.\"${CONFIG_KEY}\".bold" 2>/dev/null || echo "false")

  local CODES=""
  if [ "$BOLD" = "true" ]; then
    CODES="1"
  fi

  local fg_code=$(color_to_ansi "$FG")
  if [ -n "$fg_code" ]; then
    if [ -n "$CODES" ]; then
      CODES="${CODES};${fg_code}"
    else
      CODES="$fg_code"
    fi
  fi

  if [ -n "$CODES" ]; then
    echo "\033[${CODES}m"
  fi
}

jj_error() {
  local STYLE=$(get_jj_style "error heading")
  echo >&2 "${STYLE}Error:${RESET} $*"
}

jj_hint() {
  local STYLE=$(get_jj_style "hint heading")
  echo >&2 "${STYLE}Hint:${RESET} $*"
}
