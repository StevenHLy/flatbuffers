#!/bin/bash

# Jenkins build parameters (defined in GUI)
# REPO_NAME=sms-monolith
# BRANCH_NAME=develop
# RUN_FORTIFY=true

echo "-------------------------------------------"
echo "[INFO] Fortify Scan Step Started"
echo "Repository: $REPO_NAME"
echo "Branch: $BRANCH_NAME"
echo "Run Fortify: $RUN_FORTIFY"
echo "-------------------------------------------"

# Only run Fortify if enabled
if [ "$RUN_FORTIFY" = "true" ]; then
  echo "[INFO] Cloning the repository..."
  if [ ! -d "$REPO_NAME" ]; then
    git clone -b "$BRANCH_NAME" https://your.repo.url/${REPO_NAME}.git || exit 1
  fi
  cd "${REPO_NAME}" || exit 1

  echo "[INFO] Running Fortify Static Code Analyzer..."
  sourceanalyzer -b "$REPO_NAME" . || exit 1
  sourceanalyzer -b "$REPO_NAME" -scan -f "${REPO_NAME}.fpr" || exit 1
  echo "[SUCCESS] Fortify scan completed: ${REPO_NAME}.fpr"

  echo "[INFO] Generating HTML report..."
  ReportGenerator -format html -f "../${REPO_NAME}_report.html" -source "${REPO_NAME}.fpr" || echo "[WARN] HTML report generation failed."

  echo "[INFO] Moving scan artifacts for Jenkins archiving..."
  mv "${REPO_NAME}.fpr" ../
  cd ..
else
  echo "[INFO] Skipping Fortify scan (RUN_FORTIFY=$RUN_FORTIFY)"
fi

echo "[INFO] Fortify scan step finished."
