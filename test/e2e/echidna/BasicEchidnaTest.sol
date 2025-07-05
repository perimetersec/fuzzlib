// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../../src/FuzzBase.sol";

/**
 * @dev Basic Echidna E2E test for fuzzlib functionality.
 * Tests core helpers using assertion-based fuzzing.
 * @author Perimeter <info@perimetersec.io>
 */
contract BasicEchidnaTest is FuzzBase {
    uint256 public value;
    uint256 public lastMaxResult;
    uint256 public lastMinResult;
    uint256 public lastAbsResult;

    /**
     * @dev Test mathematical operations with assertions.
     * Verifies max, min, and abs functions work correctly under fuzzing.
     */
    function testMathOperations(uint256 a, uint256 b) public {
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
    function testAbsOperations(int256 x) public {
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
    function testClampOperations(uint256 inputValue, uint256 low, uint256 high) public {
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
    function testBasicAssertions(uint256 a, uint256 b) public {
        // Test equality when values are the same
        if (a == b) {
            fl.eq(a, b, "Values should be equal");
        }
        
        // Test greater than or equal
        uint256 maxVal = fl.max(a, b);
        fl.gte(maxVal, a, "Max should be >= a");
        fl.gte(maxVal, b, "Max should be >= b");
        
        // Test less than or equal
        uint256 minVal = fl.min(a, b);
        fl.lte(minVal, a, "Min should be <= a");
        fl.lte(minVal, b, "Min should be <= b");
        
        fl.log("Assertion tests completed");
    }

    /**
     * @dev Test logging functionality doesn't break contract state.
     * Verifies various logging functions work without side effects.
     */
    function testLoggingOperations(uint256 num, string memory message) public {
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
    function testDiffOperations(uint256 a, uint256 b) public {
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
    function testBoundaryValues() public {
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
     * @dev Test that should always fail - used to verify test detection works.
     * This test intentionally contains a false assertion.
     */
    function testAlwaysFails_ShouldFail() public {
        // This assertion should always fail
        fl.eq(uint256(1), uint256(2), "This should always fail: 1 != 2");
        
        fl.log("This should never be reached");
    }

    /**
     * @dev Test mathematical properties that should fail.
     * This tests that our validation can detect expected failures.
     */
    function testMathPropertyViolation_ShouldFail(uint256 x) public {
        // This should fail when x > 100, demonstrating property violation
        fl.lte(x, 100, "Value should be <= 100");
        
        fl.log("Value was within range:", x);
    }
}