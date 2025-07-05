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
    """Display parsed Echidna results with test expectation validation."""
    print("\n=== Echidna Fuzzing Results ===")
    
    # Validate test expectations
    validation_errors, correct_behaviors = validate_test_expectations(test_results)
    
    # Display test results
    if test_results:
        passing_count = sum(1 for _, status in test_results if status == 'passing')
        failing_count = sum(1 for _, status in test_results if status == 'failed')
        print(f"Tests: {passing_count} passed, {failing_count} failed")
        
        for test_name, status in test_results:
            status_symbol = "PASS" if status == 'passing' else "FAIL"
            print(f"  {test_name}: {status_symbol}")
    else:
        print("Tests: No test results found")
    
    # Display validation results
    if validation_errors or correct_behaviors:
        print("\n=== Test Expectation Validation ===")
        
        if correct_behaviors:
            print("✓ Correct behaviors:")
            for behavior in correct_behaviors:
                print(f"  {behavior}")
        
        if validation_errors:
            print("✗ Validation errors:")
            for error in validation_errors:
                print(f"  {error}")
    
    # Display statistics
    if stats:
        print("\n=== Campaign Statistics ===")
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
    
    return len(validation_errors) == 0


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
        result = subprocess.run(echidna_command, capture_output=True, text=True, check=False)
        
        # Parse text output for test results and statistics
        test_results, failed_tests, stats = parse_text_output(result.stdout)
        all_tests_behaved_correctly = print_results(test_results, failed_tests, stats)
            
        if all_tests_behaved_correctly:
            print("\n✓ Echidna E2E tests PASSED! All tests behaved as expected.")
            sys.exit(0)
        else:
            print("\n✗ Echidna E2E tests FAILED! Some tests did not behave as expected.")
            sys.exit(1)
    except subprocess.CalledProcessError as e:
        print("✗ Echidna E2E tests FAILED!")
        if e.stdout:
            print(e.stdout)
        if e.stderr:
            print(e.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
