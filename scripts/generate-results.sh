#!/bin/bash

# Generate validation results comment
# Usage: ./scripts/generate-validate-results.sh <plugin_name> <version> <owner> <repo> <version_match> <id_match> <readme_present> <required_artifacts> <signature_valid>

PLUGIN_NAME="$1"
VERSION="$2"
OWNER="$3"
REPO="$4"

# Checks
ID_MATCH="$5"
VERSION_MATCH="$6"
README_PRESENT="$7"
REQUIRED_ARTIFACTS="$8"
SIGNATURE_VALID="$9"

# Output header
echo "## Plugin Validation Results for $PLUGIN_NAME v$VERSION"
echo
echo "**Repository:** [$OWNER/$REPO](https://github.com/$OWNER/$REPO)"
echo

# Build check list
CHECKS=(
  "Version Match=$VERSION_MATCH"
  "ID Match=$ID_MATCH"
  "README Present=$README_PRESENT"
  "Required Artifacts=$REQUIRED_ARTIFACTS"
  "Signature Validation=$SIGNATURE_VALID"
)

# Output check results
for check in "${CHECKS[@]}"; do
  NAME=$(echo "$check" | cut -d= -f1)
  STATUS=$(echo "$check" | cut -d= -f2)
  if [ "$STATUS" = "true" ]; then
    echo "✅ $NAME"
  else
    echo "❌ $NAME"
  fi
done 