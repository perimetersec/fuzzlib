// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {HelperMath} from "../src/helpers/HelperMath.sol";

/**
 * @dev Comprehensive tests for HelperMath functionality including mathematical utilities,
 * boundary conditions, and edge cases with proper overflow handling.
 * @author Perimeter <info@perimetersec.io>
 */
contract TestHelperMath is Test, HelperMath {
    /**
     * Tests for min(uint256, uint256)
     */
    function test_min_uint256_a_smaller() public {
        assertEq(min(uint256(5), uint256(10)), uint256(5));
    }

    function test_min_uint256_b_smaller() public {
        assertEq(min(uint256(10), uint256(5)), uint256(5));
    }

    function test_min_uint256_equal() public {
        assertEq(min(uint256(7), uint256(7)), uint256(7));
    }

    function test_min_uint256_zero() public {
        assertEq(min(uint256(0), uint256(100)), uint256(0));
        assertEq(min(uint256(100), uint256(0)), uint256(0));
    }

    function test_min_uint256_max_values() public {
        assertEq(min(type(uint256).max, type(uint256).max - 1), type(uint256).max - 1);
    }

    function testFuzz_min_uint256(uint256 a, uint256 b) public {
        uint256 result = min(a, b);
        assertTrue(result <= a && result <= b);
        assertTrue(result == a || result == b);
    }

    /**
     * Tests for max(uint256, uint256)
     */
    function test_max_uint256_a_larger() public {
        assertEq(max(uint256(10), uint256(5)), uint256(10));
    }

    function test_max_uint256_b_larger() public {
        assertEq(max(uint256(5), uint256(10)), uint256(10));
    }

    function test_max_uint256_equal() public {
        assertEq(max(uint256(7), uint256(7)), uint256(7));
    }

    function test_max_uint256_zero() public {
        assertEq(max(uint256(0), uint256(100)), uint256(100));
        assertEq(max(uint256(100), uint256(0)), uint256(100));
    }

    function test_max_uint256_max_values() public {
        assertEq(max(type(uint256).max, type(uint256).max - 1), type(uint256).max);
    }

    function testFuzz_max_uint256(uint256 a, uint256 b) public {
        uint256 result = max(a, b);
        assertTrue(result >= a && result >= b);
        assertTrue(result == a || result == b);
    }

    /**
     * Tests for max(int256, int256)
     */
    function test_max_int256_a_larger() public {
        assertEq(max(int256(10), int256(5)), int256(10));
    }

    function test_max_int256_b_larger() public {
        assertEq(max(int256(5), int256(10)), int256(10));
    }

    function test_max_int256_equal() public {
        assertEq(max(int256(7), int256(7)), int256(7));
    }

    function test_max_int256_negative() public {
        assertEq(max(int256(-5), int256(-10)), int256(-5));
        assertEq(max(int256(-10), int256(-5)), int256(-5));
    }

    function test_max_int256_mixed_signs() public {
        assertEq(max(int256(-5), int256(10)), int256(10));
        assertEq(max(int256(10), int256(-5)), int256(10));
    }

    function test_max_int256_zero() public {
        assertEq(max(int256(0), int256(100)), int256(100));
        assertEq(max(int256(100), int256(0)), int256(100));
        assertEq(max(int256(0), int256(-100)), int256(0));
        assertEq(max(int256(-100), int256(0)), int256(0));
    }

    function test_max_int256_extreme_values() public {
        assertEq(max(type(int256).max, type(int256).max - 1), type(int256).max);
        assertEq(max(type(int256).min, type(int256).min + 1), type(int256).min + 1);
    }

    function testFuzz_max_int256(int256 a, int256 b) public {
        int256 result = max(a, b);
        assertTrue(result >= a && result >= b);
        assertTrue(result == a || result == b);
    }

    /**
     * Tests for abs(int128) - using low-level call to avoid ambiguity
     */
    function test_abs_int128_positive() public {
        int128 input = int128(42);
        // Use low-level call with function selector for abs(int128)
        bytes memory data = abi.encodeWithSelector(bytes4(keccak256("abs(int128)")), input);
        (bool success, bytes memory result) = address(this).call(data);
        assertTrue(success);
        int128 output = abi.decode(result, (int128));
        assertEq(output, int128(42));
    }

    function test_abs_int128_negative() public {
        int128 input = int128(-42);
        bytes memory data = abi.encodeWithSelector(bytes4(keccak256("abs(int128)")), input);
        (bool success, bytes memory result) = address(this).call(data);
        assertTrue(success);
        int128 output = abi.decode(result, (int128));
        assertEq(output, int128(42));
    }

    function test_abs_int128_zero() public {
        int128 input = int128(0);
        bytes memory data = abi.encodeWithSelector(bytes4(keccak256("abs(int128)")), input);
        (bool success, bytes memory result) = address(this).call(data);
        assertTrue(success);
        int128 output = abi.decode(result, (int128));
        assertEq(output, int128(0));
    }

    function test_abs_int128_max_value() public {
        int128 input = type(int128).max;
        bytes memory data = abi.encodeWithSelector(bytes4(keccak256("abs(int128)")), input);
        (bool success, bytes memory result) = address(this).call(data);
        assertTrue(success);
        int128 output = abi.decode(result, (int128));
        assertEq(output, type(int128).max);
    }

    function test_abs_int128_min_plus_one() public {
        // Can't test type(int128).min because -(-2^127) would overflow
        int128 input = type(int128).min + 1;
        bytes memory data = abi.encodeWithSelector(bytes4(keccak256("abs(int128)")), input);
        (bool success, bytes memory result) = address(this).call(data);
        assertTrue(success);
        int128 output = abi.decode(result, (int128));
        assertEq(output, type(int128).max);
    }

    function testFuzz_abs_int128(int128 n) public {
        vm.assume(n != type(int128).min); // Avoid overflow
        bytes memory data = abi.encodeWithSelector(bytes4(keccak256("abs(int128)")), n);
        (bool success, bytes memory result) = address(this).call(data);
        assertTrue(success);
        int128 output = abi.decode(result, (int128));
        assertTrue(output >= 0);
        if (n >= 0) {
            assertEq(output, n);
        } else {
            assertEq(output, -n);
        }
    }

    /**
     * Tests for abs(int256) -> uint256 - using low-level call to avoid ambiguity
     */
    function test_abs_int256_positive() public {
        int256 input = int256(42);
        // Use low-level call with function selector for abs(int256)
        bytes memory data = abi.encodeWithSelector(bytes4(keccak256("abs(int256)")), input);
        (bool success, bytes memory result) = address(this).call(data);
        assertTrue(success);
        uint256 output = abi.decode(result, (uint256));
        assertEq(output, uint256(42));
    }

    function test_abs_int256_negative() public {
        int256 input = int256(-42);
        bytes memory data = abi.encodeWithSelector(bytes4(keccak256("abs(int256)")), input);
        (bool success, bytes memory result) = address(this).call(data);
        assertTrue(success);
        uint256 output = abi.decode(result, (uint256));
        assertEq(output, uint256(42));
    }

    function test_abs_int256_zero() public {
        int256 input = int256(0);
        bytes memory data = abi.encodeWithSelector(bytes4(keccak256("abs(int256)")), input);
        (bool success, bytes memory result) = address(this).call(data);
        assertTrue(success);
        uint256 output = abi.decode(result, (uint256));
        assertEq(output, uint256(0));
    }

    function test_abs_int256_max_value() public {
        int256 input = type(int256).max;
        bytes memory data = abi.encodeWithSelector(bytes4(keccak256("abs(int256)")), input);
        (bool success, bytes memory result) = address(this).call(data);
        assertTrue(success);
        uint256 output = abi.decode(result, (uint256));
        assertEq(output, uint256(type(int256).max));
    }

    function test_abs_int256_min_value() public {
        // This is the special case where type(int256).min causes overflow
        // The actual HelperMath function will revert due to arithmetic overflow
        int256 input = type(int256).min;
        bytes memory data = abi.encodeWithSelector(bytes4(keccak256("abs(int256)")), input);
        (bool success,) = address(this).call(data);
        // The call should fail due to arithmetic overflow
        assertFalse(success);
    }

    function testFuzz_abs_int256(int256 n) public {
        vm.assume(n != type(int256).min); // Avoid overflow for fuzz test  
        bytes memory data = abi.encodeWithSelector(bytes4(keccak256("abs(int256)")), n);
        (bool success, bytes memory result) = address(this).call(data);
        assertTrue(success);
        uint256 output = abi.decode(result, (uint256));
        if (n >= 0) {
            assertEq(output, uint256(n));
        } else {
            assertEq(output, uint256(-n));
        }
    }

    /**
     * Tests for diff(int256, int256)
     */
    function test_diff_int256_a_larger() public {
        assertEq(diff(int256(10), int256(5)), uint256(5));
    }

    function test_diff_int256_b_larger() public {
        assertEq(diff(int256(5), int256(10)), uint256(5));
    }

    function test_diff_int256_equal() public {
        assertEq(diff(int256(7), int256(7)), uint256(0));
    }

    function test_diff_int256_negative_values() public {
        assertEq(diff(int256(-5), int256(-10)), uint256(5));
        assertEq(diff(int256(-10), int256(-5)), uint256(5));
    }

    function test_diff_int256_mixed_signs() public {
        assertEq(diff(int256(5), int256(-5)), uint256(10));
        assertEq(diff(int256(-5), int256(5)), uint256(10));
    }

    function test_diff_int256_zero() public {
        assertEq(diff(int256(0), int256(100)), uint256(100));
        assertEq(diff(int256(100), int256(0)), uint256(100));
        assertEq(diff(int256(0), int256(-100)), uint256(100));
        assertEq(diff(int256(-100), int256(0)), uint256(100));
    }

    function test_diff_int256_extreme_values() public {
        // Test with max and min values (avoiding overflow)
        assertEq(diff(type(int256).max, int256(0)), uint256(type(int256).max));
        assertEq(diff(int256(0), type(int256).max), uint256(type(int256).max));
    }

    function testFuzz_diff_int256(int256 a, int256 b) public {
        // Avoid overflow cases where the subtraction might overflow
        if (a >= 0 && b < 0) {
            vm.assume(a <= type(int256).max + b); // Avoid a - b overflow
        } else if (a < 0 && b >= 0) {
            vm.assume(b <= type(int256).max + a); // Avoid b - a overflow
        }
        
        uint256 result = diff(a, b);
        if (a >= b) {
            assertEq(result, uint256(a - b));
        } else {
            assertEq(result, uint256(b - a));
        }
    }

    /**
     * Tests for diff(uint256, uint256)
     */
    function test_diff_uint256_a_larger() public {
        assertEq(diff(uint256(10), uint256(5)), uint256(5));
    }

    function test_diff_uint256_b_larger() public {
        assertEq(diff(uint256(5), uint256(10)), uint256(5));
    }

    function test_diff_uint256_equal() public {
        assertEq(diff(uint256(7), uint256(7)), uint256(0));
    }

    function test_diff_uint256_zero() public {
        assertEq(diff(uint256(0), uint256(100)), uint256(100));
        assertEq(diff(uint256(100), uint256(0)), uint256(100));
    }

    function test_diff_uint256_max_values() public {
        assertEq(diff(type(uint256).max, uint256(0)), type(uint256).max);
        assertEq(diff(uint256(0), type(uint256).max), type(uint256).max);
        assertEq(diff(type(uint256).max, type(uint256).max - 1), uint256(1));
    }

    function testFuzz_diff_uint256(uint256 a, uint256 b) public {
        uint256 result = diff(a, b);
        if (a >= b) {
            assertEq(result, a - b);
        } else {
            assertEq(result, b - a);
        }
    }

    /**
     * Edge case tests
     */
    function test_edge_cases_boundary_values() public {
        // Test all non-ambiguous functions with boundary values
        assertEq(min(uint256(0), uint256(1)), uint256(0));
        assertEq(max(uint256(0), uint256(1)), uint256(1));
        assertEq(max(int256(-1), int256(0)), int256(0));
        assertEq(diff(int256(-1), int256(1)), uint256(2));
        assertEq(diff(uint256(0), uint256(1)), uint256(1));

        // Test abs functions using low-level calls
        bytes memory data128 = abi.encodeWithSelector(bytes4(keccak256("abs(int128)")), int128(-1));
        (bool success128, bytes memory result128) = address(this).call(data128);
        assertTrue(success128);
        int128 output128 = abi.decode(result128, (int128));
        assertEq(output128, int128(1));

        bytes memory data256 = abi.encodeWithSelector(bytes4(keccak256("abs(int256)")), int256(-1));
        (bool success256, bytes memory result256) = address(this).call(data256);
        assertTrue(success256);
        uint256 output256 = abi.decode(result256, (uint256));
        assertEq(output256, uint256(1));
    }
}