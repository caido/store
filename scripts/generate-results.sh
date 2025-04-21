#!/bin/bash

# Generate validation results comment
# Usage: ./scripts/generate-validate-results.sh <plugin_name> <version> <owner> <repo> <version_match> <id_match> <readme_present> <required_artifacts> <signature_valid>

PLUGIN_NAME="$1"
VERSION="$2"
OWNER="$3"
REPO="$4"
VERSION_MATCH="$5"
ID_MATCH="$6"
README_PRESENT="$7"
REQUIRED_ARTIFACTS="$8"
SIGNATURE_VALID="$9"

# Build check list
CHECKS=(
  "Version Match=$VERSION_MATCH"
  "ID Match=$ID_MATCH"
  "README Present=$README_PRESENT"
  "Required Artifacts=$REQUIRED_ARTIFACTS"
  "Signature Validation=$SIGNATURE_VALID"
)

# Format check list with emojis
CHECK_LIST=""
for check in "${CHECKS[@]}"; do
  NAME=$(echo "$check" | cut -d= -f1)
  STATUS=$(echo "$check" | cut -d= -f2)
  echo "$NAME: $STATUS"
  if [ "$STATUS" = "true" ]; then
    CHECK_LIST+="✅ $NAME\n"
  else
    CHECK_LIST+="❌ $NAME\n"
  fi
done

# Create comment with proper multiline formatting
echo "## Plugin Validation Results for $PLUGIN_NAME v$VERSION

**Repository:** [$OWNER/$REPO](https://github.com/$OWNER/$REPO)

$CHECK_LIST" 