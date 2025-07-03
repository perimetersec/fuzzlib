// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {HelperClamp} from "../src/helpers/HelperClamp.sol";

/**
 * @dev Tests for HelperClamp modular arithmetic clamping functions.
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
        assertEq(this.clamp(uint256(50), uint256(25), uint256(75)), uint256(50));
    }

    function test_clamp_uint256_below_range() public {
        assertEq(this.clamp(uint256(15), uint256(20), uint256(30)), uint256(24)); // 20 + (15 % 11) = 20 + 4
        assertEq(this.clamp(uint256(0), uint256(5), uint256(10)), uint256(5)); // 5 + (0 % 6) = 5 + 0
        assertEq(this.clamp(uint256(3), uint256(10), uint256(15)), uint256(13)); // 10 + (3 % 6) = 10 + 3
        assertEq(this.clamp(uint256(1), uint256(100), uint256(105)), uint256(101)); // 100 + (1 % 6) = 100 + 1
    }

    function test_clamp_uint256_above_range() public {
        assertEq(this.clamp(uint256(35), uint256(20), uint256(30)), uint256(22)); // 20 + (35 % 11) = 20 + 2
        assertEq(this.clamp(uint256(100), uint256(0), uint256(9)), uint256(0)); // 0 + (100 % 10) = 0 + 0
        assertEq(this.clamp(uint256(50), uint256(10), uint256(20)), uint256(16)); // 10 + (50 % 11) = 10 + 6
        assertEq(this.clamp(uint256(1000), uint256(5), uint256(12)), uint256(5)); // 5 + (1000 % 8) = 5 + 0
    }

    function test_clamp_uint256_single_value_range() public {
        assertEq(this.clamp(uint256(100), uint256(5), uint256(5)), uint256(5));
        assertEq(this.clamp(uint256(0), uint256(5), uint256(5)), uint256(5));
        assertEq(this.clamp(uint256(5), uint256(5), uint256(5)), uint256(5));
        assertEq(this.clamp(type(uint256).max, uint256(42), uint256(42)), uint256(42));
    }

    function test_clamp_uint256_zero_bounds() public {
        assertEq(this.clamp(uint256(0), uint256(0), uint256(0)), uint256(0));
        assertEq(this.clamp(uint256(100), uint256(0), uint256(0)), uint256(0));
        assertEq(this.clamp(type(uint256).max, uint256(0), uint256(0)), uint256(0));
    }

    function test_clamp_uint256_small_ranges() public {
        // Test ranges of size 2
        assertEq(this.clamp(uint256(10), uint256(5), uint256(6)), uint256(5)); // 5 + (10 % 2) = 5 + 0
        assertEq(this.clamp(uint256(11), uint256(5), uint256(6)), uint256(6)); // 5 + (11 % 2) = 5 + 1

        // Test ranges of size 3
        assertEq(this.clamp(uint256(15), uint256(10), uint256(12)), uint256(10)); // 10 + (15 % 3) = 10 + 0
        assertEq(this.clamp(uint256(16), uint256(10), uint256(12)), uint256(11)); // 10 + (16 % 3) = 10 + 1
        assertEq(this.clamp(uint256(17), uint256(10), uint256(12)), uint256(12)); // 10 + (17 % 3) = 10 + 2
    }

    function test_clamp_uint256_large_ranges() public {
        uint256 low = 1000;
        uint256 high = 2000;
        // Test various values in large range
        assertEq(this.clamp(uint256(0), low, high), uint256(1000)); // 1000 + (0 % 1001) = 1000
        assertEq(this.clamp(uint256(2500), low, high), uint256(1498)); // 1000 + (2500 % 1001) = 1000 + 498
        assertEq(this.clamp(uint256(5000), low, high), uint256(1996)); // 1000 + (5000 % 1001) = 1000 + 996
    }

    function test_clamp_uint256_max_values() public {
        uint256 maxVal = type(uint256).max;

        // Test max value in various ranges
        assertEq(this.clamp(maxVal, maxVal - 2, maxVal), maxVal);
        assertEq(this.clamp(maxVal - 1, maxVal - 2, maxVal), maxVal - 1);
        assertEq(this.clamp(maxVal - 2, maxVal - 2, maxVal), maxVal - 2);

        // Test max value wrapping in smaller ranges
        assertEq(this.clamp(maxVal, uint256(0), uint256(10)), uint256(8)); // 0 + (max % 11) = 0 + 8
        assertEq(this.clamp(maxVal, uint256(100), uint256(110)), uint256(108)); // 100 + (max % 11) = 100 + 8
    }

    function test_clamp_uint256_power_of_2_ranges() public {
        // Test ranges that are powers of 2 (common in bit manipulation)
        assertEq(this.clamp(uint256(100), uint256(0), uint256(7)), uint256(4)); // 0 + (100 % 8) = 0 + 4
        assertEq(this.clamp(uint256(100), uint256(0), uint256(15)), uint256(4)); // 0 + (100 % 16) = 0 + 4
        assertEq(this.clamp(uint256(100), uint256(0), uint256(31)), uint256(4)); // 0 + (100 % 32) = 0 + 4
        assertEq(this.clamp(uint256(100), uint256(0), uint256(63)), uint256(36)); // 0 + (100 % 64) = 0 + 36
    }

    function test_clamp_uint256_boundary_sequences() public {
        // Test sequential boundary values
        uint256 low = 50;
        uint256 high = 60;

        // range = 60 - 50 + 1 = 11
        assertEq(this.clamp(uint256(49), low, high), uint256(55)); // 50 + (49 % 11) = 50 + 5
        assertEq(this.clamp(uint256(61), low, high), uint256(56)); // 50 + (61 % 11) = 50 + 6
        assertEq(this.clamp(uint256(71), low, high), uint256(55)); // 50 + (71 % 11) = 50 + 5
    }

    function test_clamp_uint256_with_logging() public {
        vm.expectEmit(true, true, true, true);
        emit Clamped("Clamping value 15 to 5");
        uint256 result = this.clamp(uint256(15), uint256(0), uint256(9));
        assertEq(result, uint256(5)); // 0 + (15 % 10) = 0 + 5
    }

    function test_clamp_uint256_invalid_range() public {
        vm.expectRevert(abi.encodeWithSelector(HelperClamp.InvalidRange.selector, uint256(100), uint256(10)));
        this.clamp(uint256(50), uint256(100), uint256(10));
    }

    function test_clamp_uint256_extreme_value_combinations() public {
        uint256 maxUint = type(uint256).max;

        // Cross-boundary tests with extreme values
        assertEq(this.clamp(maxUint, uint256(0), maxUint - 1), uint256(0)); // maxUint % maxUint = 0
        assertEq(this.clamp(uint256(0), maxUint - 1, maxUint), maxUint - 1);
        assertEq(this.clamp(maxUint - 1, uint256(0), maxUint), maxUint - 1);

        // Test with very large but not max values
        uint256 largeVal = maxUint / 2;
        assertEq(this.clamp(largeVal, uint256(0), uint256(100)), uint256(68)); // (maxUint/2) % 101 = 68
    }

    function test_clamp_uint256_cyclic_property() public {
        uint256 value = 25;
        uint256 low = 10;
        uint256 high = 20;
        uint256 range = high - low + 1;

        uint256 result1 = this.clamp(value, low, high);
        uint256 result2 = this.clamp(value + range, low, high);
        uint256 result3 = this.clamp(value + 2 * range, low, high);

        assertEq(result1, result2);
        assertEq(result2, result3);
    }

    function test_clamp_uint256_distributive_property() public {
        uint256 a = 5;
        uint256 b = 7;
        uint256 low = 10;
        uint256 high = 20;

        uint256 result_a = this.clamp(a, low, high);
        uint256 result_b = this.clamp(b, low, high);

        uint256 range = high - low + 1;
        assertEq((result_b - result_a + range) % range, (b - a) % range);
    }


    function testFuzz_clamp_uint256(uint256 value, uint256 low, uint256 high) public {
        vm.assume(low <= high);

        uint256 result = this.clamp(value, low, high);

        assertTrue(result >= low);
        assertTrue(result <= high);

        if (value >= low && value <= high) {
            assertEq(result, value);
        }

        if (low != high && !(value >= low && value <= high)) {
            uint256 range = high - low + 1;
            assertEq(result - low, value % range);
        }
    }

    /**
     * Tests for clamp(int128, int128, int128)
     */
    function test_clamp_int128_within_bounds() public {
        assertEq(this.clamp(int128(5), int128(-10), int128(10)), int128(5));
        assertEq(this.clamp(int128(-5), int128(-10), int128(10)), int128(-5));
        assertEq(this.clamp(int128(0), int128(-10), int128(10)), int128(0));
        assertEq(this.clamp(int128(-10), int128(-10), int128(10)), int128(-10));
        assertEq(this.clamp(int128(10), int128(-10), int128(10)), int128(10));
    }

    function test_clamp_int128_below_range() public {
        // Test modular arithmetic with negative remainder handling
        // For negative values, we use: if (offset < 0) offset += range
        assertEq(this.clamp(int128(-15), int128(-10), int128(10)), int128(-4)); // range=21, -15%21=-15, -15+21=6, -10+6=-4
        assertEq(this.clamp(int128(-25), int128(-10), int128(10)), int128(7)); // range=21, -25%21=-4, -4+21=17, -10+17=7
        assertEq(this.clamp(int128(-100), int128(0), int128(20)), int128(5)); // range=21, -100%21=-16, -16+21=5, 0+5=5
        assertEq(this.clamp(int128(-50), int128(-20), int128(0)), int128(-7)); // range=21, -50%21=-8, -8+21=13, -20+13=-7
    }

    function test_clamp_int128_above_range() public {
        // Test modular arithmetic for positive values above range
        assertEq(this.clamp(int128(15), int128(-10), int128(10)), int128(5)); // range=21, 15%21=15, -10+15=5
        assertEq(this.clamp(int128(25), int128(-10), int128(10)), int128(-6)); // range=21, 25%21=4, -10+4=-6
        assertEq(this.clamp(int128(100), int128(0), int128(20)), int128(16)); // range=21, 100%21=16, 0+16=16
        assertEq(this.clamp(int128(50), int128(-20), int128(0)), int128(-12)); // range=21, 50%21=8, -20+8=-12
    }

    function test_clamp_int128_negative_bounds() public {
        // Test ranges entirely in negative numbers
        assertEq(this.clamp(int128(-30), int128(-20), int128(-10)), int128(-17)); // range=11, -30%11=-8, -8+11=3, -20+3=-17
        assertEq(this.clamp(int128(-5), int128(-20), int128(-10)), int128(-14)); // range=11, -5%11=-5, -5+11=6, -20+6=-14
        assertEq(this.clamp(int128(-50), int128(-100), int128(-90)), int128(-95)); // range=11, -50%11=-6, -6+11=5, -100+5=-95
        assertEq(this.clamp(int128(0), int128(-50), int128(-40)), int128(-50)); // range=11, 0%11=0, -50+0=-50
    }

    function test_clamp_int128_positive_bounds() public {
        // Test ranges entirely in positive numbers
        assertEq(this.clamp(int128(25), int128(10), int128(20)), int128(13)); // range=11, 25%11=3, 10+3=13
        assertEq(this.clamp(int128(5), int128(10), int128(20)), int128(15)); // range=11, 5%11=5, 10+5=15
        assertEq(this.clamp(int128(100), int128(50), int128(60)), int128(51)); // range=11, 100%11=1, 50+1=51
        assertEq(this.clamp(int128(-10), int128(20), int128(30)), int128(21)); // range=11, -10%11=-10, -10+11=1, 20+1=21
    }

    function test_clamp_int128_zero_crossing() public {
        // Test ranges that cross zero
        // For clamp(-50, -5, 5): range = 5 - (-5) + 1 = 11, offset = -50 % 11 = -6, -6 + 11 = 5, ans = -5 + 5 = 0
        assertEq(this.clamp(int128(-50), int128(-5), int128(5)), int128(0));
        // For clamp(50, -5, 5): range = 11, offset = 50 % 11 = 6, ans = -5 + 6 = 1
        assertEq(this.clamp(int128(50), int128(-5), int128(5)), int128(1));
        assertEq(this.clamp(int128(100), int128(-10), int128(10)), int128(6)); // range=21, 100%21=16, -10+16=6
        assertEq(this.clamp(int128(-100), int128(-10), int128(10)), int128(-5)); // range=21, -100%21=-16, -16+21=5, -10+5=-5
    }

    function test_clamp_int128_single_value_range() public {
        assertEq(this.clamp(int128(100), int128(5), int128(5)), int128(5));
        assertEq(this.clamp(int128(-100), int128(-5), int128(-5)), int128(-5));
        assertEq(this.clamp(int128(0), int128(0), int128(0)), int128(0));
        assertEq(this.clamp(type(int128).max, int128(42), int128(42)), int128(42));
        assertEq(this.clamp(type(int128).min, int128(-42), int128(-42)), int128(-42));
    }

    function test_clamp_int128_boundary_conditions() public {
        int128 max = type(int128).max;
        int128 min = type(int128).min;

        assertEq(this.clamp(max, max - 2, max), max);
        assertEq(this.clamp(max - 1, max - 2, max), max - 1);
        assertEq(this.clamp(max - 2, max - 2, max), max - 2);
        assertEq(this.clamp(max - 3, max - 2, max), max - 1); // range=3, (max-3)%3=1, (max-2)+1=max-1

        // Test around int128 min
        assertEq(this.clamp(min, min, min + 2), min);
        assertEq(this.clamp(min + 1, min, min + 2), min + 1);
        assertEq(this.clamp(min + 2, min, min + 2), min + 2);
        assertEq(this.clamp(min + 3, min, min + 2), min + 1); // range=3, (min+3)%3=1, min+1=min+1

        assertEq(this.clamp(int128(-1), int128(-1), int128(1)), int128(-1));
        assertEq(this.clamp(int128(0), int128(-1), int128(1)), int128(0));
        assertEq(this.clamp(int128(1), int128(-1), int128(1)), int128(1));
    }

    function test_clamp_int128_extreme_value_combinations() public {
        int128 maxInt = type(int128).max;
        int128 minInt = type(int128).min;

        assertEq(this.clamp(maxInt, minInt, maxInt), maxInt);
        assertEq(this.clamp(minInt, minInt, maxInt), minInt);

        // Test extreme values in smaller ranges
        assertEq(this.clamp(maxInt, int128(0), int128(100)), int128(39)); // range=101, maxInt%101=39, 0+39=39
        assertEq(this.clamp(minInt, int128(0), int128(100)), int128(61)); // range=101, minInt%101=61, 0+61=61

        // Cross-boundary tests
        assertEq(this.clamp(maxInt, int128(-50), int128(50)), int128(-11)); // range=101, maxInt%101=39, -50+39=-11
        assertEq(this.clamp(minInt, int128(-50), int128(50)), int128(11)); // range=101, minInt%101=61, -50+61=11
    }

    function test_clamp_int128_large_ranges() public {
        int128 low = -10000;
        int128 high = 10000;

        assertEq(this.clamp(int128(50000), low, high), int128(-2)); // range=20001, 50000%20001=9998, -10000+9998=-2
        assertEq(this.clamp(int128(-50000), low, high), int128(3)); // range=20001, -50000%20001=10003, -10000+10003=3
        assertEq(this.clamp(int128(0), low, high), int128(0)); // Already in range
    }

    function test_clamp_int128_small_ranges() public {
        // Test ranges of size 2
        assertEq(this.clamp(int128(10), int128(-1), int128(0)), int128(-1)); // range=2, 10%2=0, -1+0=-1
        assertEq(this.clamp(int128(11), int128(-1), int128(0)), int128(0)); // range=2, 11%2=1, -1+1=0

        // Test ranges of size 3
        assertEq(this.clamp(int128(15), int128(-1), int128(1)), int128(-1)); // range=3, 15%3=0, -1+0=-1
        assertEq(this.clamp(int128(16), int128(-1), int128(1)), int128(0)); // range=3, 16%3=1, -1+1=0
        assertEq(this.clamp(int128(17), int128(-1), int128(1)), int128(1)); // range=3, 17%3=2, -1+2=1
    }

    function test_clamp_int128_with_logging() public {
        vm.expectEmit(true, true, true, true);
        emit Clamped("Clamping value 15 to 5");
        int128 result = this.clamp(int128(15), int128(-10), int128(10));
        assertEq(result, int128(5)); // range=21, 15%21=15, -10+15=5
    }

    function test_clamp_int128_invalid_range() public {
        vm.expectRevert(abi.encodeWithSelector(HelperClamp.InvalidRangeInt128.selector, int128(100), int128(10)));
        this.clamp(int128(50), int128(100), int128(10));
    }

    function test_clamp_int128_cyclic_property() public {
        int128 value = 15;
        int128 low = -10;
        int128 high = 10;
        int256 range = int256(high) - int256(low) + 1;

        int128 result1 = this.clamp(value, low, high);
        int128 result2 = this.clamp(int128(int256(value) + range), low, high);

        assertEq(result1, result2);
    }

    function test_clamp_int128_sign_preservation_property() public {
        int128 pos_val = 50;
        int128 neg_val = -50;
        int128 low = -10;
        int128 high = 10;

        int128 pos_result = this.clamp(pos_val, low, high);
        int128 neg_result = this.clamp(neg_val, low, high);

        assertTrue(pos_result >= low && pos_result <= high);
        assertTrue(neg_result >= low && neg_result <= high);
    }


    function testFuzz_clamp_int128(int128 value, int128 low, int128 high) public {
        vm.assume(low <= high);

        int128 result = this.clamp(value, low, high);

        assertTrue(result >= low);
        assertTrue(result <= high);

        if (value >= low && value <= high) {
            assertEq(result, value);
        }
    }

    /**
     * Tests for clampLt(uint256, uint256)
     */
    function test_clampLt_uint256_basic_behavior() public {
        assertEq(this.clampLt(uint256(5), uint256(10)), this.clamp(uint256(5), uint256(0), uint256(9)));
        assertEq(this.clampLt(uint256(15), uint256(10)), this.clamp(uint256(15), uint256(0), uint256(9)));
        assertEq(this.clampLt(uint256(100), uint256(50)), this.clamp(uint256(100), uint256(0), uint256(49)));
    }

    function test_clampLt_uint256_edge_cases() public {
        assertEq(this.clampLt(uint256(1), uint256(2)), uint256(1));
        assertEq(this.clampLt(uint256(10), uint256(5)), uint256(0));
        assertEq(this.clampLt(uint256(11), uint256(5)), uint256(1));
    }

    function test_clampLt_uint256_overflow_cases() public {
        vm.expectRevert(abi.encodeWithSelector(HelperClamp.UnsupportedClampLtValue.selector, uint256(0)));
        this.clampLt(uint256(100), uint256(0));
    }

    function testFuzz_clampLt_uint256(uint256 a, uint256 b) public {
        vm.assume(b > 0);

        uint256 result = this.clampLt(a, b);

        assertTrue(result < b);
        assertTrue(result >= 0);

        if (a < b) {
            assertEq(result, a);
        }
    }

    /**
     * Tests for clampLt(int128, int128)
     */
    function test_clampLt_int128_basic_behavior() public {
        assertEq(this.clampLt(int128(5), int128(10)), int128(5));
        assertEq(this.clampLt(int128(-5), int128(10)), int128(-5));
        assertEq(this.clampLt(int128(15), int128(10)), this.clamp(int128(15), type(int128).min, int128(9)));
    }

    function test_clampLt_int128_overflow_cases() public {
        vm.expectRevert(abi.encodeWithSelector(HelperClamp.UnsupportedClampLtValueInt128.selector, type(int128).min));
        this.clampLt(int128(100), type(int128).min);
    }

    /**
     * Tests for clampLte(uint256, uint256)
     */
    function test_clampLte_uint256_basic_behavior() public {
        assertEq(this.clampLte(uint256(5), uint256(10)), this.clamp(uint256(5), uint256(0), uint256(10)));
        assertEq(this.clampLte(uint256(15), uint256(10)), this.clamp(uint256(15), uint256(0), uint256(10)));
        assertEq(this.clampLte(uint256(10), uint256(10)), uint256(10));
    }

    function test_clampLte_uint256_edge_cases() public {
        assertEq(this.clampLte(uint256(0), uint256(0)), uint256(0));
        assertEq(this.clampLte(uint256(100), uint256(0)), uint256(0));
        assertEq(this.clampLte(type(uint256).max, uint256(50)), uint256(0));
    }

    function testFuzz_clampLte_uint256(uint256 a, uint256 b) public {
        uint256 result = this.clampLte(a, b);

        assertTrue(result <= b);
        assertTrue(result >= 0);

        if (a <= b) {
            assertEq(result, a);
        }
    }

    /**
     * Tests for clampLte(int128, int128)
     */
    function test_clampLte_int128_basic_behavior() public {
        assertEq(this.clampLte(int128(5), int128(10)), int128(5));
        assertEq(this.clampLte(int128(10), int128(10)), int128(10));
        assertEq(this.clampLte(int128(-5), int128(10)), int128(-5));
    }

    /**
     * Tests for clampGt(uint256, uint256)
     */
    function test_clampGt_uint256_basic_behavior() public {
        assertEq(this.clampGt(uint256(15), uint256(10)), uint256(15));
        assertEq(this.clampGt(uint256(5), uint256(10)), this.clamp(uint256(5), uint256(11), type(uint256).max));
        assertEq(this.clampGt(uint256(10), uint256(10)), this.clamp(uint256(10), uint256(11), type(uint256).max));
    }

    function test_clampGt_uint256_edge_cases() public {
        assertEq(this.clampGt(uint256(0), uint256(5)), this.clamp(uint256(0), uint256(6), type(uint256).max));
        assertEq(this.clampGt(uint256(100), uint256(50)), uint256(100));
    }

    function test_clampGt_uint256_overflow_cases() public {
        vm.expectRevert(abi.encodeWithSelector(HelperClamp.UnsupportedClampGtValue.selector, type(uint256).max));
        this.clampGt(uint256(100), type(uint256).max);
    }

    function testFuzz_clampGt_uint256(uint256 a, uint256 b) public {
        vm.assume(b < type(uint256).max);

        uint256 result = this.clampGt(a, b);

        assertTrue(result > b);

        if (a > b) {
            assertEq(result, a);
        }
    }

    /**
     * Tests for clampGt(int128, int128)
     */
    function test_clampGt_int128_basic_behavior() public {
        assertEq(this.clampGt(int128(15), int128(10)), int128(15));
        assertEq(this.clampGt(int128(5), int128(10)), this.clamp(int128(5), int128(11), type(int128).max));
        assertEq(this.clampGt(int128(-5), int128(-10)), int128(-5));
    }

    function test_clampGt_int128_overflow_cases() public {
        vm.expectRevert(abi.encodeWithSelector(HelperClamp.UnsupportedClampGtValueInt128.selector, type(int128).max));
        this.clampGt(int128(100), type(int128).max);
    }

    /**
     * Tests for clampGte(uint256, uint256)
     */
    function test_clampGte_uint256_basic_behavior() public {
        assertEq(this.clampGte(uint256(15), uint256(10)), uint256(15));
        assertEq(this.clampGte(uint256(10), uint256(10)), uint256(10));
        assertEq(this.clampGte(uint256(5), uint256(10)), this.clamp(uint256(5), uint256(10), type(uint256).max));
    }

    function test_clampGte_uint256_edge_cases() public {
        assertEq(this.clampGte(uint256(0), uint256(0)), uint256(0));
        assertEq(this.clampGte(uint256(100), uint256(50)), uint256(100));
        assertEq(this.clampGte(uint256(10), uint256(100)), this.clamp(uint256(10), uint256(100), type(uint256).max));
    }

    function test_clampGte_uint256_with_logging() public {
        vm.expectEmit(true, true, true, true);
        emit Clamped("Clamping value 5 to 15");
        this.clampGte(uint256(5), uint256(10));
    }

    function testFuzz_clampGte_uint256(uint256 a, uint256 b) public {
        uint256 result = this.clampGte(a, b);

        assertTrue(result >= b);

        if (a >= b) {
            assertEq(result, a);
        }
    }

    /**
     * Tests for clampGte(int128, int128)
     */
    function test_clampGte_int128_basic_behavior() public {
        assertEq(this.clampGte(int128(15), int128(10)), int128(15));
        assertEq(this.clampGte(int128(10), int128(10)), int128(10));
        assertEq(this.clampGte(int128(5), int128(10)), this.clamp(int128(5), int128(10), type(int128).max));
        assertEq(this.clampGte(int128(-5), int128(-10)), int128(-5));
    }
}
