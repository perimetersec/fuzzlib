# Fuzzlib

**Stop writing repetitive fuzzing code.** Fuzzlib is a battle-tested Solidity library that eliminates the tedious setup work in smart contract fuzzing. Instead of manually implementing assertions, value clamping, and error handling in every test, you get a complete toolkit through a simple `fl` namespace.

**Why Fuzzlib?**
- **Write less code**: Replace dozens of lines of boilerplate with single function calls
- **Find more bugs**: Advanced clamping and assertions help explore edge cases effectively  
- **Debug faster**: Built-in logging and error handling make failures easier to understand
- **Focus on logic**: Spend time on test scenarios, not infrastructure

Built for Foundry and used in production by security teams to find critical vulnerabilities.

## Key Features

- 🎯 **Basic Assertions**: Fundamental assertion helpers for testing conditions and equality
- 🔬 **Advanced Assertions**: Sophisticated error handling via `errAllow` for expected failures
- 🔧 **Value Clamping**: Clamp values to ranges with uniform distribution for better fuzzing
- 📝 **Logging Utilities**: Unified logging for debugging and tracing fuzzing scenarios
- 📊 **Mathematical Utilities**: Min/max operations, absolute values, and difference calculations
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

Create a simple fuzzing test by extending `FuzzBase`:

```solidity
import {FuzzBase} from "fuzzlib/FuzzBase.sol";

contract MyFuzzer is FuzzBase {
    function testMath(uint256 a, uint256 b) public {
        // Clamp inputs to reasonable ranges
        uint256 x = fl.clamp(a, 0, 1000);
        uint256 y = fl.clamp(b, 0, 1000);
        
        // Test mathematical properties
        fl.gte(fl.max(x, y), x, "Max should be >= x");
        fl.gte(fl.max(x, y), y, "Max should be >= y");
        
        // Log for debugging
        fl.log("Testing with", x, "and", y);
    }
}
```

## Disclaimer

This software is provided as-is without warranty. The main branch contains new and experimental features that may be unstable. For production use, we recommend using official tagged releases which have been thoroughly tested. While we are not responsible for any bugs or issues, we maintain a bug bounty program that applies to official releases only.

## Function Reference

### Basic Assertions

```solidity
// Fundamental assertions
fl.t(condition, "Should be true");
fl.eq(a, b, "Values should be equal");
fl.neq(a, b, "Values should not be equal");

// Comparison assertions
fl.gt(a, b, "A should be > B");
fl.gte(a, b, "A should be >= B");
fl.lt(a, b, "A should be < B");
fl.lte(a, b, "A should be <= B");
```

### Advanced Assertions (Error Handling)

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

### Value Clamping

```solidity
// Value clamping with uniform distribution
uint256 clamped = fl.clamp(value, 0, 100);

// Clamp to greater than value
uint256 clampedGt = fl.clampGt(value, 50);

// Clamp to greater than or equal
uint256 clampedGte = fl.clampGte(value, 50);

// Clamp to less than value
uint256 clampedLt = fl.clampLt(value, 100);

// Clamp to less than or equal
uint256 clampedLte = fl.clampLte(value, 100);
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

### Mathematical Operations

```solidity
// Min/max operations
uint256 maximum = fl.max(a, b);
int256 minimum = fl.min(x, y);

// Absolute value and difference
uint256 absolute = fl.abs(-42);
uint256 difference = fl.diff(a, b);
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




## Known Limitations

- **Signed Integer Clamping**: Limited to `int128` range to avoid overflow issues in range calculations
- **Gas Optimization**: Library prioritizes functionality over gas optimization

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

# Run Echidna E2E tests
python3 test/e2e/echidna/run-echidna.py
```

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
