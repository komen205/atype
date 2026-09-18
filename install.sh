#!/usr/bin/env bash
# atype installer (public repo)
#   curl -fsSL https://raw.githubusercontent.com/komen205/atype/main/install.sh | bash
set -euo pipefail

REPO="komen205/atype"
BRANCH="${ATYPE_BRANCH:-main}"
RAW="https://raw.githubusercontent.com/$REPO/$BRANCH/atype"
BIN_DIR="${ATYPE_BIN_DIR:-$HOME/.local/bin}"
DEST="$BIN_DIR/atype"

say()  { printf '\033[1;32m==>\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m warn\033[0m %s\n' "$1"; }

command -v curl >/dev/null 2>&1 || {
  echo "curl is required" >&2; exit 1; }

say "Fetching atype from $REPO ($BRANCH)"
mkdir -p "$BIN_DIR"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
curl -fsSL "$RAW" -o "$tmp"
install -m 755 "$tmp" "$DEST"
say "Installed $DEST"

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) warn "$BIN_DIR is not on your PATH. Add to your shell rc:"
     printf '      export PATH="%s:$PATH"\n' "$BIN_DIR" ;;
esac

if [ -x "$HOME/Library/Android/sdk/platform-tools/adb" ]; then
  adb_bin="$HOME/Library/Android/sdk/platform-tools/adb"
elif command -v adb >/dev/null 2>&1; then
  adb_bin="$(command -v adb)"
else
  adb_bin=""
  warn "adb not found — install Android platform-tools or set ADB when running atype."
fi

if [ -n "$adb_bin" ]; then
  if "$adb_bin" devices | sed '1d' | grep -q '^emulator-.*[[:space:]]device'; then
    say "Android Emulator detected."
  else
    warn "No running Android Emulator detected."
  fi
fi

say "Done. Focus a text field, then try: atype \"hello\""
