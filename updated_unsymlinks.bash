#!/bin/bash
# Usage: ./fix_symlinks.sh /path/to/folder1

set -uo pipefail   # removed -e so script won't stop

FOLDER="${1:-}"

if [[ -z "$FOLDER" || ! -d "$FOLDER" ]]; then
  echo "Usage: $0 /path/to/folder1"
  exit 1
fi

SKIPPED_FILE="skipped_symlinks.txt"
: > "$SKIPPED_FILE"   # clear file at start

RED_BLINK="\e[5m\e[31m"
RESET="\e[0m"

echo "Starting symlink replacement in: $FOLDER"

while true; do
  mapfile -t SYMLINKS < <(find "$FOLDER" -type l)

  if [[ ${#SYMLINKS[@]} -eq 0 ]]; then
    echo "✅ No more symlinks found. Completed."
    break
  fi

  echo ""
  echo "🔁 Found ${#SYMLINKS[@]} symlink(s). Processing..."

  for link in "${SYMLINKS[@]}"; do
    [[ -L "$link" ]] || { echo "⚠️ Missing link, skipping: $link"; continue; }

    target=$(readlink "$link")
    echo "Processing: $link -> $target"

    # resolve absolute path
    if [[ ! "$target" = /* ]]; then
      target=$(realpath "$(dirname "$link")/$target")
    fi

    # HANDLE SKIPPED SYMLINKS HERE
    if [[ ! -e "$target" ]]; then
      echo -e "${RED_BLINK}⚠️ Skipped (target missing): $link → $target${RESET}"

      # export to skipped_symlinks.txt
      echo "$link -> $target" >> "$SKIPPED_FILE"
      continue
    fi

    # Remove the symlink (ignore error if already gone)
    rm -f "$link" || true
    echo "Removed: $link"

    # Copy content
    cp -a "$target" "$link"
    echo "Copied: $target → $link"
  done
done

echo ""
echo "📄 Exported skipped symlinks to: $SKIPPED_FILE"
echo "Done."
