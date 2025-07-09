# Fuzzlib

A comprehensive Solidity library designed for smart contract fuzzing with **Foundry**. Fuzzlib provides essential utilities for both stateful and stateless fuzzing, making it easier to write robust fuzzing harnesses and discover edge cases in your smart contracts.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Foundry](https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg)](https://getfoundry.sh/)
[![Version](https://img.shields.io/badge/Version-0.3.2-blue.svg)](https://github.com/perimetersec/fuzzlib/releases)

## Overview

Fuzzlib is an unopinionated Solidity library that streamlines fuzzing harness development. It provides a collection of essential utilities including mathematical operations, assertion helpers, logging capabilities, and sophisticated error handling—all accessible through a simple `fl` namespace.

The library uses a modular architecture that makes it easy to write comprehensive fuzzing harnesses for your smart contracts.

## Key Features

- 📊 **Mathematical Utilities**: Min/max operations, absolute values, difference calculations, and value clamping
- 🎯 **Advanced Assertions**: Comprehensive assertion helpers with sophisticated error handling via `errAllow`
- 📝 **Logging Utilities**: Unified logging for debugging and tracing fuzzing scenarios
- 🎲 **Random Utilities**: Random number generation and Fisher-Yates array shuffling
- 📞 **Function Call Helpers**: Utilities for making function calls with actor pranking and error handling
- 🔍 **String Utilities**: Integer-to-string conversion for logging and assertions
- 🧪 **Comprehensive Testing**: Extensive test suite with both unit and fuzz tests
- 📚 **Well-Documented**: Comprehensive documentation following OpenZeppelin standards

## Installation

### Using Foundry

```bash
forge install perimetersec/fuzzlib
```

### Using npm

```bash
npm install @perimetersec/fuzzlib
```

Add to your `remappings.txt`:
```
fuzzlib/=lib/fuzzlib/src/
```

## Quick Start

Create a fuzzing harness by extending `FuzzBase`:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {FuzzBase} from "fuzzlib/FuzzBase.sol";

contract MyTokenFuzzer is FuzzBase {
    MyToken token;
    
    constructor() {
        token = new MyToken();
    }
    
    function testTransfer(address to, uint256 amount) public {
        // Log the test scenario
        fl.log("Testing transfer to", to, "amount", amount);
        
        // Clamp amount to reasonable range
        uint256 clampedAmount = fl.clamp(amount, 0, token.totalSupply());
        
        // Get initial balances
        uint256 initialBalance = token.balanceOf(address(this));
        
        // Only proceed if we have enough balance
        if (initialBalance >= clampedAmount) {
            // Make the transfer
            token.transfer(to, clampedAmount);
            
            // Verify the transfer worked correctly
            fl.eq(
                token.balanceOf(address(this)),
                initialBalance - clampedAmount,
                "Sender balance should decrease"
            );
        }
    }
}
```

## Core Components

### Mathematical Operations

```solidity
// Min/max operations
uint256 maximum = fl.max(a, b);
int256 minimum = fl.min(x, y);

// Absolute value and difference
uint256 absolute = fl.abs(-42);
uint256 difference = fl.diff(a, b);

// Value clamping with uniform distribution
uint256 clamped = fl.clamp(value, 0, 100);
```

### Assertion Helpers

```solidity
// Basic assertions
fl.t(condition, "Should be true");
fl.eq(a, b, "Values should be equal");
fl.gte(a, b, "A should be >= B");
fl.lte(a, b, "A should be <= B");

// Advanced error handling
fl.errAllow(["Insufficient balance", "Transfer failed"]);
token.transfer(recipient, amount); // Will pass if these errors occur
```

### Logging Utilities

```solidity
// Simple logging
fl.log("Testing scenario");

// Logging with values
fl.log("Balance:", balance);
fl.log("Transfer from", sender, "to", recipient, "amount", amount);
```

### Random Utilities

```solidity
// Generate random numbers
uint256 random = fl.randomUint(seed, 0, 100);
address randomAddr = fl.randomAddress(seed);

// Shuffle arrays
uint256[] memory array = new uint256[](10);
fl.shuffleArray(array, entropy);
```

### Function Call Helpers

```solidity
// Make function calls with error handling
bytes memory result = fl.doFunctionCall(
    address(target),
    abi.encodeWithSignature("getValue()"),
    msg.sender  // actor
);

// Calls with automatic pranking
(bool success, bytes memory data) = fl.doFunctionCall(
    address(target),
    callData,
    actor
);
```

## Usage with Foundry

Run your fuzzing harnesses with Foundry:

```bash
forge test --match-contract MyTokenFuzzer
```

## Advanced Features

### Error Handling with errAllow

Fuzzlib provides sophisticated error handling that allows you to specify which errors are acceptable:

```solidity
function testRiskyOperation(uint256 amount) public {
    // Allow specific require messages
    string[] memory allowedMessages = new string[](2);
    allowedMessages[0] = "Insufficient balance";
    allowedMessages[1] = "Transfer failed";
    
    // Allow specific custom errors
    bytes4[] memory allowedErrors = new bytes4[](1);
    allowedErrors[0] = InsufficientBalance.selector;
    
    // Set up error handling
    fl.errAllow(allowedMessages, allowedErrors);
    
    // This call may fail with allowed errors
    token.transfer(recipient, amount);
}
```

### Logging Utilities

Use logging to debug and trace your fuzzing scenarios:

```solidity
function testComplexScenario(uint256 a, uint256 b) public {
    fl.log("Starting test with values", a, b);
    
    uint256 result = fl.max(a, b);
    fl.log("Maximum value:", result);
    
    if (result > 1000) {
        fl.log("Large value detected");
    }
}
```

## API Reference

### Mathematical Operations

| Function | Description | Example |
|----------|-------------|---------|
| `max(a, b)` | Returns the larger of two values | `fl.max(10, 20)` |
| `min(a, b)` | Returns the smaller of two values | `fl.min(10, 20)` |
| `abs(x)` | Returns the absolute value | `fl.abs(-42)` |
| `diff(a, b)` | Returns the absolute difference | `fl.diff(10, 20)` |
| `clamp(value, low, high)` | Clamps value to range | `fl.clamp(150, 0, 100)` |

### Assertion Helpers

| Function | Description | Example |
|----------|-------------|---------|
| `t(condition, message)` | Assert condition is true | `fl.t(x > 0, "X must be positive")` |
| `eq(a, b, message)` | Assert values are equal | `fl.eq(balance, 100, "Balance should be 100")` |
| `gte(a, b, message)` | Assert a >= b | `fl.gte(balance, 0, "Balance should be non-negative")` |
| `lte(a, b, message)` | Assert a <= b | `fl.lte(amount, limit, "Amount should not exceed limit")` |

### Logging Functions

| Function | Description | Example |
|----------|-------------|---------|
| `log(message)` | Log a simple message | `fl.log("Test completed")` |
| `log(message, value)` | Log message with value | `fl.log("Balance:", balance)` |
| `log(msg, val1, msg2, val2)` | Log multiple values | `fl.log("From", sender, "to", recipient)` |

### Random Utilities

| Function | Description | Example |
|----------|-------------|---------|
| `randomUint(seed, min, max)` | Generate random uint in range | `fl.randomUint(block.timestamp, 0, 100)` |
| `randomAddress(seed)` | Generate random address | `fl.randomAddress(seed)` |
| `shuffleArray(array, entropy)` | Shuffle array in-place | `fl.shuffleArray(myArray, entropy)` |

## Configuration

### Foundry Configuration

Add to your `foundry.toml`:

```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]

[profile.fuzz]
fuzz = { runs = 10000 }
```


## Development

### Prerequisites

- [Foundry](https://getfoundry.sh/)
- [Node.js](https://nodejs.org/) (for npm packages)

### Setup

```bash
git clone https://github.com/perimetersec/fuzzlib.git
cd fuzzlib
forge install
```

### Testing

```bash
# Run all tests
forge test

# Run tests with increased fuzz runs
forge test --fuzz-runs 10000

# Run specific test file
forge test --match-path test/HelperMath.t.sol
```

### Code Formatting

```bash
# Format all code
forge fmt

# Check formatting
forge fmt --check
```

## Examples

### Token Fuzzing

```solidity
import {FuzzBase} from "fuzzlib/FuzzBase.sol";

contract ERC20Fuzzer is FuzzBase {
    MyToken token;
    
    constructor() {
        token = new MyToken();
    }
    
    function testTransferInvariants(address to, uint256 amount) public {
        fl.log("Testing transfer invariants");
        
        uint256 totalSupplyBefore = token.totalSupply();
        uint256 balanceBefore = token.balanceOf(address(this));
        
        // Clamp amount to available balance
        uint256 clampedAmount = fl.clamp(amount, 0, balanceBefore);
        
        if (to != address(0) && to != address(this)) {
            token.transfer(to, clampedAmount);
            
            // Verify total supply unchanged
            fl.eq(
                token.totalSupply(),
                totalSupplyBefore,
                "Total supply should remain constant"
            );
        }
    }
}
```

### DeFi Protocol Fuzzing

```solidity
import {FuzzBase} from "fuzzlib/FuzzBase.sol";

contract DEXFuzzer is FuzzBase {
    DEX dex;
    
    function testSwapInvariants(uint256 amountIn, address tokenIn, address tokenOut) public {
        fl.log("Testing swap with amount", amountIn);
        
        // Get initial reserves
        uint256 reserveInBefore = dex.getReserve(tokenIn);
        uint256 reserveOutBefore = dex.getReserve(tokenOut);
        
        // Clamp input to reasonable range
        uint256 clampedAmount = fl.clamp(amountIn, 1, reserveInBefore / 10);
        
        // Allow expected swap errors
        fl.errAllow(["Insufficient liquidity", "Slippage too high"]);
        
        // Perform swap
        dex.swap(tokenIn, tokenOut, clampedAmount);
        
        // Verify reserves changed appropriately
        uint256 reserveInAfter = dex.getReserve(tokenIn);
        uint256 reserveOutAfter = dex.getReserve(tokenOut);
        
        fl.gte(reserveInAfter, reserveInBefore, "Reserve in should increase");
        fl.lte(reserveOutAfter, reserveOutBefore, "Reserve out should decrease");
    }
}
```

## Known Limitations

- **Signed Integer Clamping**: Limited to `int128` range to avoid overflow issues in range calculations
- **Gas Optimization**: Library prioritizes functionality over gas optimization

## Branches

- **`main`**: Latest version with `fl.` namespace (recommended)
- **`v0_2`**: Legacy version for backwards compatibility

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add comprehensive tests
5. Ensure all tests pass: `forge test`
6. Format code: `forge fmt`
7. Submit a pull request

## Roadmap

- [ ] Enhanced string manipulation utilities
- [ ] Advanced statistical analysis tools
- [ ] Gas optimization improvements
- [ ] Integration with formal verification tools
- [ ] Extended mathematical operations
- [ ] Custom assertion frameworks

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📧 Email: [info@perimetersec.io](mailto:info@perimetersec.io)
- 🐛 Issues: [GitHub Issues](https://github.com/perimetersec/fuzzlib/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/perimetersec/fuzzlib/discussions)

---

**Built with ❤️ by [Perimeter](https://perimetersec.io)**