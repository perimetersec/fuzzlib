# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

- **Test**: `foundry test` - Runs the test suite using Foundry
- **Build**: Foundry automatically compiles contracts when running tests
- **Format**: `forge fmt` - Formats code using Foundry's built-in formatter (run after making changes)

## Architecture Overview

Fuzzlib is a Solidity library designed for fuzzing smart contracts with Echidna, Medusa, and Foundry. The architecture uses a modular helper system with platform abstraction:

### Core Structure

- **Fuzzlib.sol**: Main contract that inherits from all helper contracts, providing the complete API
- **FuzzBase.sol**: Abstract base contract that users extend, automatically sets up Fuzzlib with Crytic platform
- **fl namespace**: All functions are accessed through the `fl` instance (e.g., `fl.clamp()`, `fl.log()`)

### Helper System

Located in `src/helpers/`, each helper provides specific functionality:
- **HelperBase**: Platform management and core functionality
- **HelperAssert**: Assertion utilities for fuzzing
- **HelperClamp**: Value clamping and bounds checking
- **HelperLog**: Logging utilities
- **HelperMath**: Mathematical operations
- **HelperRandom**: Random number generation
- **HelperCall**: Function call utilities

### Platform Abstraction

Located in `src/platform/`, supports different fuzzing tools:
- **IPlatform**: Interface defining platform-specific operations
- **PlatformCrytic**: Crytic/Echidna implementation
- **PlatformEchidna**: Echidna-specific implementation  
- **PlatformMedusa**: Medusa-specific implementation

### Usage Pattern

Users create fuzzing harnesses by extending `FuzzBase`:

```solidity
import {FuzzBase} from "fuzzlib/FuzzBase.sol";

contract MyFuzzTest is FuzzBase {
    function testSomething() public {
        fl.log("Testing...");
        fl.clamp(value, 0, 100);
    }
}
```

The library automatically sets up the appropriate platform and provides access to all helper functions through the `fl` instance.

## Testing Guidelines

### Test Structure and Organization
- Test files are located in `test/` directory with `.t.sol` extension
- Each helper contract has a corresponding test file (e.g., `HelperMath.sol` → `HelperMath.t.sol`)
- Test contracts inherit from both `Test` (Foundry) and the helper being tested
- Use descriptive test names following the pattern: `test_[function]_[scenario]` and `testFuzz_[function]_[scenario]`

### Testing Best Practices
- **Test actual functions**: Always test the actual helper functions, never duplicate logic in tests
- **Comprehensive coverage**: Include unit tests for specific cases and fuzz tests for broad validation
- **Edge cases**: Test boundary values (zero, max values, negative numbers, overflow conditions)
- **Function overloads**: Use low-level calls with explicit selectors when testing overloaded functions
- **Type safety**: Explicitly cast literal values to avoid compiler ambiguity (e.g., `uint256(5)`, `int256(-1)`)
- **Overflow handling**: Use `vm.assume()` to avoid problematic values in fuzz tests (e.g., `type(int256).min`)

### Fuzz Testing Guidelines
- **Ensure meaningful coverage**: Fuzz tests must exercise both success and failure paths regularly
- **Avoid low-probability conditions**: Never rely on random inputs matching specific values (e.g., random strings matching specific messages, random bytes4 matching specific selectors)
- **Use controlled inputs**: Structure fuzz inputs using `uint8` choice parameters to deterministically control test paths
- **Target 4-10% success rate**: Design fuzz tests so success paths occur 4-10% of the time for adequate coverage
- **Precise selector generation**: When generating invalid selectors, use fixed ranges that provably cannot match valid ones
- **Comment precision**: Comments must precisely describe what the code does, never use imprecise terms like "unlikely"

### Fuzz Test Pattern for Low-Probability Success Cases
```solidity
function testFuzz_function_with_specific_inputs(uint8 choice, string memory randomData) public {
    if (choice < 20) {
        // ~8% - Test valid inputs (cycle through known valid values)
        uint8 validIndex = choice % validInputs.length;
        // Test with validInputs[validIndex]
    } else {
        // ~92% - Test invalid inputs with guaranteed non-matching values
        // Use fixed ranges that cannot match valid inputs
    }
}
```

### Test Organization Pattern
```solidity
/**
 * Tests for functionName(param1, param2)
 */
function test_functionName_specific_case() public { ... }
function test_functionName_edge_case() public { ... }
function testFuzz_functionName(type param) public { ... }
```

### Advanced Edge Case Testing
- **Cross-boundary tests**: Test interactions between extreme values (e.g., `type(uint256).max` vs `uint256(0)`)
- **Sequential boundary tests**: Test values immediately adjacent to boundaries (e.g., `max`, `max-1`, `max-2`)
- **Comprehensive combinations**: For critical types like `int256`, test all combinations of extreme values
- **Platform-specific behavior**: Test error handling with `errAllow` functions using multiple error types

## Documentation Standards

Fuzzlib follows OpenZeppelin-inspired documentation standards for consistency and clarity:

### Contract-Level Documentation
- Use `@dev` tag for brief, technical description of contract purpose
- Include `@author` tag with attribution: `@author Perimeter <info@perimetersec.io>`

### Function Documentation
- Use `@dev` tag for concise function descriptions
- Focus on what the function does, not implementation details
- Keep descriptions brief and technically precise
- Avoid redundant `@param` and `@return` tags unless they add significant value

### Example Documentation Pattern
```solidity
/**
 * @dev Mathematical utility functions for fuzzing operations.
 * @author Perimeter <info@perimetersec.io>
 */
abstract contract HelperMath {
    /**
     * @dev Returns the largest of two unsigned numbers.
     */
    function max(uint256 a, uint256 b) public pure returns (uint256) {
        return a > b ? a : b;
    }
}
```