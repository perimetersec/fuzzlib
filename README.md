# Fuzzlib

A comprehensive Solidity library designed for smart contract fuzzing with **Foundry**. Fuzzlib provides essential utilities for both stateful and stateless fuzzing, making it easier to write robust fuzzing harnesses and discover edge cases in your smart contracts.

## Overview

Fuzzlib is an unopinionated Solidity library that streamlines fuzzing harness development. It provides a collection of essential utilities including mathematical operations, assertion helpers, logging capabilities, and sophisticated error handling—all accessible through a simple `fl` namespace.

The library uses a modular architecture that makes it easy to write comprehensive fuzzing harnesses for your smart contracts.

## Key Features

- 📊 **Mathematical Utilities**: Min/max operations, absolute values, difference calculations, and value clamping
- 🎯 **Advanced Assertions**: Comprehensive assertion helpers with sophisticated error handling via `errAllow`
- 📝 **Logging Utilities**: Unified logging for debugging and tracing fuzzing scenarios
- 🎲 **Random Utilities**: Random number generation and Fisher-Yates array shuffling
- 📞 **Function Call Helpers**: Utilities for making function calls with actor pranking and error handling
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
fl.neq(a, b, "Values should not be equal");
fl.gt(a, b, "A should be > B");
fl.lt(a, b, "A should be < B");
```

### Error Handling

```solidity
// Allow specific require messages
string[] memory allowedMessages = new string[](1);
allowedMessages[0] = "Insufficient balance";
fl.errAllow(errorData, allowedMessages, "Message should be allowed");

// Allow specific custom errors
bytes4[] memory allowedErrors = new bytes4[](1);
allowedErrors[0] = CustomError.selector;
fl.errAllow(errorSelector, allowedErrors, "Error should be allowed");

// Combined error handling
fl.errAllow(errorData, allowedMessages, allowedErrors, "Either should be allowed");
```

### Logging Utilities

```solidity
// Simple logging
fl.log("Testing scenario");

// Logging with values
fl.log("Balance:", balance);
fl.log("Transfer from", sender, "to", recipient, "amount", amount);

// Failure logging
fl.logFail("This test failed");
fl.logFail("Failed with value:", errorValue);
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

// Static calls (view functions)
(bool success, bytes memory data) = fl.doFunctionStaticCall(
    address(target),
    callData
);

// Calls with automatic pranking
(bool success, bytes memory data) = fl.doFunctionCall(
    address(target),
    callData,
    actor
);
```




## Development

### Prerequisites

- [Foundry](https://getfoundry.sh/)

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

## Known Limitations

- **Signed Integer Clamping**: Limited to `int128` range to avoid overflow issues in range calculations
- **Gas Optimization**: Library prioritizes functionality over gas optimization

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Ensure all tests pass: `forge test`
6. Format code: `forge fmt`
7. Submit a pull request

## Roadmap

- [ ] Support for more platforms
- [ ] Add more helper functions
- [ ] Performance optimizations

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
