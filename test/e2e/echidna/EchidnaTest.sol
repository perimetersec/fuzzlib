// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../../src/FuzzBase.sol";
import "./DummyTarget.sol";

/**
 * @dev Base E2E test contract for fuzzlib functionality.
 * Contains core handler functions and test infrastructure.
 * @author Perimeter <info@perimetersec.io>
 */
contract EchidnaTest is FuzzBase {
    DummyTarget public target;

    constructor() {
        target = new DummyTarget();
    }


    /**
     * @dev Handler for mathematical operations with assertions.
     * Verifies max, min, and abs functions work correctly under fuzzing.
     */
    function handler_math_operations(uint256 a, uint256 b) public {
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
     * @dev Handler for absolute value operations with signed integers.
     * Verifies abs function works correctly with positive and negative values.
     */
    function handler_abs_operations(int256 x) public {
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
     * @dev Handler for value clamping behavior.
     * Verifies clamp results always stay within specified bounds.
     */
    function handler_clamp_operations(uint256 inputValue, uint256 _low, uint256 _high) public {
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
     * @dev Handler for basic assertion helpers.
     * Verifies comparison functions work correctly.
     */
    function handler_basic_assertions(uint256 a, uint256 b) public {
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
     * @dev Handler for logging functionality doesn't break contract state.
     * Verifies various logging functions work without unwanted reverts.
     */
    function handler_logging_operations(uint256 num, string memory message) public {
        fl.log("Testing logging with number:", num);
        fl.log("Testing logging with message:", message);
        fl.log("Testing simple message");
    }

    /**
     * @dev Handler for mathematical difference operations.
     * Verifies diff function calculates absolute difference correctly.
     */
    function handler_diff_operations(uint256 a, uint256 b) public {
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
     * @dev Handler for HelperRandom shuffleArray functionality.
     * Verifies array shuffling preserves elements and behaves deterministically.
     */
    function handler_shuffle_array_operations(uint256 entropy) public {
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
     * @dev Handler for HelperCall function call functionality using DummyTarget.
     * Verifies function calls work correctly with the target contract.
     */
    function handler_function_call_basic(uint256 testValue) public {
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
     * @dev Handler for HelperCall with actor specification using DummyTarget.
     * Verifies calls can be made with different actor addresses.
     */
    function handler_function_call_with_actor(address actor, uint256 value) public {
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
     * @dev Handler for HelperCall with multiple return values using DummyTarget.
     * Verifies handling of complex return data and actor functionality.
     */
    function handler_function_call_multiple_returns(uint256 value, string memory testString, bool flag, address actor) public {
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
     * @dev Handler that should always fail - used to verify test detection works.
     * This handler intentionally contains a false assertion.
     */
    function handler_always_fails_should_fail() public {
        fl.eq(uint256(1), uint256(2), "This should always fail: 1 != 2");
    }

    /**
     * @dev Handler for mathematical properties that should fail.
     * This handler tests that our validation can detect expected failures.
     */
    function handler_math_property_violation_should_fail(uint256 x) public {
        fl.lte(x, 100, "Value should be <= 100");
    }

    /**
     * @dev Handler for errAllow functionality testing.
     * Verifies errAllow works correctly with require and custom errors.
     */
    function handler_errallow(string memory errorMessage) public {
        // Test require error handling
        bytes memory callData = abi.encodeWithSignature("failWithRequire(string)", errorMessage);
        (bool success, bytes memory errorData) = address(target).call(callData);
        
        fl.t(!success, "Call should have failed");
        fl.t(errorData.length > 0, "Should have error data");
        
        string[] memory allowedMessages = new string[](1);
        allowedMessages[0] = errorMessage;
        fl.errAllow(errorData, allowedMessages, "require message should be allowed");
        
        // Test custom error handling
        bytes memory customCallData = abi.encodeWithSignature("failWithInvalidOperation()");
        (bool customSuccess, bytes memory customErrorData) = address(target).call(customCallData);
        
        fl.t(!customSuccess, "Custom error call should have failed");
        fl.t(customErrorData.length > 0, "Should have custom error data");
        
        bytes4[] memory allowedSelectors = new bytes4[](1);
        allowedSelectors[0] = DummyTarget.InvalidOperation.selector;
        fl.errAllow(bytes4(customErrorData), allowedSelectors, "InvalidOperation should be allowed");
    }

    /**
     * @dev Handler for errAllow that should fail - tests error handling validation.
     * This handler tests that errAllow correctly rejects unallowed errors.
     */
    function handler_errallow_should_fail(string memory errorMessage) public {
        // Make a call that will fail and capture the error data
        bytes memory callData = abi.encodeWithSignature("failWithRequire(string)", errorMessage);
        (bool success, bytes memory errorData) = address(target).call(callData);
        
        fl.t(!success, "Call should have failed");
        fl.t(errorData.length > 0, "Should have error data");
        
        // Test errAllow with WRONG allowed messages (should fail)
        string[] memory wrongMessages = new string[](1);
        wrongMessages[0] = "Different error message";
        fl.errAllow(errorData, wrongMessages, "This should fail - wrong message allowed");
    }
}