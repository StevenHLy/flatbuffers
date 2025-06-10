#!/bin/bash

# Jenkins build parameters (defined in GUI or environment)
# REPO_NAME=sms-monolith
# BRANCH_NAME=develop
# RUN_FORTIFY=true

echo "-------------------------------------------"
echo "[INFO] Fortify Maven Scan Step Started"
echo "Repository: $REPO_NAME"
echo "Branch: $BRANCH_NAME"
echo "Run Fortify: $RUN_FORTIFY"
echo "-------------------------------------------"

# Only run Fortify scan if enabled
if [ "$RUN_FORTIFY" = "true" ]; then
  echo "[INFO] Cloning the repository..."
  if [ ! -d "$REPO_NAME" ]; then
    git clone -b "$BRANCH_NAME" https://your.repo.url/${REPO_NAME}.git || exit 1
  fi
  cd "${REPO_NAME}" || exit 1

  echo "[INFO] Running Fortify translation and scan via Maven..."
  mvn clean install \
    com.fortify.sca.plugins.maven:sca-maven-plugin:translate \
    com.fortify.sca.plugins.maven:sca-maven-plugin:scan \
    -Dfortify.sca.build.id=$REPO_NAME \
    -Dfortify.sca.report.output=../${REPO_NAME}.fpr || exit 1

  echo "[INFO] Generating HTML report..."
  ReportGenerator -format html -f "../${REPO_NAME}_report.html" -source "../${REPO_NAME}.fpr" || echo "[WARN] HTML report generation failed."

  echo "[INFO] Attempting to open HTML report in browser (if supported)..."
  if command -v xdg-open >/dev/null; then
    xdg-open "../${REPO_NAME}_report.html" &
  elif command -v firefox >/dev/null; then
    firefox "../${REPO_NAME}_report.html" &
  else
    echo "[INFO] No compatible browser launcher found (expected in GUI environment)."
  fi

  cd ..
else
  echo "[INFO] Skipping Fortify scan (RUN_FORTIFY=$RUN_FORTIFY)"
fi

echo "[INFO] Fortify Maven scan step finished."
