// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./EchidnaTest.sol";

/**
 * @dev Entry point contract for Echidna E2E fuzzing tests.
 * Inherits all handler functions and test wrappers.
 * @author Perimeter <info@perimetersec.io>
 */
contract EchidnaEntry is EchidnaTest {
    // This contract serves as the entry point for Echidna
    // All functionality is inherited from the parent contracts:
    // - EchidnaHandler: handler_* functions
    // - EchidnaTest: fuzz_* wrapper functions and _testSelf helper
}