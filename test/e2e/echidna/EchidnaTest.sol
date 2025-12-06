// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "./EchidnaHandler.sol";

/**
 * @dev Main test contract for Echidna E2E tests.
 * Contains delegatecall wrappers for unwanted revert detection.
 * @author Perimeter <info@perimetersec.io>
 */
contract EchidnaTest is EchidnaHandler {
    /**
     * @dev Executes a delegatecall to this contract with the given callData.
     * Used to test function behavior and detect unwanted reverts during fuzzing.
     * @param callData The data to be used in the delegatecall
     * @return success Whether the delegatecall succeeded
     * @return errorSelector The error selector if the call failed
     */
    function _testSelf(bytes memory callData) internal returns (bool success, bytes4 errorSelector) {
        bytes memory returnData;
        (success, returnData) = address(this).delegatecall(callData);

        if (!success && returnData.length >= 4) {
            assembly {
                errorSelector := mload(add(returnData, 0x20))
            }
        }

        return (success, errorSelector);
    }

    /**
     * @dev Fuzz wrapper for mathematical operations testing.
     */
    function fuzz_math_operations(uint256 a, uint256 b) public {
        bytes memory callData = abi.encodeWithSelector(this.handler_math_operations.selector, a, b);
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "MATH-01: Unexpected math operation failure");
        }
    }

    /**
     * @dev Fuzz wrapper for math property violation test (should fail).
     */
    function fuzz_math_property_violation_should_fail(uint256 x) public {
        bytes memory callData = abi.encodeWithSelector(this.handler_math_property_violation_should_fail.selector, x);
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "FAIL-02: Unexpected math property violation failure");
        }
    }

    /**
     * @dev Fuzz wrapper for absolute value operations testing.
     */
    function fuzz_abs_operations(int256 x) public {
        bytes memory callData = abi.encodeWithSelector(this.handler_abs_operations.selector, x);
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "ABS-01: Unexpected abs operation failure");
        }
    }

    /**
     * @dev Fuzz wrapper for clamp operations testing.
     */
    function fuzz_clamp_operations(uint256 inputValue, uint256 _low, uint256 _high) public {
        bytes memory callData = abi.encodeWithSelector(this.handler_clamp_operations.selector, inputValue, _low, _high);
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "CLAMP-01: Unexpected clamp operation failure");
        }
    }

    /**
     * @dev Fuzz wrapper for basic assertions testing.
     */
    function fuzz_basic_assertions(uint256 a, uint256 b) public {
        bytes memory callData = abi.encodeWithSelector(this.handler_basic_assertions.selector, a, b);
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "ASSERT-01: Unexpected assertion failure");
        }
    }

    /**
     * @dev Fuzz wrapper for logging operations testing.
     */
    function fuzz_logging_operations(uint256 num, string memory message) public {
        bytes memory callData = abi.encodeWithSelector(this.handler_logging_operations.selector, num, message);
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "LOG-01: Unexpected logging failure");
        }
    }

    /**
     * @dev Fuzz wrapper for diff operations testing.
     */
    function fuzz_diff_operations(uint256 a, uint256 b) public {
        bytes memory callData = abi.encodeWithSelector(this.handler_diff_operations.selector, a, b);
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "DIFF-01: Unexpected diff operation failure");
        }
    }

    /**
     * @dev Fuzz wrapper for shuffle array operations testing.
     */
    function fuzz_shuffle_array_operations(uint256 entropy) public {
        bytes memory callData = abi.encodeWithSelector(this.handler_shuffle_array_operations.selector, entropy);
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "SHUFFLE-01: Unexpected shuffle operation failure");
        }
    }

    /**
     * @dev Fuzz wrapper for basic function call testing.
     */
    function fuzz_function_call_basic(uint256 testValue) public {
        bytes memory callData = abi.encodeWithSelector(this.handler_function_call_basic.selector, testValue);
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "CALL-01: Unexpected function call failure");
        }
    }

    /**
     * @dev Fuzz wrapper for function call with actor testing.
     */
    function fuzz_function_call_with_actor(address actor, uint256 value) public {
        bytes memory callData = abi.encodeWithSelector(this.handler_function_call_with_actor.selector, actor, value);
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "CALL-02: Unexpected function call with actor failure");
        }
    }

    /**
     * @dev Fuzz wrapper for function call with multiple returns testing.
     */
    function fuzz_function_call_multiple_returns(uint256 value, string memory testString, bool flag, address actor)
        public
    {
        bytes memory callData =
            abi.encodeWithSelector(this.handler_function_call_multiple_returns.selector, value, testString, flag, actor);
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "CALL-03: Unexpected function call multiple returns failure");
        }
    }

    /**
     * @dev Fuzz wrapper for always-failing test (should fail).
     */
    function fuzz_always_fails_should_fail() public {
        bytes memory callData = abi.encodeWithSelector(this.handler_always_fails_should_fail.selector);
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "FAIL-01: Unexpected always-fail test failure");
        }
    }

    /**
     * @dev Fuzz wrapper for errAllow functionality testing.
     */
    function fuzz_errallow(string memory errorMessage) public {
        bytes memory callData = abi.encodeWithSelector(this.handler_errallow.selector, errorMessage);
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "ERRALLOW-01: Unexpected errAllow functionality failure");
        }
    }

    /**
     * @dev Fuzz wrapper for errAllow that should fail.
     */
    function fuzz_errallow_should_fail(string memory errorMessage) public {
        bytes memory callData = abi.encodeWithSelector(this.handler_errallow_should_fail.selector, errorMessage);
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "ERRALLOW-02: Unexpected errAllow should fail test failure");
        }
    }
}
