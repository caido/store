#!/bin/bash

# validate-manifest.sh
# Validates the manifest.json in a plugin package
# Usage: ./validate-manifest.sh <plugin_package.zip> <expected_version> <expected_id>

set -e

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <plugin_package.zip> <expected_version> <expected_id>"
    exit 1
fi

PLUGIN_PACKAGE="$1"
EXPECTED_VERSION="$2"
EXPECTED_ID="$3"

# Create temporary directory for our work
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Extract manifest.json from the zip file
unzip -p "$PLUGIN_PACKAGE" manifest.json > "$TEMP_DIR/manifest.json" || {
    echo "manifest.json not found in plugin package"
    exit 1
}

# Extract version and id from manifest using jq
if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed. Please install jq to use this script."
    exit 1
fi

MANIFEST_VERSION=$(jq -r '.version' "$TEMP_DIR/manifest.json")
MANIFEST_ID=$(jq -r '.id' "$TEMP_DIR/manifest.json")

# Check if version matches
if [ "$MANIFEST_VERSION" != "$EXPECTED_VERSION" ]; then
    echo "Version mismatch: expected $EXPECTED_VERSION, got $MANIFEST_VERSION"
    exit 1
fi

# Check if ID matches
if [ "$MANIFEST_ID" != "$EXPECTED_ID" ]; then
    echo "ID mismatch: expected $EXPECTED_ID, got $MANIFEST_ID"
    exit 1
fi

echo "Manifest validation successful"
exit 0 