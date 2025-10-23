#!/bin/bash
# Usage: ./fix_symlinks.sh /path/to/folder1

set -euo pipefail

FOLDER="${1:-}"

if [[ -z "$FOLDER" || ! -d "$FOLDER" ]]; then
  echo "Usage: $0 /path/to/folder1"
  exit 1
fi

# Find all symlinks recursively
find "$FOLDER" -type l | while read -r link; do
  target=$(readlink "$link")
  
  echo "Processing symlink: $link -> $target"

  # Resolve to absolute path
  if [[ ! "$target" = /* ]]; then
    # Handle relative symlink
    target_dir=$(dirname "$link")
    target=$(realpath "$target_dir/$target")
  fi

  if [[ ! -e "$target" ]]; then
    echo "⚠️ Target does not exist: $target (skipping)"
    continue
  fi

  # Remove the symlink
  rm "$link"
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
