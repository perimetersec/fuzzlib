# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

- **Test**: `forge test` - Runs the test suite using Foundry
- **Build**: Foundry automatically compiles contracts when running tests
- **Format**: `forge fmt` - Formats code using Foundry's built-in formatter (run after making changes)
- **Extended Fuzz Testing**: `forge test --fuzz-runs 10000` - Run comprehensive fuzz testing after large edits (resource intensive, use sparingly)

## Architecture Overview

Fuzzlib is a Solidity library designed for fuzzing smart contracts with Echidna, Medusa, and Foundry. The architecture uses a modular helper system with platform abstraction:

### Core Structure

- **Fuzzlib.sol**: Main contract that inherits from all helper contracts, providing the complete API
- **FuzzBase.sol**: Abstract base contract that users extend, automatically sets up Fuzzlib with Crytic platform
- **fl namespace**: All functions are accessed through the `fl` instance (e.g., `fl.clamp()`, `fl.log()`)

### Helper System

Located in `src/helpers/`, each helper provides specific functionality:
- **HelperBase**: Platform management and core functionality
- **HelperAssert**: Assertion utilities for fuzzing with `errAllow` error handling
- **HelperClamp**: Value clamping using modular arithmetic
- **HelperLog**: Logging utilities for different platforms
- **HelperMath**: Mathematical operations (`min`, `max`, `abs`, `diff`)
- **HelperRandom**: Random number generation utilities
- **HelperCall**: Function call utilities with error handling

### Platform Abstraction

Located in `src/platform/`, supports different fuzzing tools:
- **IPlatform**: Simple interface with `assertFail()` method
- **PlatformCrytic**: Default platform implementation
- **PlatformEchidna**: Echidna-specific implementation  
- **PlatformMedusa**: Medusa-specific implementation
- **PlatformTest**: Testing-specific platform implementation

### Utility Libraries

Additional utilities support core functionality:
- **FuzzLibString**: String conversion utilities for logging and assertions
- **Constants**: Common constants and type definitions
- **Test utilities**: `DummyContract`, `ErrAllowTestHelper`, `CallTarget` for comprehensive testing

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

### Import Patterns

Use consistent import patterns throughout the codebase:

```solidity
// Import the base contract for fuzzing
import {FuzzBase} from "fuzzlib/FuzzBase.sol";

// Import specific helpers if needed individually
import {HelperMath} from "fuzzlib/src/helpers/HelperMath.sol";
import {FuzzLibString} from "fuzzlib/src/FuzzLibString.sol";

// Import testing utilities for test files
import {DummyContract} from "../test/util/DummyContract.sol";
import {ErrAllowTestHelper} from "../test/util/ErrAllowTestHelper.sol";
```

## Code Quality Guidelines

### Defensive Programming Approach
- **Fail-fast principle**: Let functions fail naturally rather than adding defensive checks that mask issues
- **Minimize assumptions**: Remove unnecessary overflow checks and edge case handling in helper functions
- **Clear error messages**: When errors occur, let them surface with meaningful context rather than defensive handling
- **Simplicity over safety**: Prioritize code clarity and simplicity over defensive programming patterns

### Implementation Best Practices
- **Direct implementations**: Implement mathematical operations directly without unnecessary safeguards
- **Consistent patterns**: Use consistent coding patterns across all helper functions
- **Type safety**: Rely on Solidity's type system rather than manual type checking
- **Performance focus**: Prioritize execution efficiency over defensive error handling
- **Maintainability**: Write code that is easy to understand and modify without defensive complexity
- **Custom errors**: Use custom errors instead of `require` statements for better gas efficiency and clearer error handling

## Error Handling

### errAllow Functions

The `HelperAssert` contract provides sophisticated error handling through `errAllow` functions:

```solidity
// Allow specific require failure messages
errAllow(["Error message 1", "Error message 2"]);

// Allow specific custom error selectors
errAllow([bytes4(CustomError.selector), bytes4(AnotherError.selector)]);

// Combined error handling (both require messages and custom errors)
errAllow(
    ["Require message"],
    [bytes4(CustomError.selector)]
);
```

### Error Testing Patterns

- **Multiple error types**: Test both require failures and custom errors in the same test
- **Error message matching**: Use exact string matching for require messages
- **Custom error detection**: Use function selectors for custom error matching
- **Platform-specific errors**: Different platforms may handle errors differently
- **Error isolation**: Test error conditions separately from success conditions

