# Fuzzlib

General purpose unopinionated Solidity fuzzing library for stateful and stateless fuzzing. Compatible with Echidna, Medusa, and Foundry.

Provides common utilities for fuzz testing through a simple `fl` namespace: assertions, value clamping, logging, math operations, and more.

## Key Features

- **Basic Assertions**: Helpers for common test conditions and equality checks 
- **Advanced Assertions**: Utilities like error handling via `errAllow` for expected failures
- **Value Clamping**: Clamp values to ranges with uniform distribution for better fuzzing
- **Logging Utilities**: Unified logging for debugging and tracing
- **Math Utilities**: Operations like min, max, absolute value, and difference calculations
- **Random Utilities**: Fisher-Yates array shuffling
- **Function Call Helpers**: Utilities for making function calls with actor pranking
- **Comprehensive Testing**: Extensive test suite with both unit and fuzz tests
- **Well-Documented**: Clear and complete, following OpenZeppelin-style conventions

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
         
        // Log for debugging
        fl.log("Testing max function. x =", x);
        fl.log("Testing max function. y =", y);
       
        // Test mathematical properties
        fl.gte(fl.max(x, y), x, "Max should be >= x");
        fl.gte(fl.max(x, y), y, "Max should be >= y");
    }
}
```


## Function Reference

### Basic Assertions

```solidity
// Fundamental assertions
fl.t(exists, "Property X exists");
fl.eq(result, 100, "Result should equal 100");
fl.neq(userA, userB, "Users should be different");

// Comparison assertions
fl.gt(balance, 1000, "Balance should be greater than 1000");
fl.gte(amount, 50, "Amount should be greater than or equal to 50");
fl.lt(fee, 100, "Fee should be less than 100");
fl.lte(price, 500, "Price should be less than or equal to 500");
```

### Advanced Assertions

```solidity
// Allow specific require messages
string[] memory allowedMessages = new string[](1);
allowedMessages[0] = "Insufficient balance";
fl.errAllow(errorData, allowedMessages, "Message X should be allowed");

// Allow specific custom errors
bytes4[] memory allowedErrors = new bytes4[](1);
allowedErrors[0] = CustomError.selector;
fl.errAllow(errorSelector, allowedErrors, "Error X should be allowed");

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

### Logging

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

### Math Utilities

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
// Shuffle arrays
uint256[] memory array = new uint256[](10);
fl.shuffleArray(array, entropy);
```

### Function Call Helpers

```solidity
// Make function calls
bytes memory result = fl.doFunctionCall(
    address(target),
    abi.encodeWithSignature("getValue()"),
    msg.sender  // actor
);

// Calls with automatic pranking
(bool success, bytes memory data) = fl.doFunctionCall(
    address(target),
    abi.encodeWithSignature("transfer(address,uint256)", recipient, amount),
    sender
);

// Static calls (view functions)
(bool success, bytes memory data) = fl.doFunctionStaticCall(
    address(target),
    abi.encodeWithSignature("balanceOf(address)", user)
);
```

## Known Limitations

- **Signed Integer Clamping**: Limited to `int128` range to avoid overflow issues in range calculations
- **Gas Optimization**: Library prioritizes functionality over gas optimization
- **Function Selector Clashing**: If the error selector clashes with `Error(string)` when using errAllow, unexpected behavior may happen


## Roadmap

- [ ] Support for more platforms
- [ ] Add more helper functions
- [ ] Performance optimizations


## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.


## License

This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.

Some portions of this code are modified from [Crytic Properties](https://github.com/crytic/properties/blob/main/contracts/util/PropertiesHelper.sol), which is licensed under the GNU Affero General Public License v3.0 (AGPL-3.0).

Some portions of this code are modified from [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeCast.sol), which is licensed under the MIT License.


## Disclaimer

This software is provided as-is without warranty. The main branch contains new and experimental features that may be unstable. For production use, we recommend using official tagged releases which have been thoroughly tested. While we are not responsible for any bugs or issues, we maintain a bug bounty program that applies to official releases only.
