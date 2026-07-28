#!/usr/bin/env bash
# Instructor / VM-prep only. Run as root AFTER building Level 3.
#
# Students log in as a normal user. Only a successful Level 3 exploit should
# yield a root shell. Levels 1–2 must NOT be setuid.
#
# Usage (from the lab root, as root):
#   ./setup-perms.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root: sudo $0" >&2
  exit 1
fi

bin="$ROOT_DIR/level3_nopsled/vulnerable"
if [ ! -f "$bin" ]; then
  echo "missing (build Level 3 first): $bin" >&2
  exit 1
fi

echo "Levels 1–2 stay normal."
echo "Setting setuid-root on Level 3 only..."
chown root:root "$bin"
chmod 4755 "$bin"
ls -l "$bin"

echo
echo "Done. Before Level 3 exploit: id  (not root)"
echo "After successful Level 3 shell: id  (uid=0)"
