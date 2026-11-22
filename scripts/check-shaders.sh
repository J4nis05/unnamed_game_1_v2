#!/usr/bin/env bash
# Compiles all game shaders under OpenGL ES (as used on Android and iOS) and
# desktop OpenGL. GLSL ES is stricter: no uniform initializers, no implicit
# int->float conversion, no array constructors, matching precision across stages.
# Usage: scripts/check-shaders.sh <path-to-love-binary>
# Needs an X display (e.g. run under xvfb-run) with Mesa.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOVE="${1:?usage: $0 <love-binary>}"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
cp "$ROOT"/scripts/check-shaders/*.lua "$work/"
cp -r "$ROOT/assets/shaders" "$work/shaders"

status=0
for renderer in opengles opengl; do
  echo "== $renderer"
  if [ "$renderer" = opengles ]; then
    export LOVE_GRAPHICS_USE_OPENGLES=1
  else
    unset LOVE_GRAPHICS_USE_OPENGLES
  fi
  "$LOVE" "$work" 2> /dev/null || status=1
done
exit $status
