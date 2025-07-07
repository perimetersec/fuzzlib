// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./EchidnaTestIntegrity.sol";

/**
 * @dev Entry point contract for Echidna E2E fuzzing tests.
 * Inherits all handler functions and integrity tests.
 * @author Perimeter <info@perimetersec.io>
 */
contract EchidnaEntry is EchidnaTestIntegrity {
    // This contract serves as the entry point for Echidna
    // All functionality is inherited from the parent contracts:
    // - EchidnaTest: handler_* functions
    // - EchidnaTestIntegrity: fuzz_* wrapper functions and _testSelf helper
}