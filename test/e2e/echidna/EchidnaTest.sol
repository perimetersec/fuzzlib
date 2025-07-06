// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../../src/FuzzBase.sol";

/**
 * @dev Echidna E2E test for fuzzlib functionality.
 * Tests core helpers using assertion-based fuzzing.
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
        
        fl.log("Math operations completed");
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
        fl.log("Abs operation completed for value:", x);
    }

    /**
     * @dev Test value clamping behavior.
     * Verifies clamp results always stay within specified bounds.
     * Note: fuzzlib clamp uses modular arithmetic, not traditional min/max clamping.
     */
    function test_clamp_operations(uint256 inputValue, uint256 low, uint256 high) public {
        // Ensure valid range (low <= high)
        if (low > high) return;
        
        uint256 clampedValue = fl.clamp(inputValue, low, high);
        
        // Verify clamped value is within bounds - this should always be true
        fl.gte(clampedValue, low, "Clamped value should be >= low bound");
        fl.lte(clampedValue, high, "Clamped value should be <= high bound");
        
        // For modular arithmetic clamping, if value is already in range, it stays unchanged
        if (inputValue >= low && inputValue <= high) {
            fl.eq(clampedValue, inputValue, "Value in range should remain unchanged");
        } else {
            // For out-of-range values, result should be: low + (inputValue % (high - low + 1))
            uint256 range = high - low + 1;
            uint256 expected = low + (inputValue % range);
            fl.eq(clampedValue, expected, "Out-of-range value should use modular arithmetic");
        }
        
        value = clampedValue;
        fl.log("Clamped value:", clampedValue);
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
        
        fl.log("Assertion tests completed");
    }

    /**
     * @dev Test logging functionality doesn't break contract state.
     * Verifies various logging functions work without side effects.
     */
    function test_logging_operations(uint256 num, string memory message) public {
        uint256 stateBefore = value;
        
        // Test different logging functions
        fl.log("Testing logging with number:", num);
        fl.log("Testing logging with message:", message);
        fl.log("Testing simple message");
        
        // State should be unchanged after logging
        fl.eq(value, stateBefore, "Logging should not change contract state");
        
        // Update state and verify logging still works
        value = num % 1000; // Keep value reasonable
        fl.log("Updated value to:", value);
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
        
        fl.log("Difference calculated:", difference);
    }

    /**
     * @dev Test edge cases with boundary values.
     * Verifies helpers work correctly with extreme values.
     */
    function test_boundary_values() public {
        // Test with zero values using explicit types
        fl.eq(fl.max(uint256(0), uint256(0)), 0, "Max of two zeros should be zero");
        fl.eq(fl.min(uint256(0), uint256(0)), 0, "Min of two zeros should be zero");
        fl.eq(fl.clamp(uint256(100), uint256(0), uint256(0)), 0, "Clamp to zero range should be zero");
        
        // Test with larger values (be careful with overflow)
        uint256 large = type(uint256).max / 2; // Use half max to avoid overflow
        fl.eq(fl.max(large, uint256(0)), large, "Max of large and zero should be large");
        fl.eq(fl.min(large, uint256(0)), 0, "Min of large and zero should be zero");
        
        fl.log("Boundary value tests completed");
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
        
        fl.log("Array shuffled successfully with entropy:", entropy);
    }

    /**
     * @dev Test HelperRandom deterministic behavior.
     * Same entropy should produce same shuffle result.
     */
    function test_shuffle_deterministic_behavior() public {
        // Create two identical arrays
        uint256[] memory array1 = new uint256[](4);
        uint256[] memory array2 = new uint256[](4);
        array1[0] = 1; array2[0] = 1;
        array1[1] = 2; array2[1] = 2;
        array1[2] = 3; array2[2] = 3;
        array1[3] = 4; array2[3] = 4;
        
        // Shuffle both with same entropy
        uint256 entropy = 12345;
        fl.shuffleArray(array1, entropy);
        fl.shuffleArray(array2, entropy);
        
        // Results should be identical
        fl.eq(array1.length, array2.length, "Arrays should have same length");
        for (uint256 i = 0; i < array1.length; i++) {
            fl.eq(array1[i], array2[i], "Elements should match at same positions");
        }
        
        fl.log("Deterministic shuffle behavior verified");
    }

    /**
     * @dev Test HelperRandom edge cases with small arrays.
     * Verifies behavior with single-element and two-element arrays.
     */
    function test_shuffle_edge_cases(uint256 entropy) public {
        // Test single element array (should remain unchanged)
        uint256[] memory singleArray = new uint256[](1);
        singleArray[0] = 42;
        fl.shuffleArray(singleArray, entropy);
        fl.eq(singleArray[0], 42, "Single element should remain unchanged");
        
        // Test two element array
        uint256[] memory twoArray = new uint256[](2);
        twoArray[0] = 100;
        twoArray[1] = 200;
        fl.shuffleArray(twoArray, entropy);
        fl.eq(twoArray.length, 2, "Two element array should preserve length");
        fl.t(
            (twoArray[0] == 100 && twoArray[1] == 200) || 
            (twoArray[0] == 200 && twoArray[1] == 100),
            "Two element array should contain both original elements"
        );
        
        fl.log("Edge case shuffling completed");
    }

    /**
     * @dev Test HelperCall function call functionality.
     * Verifies function calls work correctly with different scenarios.
     */
    function test_function_call_operations(uint256 testValue) public {
        // Keep test value reasonable to avoid gas issues
        testValue = testValue % 1000000;
        
        // Test call to a view function on this contract
        bytes memory callData = abi.encodeWithSignature("value()");
        (bool success, bytes memory returnData) = fl.doFunctionCall(address(this), callData);
        
        fl.t(success, "Function call should succeed");
        fl.t(returnData.length > 0, "Should return data");
        
        // Decode returned value
        uint256 returnedValue = abi.decode(returnData, (uint256));
        fl.eq(returnedValue, value, "Returned value should match contract state");
        
        fl.log("Function call completed successfully");
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
     * @dev Test HelperCall static call functionality.
     * Verifies static calls work for view functions.
     */
    function test_static_call_operations() public {
        // Test static call to view function
        bytes memory callData = abi.encodeWithSignature("value()");
        (bool success, bytes memory returnData) = fl.doFunctionStaticCall(address(this), callData);
        
        fl.t(success, "Static call should succeed");
        fl.t(returnData.length > 0, "Should return data");
        
        // Decode returned value
        uint256 returnedValue = abi.decode(returnData, (uint256));
        fl.eq(returnedValue, value, "Static call should return correct value");
        
        fl.log("Static call completed successfully");
    }

    /**
     * @dev Test error handling to verify errAllow is not available in E2E testing.
     * This demonstrates the difference between unit tests and E2E fuzzing.
     */
    function test_error_handling_differences() public {
        // In E2E testing, we can't use errAllow like in unit tests
        // Instead, we test that functions work correctly without expected failures
        
        // Test array shuffle with empty array should revert
        uint256[] memory emptyArray = new uint256[](0);
        
        // This call should revert with EmptyArray() error
        // In E2E testing, we let it revert naturally rather than using errAllow
        bool shouldRevert = false;
        try fl.shuffleArray(emptyArray, 123) {
            shouldRevert = false;
        } catch {
            shouldRevert = true;
        }
        
        // In E2E testing, we verify the revert occurred
        fl.t(shouldRevert, "Empty array shuffle should revert");
        
        fl.log("Error handling test completed");
    }

    /**
     * @dev Test successful error recovery scenarios.
     * Verifies that valid operations work after failed operations.
     */
    function test_error_recovery_operations() public {
        // Test that we can recover from failed operations
        uint256[] memory validArray = new uint256[](3);
        validArray[0] = 1;
        validArray[1] = 2;
        validArray[2] = 3;
        
        // This should work fine after any previous failures
        fl.shuffleArray(validArray, 456);
        
        // Verify array was shuffled (length preserved)
        fl.eq(validArray.length, 3, "Array length should be preserved");
        
        // Verify sum is preserved
        uint256 sum = validArray[0] + validArray[1] + validArray[2];
        fl.eq(sum, 6, "Sum should be preserved after shuffle");
        
        fl.log("Error recovery test completed");
    }

    /**
     * @dev Test that should always fail - used to verify test detection works.
     * This test intentionally contains a false assertion.
     */
    function test_always_fails_should_fail() public {
        // This assertion should always fail
        fl.eq(uint256(1), uint256(2), "This should always fail: 1 != 2");
        
        fl.log("This should never be reached");
    }

    /**
     * @dev Test mathematical properties that should fail.
     * This tests that our validation can detect expected failures.
     */
    function test_math_property_violation_should_fail(uint256 x) public {
        // This should fail when x > 100, demonstrating property violation
        fl.lte(x, 100, "Value should be <= 100");
        
        fl.log("Value was within range:", x);
    }
}