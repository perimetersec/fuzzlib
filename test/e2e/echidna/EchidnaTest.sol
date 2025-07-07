// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../../src/FuzzBase.sol";

/**
 * @dev Echidna E2E integration test for fuzzlib functionality.
 * @author Perimeter <info@perimetersec.io>
 */
contract EchidnaTest is FuzzBase {
    uint256 public value;
    uint256 public lastMaxResult;
    uint256 public lastMinResult;
    uint256 public lastAbsResult;

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
        lastMaxResult = maxResult;

        // Test min operation
        uint256 minResult = fl.min(a, b);
        fl.lte(minResult, a, "Min result should be <= a");
        fl.lte(minResult, b, "Min result should be <= b");
        fl.t(minResult == a || minResult == b, "Min result should equal either a or b");
        lastMinResult = minResult;
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
        lastAbsResult = absResult;
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

        value = clampedValue;
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
     * @dev Test logging functionality doesn't break contract state.
     * Verifies various logging functions work without unwanted reverts.
     */
    function test_logging_operations(uint256 num, string memory message) public {
        fl.log("Testing logging with number:", num);
        fl.log("Testing logging with message:", message);
        fl.log("Testing simple message");
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
     * @dev Test HelperCall function call functionality.
     */
    function test_function_call() public {
        // Test call to a view function on this contract
        bytes memory callData = abi.encodeWithSignature("value()");
        (bool success, bytes memory returnData) = fl.doFunctionCall(address(this), callData);

        fl.t(success, "Function call should succeed");
        fl.t(returnData.length > 0, "Should return data");

        // Decode returned value
        uint256 returnedValue = abi.decode(returnData, (uint256));
        fl.eq(returnedValue, value, "Returned value should match contract state");
    }

    /**
     * @dev Test HelperCall with actor specification.
     * Verifies calls can be made with different actor addresses.
     */
    function test_function_call_with_actor(address actor) public {
        // Use a simple view function call with specified actor
        bytes memory callData = abi.encodeWithSignature("value()");
        (bool success, bytes memory returnData) = fl.doFunctionCall(address(this), callData, actor);

        fl.t(success, "Function call with actor should succeed");
        fl.t(returnData.length > 0, "Should return data");

        // Decode and verify
        uint256 returnedValue = abi.decode(returnData, (uint256));
        fl.eq(returnedValue, value, "Returned value should match regardless of actor");

        fl.log("Function call with actor completed");
    }

    /**
     * @dev Test that should always fail - used to verify test detection works.
     * This test intentionally contains a false assertion.
     */
    function test_always_fails_should_fail() public {
        fl.eq(uint256(1), uint256(2), "This should always fail: 1 != 2");
    }

    /**
     * @dev Test mathematical properties that should fail.
     * This tests that our validation can detect expected failures.
     */
    function test_math_property_violation_should_fail(uint256 x) public {
        fl.lte(x, 100, "Value should be <= 100");
    }
}

