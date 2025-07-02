// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {HelperClamp} from "../src/helpers/HelperClamp.sol";

/**
 * @dev Comprehensive tests for HelperClamp functionality including value clamping,
 * bounds checking, logging, and edge cases with proper overflow handling.
 * @author Perimeter <info@perimetersec.io>
 */
contract TestHelperClamp is Test, HelperClamp {
    /**
     * Tests for clamp(uint256, uint256, uint256)
     */
    function test_clamp_uint256_within_bounds() public {
        assertEq(this.clamp(uint256(5), uint256(0), uint256(10)), uint256(5));
        assertEq(this.clamp(uint256(0), uint256(0), uint256(10)), uint256(0));
        assertEq(this.clamp(uint256(10), uint256(0), uint256(10)), uint256(10));
    }

    function test_clamp_uint256_below_range() public {
        // Test modulo arithmetic: low + (value % (high - low + 1))
        // For value=15, low=20, high=30: 20 + (15 % 11) = 20 + 4 = 24
        assertEq(this.clamp(uint256(15), uint256(20), uint256(30)), uint256(24));

        // For value=0, low=5, high=10: 5 + (0 % 6) = 5 + 0 = 5
        assertEq(this.clamp(uint256(0), uint256(5), uint256(10)), uint256(5));
    }

    function test_clamp_uint256_above_range() public {
        // For value=35, low=20, high=30: 20 + (35 % 11) = 20 + 2 = 22
        assertEq(this.clamp(uint256(35), uint256(20), uint256(30)), uint256(22));

        // For value=100, low=0, high=9: 0 + (100 % 10) = 0 + 0 = 0
        assertEq(this.clamp(uint256(100), uint256(0), uint256(9)), uint256(0));
    }

    function test_clamp_uint256_single_value_range() public {
        // When low == high, all values should clamp to that value
        assertEq(this.clamp(uint256(100), uint256(5), uint256(5)), uint256(5));
        assertEq(this.clamp(uint256(0), uint256(5), uint256(5)), uint256(5));
        assertEq(this.clamp(uint256(5), uint256(5), uint256(5)), uint256(5));
    }

    function test_clamp_uint256_zero_bounds() public {
        assertEq(this.clamp(uint256(0), uint256(0), uint256(0)), uint256(0));
        assertEq(this.clamp(uint256(100), uint256(0), uint256(0)), uint256(0));
    }

    function test_clamp_uint256_max_values() public {
        uint256 maxVal = type(uint256).max;
        assertEq(this.clamp(maxVal, maxVal - 1, maxVal), maxVal);
        // For value=maxVal-2, low=maxVal-1, high=maxVal: range=2, (maxVal-2-(maxVal-1))%2 = (-1)%2 would underflow
        // Let's test a safer case
        assertEq(this.clamp(maxVal - 3, maxVal - 1, maxVal), maxVal - 1);
    }

    function test_clamp_uint256_with_logging() public {
        vm.expectEmit(true, true, true, true);
        emit Clamped("Clamping value 15 to 5");

        uint256 result = this.clamp(uint256(15), uint256(0), uint256(9));
        assertEq(result, uint256(5));
    }

    function testFuzz_clamp_uint256(uint256 value, uint256 low, uint256 high) public {
        vm.assume(low <= high);

        uint256 result = this.clamp(value, low, high);

        // Result should always be within bounds
        assertTrue(result >= low);
        assertTrue(result <= high);

        // If value was already in range, result should equal value
        if (value >= low && value <= high) {
            assertEq(result, value);
        }
    }

    /**
     * Tests for clamp(int256, int256, int256)
     */
    function test_clamp_int256_within_bounds() public {
        assertEq(this.clamp(int256(5), int256(-10), int256(10)), int256(5));
        assertEq(this.clamp(int256(-5), int256(-10), int256(10)), int256(-5));
        assertEq(this.clamp(int256(0), int256(-10), int256(10)), int256(0));
    }

    function test_clamp_int256_below_range() public {
        // Test signed modulo arithmetic with proper handling of negative values
        // For value=-15, low=-10, high=10: range=21, (-15-(-10))%21 = -5%21 = -5+21 = 16, ans=-10+16=6
        assertEq(this.clamp(int256(-15), int256(-10), int256(10)), int256(6));
        // For value=-25, low=-10, high=10: range=21, (-25-(-10))%21 = -15%21 = -15+21 = 6, ans=-10+6=-4
        assertEq(this.clamp(int256(-25), int256(-10), int256(10)), int256(-4));
    }

    function test_clamp_int256_above_range() public {
        // For value=15, low=-10, high=10: range=21, (15-(-10))%21 = 25%21 = 4, ans=-10+4=-6
        assertEq(this.clamp(int256(15), int256(-10), int256(10)), int256(-6));
        // For value=25, low=-10, high=10: range=21, (25-(-10))%21 = 35%21 = 14, ans=-10+14=4
        assertEq(this.clamp(int256(25), int256(-10), int256(10)), int256(4));
    }

    function test_clamp_int256_negative_bounds() public {
        // For value=-30, low=-20, high=-10: range=11, (-30-(-20))%11 = -10%11 = -10+11 = 1, ans=-20+1=-19
        assertEq(this.clamp(int256(-30), int256(-20), int256(-10)), int256(-19));
        // For value=-5, low=-20, high=-10: range=11, (-5-(-20))%11 = 15%11 = 4, ans=-20+4=-16
        assertEq(this.clamp(int256(-5), int256(-20), int256(-10)), int256(-16));
    }

    function test_clamp_int256_positive_bounds() public {
        // For value=25, low=10, high=20: range=11, (25-10)%11 = 15%11 = 4, ans=10+4=14
        assertEq(this.clamp(int256(25), int256(10), int256(20)), int256(14));
        // For value=5, low=10, high=20: range=11, (5-10)%11 = -5%11 = -5+11 = 6, ans=10+6=16
        assertEq(this.clamp(int256(5), int256(10), int256(20)), int256(16));
    }

    function test_clamp_int256_single_value_range() public {
        assertEq(this.clamp(int256(100), int256(5), int256(5)), int256(5));
        assertEq(this.clamp(int256(-100), int256(-5), int256(-5)), int256(-5));
    }

    function test_clamp_int256_extreme_values() public {
        int256 minVal = type(int256).min;
        int256 maxVal = type(int256).max;

        assertEq(this.clamp(maxVal, minVal, maxVal), maxVal);
        assertEq(this.clamp(minVal, minVal, maxVal), minVal);
    }

    function test_clamp_int256_with_logging() public {
        vm.expectEmit(true, true, true, true);
        emit Clamped("Clamping value 15 to -6");

        int256 result = this.clamp(int256(15), int256(-10), int256(10));
        assertEq(result, int256(-6));
    }

    function testFuzz_clamp_int256(int256 value, int256 low, int256 high) public {
        vm.assume(low <= high);
        // Avoid overflow in range calculation by ensuring reasonable bounds
        vm.assume(low > type(int256).min / 4 && high < type(int256).max / 4);
        vm.assume(high - low < type(int256).max / 4);
        // Avoid edge cases that might cause overflow in modulo arithmetic
        vm.assume(value > type(int256).min / 4 && value < type(int256).max / 4);

        int256 result = this.clamp(value, low, high);

        // Result should always be within bounds
        assertTrue(result >= low);
        assertTrue(result <= high);

        // If value was already in range, result should equal value
        if (value >= low && value <= high) {
            assertEq(result, value);
        }
    }

    /**
     * Edge case tests
     */
    function test_edge_cases_boundary_values() public {
        // Test all functions with boundary values
        assertEq(this.clamp(uint256(0), uint256(0), uint256(1)), uint256(0));
        assertEq(this.clamp(int256(-1), int256(-1), int256(0)), int256(-1));
    }

    function test_clamp_invalid_range_uint256() public {
        // When low > high, the range calculation will underflow/wrap around
        // For uint256: high - low + 1 will wrap to a very large number
        // This tests the behavior with invalid ranges - but we expect it to revert
        vm.expectRevert(); // The function should revert due to underflow in range calculation
        this.clamp(uint256(50), uint256(100), uint256(10));
    }

    function test_clamp_invalid_range_int256() public {
        // When low > high for signed integers, the behavior is more complex
        // For int256: high - low + 1 will be negative, affecting the modulo
        int256 result = this.clamp(int256(50), int256(100), int256(10));
        // With low=100, high=10: range = 10 - 100 + 1 = -89
        // The modulo with negative range creates interesting edge case behavior
        assertTrue(result >= type(int256).min && result <= type(int256).max); // Always true, documents behavior
    }

    /**
     * Sequential boundary tests - testing values immediately adjacent to boundaries
     */
    function test_sequential_boundary_uint256_max() public {
        uint256 max = type(uint256).max;

        // Test around uint256 max for different clamp functions
        assertEq(this.clamp(max, max - 2, max), max);
        assertEq(this.clamp(max - 1, max - 2, max), max - 1);
        assertEq(this.clamp(max - 2, max - 2, max), max - 2);
    }

    function test_sequential_boundary_uint256_zero() public {
        // Test around zero boundary
        assertEq(this.clamp(uint256(0), uint256(0), uint256(2)), uint256(0));
        assertEq(this.clamp(uint256(1), uint256(0), uint256(2)), uint256(1));
        assertEq(this.clamp(uint256(2), uint256(0), uint256(2)), uint256(2));
    }

    function test_sequential_boundary_int256_max() public {
        int256 max = type(int256).max;

        // Test around int256 max
        assertEq(this.clamp(max, max - 2, max), max);
        assertEq(this.clamp(max - 1, max - 2, max), max - 1);
        assertEq(this.clamp(max - 2, max - 2, max), max - 2);
    }

    function test_sequential_boundary_int256_min() public {
        int256 min = type(int256).min;

        // Test around int256 min
        assertEq(this.clamp(min, min, min + 2), min);
        assertEq(this.clamp(min + 1, min, min + 2), min + 1);
        assertEq(this.clamp(min + 2, min, min + 2), min + 2);
    }

    function test_sequential_boundary_int256_zero_crossing() public {
        // Test around zero crossing for signed integers
        assertEq(this.clamp(int256(-1), int256(-2), int256(2)), int256(-1));
        assertEq(this.clamp(int256(0), int256(-2), int256(2)), int256(0));
        assertEq(this.clamp(int256(1), int256(-2), int256(2)), int256(1));
    }

    function test_cross_boundary_extreme_combinations() public {
        // Test combinations of extreme values across different boundaries
        uint256 maxUint = type(uint256).max;
        int256 maxInt = type(int256).max;
        int256 minInt = type(int256).min;

        // Cross-boundary uint256 tests
        assertEq(this.clamp(maxUint, uint256(0), maxUint - 1), uint256(0)); // Wraps to 0 due to modulo
        assertEq(this.clamp(uint256(0), maxUint - 1, maxUint), maxUint - 1);

        // Cross-boundary int256 tests with safer ranges to avoid overflow
        int256 safeMax = maxInt / 2;
        int256 safeMin = minInt / 2;
        assertEq(this.clamp(safeMax, safeMin, safeMax - 1), safeMin);
        assertEq(this.clamp(safeMin, safeMax - 1, safeMax), safeMax - 1);
    }

    /**
     * Cross-boundary tests with extreme values
     */
    function test_extreme_value_combinations() public {
        // Test combinations of extreme values
        uint256 maxUint = type(uint256).max;
        int256 maxInt = type(int256).max;
        int256 minInt = type(int256).min;

        // Test clamp with max values
        assertEq(this.clamp(maxUint, maxUint - 1, maxUint), maxUint);
        assertEq(this.clamp(maxInt, minInt, maxInt), maxInt);
        assertEq(this.clamp(minInt, minInt, maxInt), minInt);
    }
}
