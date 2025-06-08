#!/bin/bash

# === Configuration ===
JENKINS_URL="http://jenkins.company.com"
FORTIFY_JOB="fortify-analysis"
USER="your_jenkins_user"
API_TOKEN="your_api_token"

echo "-------------------------------------------"
echo "[INFO] Triggering Fortify scan via Jenkins API"
echo "Target job: ${FORTIFY_JOB}"
echo "Jenkins URL: ${JENKINS_URL}"
echo "-------------------------------------------"

# === Trigger the job (uses default GUI parameters) ===
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
  "${JENKINS_URL}/job/${FORTIFY_JOB}/build" \
  --user "${USER}:${API_TOKEN}")

# === Result handling ===
if [ "$RESPONSE" -eq 201 ]; then
  echo "[SUCCESS] Fortify job '${FORTIFY_JOB}' was triggered successfully."
else
  echo "[ERROR] Failed to trigger Fortify job. HTTP status code: $RESPONSE"
  echo "Please verify Jenkins URL, job name, credentials, or CSRF settings."
  exit 1
fi

echo "[INFO] Script finished."