### Testing Utilities for Error Scenarios

- **DummyContract**: Provides controlled error scenarios for testing
- **ErrAllowTestHelper**: Specialized utilities for testing error handling
- **CallTarget**: Test function calls that may fail with various error types

## String Utilities

### FuzzLibString Library

The `FuzzLibString` library provides essential string conversion utilities used throughout the codebase:

```solidity
import {FuzzLibString} from "fuzzlib/src/FuzzLibString.sol";

// Convert integers to strings for logging
string memory str = FuzzLibString.toString(uint256(42));
string memory strSigned = FuzzLibString.toString(int256(-42));

// Used internally by logging and assertion functions
emit Clamped(
    string(
        abi.encodePacked(
            "Clamping value ",
            FuzzLibString.toString(value),
            " to ",
            FuzzLibString.toString(result)
        )
    )
);
```

### String Utility Best Practices

- **Consistent usage**: Use `FuzzLibString.toString()` for all integer-to-string conversions
- **Efficient concatenation**: Use `abi.encodePacked()` for combining strings with conversions
- **Logging integration**: String utilities are essential for meaningful log messages
- **Cross-platform compatibility**: String formatting works consistently across all supported platforms

## Error Handling Implementation

### Custom Errors vs Require Statements

All new code should use custom errors instead of `require` statements for better gas efficiency and clearer error semantics:

```solidity
// ❌ Avoid: Traditional require statements
require(low <= high, "HelperClamp: invalid range");
require(b > 0, "HelperClamp: clampLt unsupported value");

// ✅ Prefer: Custom errors
error InvalidRange(uint256 low, uint256 high);
error UnsupportedClampLtValue(uint256 value);

if (low > high) revert InvalidRange(low, high);
if (b == 0) revert UnsupportedClampLtValue(b);
```

### Custom Error Best Practices

- **Descriptive names**: Use clear, specific error names that indicate the problem
- **Include context**: Add relevant parameter values to help with debugging
- **Consistent naming**: Follow `PascalCase` convention for error names
- **Gas efficiency**: Custom errors use less gas than require strings
- **Type safety**: Custom errors provide better tooling support and type checking
- **Testing compatibility**: Custom errors work seamlessly with `errAllow` testing functions

### Migration Guidelines

When updating existing code:

1. **Define custom errors** at the contract level near the top
2. **Replace require statements** with `if (condition) revert CustomError(params);`
3. **Update tests** to use the new custom error selectors with `errAllow`
4. **Maintain backward compatibility** during the transition period

### Example Migration

```solidity
// Before:
contract HelperClamp {
    function clamp(uint256 value, uint256 low, uint256 high) public returns (uint256) {
        require(low <= high, "HelperClamp: invalid range");
        // ... rest of function
    }
}

// After:
contract HelperClamp {
    error InvalidRange(uint256 low, uint256 high);
    error UnsupportedClampLtValue(uint256 value);
    
    function clamp(uint256 value, uint256 low, uint256 high) public returns (uint256) {
        if (low > high) revert InvalidRange(low, high);
        // ... rest of function
    }
}
```

## Development Workflow

### Common Development Tasks

1. **Adding new helper functions**:
   - Add to appropriate helper contract in `src/helpers/`
   - Follow existing naming conventions (short, clear names)
   - Add comprehensive tests organized by function
   - Include both unit tests and fuzz tests
   - Update documentation with `@dev` tags

2. **Testing new functionality**:
   - Create test file in `test/` with `.t.sol` extension
   - Inherit from both `Test` and the helper being tested
   - Organize tests by function, not by test type
   - Use `errAllow` for error handling tests
   - Leverage utility contracts for complex scenarios

3. **Code review checklist**:
   - ✅ Tests organized by function
   - ✅ No defensive programming patterns
   - ✅ Consistent documentation style
   - ✅ Proper error handling with `errAllow`
   - ✅ String utilities used for logging
   - ✅ Import patterns followed
   - ✅ Function overloads tested with selectors
   - ✅ Custom errors used instead of require statements
   - ✅ Error tests updated for custom error selectors

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
- **Function overloads**: Use low-level calls with explicit selectors when testing overloaded functions:
  ```solidity
  // Example: Testing max(uint256, uint256) vs max(int256, int256)
  bytes4 uint256MaxSelector = bytes4(keccak256("max(uint256,uint256)"));
  (bool success, bytes memory data) = address(this).call(
      abi.encodeWithSelector(uint256MaxSelector, a, b)
  );
  ```
