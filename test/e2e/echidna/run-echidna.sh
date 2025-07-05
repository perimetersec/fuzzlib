#!/bin/bash

# Echidna E2E Test Runner for Fuzzlib
set -e

# Configuration
CONFIG_FILE="test/e2e/echidna/echidna-config.yaml"
CONTRACT_NAME="BasicEchidnaTest"
ECHIDNA_BINARY="echidna"
ECHIDNA_COMMAND="$ECHIDNA_BINARY . --contract $CONTRACT_NAME --config $CONFIG_FILE"

echo "Running Echidna E2E tests for fuzzlib..."

# Check Echidna installation
if ! command -v "$ECHIDNA_BINARY" &> /dev/null; then
    echo "Error: $ECHIDNA_BINARY not found!"
    echo "Install from: https://github.com/crytic/echidna/releases"
    exit 1
fi

# Verify config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Config file not found: $CONFIG_FILE"
    exit 1
fi

# Run Echidna
echo "Running: $ECHIDNA_COMMAND"

if $ECHIDNA_COMMAND; then
    echo "✓ Echidna E2E tests PASSED!"
else
    echo "✗ Echidna E2E tests FAILED!"
    exit 1
fi