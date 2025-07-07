#!/usr/bin/env python3

"""
Echidna E2E Test Runner for Fuzzlib
Runs Echidna fuzzing tests on the EchidnaTest contract
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
    failed_tests = []
    stats = {}
    
    # Parse test results
    for line in lines:
        if ': passing' in line:
            test_name = line.split(':')[0].strip()
            test_results.append((test_name, 'passing'))
        elif ': falsified' in line or ': failed' in line:
            test_name = line.split(':')[0].strip()
            test_results.append((test_name, 'failed'))
            failed_tests.append(test_name)
    
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
    
    return test_results, failed_tests, stats

def validate_test_expectations(test_results):
    """Validate that test results match expectations based on naming conventions."""
    validation_errors = []
    correct_behaviors = []
    
    for test_name, status in test_results:
        should_fail = '_should_fail' in test_name
        
        if should_fail and status == 'passing':
            validation_errors.append(f"{test_name}: Expected to fail but passed")
        elif should_fail and status == 'failed':
            correct_behaviors.append(f"{test_name}: Correctly failed as expected")
        elif not should_fail and status == 'passing':
            correct_behaviors.append(f"{test_name}: Correctly passed")
        elif not should_fail and status == 'failed':
            validation_errors.append(f"{test_name}: Expected to pass but failed")
    
    return validation_errors, correct_behaviors

def print_results(test_results, failed_tests, stats):
    """Display concise summary of test results and validation."""

    # Validate test expectations
    validation_errors, correct_behaviors = validate_test_expectations(test_results)
    
    # Display test suite status
    if validation_errors:
        print("❌ Test suite FAILED - unexpected behavior detected:")
        for error in validation_errors:
            print(f"  {error}")
    else:
        print("✅ Test suite PASSED - all tests behaved as expected")
    
    return len(validation_errors) == 0


def main():
    # Configuration
    config_file = "test/e2e/echidna/echidna-config.yaml"
    contract_name = "EchidnaEntry"
    echidna_binary = "echidna"
    echidna_command = [echidna_binary, ".", "--contract", contract_name, "--config", config_file]

    print("Running Echidna E2E tests for fuzzlib...")

    # Check Echidna installation
    try:
        subprocess.run([echidna_binary, "--version"], capture_output=True, check=True)
    except (subprocess.CalledProcessError, FileNotFoundError):
        print(f"Error: {echidna_binary} not found!")
        print("Install from: https://github.com/crytic/echidna")
        sys.exit(1)

    # Run Echidna
    print(f"Running: {' '.join(echidna_command)}")

    try:
        # Run Echidna with real-time output
        process = subprocess.Popen(echidna_command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, 
                                 text=True, bufsize=1, universal_newlines=True)
        
        # Capture output while displaying it in real-time
        output_lines = []
        
        for line in iter(process.stdout.readline, ''):
            print(line.rstrip())  # Display real-time output
            output_lines.append(line.rstrip())
        
        process.wait()  # Wait for process to complete
        
        # Combine all output for parsing
        full_output = '\n'.join(output_lines)
        
        # Parse text output for test results and statistics
        test_results, failed_tests, stats = parse_text_output(full_output)
        all_tests_behaved_correctly = print_results(test_results, failed_tests, stats)
            
        sys.exit(0 if all_tests_behaved_correctly else 1)
    except Exception as e:
        print(f"✗ Echidna E2E tests FAILED! Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
