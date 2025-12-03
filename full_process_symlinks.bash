#!/bin/bash
# Usage: ./fix_symlinks.sh /path/to/project

set -uo pipefail

ROOT="${1:-}"

if [[ -z "$ROOT" || ! -d "$ROOT" ]]; then
  echo "Usage: $0 /path/to/project-root"
  exit 1
fi

CMAKE="$ROOT/CMakeLists.txt"

if [[ ! -f "$CMAKE" ]]; then
  echo "❌ CMakeLists.txt not found in $ROOT"
  exit 1
fi

# Extract compiled sources from CMakeLists.txt
mapfile -t COMPILED_SOURCES < <(
  grep -E '^[[:space:]]*(src/|include/).*' "$CMAKE" \
    | sed 's/^[[:space:]]*//'
)

echo "🔍 Compiled sources found in CMakeLists:"
printf '  - %s\n' "${COMPILED_SOURCES[@]}"
echo ""

SKIPPED="skipped_symlinks.txt"
REMOVED="removed_broken_symlinks.txt"
REPLACED="replaced_compiled_files.txt"

: > "$SKIPPED"
: > "$REMOVED"
: > "$REPLACED"

RED_BLINK="\e[5m\e[31m"
RESET="\e[0m"

echo "Starting symlink processing under: $ROOT"

while true; do
  mapfile -t SYMLINKS < <(find "$ROOT" -type l)

  [[ ${#SYMLINKS[@]} -eq 0 ]] && {
    echo "✅ All symlinks processed."
    break
  }

  echo ""
  echo "🔁 Found ${#SYMLINKS[@]} symlink(s). Processing..."

  for link in "${SYMLINKS[@]}"; do

    [[ -L "$link" ]] || continue

    # Resolve relative path compared to project root
    REL=$(realpath --relative-to="$ROOT" "$link")

    target=$(readlink "$link")

    # Resolve absolute target
    if [[ ! "$target" = /* ]]; then
      target=$(realpath "$(dirname "$link")/$target" 2>/dev/null || true)
    fi

    # Case 1 — TARGET EXISTS → replace normally
    if [[ -e "$target" ]]; then
      rm -f "$link"
      cp -a "$target" "$link"
      echo "✔ Replaced symlink: $REL"
      echo "$REL -> $target" >> "$REPLACED"
      continue
    fi

    # Case 2 — BROKEN SYMLINK
    echo -e "${RED_BLINK}⚠️ Broken symlink: $REL (missing target)${RESET}"

    # Check if REL is in COMPILED_SOURCES
    if printf "%s\n" "${COMPILED_SOURCES[@]}" | grep -qx "$REL"; then
      # Compiled source expected → restore from root/$REL
      REAL="$ROOT/$REL"
      if [[ -e "$REAL" ]]; then
        rm -f "$link"
        cp -a "$REAL" "$link"
        echo "🔧 Restored compiled file: $REL"
        echo "$REL restored from $REAL" >> "$REPLACED"
      else
        echo -e "${RED_BLINK}❌ ERROR: Compiled file missing in project: $REL${RESET}"
        echo "$REL (compiled but missing)" >> "$SKIPPED"
      fi
    else
      # Not compiled → delete the symlink
      echo "🗑️ Removing non-compiled broken symlink: $REL"
      rm -f "$link"
      echo "$REL" >> "$REMOVED"
    fi
  done
done

echo ""
echo "📄 Logs created:"
echo "  - $REPLACED  (replaced or restored)"
echo "  - $REMOVED   (deleted broken symlinks)"
echo "  - $SKIPPED   (compiled but missing in project)"
echo ""
echo "Done."
