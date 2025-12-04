#!/bin/bash
# Usage: ./fix_symlinks.sh /path/to/folder1

set -euo pipefail

FOLDER="${1:-}"

if [[ -z "$FOLDER" || ! -d "$FOLDER" ]]; then
  echo "Usage: $0 /path/to/folder1"
  exit 1
fi

echo "🔍 Scanning for symlinks in: $FOLDER"
echo

# Find all symlinks recursively
find "$FOLDER" -type l | while IFS= read -r link; do
  target=$(readlink "$link")

  echo "Processing symlink:"
  echo "  LINK:   $link"
  echo "  TARGET: $target"

  # --- Resolve absolute path ---
  if [[ ! "$target" = /* ]]; then
    target_dir=$(dirname "$link")
    target=$(realpath "$target_dir/$target" 2>/dev/null || true)
  fi

  if [[ -z "$target" || ! -e "$target" ]]; then
    echo "⚠️  Skipping broken symlink (target does not exist)"
    echo
    continue
  fi

  echo "  → Resolved absolute target: $target"

  # --- Ensure parent directory exists ---
  parent_dir=$(dirname "$link")
  mkdir -p "$parent_dir"

  # --- Create a temporary filename for copy-test ---
  tmpfile="${link}.tmp_copy_check"

  echo "  Copying to temp: $tmpfile"

  if cp -a "$target" "$tmpfile"; then
    echo "  ✓ Temp copy successful"
  else
    echo "❌ ERROR: Failed copying $target → $tmpfile"
    echo "   Skipping this symlink"
    rm -f "$tmpfile"
    echo
    continue
  fi

  # --- Safe replace: remove symlink, move temp to final ---
  echo "  Removing symlink..."
  rm -f "$link"

  echo "  Moving temp to final: $link"
  mv "$tmpfile" "$link"

  echo "  ✓ Replaced successfully"
  echo
done

echo "✅ Done. All symlinks safely replaced with actual files/folders."
