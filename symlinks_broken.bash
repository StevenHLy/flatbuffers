#!/bin/bash
# Usage: ./fix_symlinks.sh /path/to/folder1
# Replaces symlinks (files/folders) with actual content.

set -euo pipefail

FOLDER="${1:-}"

if [[ -z "$FOLDER" || ! -d "$FOLDER" ]]; then
  echo "Usage: $0 /path/to/folder1"
  exit 1
fi

echo "🔍 Scanning for symlinks in: $FOLDER"
echo "-----------------------------------"
SYMLINKS_BEFORE=$(mktemp)
find "$FOLDER" -type l > "$SYMLINKS_BEFORE"

if [[ ! -s "$SYMLINKS_BEFORE" ]]; then
  echo "✅ No symlinks found."
  exit 0
fi

echo "Found the following symlinks:"
cat "$SYMLINKS_BEFORE"
echo "-----------------------------------"

BROKEN_LINKS=()

# Process each symlink
while read -r link; do
  target=$(readlink "$link")

  echo ""
  echo "➡️ Processing symlink: $link -> $target"

  # Resolve to absolute path
  if [[ ! "$target" = /* ]]; then
    # Handle relative symlink
    target_dir=$(dirname "$link")
    target=$(realpath -m "$target_dir/$target")
  fi

  if [[ ! -e "$target" ]]; then
    echo "⚠️  Broken symlink (target missing): $target"
    BROKEN_LINKS+=("$link")
    continue
  fi

  # Remove the symlink
  rm "$link"
  echo "🧹 Removed symlink: $link"

  # Copy actual file/folder content
  if [[ -d "$target" ]]; then
    cp -a "$target" "$link"
    echo "📁 Copied directory: $target → $link"
  else
    cp -a "$target" "$link"
    echo "📄 Copied file: $target → $link"
  fi
done < "$SYMLINKS_BEFORE"

echo ""
echo "-----------------------------------"
echo "🔁 Rescanning for remaining symlinks..."
SYMLINKS_AFTER=$(mktemp)
find "$FOLDER" -type l > "$SYMLINKS_AFTER"

if [[ -s "$SYMLINKS_AFTER" ]]; then
  echo "⚠️ Remaining symlinks after cleanup:"
  cat "$SYMLINKS_AFTER"
else
  echo "✅ All symlinks replaced successfully."
fi

if [[ ${#BROKEN_LINKS[@]} -gt 0 ]]; then
  echo ""
  echo "⚠️ Broken symlinks (targets not found):"
  printf ' - %s\n' "${BROKEN_LINKS[@]}"
fi

echo ""
echo "🟢 Done."