- **Type safety**: Explicitly cast literal values to avoid compiler ambiguity (e.g., `uint256(5)`, `int256(-1)`). Do this only when absolutely necessary.
- **Overflow handling**: Use `vm.assume()` sparingly to avoid problematic values (e.g., `type(int256).min` for abs operations)
- **Fail-fast testing**: Avoid empty catch blocks or overly defensive error handling - tests should fail when unexpected behavior occurs
- **Test expected behavior**: Assert that operations work as expected rather than defensively handling edge cases that shouldn't fail in test environments
- **Minimize defensive assumptions**: Remove unnecessary `vm.assume()` calls and overflow checks that mask actual issues
- **Clean test structure**: Remove verbose inline comments that duplicate test logic - let the code speak for itself
- **Focus on properties**: Test mathematical properties and invariants rather than implementation details

### Fuzz Testing Guidelines
- **Keep it simple**: Fuzz tests should be straightforward and direct, avoiding complex conditional logic
- **Test natural properties**: Focus on testing mathematical properties and invariants that hold for all valid inputs
- **Use vm.assume sparingly**: Only use assumptions to avoid overflow or undefined behavior, not to control test paths
- **When in doubt, remove**: If a fuzz test requires complex logic to be meaningful, consider removing it in favor of targeted unit tests

### Test Organization Pattern
- **Group by function**: Tests should be organized by the function being tested, not by test type (unit/fuzz/edge)
- **Sequential organization**: All tests for a single function should be grouped together in the test file
- **Clear function sections**: Use comments to separate test groups for different functions

```solidity
/**
 * Tests for functionName(param1, param2)
 */
function test_functionName_specific_case() public { ... }
function test_functionName_edge_case() public { ... }
function testFuzz_functionName(type param) public { ... }

/**
 * Tests for anotherFunction(param1)
 */
function test_anotherFunction_basic_case() public { ... }
function testFuzz_anotherFunction(type param) public { ... }
```

### Testing Utility Contracts

Leverage specialized utility contracts for comprehensive testing:

```solidity
// Use DummyContract for controlled error scenarios
contract MyTest is Test, HelperAssert {
    DummyContract dummy;
    
    function setUp() public {
        dummy = new DummyContract();
    }
    
    function test_error_handling() public {
        errAllow(["Dummy error"]);
        dummy.failWithMessage("Dummy error");
    }
}

// Use CallTarget for function call testing
contract CallTest is Test, HelperCall {
    CallTarget target;
    
    function test_function_calls() public {
        target = new CallTarget();
        bytes memory result = doFunctionCall(
            address(target),
            abi.encodeWithSignature("getValue()"),
            0
        );
    }
}
```

### Advanced Edge Case Testing
- **Cross-boundary tests**: Test interactions between extreme values (e.g., `type(uint256).max` vs `uint256(0)`)
- **Sequential boundary tests**: Test values immediately adjacent to boundaries (e.g., `max`, `max-1`, `max-2`)
- **Comprehensive combinations**: For critical types like `int256`, test all combinations of extreme values
- **Platform-specific behavior**: Test error handling with `errAllow` functions using multiple error types
- **Address verification**: Use `extcodesize` to verify addresses have no code when testing non-contract scenarios
- **Error handling testing**: Use `errAllow` functions to test multiple error types and scenarios
- **Testing utilities**: Leverage utility contracts like `DummyContract` for error scenarios and `CallTarget` for function call testing

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

### Documentation Separation
- **NatSpec for users**: Focus on what the function does, its purpose, and expected behavior
- **Inline comments for implementers**: Focus on how the code works, technical details, and implementation rationale

### Documentation Quality Guidelines
- **Conciseness**: Keep descriptions brief and technically precise - avoid verbose explanations
- **Consistency**: Use consistent terminology and formatting across all documentation
- **Outsider-friendly**: Write for developers unfamiliar with the codebase, avoiding internal jargon
- **No redundant comments**: Avoid comments that simply restate what the code does
- **Accuracy first**: Ensure all mathematical examples and descriptions are correct

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
