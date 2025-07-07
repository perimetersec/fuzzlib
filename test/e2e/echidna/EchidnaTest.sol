// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../../src/FuzzBase.sol";
import "./DummyTarget.sol";

/**
 * @dev Echidna E2E integration test for fuzzlib functionality.
 * @author Perimeter <info@perimetersec.io>
 */
contract EchidnaTest is FuzzBase {
    DummyTarget public target;

    constructor() {
        target = new DummyTarget();
    }

    /**
     * @dev Executes a delegatecall to this contract with the given callData.
     * Used to test function integrity and detect unwanted reverts during fuzzing.
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
     * @dev Test mathematical operations with assertions.
     * Verifies max, min, and abs functions work correctly under fuzzing.
     */
    function test_math_operations(uint256 a, uint256 b) public {
        // Test max operation
        uint256 maxResult = fl.max(a, b);
        fl.gte(maxResult, a, "Max result should be >= a");
        fl.gte(maxResult, b, "Max result should be >= b");
        fl.t(maxResult == a || maxResult == b, "Max result should equal either a or b");

        // Test min operation
        uint256 minResult = fl.min(a, b);
        fl.lte(minResult, a, "Min result should be <= a");
        fl.lte(minResult, b, "Min result should be <= b");
        fl.t(minResult == a || minResult == b, "Min result should equal either a or b");
    }

    /**
     * @dev Fuzz wrapper for mathematical operations integrity testing.
     */
    function fuzz_math_operations(uint256 a, uint256 b) public {
        bytes memory callData = abi.encodeWithSelector(
            this.test_math_operations.selector, a, b
        );
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "MATH-01: Unexpected math operation failure");
        }
    }

    /**
     * @dev Test absolute value operations with signed integers.
     * Verifies abs function works correctly with positive and negative values.
     */
    function test_abs_operations(int256 x) public {
        // Avoid testing type(int256).min to prevent overflow
        if (x == type(int256).min) return;

        uint256 absResult = fl.abs(x);
        if (x >= 0) {
            fl.eq(absResult, uint256(x), "Abs of positive number should equal the number");
        } else {
            fl.eq(absResult, uint256(-x), "Abs of negative number should equal its negation");
        }
    }

    /**
     * @dev Fuzz wrapper for absolute value operations integrity testing.
     */
    function fuzz_abs_operations(int256 x) public {
        bytes memory callData = abi.encodeWithSelector(
            this.test_abs_operations.selector, x
        );
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "ABS-01: Unexpected abs operation failure");
        }
    }

    /**
     * @dev Test value clamping behavior.
     * Verifies clamp results always stay within specified bounds.
     */
    function test_clamp_operations(uint256 inputValue, uint256 _low, uint256 _high) public {
        uint256 low;
        uint256 high;
        if (_low < _high) {
            low = _low;
            high = _high;
        } else {
            low = _high;
            high = _low;
        }

        uint256 clampedValue = fl.clamp(inputValue, low, high);

        // Verify clamped value is within bounds
        fl.gte(clampedValue, low, "Clamped value should be >= low bound");
        fl.lte(clampedValue, high, "Clamped value should be <= high bound");

        // If value is already in range, it stays unchanged
        if (inputValue >= low && inputValue <= high) {
            fl.eq(clampedValue, inputValue, "Value in range should remain unchanged");
        }
    }

    /**
     * @dev Fuzz wrapper for clamp operations integrity testing.
     */
    function fuzz_clamp_operations(uint256 inputValue, uint256 _low, uint256 _high) public {
        bytes memory callData = abi.encodeWithSelector(
            this.test_clamp_operations.selector, inputValue, _low, _high
        );
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "CLAMP-01: Unexpected clamp operation failure");
        }
    }

    /**
     * @dev Test basic assertion helpers.
     * Verifies comparison functions work correctly.
     */
    function test_basic_assertions(uint256 a, uint256 b) public {
        // Test equality with known equal values
        fl.eq(uint256(42), uint256(42), "Equal constants should be equal");

        // Test greater than or equal
        uint256 maxVal = fl.max(a, b);
        fl.gte(maxVal, a, "Max should be >= a");
        fl.gte(maxVal, b, "Max should be >= b");

        // Test less than or equal
        uint256 minVal = fl.min(a, b);
        fl.lte(minVal, a, "Min should be <= a");
        fl.lte(minVal, b, "Min should be <= b");

        // Test with known inequalities
        fl.gte(uint256(100), uint256(50), "100 should be >= 50");
        fl.lte(uint256(25), uint256(75), "25 should be <= 75");
    }

    /**
     * @dev Fuzz wrapper for basic assertions integrity testing.
     */
    function fuzz_basic_assertions(uint256 a, uint256 b) public {
        bytes memory callData = abi.encodeWithSelector(
            this.test_basic_assertions.selector, a, b
        );
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "ASSERT-01: Unexpected assertion failure");
        }
    }

    /**
     * @dev Test logging functionality doesn't break contract state.
     * Verifies various logging functions work without unwanted reverts.
     */
    function test_logging_operations(uint256 num, string memory message) public {
        fl.log("Testing logging with number:", num);
        fl.log("Testing logging with message:", message);
        fl.log("Testing simple message");
    }

    /**
     * @dev Fuzz wrapper for logging operations integrity testing.
     */
    function fuzz_logging_operations(uint256 num, string memory message) public {
        bytes memory callData = abi.encodeWithSelector(
            this.test_logging_operations.selector, num, message
        );
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "LOG-01: Unexpected logging failure");
        }
    }

    /**
     * @dev Test mathematical difference operations.
     * Verifies diff function calculates absolute difference correctly.
     */
    function test_diff_operations(uint256 a, uint256 b) public {
        uint256 difference = fl.diff(a, b);

        // Verify difference is always positive (uint256 is always >= 0)
        fl.gte(difference, 0, "Difference should always be non-negative");

        // Verify difference calculation
        if (a >= b) {
            fl.eq(difference, a - b, "Difference should equal a - b when a >= b");
        } else {
            fl.eq(difference, b - a, "Difference should equal b - a when b > a");
        }

        // Verify difference properties
        fl.eq(fl.diff(a, a), 0, "Difference of identical values should be zero");
        fl.eq(fl.diff(a, b), fl.diff(b, a), "Difference should be commutative");
    }

    /**
     * @dev Fuzz wrapper for diff operations integrity testing.
     */
    function fuzz_diff_operations(uint256 a, uint256 b) public {
        bytes memory callData = abi.encodeWithSelector(
            this.test_diff_operations.selector, a, b
        );
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "DIFF-01: Unexpected diff operation failure");
        }
    }

    /**
     * @dev Test HelperRandom shuffleArray functionality.
     * Verifies array shuffling preserves elements and behaves deterministically.
     */
    function test_shuffle_array_operations(uint256 entropy) public {
        // Test with a fixed small array
        uint256[] memory testArray = new uint256[](5);
        testArray[0] = 10;
        testArray[1] = 20;
        testArray[2] = 30;
        testArray[3] = 40;
        testArray[4] = 50;

        // Store original sum to verify all elements preserved
        uint256 originalSum = 0;
        for (uint256 i = 0; i < testArray.length; i++) {
            originalSum += testArray[i];
        }

        // Shuffle the array
        fl.shuffleArray(testArray, entropy);

        // Verify all elements are still present (sum unchanged)
        uint256 shuffledSum = 0;
        for (uint256 i = 0; i < testArray.length; i++) {
            shuffledSum += testArray[i];
        }
        fl.eq(shuffledSum, originalSum, "Sum should be preserved after shuffling");

        // Verify array still contains all original elements
        fl.eq(testArray.length, 5, "Array length should be preserved");
    }

    /**
     * @dev Fuzz wrapper for shuffle array operations integrity testing.
     */
    function fuzz_shuffle_array_operations(uint256 entropy) public {
        bytes memory callData = abi.encodeWithSelector(
            this.test_shuffle_array_operations.selector, entropy
        );
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "SHUFFLE-01: Unexpected shuffle operation failure");
        }
    }

    /**
     * @dev Test HelperCall function call functionality using DummyTarget.
     * Verifies function calls work correctly with the target contract.
     */
    function test_function_call_basic(uint256 testValue) public {
        // Test setting and getting value from target contract
        bytes memory setCallData = abi.encodeWithSignature("setValue(uint256)", testValue);
        (bool setSuccess,) = fl.doFunctionCall(address(target), setCallData);
        fl.t(setSuccess, "setValue call should succeed");
        
        // Test getting the value back
        bytes memory getCallData = abi.encodeWithSignature("getValue()");
        (bool getSuccess, bytes memory returnData) = fl.doFunctionCall(address(target), getCallData);
        
        fl.t(getSuccess, "getValue call should succeed");
        fl.t(returnData.length > 0, "Should return data");
        
        uint256 returnedValue = abi.decode(returnData, (uint256));
        fl.eq(returnedValue, testValue, "Returned value should match set value");
    }

    /**
     * @dev Fuzz wrapper for basic function call integrity testing.
     */
    function fuzz_function_call_basic(uint256 testValue) public {
        bytes memory callData = abi.encodeWithSelector(
            this.test_function_call_basic.selector, testValue
        );
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "CALL-01: Unexpected function call failure");
        }
    }

    /**
     * @dev Test HelperCall with actor specification using DummyTarget.
     * Verifies calls can be made with different actor addresses.
     */
    function test_function_call_with_actor(address actor, uint256 value) public {
        // Use target contract with specified actor
        bytes memory callData = abi.encodeWithSignature("setValue(uint256)", value);
        (bool success,) = fl.doFunctionCall(address(target), callData, actor);
        
        fl.t(success, "Function call with actor should succeed");
        
        // Verify the value was set correctly
        uint256 storedValue = target.getValue();
        fl.eq(storedValue, value, "Value should be set correctly regardless of actor");
        
        // Verify the actor was actually used as msg.sender
        address lastSender = target.getLastMsgSender();
        fl.eq(lastSender, actor, "Last msg.sender should be the specified actor");
    }

    /**
     * @dev Fuzz wrapper for function call with actor integrity testing.
     */
    function fuzz_function_call_with_actor(address actor, uint256 value) public {
        bytes memory callData = abi.encodeWithSelector(
            this.test_function_call_with_actor.selector, actor, value
        );
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "CALL-02: Unexpected function call with actor failure");
        }
    }

    /**
     * @dev Test HelperCall with multiple return values using DummyTarget.
     * Verifies handling of complex return data and actor functionality.
     */
    function test_function_call_multiple_returns(uint256 value, string memory testString, bool flag, address actor) public {
        // Set up target contract with multiple values using specified actor
        bytes memory setCallData = abi.encodeWithSignature("setMultipleValues(uint256,string,bool)", value, testString, flag);
        (bool setSuccess,) = fl.doFunctionCall(address(target), setCallData, actor);
        fl.t(setSuccess, "setMultipleValues call should succeed");
        
        // Verify the actor was used as msg.sender
        address lastSender = target.getLastMsgSender();
        fl.eq(lastSender, actor, "Last msg.sender should be the specified actor");
        
        // Call function that returns multiple values
        bytes memory getCallData = abi.encodeWithSignature("getMultipleValues()");
        (bool success, bytes memory returnData) = fl.doFunctionCall(address(target), getCallData);
        
        fl.t(success, "Multiple return call should succeed");
        fl.t(returnData.length > 0, "Should return data");
        
        (uint256 retValue, string memory retString, bool retFlag) = 
            abi.decode(returnData, (uint256, string, bool));
            
        fl.eq(retValue, value, "Returned value should match");
        fl.eq(retFlag, flag, "Returned flag should match");
    }

    /**
     * @dev Fuzz wrapper for function call with multiple returns integrity testing.
     */
    function fuzz_function_call_multiple_returns(uint256 value, string memory testString, bool flag, address actor) public {
        bytes memory callData = abi.encodeWithSelector(
            this.test_function_call_multiple_returns.selector, value, testString, flag, actor
        );
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "CALL-03: Unexpected function call multiple returns failure");
        }
    }

    /**
     * @dev Test that should always fail - used to verify test detection works.
     * This test intentionally contains a false assertion.
     */
    function test_always_fails_should_fail() public {
        fl.eq(uint256(1), uint256(2), "This should always fail: 1 != 2");
    }

    /**
     * @dev Fuzz wrapper for always-failing test (should fail).
     */
    function fuzz_always_fails_should_fail() public {
        bytes memory callData = abi.encodeWithSelector(
            this.test_always_fails_should_fail.selector
        );
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "FAIL-01: Unexpected always-fail test failure");
        }
    }

    /**
     * @dev Test mathematical properties that should fail.
     * This tests that our validation can detect expected failures.
     */
    function test_math_property_violation_should_fail(uint256 x) public {
        fl.lte(x, 100, "Value should be <= 100");
    }

    /**
     * @dev Fuzz wrapper for math property violation test (should fail).
     */
    function fuzz_math_property_violation_should_fail(uint256 x) public {
        bytes memory callData = abi.encodeWithSelector(
            this.test_math_property_violation_should_fail.selector, x
        );
        (bool success, bytes4 errorSelector) = _testSelf(callData);
        if (!success) {
            fl.t(false, "FAIL-02: Unexpected math property violation failure");
        }
    }
}