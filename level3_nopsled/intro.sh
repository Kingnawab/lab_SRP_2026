#!/usr/bin/env bash
# Animated hacker-style intro for Level 3.
# Usage:  ./intro.sh

COLOR_GREEN_BOLD=$'\033[1;32m'
COLOR_MAGENTA_BOLD=$'\033[1;35m'
COLOR_CYAN=$'\033[0;36m'
COLOR_DIM=$'\033[2m'
COLOR_RESET=$'\033[0m'

type_out() {
  local text="$1" delay="${2:-0.02}"
  for (( i=0; i<${#text}; i++ )); do
    printf '%s' "${text:$i:1}"
    sleep "$delay"
  done
  printf '\n'
}

clear 2>/dev/null
printf '%s' "$COLOR_GREEN_BOLD"
cat <<'ART'
   ____ ____  _____   ____   ___    _   _    _    ____ _  __
  / ___/ ___|| ____| |___ \ / _ \  | | | |  / \  / ___| |/ /
 | |   \___ \|  _|     __) | (_) | | |_| | / _ \| |   | ' /
 | |___ ___) | |___   / __/ \__, | |  _  |/ ___ \ |___| . \
  \____|____/|_____| |_____|  /_/  |_| |_/_/   \_\____|_|\_\
ART
printf '%s\n' "$COLOR_RESET"
sleep 0.3
printf '%s        [ CSE 29 :: LEVEL 3 :: NOP SLED → ROOT SHELL ]%s\n\n' "$COLOR_MAGENTA_BOLD" "$COLOR_RESET"
sleep 0.4

printf '%s' "$COLOR_CYAN"
type_out "  > mapping stack buffer......................... ok" 0.015
type_out "  > loading shellcode from shellcode.py.......... armed" 0.015
printf '%s\n' "$COLOR_RESET"
sleep 0.2

printf '%s' "$COLOR_GREEN_BOLD"
type_out "  psst... Level 2 hit one exact function. Level 3 injects your own code."
type_out "  Build a NOP runway, slide into shellcode, and become root."
printf '%s\n' "$COLOR_RESET"
sleep 0.2

printf '%s' "$COLOR_CYAN"
type_out "  MISSION: overwrite the return address into a NOP sled (\\x90)."
type_out "  Slide into shellcode.py (setuid + /bin/sh) and get a root shell."
type_out "  Try two different landings in the sled — both should work."
printf '%s\n' "$COLOR_RESET"

printf '%s' "$COLOR_DIM"
printf '  ---------------------------------------------------------\n'
printf '%s\n' "$COLOR_RESET"

printf '\n%s  Good luck, hacker.%s\n\n' "$COLOR_GREEN_BOLD" "$COLOR_RESET"
