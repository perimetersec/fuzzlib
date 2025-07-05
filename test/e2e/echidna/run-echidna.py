#!/usr/bin/env python3

"""
Echidna E2E Test Runner for Fuzzlib
Runs Echidna fuzzing tests on the BasicEchidnaTest contract
to validate fuzzlib functionality under actual fuzzing conditions.
"""

import subprocess
import sys
import os
import re
from pathlib import Path


def parse_text_output(output):
    """Parse Echidna text output to extract test results and statistics."""
    lines = output.strip().split('\n')
    
    test_results = []
    stats = {}
    
    # Parse test results
    for line in lines:
        if ': passing' in line:
            test_name = line.split(':')[0].strip()
            test_results.append(test_name)
    
    # Parse statistics from the end
    for line in reversed(lines):
        if 'Unique instructions:' in line:
            stats['instructions'] = int(line.split(':')[1].strip())
        elif 'Unique codehashes:' in line:
            stats['contracts'] = int(line.split(':')[1].strip())
        elif 'Corpus size:' in line:
            stats['corpus'] = int(line.split(':')[1].strip())
        elif 'Seed:' in line:
            stats['seed'] = int(line.split(':')[1].strip())
        elif 'Total calls:' in line:
            stats['calls'] = int(line.split(':')[1].strip())
    
    return test_results, stats

def print_results(test_results, stats):
    """Display parsed Echidna results in a readable format."""
    print("\n=== Echidna Fuzzing Results ===")
    
    # Display test results
    if test_results:
        print(f"Tests: {len(test_results)} passed")
        for test in test_results:
            print(f"  {test}: PASS")
    else:
        print("Tests: No test results found")
    
    # Display statistics
    if 'instructions' in stats:
        print(f"Coverage: {stats['instructions']} unique instructions")
    if 'contracts' in stats:
        print(f"Contracts: {stats['contracts']} analyzed")
    if 'corpus' in stats:
        print(f"Corpus: {stats['corpus']} sequences")
    if 'calls' in stats:
        print(f"Total calls: {stats['calls']}")
    if 'seed' in stats:
        print(f"Seed: {stats['seed']}")


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
        result = subprocess.run(echidna_command, capture_output=True, text=True, check=True)
        
        # Parse text output for test results and statistics
        test_results, stats = parse_text_output(result.stdout)
        print_results(test_results, stats)
            
        print("✓ Echidna E2E tests PASSED!")
        sys.exit(0)
    except subprocess.CalledProcessError as e:
        print("✗ Echidna E2E tests FAILED!")
        if e.stdout:
            print(e.stdout)
        if e.stderr:
            print(e.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
