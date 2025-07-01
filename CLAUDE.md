# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

- **Test**: `foundry test` - Runs the test suite using Foundry
- **Build**: Foundry automatically compiles contracts when running tests

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