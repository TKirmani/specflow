#!/usr/bin/env sh
# specflow installer.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/TKirmani/specflow/main/install.sh | sh
#
# Environment overrides:
#   PREFIX          Install prefix (default: $HOME/.local)
#   SPECFLOW_REF    Git ref to install (default: main)

set -eu

PREFIX="${PREFIX:-$HOME/.local}"
BIN_DIR="$PREFIX/bin"
REPO_URL="https://github.com/TKirmani/specflow"
REF="${SPECFLOW_REF:-main}"

mkdir -p "$BIN_DIR"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "[specflow] fetching $REPO_URL@$REF"
if command -v git >/dev/null 2>&1; then
  git clone --depth 1 --branch "$REF" "$REPO_URL" "$TMP/specflow" >/dev/null 2>&1
elif command -v curl >/dev/null 2>&1; then
  curl -fsSL "$REPO_URL/archive/$REF.tar.gz" | tar -xz -C "$TMP"
  mv "$TMP"/specflow-* "$TMP/specflow"
else
  echo "[specflow] ERROR: need either 'git' or 'curl' to install" >&2
  exit 1
fi

install -m 0755 "$TMP/specflow/bin/specflow"          "$BIN_DIR/specflow"
install -m 0755 "$TMP/specflow/bin/specflow-progress" "$BIN_DIR/specflow-progress"

echo "[specflow] installed to $BIN_DIR"
case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) echo "[specflow] NOTE: $BIN_DIR is not on PATH. Add it to your shell profile." ;;
esac
echo "[specflow] done. Try:  specflow --help"
