#!/usr/bin/env bash
# Packages the game into a .love archive (a zip with main.lua at its root).
# Usage: scripts/build-love.sh [output-path]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${1:-$ROOT/dist/Mordoria.love}"
case "$OUT" in /*) ;; *) OUT="$PWD/$OUT" ;; esac

mkdir -p "$(dirname "$OUT")"
rm -f "$OUT"

cd "$ROOT"
zip -9 -q -r "$OUT" \
  main.lua conf.lua say.lua \
  assets gear packages ui utils vendor vibes \
  -x '*.DS_Store' '*~' 'assets/mockups/*'

echo "Built $OUT ($(du -h "$OUT" | cut -f1))"
