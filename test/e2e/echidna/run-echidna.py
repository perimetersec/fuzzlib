#!/usr/bin/env python3

"""
Echidna E2E Test Runner for Fuzzlib
Runs Echidna fuzzing tests on the BasicEchidnaTest contract
to validate fuzzlib functionality under actual fuzzing conditions.
"""

import subprocess
import sys
import os
from pathlib import Path


def main():
    # Configuration
    config_file = "test/e2e/echidna/echidna-config.yaml"
    contract_name = "BasicEchidnaTest"
    echidna_binary = "echidna"
    echidna_command = [echidna_binary, ".", "--contract", contract_name, "--config", config_file]

    print("Running Echidna E2E tests for fuzzlib...")

    # Check Echidna installation
    try:
        subprocess.run([echidna_binary, "--version"], capture_output=True, check=True)
    except (subprocess.CalledProcessError, FileNotFoundError):
        print(f"Error: {echidna_binary} not found!")
        print("Install from: https://github.com/crytic/echidna/releases")
        sys.exit(1)

    # Run Echidna
    print(f"Running: {' '.join(echidna_command)}")

    try:
        result = subprocess.run(echidna_command, check=True)
        print("✓ Echidna E2E tests PASSED!")
        sys.exit(0)
    except subprocess.CalledProcessError:
        print("✗ Echidna E2E tests FAILED!")
        sys.exit(1)


if __name__ == "__main__":
    main()
