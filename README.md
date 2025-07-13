# Fuzzlib

**Fuzzlib** is a general-purpose Solidity library for simplifying fuzz testing. It supports both stateful and stateless fuzzing and is designed to work with tools like **Echidna**, **Medusa**, and **Foundry**.

The `fl` namespace offers utilities that reduce repetitive setup in fuzz tests, such as value clamping, error handling, and logging.

## Why Fuzzlib

Fuzzing suites often require a lot of boilerplate code to handle things like input clamping, expected failures, and logging. This setup can get in the way of writing clear and focused tests.

Fuzzlib was created to reduce that overhead. It provides a lightweight set of helpers to build and maintain effective fuzzing suites without duplicating the same logic across every test.

Fuzzlib is used in production by smart contract security teams and is actively maintained.


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
        fl.log("Testing max function");
    }
}
```

## Disclaimer

This software is provided as-is without warranty. The main branch contains new and experimental features that may be unstable. For production use, we recommend using official tagged releases which have been thoroughly tested. While we are not responsible for any bugs or issues, we maintain a bug bounty program that applies to official releases only.

## Function Reference

### Basic Assertions

```solidity
// Fundamental assertions
fl.t(balance > 0, "Balance should be positive");
fl.eq(result, 100, "Result should equal 100");
fl.neq(userA, userB, "Users should be different");

// Comparison assertions
fl.gt(balance, 1000, "Balance should be > 1000");
fl.gte(amount, 50, "Amount should be >= 50");
fl.lt(fee, 100, "Fee should be < 100");
fl.lte(price, 500, "Price should be <= 500");
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
uint256 clamped = fl.clamp(inputValue, 0, 100);

// Clamp to greater than value
uint256 clampedGt = fl.clampGt(inputValue, 50);

// Clamp to greater than or equal
uint256 clampedGte = fl.clampGte(inputValue, 50);

// Clamp to less than value
uint256 clampedLt = fl.clampLt(inputValue, 100);

// Clamp to less than or equal
uint256 clampedLte = fl.clampLte(inputValue, 100);
```

### Logging Utilities

```solidity
// Simple logging
fl.log("Testing scenario");

// Logging with values
fl.log("Balance:", balance);
fl.log("User count:", 42);

// Failure logging
fl.logFail("This test failed");
fl.logFail("Invalid amount:", amount);
```

### Mathematical Operations

```solidity
// Min/max operations
uint256 maximum = fl.max(150, 300);
int256 minimum = fl.min(-50, 25);

// Absolute value and difference
uint256 absolute = fl.abs(-42);
uint256 difference = fl.diff(100, 75);
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
    abi.encodeWithSignature("balanceOf(address)", user)
);

// Calls with automatic pranking
(bool success, bytes memory data) = fl.doFunctionCall(
    address(target),
    abi.encodeWithSignature("transfer(address,uint256)", recipient, amount),
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
