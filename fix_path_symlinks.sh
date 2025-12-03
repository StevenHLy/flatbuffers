#!/bin/bash
# Usage: ./fix_symlinks.sh /path/to/folder1

set -euo pipefail

FOLDER="${1:-}"

if [[ -z "$FOLDER" || ! -d "$FOLDER" ]]; then
  echo "Usage: $0 /path/to/folder1"
  exit 1
fi

# Find all symlinks recursively
find "$FOLDER" -type l | while IFS= read -r link; do
  raw_target=$(readlink "$link")

  echo "Processing symlink: $link -> $raw_target"

  # Resolve to absolute path safely
  if [[ "$raw_target" = /* ]]; then
      target="$raw_target"
  else
      # ALWAYS get a correct absolute path
      target=$(realpath -m "$(dirname "$link")/$raw_target") || {
        echo "❌ realpath failed for: $link (raw: $raw_target)"
        continue
      }
  fi

  # Check resolved target exists
  if [[ ! -e "$target" ]]; then
    echo "⚠️ Target does not exist: $target (skipping)"
    continue
  fi

  # Remove the symlink
  rm -f "$link"
  echo "Removed symlink: $link"

  # Copy target content into place
  if [[ -d "$target" ]]; then
    cp -a "$target" "$link"
    echo "Copied directory: $target → $link"
  else
    cp -a "$target" "$link"
    echo "Copied file: $target → $link"
  fi

done

echo "✅ Done. All symlinks replaced with actual files/folders."
