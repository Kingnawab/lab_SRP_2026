#!/usr/bin/env bash
# Start the CSE 29 buffer-overflow lab in a 32-bit (i386) Linux container.
# The labs/ folder is mounted at /lab inside the container, so any edits you
# make on the Mac show up instantly in Linux (and vice versa).
#
# Usage:
#   ./start-lab.sh
#
# First run downloads the Debian image and installs tools (gcc/gdb/python3),
# which can take a few minutes under x86 emulation on Apple Silicon.
set -euo pipefail

LABS_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Starting 32-bit Linux lab (mounting $LABS_DIR at /lab)..."
echo

exec docker run --rm -it \
  --platform linux/386 \
  -v "$LABS_DIR:/lab" \
  -w /lab \
  debian:bookworm \
  /bin/bash -lc '
    if ! command -v gcc >/dev/null 2>&1; then
      echo "[setup] Installing build tools (first run only)..."
      apt-get update -qq
      apt-get install -y -qq build-essential gdb python3 file >/dev/null
    fi
    if [ -f /lab/level1_grade/intro.sh ]; then
      bash /lab/level1_grade/intro.sh
    fi
    cd /lab/level1_grade 2>/dev/null || cd /lab
    exec /bin/bash
  '
