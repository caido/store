#!/bin/bash

# validate-signature.sh
# Validates the signature of a plugin package against a public key
# Usage: ./validate-signature.sh <plugin_package.zip> <plugin_package.zip.sig> <public_key>

set -e

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <plugin_package.zip> <plugin_package.zip.sig> <public_key>"
    exit 1
fi

PLUGIN_PACKAGE="$1"
SIGNATURE_FILE="$2"
PUBLIC_KEY="$3"

# Create temporary directory for our work
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Create public key file
PUBKEY_FILE="$TEMP_DIR/pubkey.pem"
echo "-----BEGIN PUBLIC KEY-----" > "$PUBKEY_FILE"
echo "$PUBLIC_KEY" >> "$PUBKEY_FILE"
echo "-----END PUBLIC KEY-----" >> "$PUBKEY_FILE"

# Validate signature
if openssl pkeyutl -verify -pubin -inkey "$PUBKEY_FILE" -sigfile "$SIGNATURE_FILE" -in "$PLUGIN_PACKAGE" -rawin; then
    echo "Signature is valid"
    exit 0
else
    echo "Signature validation failed"
    exit 1
fi 