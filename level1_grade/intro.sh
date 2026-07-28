#!/usr/bin/env bash
# Animated hacker-style intro for Level 1.
# Usage:  ./intro.sh

COLOR_GREEN_BOLD=$'\033[1;32m'
COLOR_MAGENTA_BOLD=$'\033[1;35m'
COLOR_CYAN=$'\033[0;36m'
COLOR_DIM=$'\033[2m'
COLOR_RESET=$'\033[0m'

# typewriter: print text one char at a time
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
printf '%s        [ CSE 29 :: GRADE OVERRIDE TERMINAL ]%s\n\n' "$COLOR_MAGENTA_BOLD" "$COLOR_RESET"
sleep 0.4

printf '%s' "$COLOR_CYAN"
type_out "  > establishing connection to grade server......... ok" 0.015
type_out "  > bypassing auth............................. bypassed" 0.015
printf '%s\n' "$COLOR_RESET"
sleep 0.2

printf '%s' "$COLOR_GREEN_BOLD"
type_out "  psst... I heard you want to hack into the CSE 29 course files."
type_out "  How about we change your score to be devious..."
printf '%s\n' "$COLOR_RESET"
sleep 0.2

printf '%s' "$COLOR_CYAN"
type_out "  MISSION: your grade is locked at 'D'."
type_out "  The 'grade' field sits right after the 'name' buffer in memory."
type_out "  Overflow 'name', spill into 'grade', and set yourself an 'A+'."
printf '%s\n' "$COLOR_RESET"

printf '\n%s  Good luck, hacker.%s\n\n' "$COLOR_GREEN_BOLD" "$COLOR_RESET"
