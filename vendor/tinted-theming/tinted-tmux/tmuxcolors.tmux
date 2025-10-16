#!/usr/bin/env bash

main() {
  CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  theme="$(tmux show-option -gqv "@tinted-color")"

  # Use legacy `@colors-base16` variable if it exists
  if [ -z $theme ]; then
    theme="base16-$(tmux show-option -gqv "@colors-base16")"
  fi

  if [ -z "$theme" ]; then
    theme="base16-default-dark"
  fi

  case "$theme" in
    base16-*)
      theme_name="${theme#base16-}"
      ;;
    base24-*)
      theme_name="${theme#base24-}"
      ;;
    *)
      theme_name="$theme"
      ;;
  esac
  theme_system="${theme%%-*}"
  theme_system="$(printf '%s' "$theme_system" | sed 's/^[ \t]*//;s/[ \t]*$//')"

  if [ "$theme_system" = "base16" ] || [ "$theme_system" = "base24" ]; then
    tmux source-file "$CURRENT_DIR/colors/$theme_system-$theme_name.conf"
  else
    tmux display-message -t 0 "tinted-tmux: Unknown theme system: $theme_system (Supported values: base16, base24)"
  fi

  unset theme_option default_theme theme theme_name theme_system
}

main "$@"
