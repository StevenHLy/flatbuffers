#!/bin/bash
# Usage: ./fix_symlinks.sh /path/to/folder1

set -uo pipefail   # *** IMPORTANT: remove -e to prevent early aborts ***

FOLDER="${1:-}"

if [[ -z "$FOLDER" || ! -d "$FOLDER" ]]; then
  echo "Usage: $0 /path/to/folder1"
  exit 1
fi

find "$FOLDER" -type l | while IFS= read -r link; do
  raw_target=$(readlink "$link")

  echo "Processing symlink: $link -> $raw_target"

  # Always resolve absolute path safely
  if [[ "$raw_target" = /* ]]; then
      target="$raw_target"
  else
      target=$(realpath -m "$(dirname "$link")/$raw_target") || target=""
  fi

  # Validate BEFORE removing the symlink
  if [[ -z "$target" || ! -e "$target" ]]; then
    echo "⚠️ Target invalid or missing: $target (leaving symlink untouched)"
    continue
  fi

  # Safe replace: remove only after copy succeeded
  tmpfile="${link}.replace_tmp"

  if cp -a "$target" "$tmpfile"; then
      rm -f "$link"
      mv "$tmpfile" "$link"
      echo "✔ Replaced symlink with actual: $link"
  else
      echo "❌ Copy failed, symlink NOT removed: $link"
      rm -f "$tmpfile"
  fi
done

echo "✅ Done. All valid symlinks safely replaced."
