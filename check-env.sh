#!/usr/bin/env bash
# Quick sanity check for the CSE 29 32-bit UTM lab VM.
set -euo pipefail

echo "== architecture =="
uname -m
getconf LONG_BIT

echo
echo "== ASLR =="
if [ -r /proc/sys/kernel/randomize_va_space ]; then
  cat /proc/sys/kernel/randomize_va_space
else
  echo "(could not read randomize_va_space)"
fi

echo
echo "== tools =="
command -v gcc && gcc --version | head -1
command -v gdb && gdb --version | head -1
command -v python3 && python3 --version
command -v make && make --version | head -1

echo
echo "== expected =="
echo "uname -m:          i686 (or similar 32-bit)"
echo "LONG_BIT:          32"
echo "randomize_va_space: 0  (run: sudo sysctl -w kernel.randomize_va_space=0)"
echo
echo "Then: cd level1_grade && make && file vulnerable"
