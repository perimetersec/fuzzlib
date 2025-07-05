# Fuzzlib Echidna E2E Testing

This directory contains end-to-end tests for validating fuzzlib functionality with actual Echidna fuzzing campaigns.

## Overview

The E2E testing suite uses **assertion-based fuzzing** to verify that fuzzlib helpers work correctly under real fuzzing conditions. Instead of unit tests that simulate fuzzing environments, these tests run actual Echidna campaigns against contracts that use fuzzlib.

## Files

- **`BasicEchidnaTest.sol`** - Main test contract extending `FuzzBase`
- **`echidna-config.yaml`** - Echidna configuration with balanced parameters  
- **`run-echidna.sh`** - Execution script with helpful output and error checking
- **`README.md`** - This documentation file

## Prerequisites

### Install Echidna

You need Echidna installed to run these tests. Choose one method:

#### Option 1: Binary Release (Recommended)
```bash
# Download latest release from GitHub
wget https://github.com/crytic/echidna/releases/latest/download/echidna-x86_64-linux
chmod +x echidna-x86_64-linux
sudo mv echidna-x86_64-linux /usr/local/bin/echidna
```

#### Option 2: Stack (Build from Source)
```bash
# Install Stack first: https://docs.haskellstack.org/en/stable/install_and_upgrade/
stack install echidna
```

### Verify Installation
```bash
echidna --version
```

## Running the Tests

### Basic Usage
```bash
# From the echidna directory
./run-echidna.sh

# Or from anywhere in the project
./test/e2e/echidna/run-echidna.sh
```

### With Options
```bash
# Verbose output
./run-echidna.sh --verbose

# Help information
./run-echidna.sh --help

# Custom Echidna arguments
ECHIDNA_ARGS='--timeout 600' ./run-echidna.sh
```

## What the Tests Validate

### Mathematical Operations
- `fl.max()`, `fl.min()`, `fl.abs()` - Verify mathematical properties hold
- `fl.diff()` - Test absolute difference calculations
- Boundary value handling with extreme inputs

### Value Clamping  
- `fl.clamp()` - Ensure results always stay within specified bounds
- Edge cases with min/max values
- Invalid range handling

### Logging Integration
- `fl.log()` variants - Verify logging doesn't affect contract state
- Different data types (uint256, int256, string, etc.)
- State consistency after logging operations

### Basic Assertions
- `fl.eq()`, `fl.gte()`, `fl.lte()` - Test comparison functions
- Error handling when assertions fail
- Integration with Echidna's assertion checking

### State Management
- Contract state remains consistent across fuzzing sequences
- No unexpected side effects from helper function calls
- Proper handling of edge cases and boundary conditions

## Configuration

The `echidna-config.yaml` file contains balanced parameters:

- **Sequence Length**: 50 transactions per test sequence
- **Test Limit**: 5000 test sequences total  
- **Shrinking**: Up to 1000 attempts to minimize failures
- **Coverage**: Enabled for monitoring code paths
- **Timeout**: 5 minutes maximum campaign duration

### Customizing Configuration

To adjust test intensity, modify `echidna-config.yaml`:

```yaml
# For faster testing
seqLen: 25
testLimit: 1000

# For more thorough testing  
seqLen: 100
testLimit: 20000
```

## Expected Output

### Successful Run
```
===========================================
  Fuzzlib Echidna E2E Testing Suite       
===========================================

✓ Echidna found: echidna 2.2.2
✓ Contract file found: BasicEchidnaTest.sol
✓ Config file found: echidna-config.yaml

Starting Echidna fuzzing campaign...
[Echidna output...]

===========================================
  ✓ Echidna E2E Test PASSED!             
===========================================
All assertions passed during fuzzing campaign.
Fuzzlib integration with Echidna is working correctly.
```

### Failed Run
If assertions fail during fuzzing, Echidna will report:
- Which assertion failed
- The input values that caused the failure
- A simplified test case demonstrating the issue

## Troubleshooting

### Common Issues

#### "echidna not found"
- Install Echidna using one of the methods above
- Ensure it's in your PATH

#### Import resolution errors
- The script automatically changes to the project root directory
- Ensure you're running from within the fuzzlib project

#### Gas limit errors
- Increase `testGasLimit` in the config file
- Check for infinite loops in test functions

#### Timeout errors
- Increase `timeout` value in config file
- Reduce `seqLen` or `testLimit` for faster execution

### Debugging Failed Tests

1. **Review the failing assertion** - Echidna will show which assert() failed
2. **Check input values** - Look at the values that triggered the failure
3. **Verify test logic** - Ensure the assertion is testing the right property
4. **Add logging** - Use `fl.log()` to trace execution
5. **Reduce complexity** - Simplify the test to isolate the issue

## Integration with CI/CD

To integrate into GitHub Actions or similar CI systems:

```yaml
- name: Install Echidna
  run: |
    wget https://github.com/crytic/echidna/releases/latest/download/echidna-x86_64-linux
    chmod +x echidna-x86_64-linux
    sudo mv echidna-x86_64-linux /usr/local/bin/echidna

- name: Run Echidna E2E Tests
  run: ./test/e2e/echidna/run-echidna.sh
```

## Next Steps

After basic E2E testing works:

1. **Add more helpers** - Test `HelperRandom`, `HelperCall`, etc.
2. **Complex scenarios** - Multi-step workflows and interactions
3. **Platform testing** - Verify platform switching behavior
4. **Performance testing** - Long-running campaigns and stress tests
5. **Real contract integration** - Test with actual DeFi/protocol patterns

## Contributing

When adding new E2E tests:

- Follow the existing assertion-based pattern
- Add comprehensive comments explaining what's being tested
- Include edge cases and boundary conditions
- Update this README with new test scenarios
- Ensure tests are deterministic where possible