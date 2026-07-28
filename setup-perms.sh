#!/usr/bin/env bash
# Instructor / VM-prep only. Run as root AFTER building Level 2 and 3.
#
# Students log in as a normal user. Only a successful exploit should yield
# a root shell. That requires these binaries to be setuid-root.
#
# Usage (from the lab root, as root):
#   ./setup-perms.sh
#
# If a student runs `make` again, the new binary loses setuid. Re-run this
# script (or provide a limited sudoers rule for it).

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root: sudo $0" >&2
  exit 1
fi

fix_setuid() {
  local bin="$1"
  if [ ! -f "$bin" ]; then
    echo "missing (build first): $bin" >&2
    exit 1
  fi
  chown root:root "$bin"
  chmod 4755 "$bin"
  ls -l "$bin"
}

echo "Level 1 stays normal (no root shell on this level)."
echo "Setting setuid-root on Level 2 and Level 3 binaries..."

fix_setuid "$ROOT_DIR/level2_nopsled/vulnerable"
fix_setuid "$ROOT_DIR/level3_rootshell/vulnerable"

echo
echo "Done. Students should see uid!=0 before the exploit:"
echo "  id"
echo "and uid=0 inside the shell after a successful Level 2/3 attack."
