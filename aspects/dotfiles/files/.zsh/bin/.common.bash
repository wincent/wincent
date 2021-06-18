#!/bin/bash

BOLD=$(tput bold)
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
RESET=$(tput sgr0)
YELLOW=$(tput setaf 3)

bold() {
  echo -n "${BOLD}$1${RESET}"
}

green() {
  echo -n "${GREEN}${BOLD}$1${RESET}"
}

red() {
  echo -n "${RED}${BOLD}$1${RESET}"
}

yellow() {
  echo -n "${YELLOW}${BOLD}$1${RESET}"
}
