// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../FuzzLibString.sol";
import "./HelperAssert.sol";

/**
 * @dev Value clamping and bounds checking utilities for fuzzing operations.
 * @author Perimeter <info@perimetersec.io>
 * Based on Crytic PropertiesHelper (https://github.com/crytic/properties/blob/main/contracts/util/PropertiesHelper.sol)
 */
abstract contract HelperClamp is HelperAssert {
    event Clamped(string);

    /*
     **************************************************************************
     * Clamp functions with logging enabled
     **************************************************************************
     */

    /**
     * @dev Clamps unsigned integer value to be between low and high bounds (inclusive).
     * @param value The value to clamp
     * @param low The minimum bound (inclusive)
     * @param high The maximum bound (inclusive)
     * @return The clamped value
     */
    function clamp(uint256 value, uint256 low, uint256 high) public returns (uint256) {
        return clamp(value, low, high, true);
    }

    /**
     * @dev Clamps signed integer value to be between low and high bounds (inclusive).
     * @param value The value to clamp
     * @param low The minimum bound (inclusive)
     * @param high The maximum bound (inclusive)
     * @return The clamped value
     */
    function clamp(int256 value, int256 low, int256 high) public returns (int256) {
        return clamp(value, low, high, true);
    }

    /**
     * @dev Clamps unsigned integer to be less than specified value.
     */
    function clampLt(uint256 a, uint256 b) public returns (uint256) {
        return clampLt(a, b, true);
    }

    /**
     * @dev Clamps signed integer to be less than specified value.
     */
    function clampLt(int256 a, int256 b) public returns (int256) {
        return clampLt(a, b, true);
    }

    /**
     * @dev Clamps unsigned integer to be less than or equal to specified value.
     */
    function clampLte(uint256 a, uint256 b) public returns (uint256) {
        return clampLte(a, b, true);
    }

    /**
     * @dev Clamps signed integer to be less than or equal to specified value.
     */
    function clampLte(int256 a, int256 b) public returns (int256) {
        return clampLte(a, b, true);
    }

    /**
     * @dev Clamps unsigned integer to be greater than specified value.
     */
    function clampGt(uint256 a, uint256 b) public returns (uint256) {
        return clampGt(a, b, true);
    }

    /**
     * @dev Clamps signed integer to be greater than specified value.
     */
    function clampGt(int256 a, int256 b) public returns (int256) {
        return clampGt(a, b, true);
    }

    /**
     * @dev Clamps unsigned integer to be greater than or equal to specified value.
     */
    function clampGte(uint256 a, uint256 b) public returns (uint256) {
        return clampGte(a, b, true);
    }

    /**
     * @dev Clamps signed integer to be greater than or equal to specified value.
     */
    function clampGte(int256 a, int256 b) public returns (int256) {
        return clampGte(a, b, true);
    }

    /*
     **************************************************************************
     * Clamp functions with optional logging
     **************************************************************************
     */

    /**
     * @dev Clamps unsigned integer value to be between low and high bounds using modular arithmetic.
     *
     * Unlike traditional clamping that uses min/max (which can bias toward boundaries), this function
     * wraps out-of-range values cyclically through the target range. This provides uniform distribution
     * across the entire range when used with random input values.
     *
     * Examples:
     * - clamp(5, 0, 10) → 5 (already in range)
     * - clamp(15, 0, 10) → 4 (wraps around)
     * - clamp(25, 10, 20) → 13 (wraps around)
     * - clamp(100, 5, 5) → 5 (single-value range)
     *
     * @param value The value to clamp
     * @param low The minimum bound (inclusive)
     * @param high The maximum bound (inclusive)
     * @param enableLogs Whether to emit Clamped events when value is adjusted
     * @return The clamped value, guaranteed to be in range [low, high]
     */
    function clamp(uint256 value, uint256 low, uint256 high, bool enableLogs) public returns (uint256) {
        // Input validation: Ensure low <= high to prevent overflow
        // Without this check, (high - low + 1) could wrap around if low > high
        require(low <= high, "HelperClamp: invalid range");

        // Return values already in range without modification.
        // This optimization also handles the full uint256 range [0, type(uint256).max]
        // where every possible value would pass this check
        if (value >= low && value <= high) {
            return value; // Already in range - no clamping or logging needed
        }

        // At this point: value is outside [low, high] and needs wrapping
        uint256 ans;

        if (low == high) {
            // Edge case: Single-value range - everything maps to the same value
            // Avoids potential division by zero in modulo calculation
            ans = low;
        } else {
            // Main algorithm: Wrap out-of-range values using modular arithmetic
            //
            // The formula: ans = low + (value % range_size)
            // Where range_size = (high - low + 1) = total valid values in range
            //
            // Example:
            // clamp(17, 5, 9) with range [5,6,7,8,9] (size=5)
            // → 17 % 5 = 2, so 5 + 2 = 7 ✓ (wraps to position 2 in range)
            ans = low + (value % (high - low + 1));
        }

        // Optional logging: Record when values were actually clamped
        if (enableLogs) {
            logClamp(value, ans);
        }

        return ans;
    }

    /**
     * @dev Clamps signed integer value to be between low and high bounds using modular arithmetic.
     *
     * Unlike traditional clamping that uses min/max (which can bias toward boundaries), this function
     * wraps out-of-range values cyclically through the target range. This provides uniform distribution
     * across the entire range when used with random input values.
     *
     * Examples:
     * - clamp(5, -10, 10) → 5 (already in range)
     * - clamp(-1234, -123, 123) → -121 (wraps around)
     * - clamp(1000, -5, 5) → 5 (wraps around)
     * - clamp(-50, 10, 20) → 15 (wraps around)
     * - clamp(100, 5, 5) → 5 (single-value range)
     *
     * @param value The value to clamp
     * @param low The minimum bound (inclusive)
     * @param high The maximum bound (inclusive)
     * @param enableLogs Whether to emit Clamped events when value is adjusted
     * @return The clamped value, guaranteed to be in range [low, high]
     */
    function clamp(int256 value, int256 low, int256 high, bool enableLogs) public returns (int256) {
        // Input validation: Ensure low <= high to prevent overflow
        // This is especially critical for signed integers where range calculation
        // can overflow more easily (e.g., type(int256).min to type(int256).max)
        require(low <= high, "HelperClamp: invalid range");

        // Return values already in range without modification.
        // This optimization also handles the full int256 range case where
        // every possible value would pass this check
        if (value >= low && value <= high) {
            return value; // Already in range - no clamping or logging needed
        }

        // At this point: value is outside [low, high] and needs wrapping
        int256 ans;

        if (low == high) {
            // Single-value range: everything maps to the same value
            // Avoids potential division by zero in modulo calculation
            ans = low;
        } else {
            // Main algorithm: Wrap out-of-range values using modular arithmetic
            // More complex than uint256 because we must handle negative remainders
            //
            // The formula: ans = low + (offset % range_size)
            // Where range_size = (high - low + 1) = total valid values in range
            //
            // Key difference: Solidity's % can return negative values for signed integers,
            // so we must convert negative offsets to positive equivalents because we're
            // adding the offset to `low` and need the result to stay within [low, high].
            //
            // Examples:
            // clamp(-50, 10, 20) with range [10,11,12,13,14,15,16,17,18,19,20] (size=11)
            // → -50 % 11 = -6, then -6 + 11 = 5, so 10 + 5 = 15 ✓
            //
            // clamp(-25, -10, 5) with range [-10,-9,-8,...,3,4,5] (size=16)
            // → -25 % 16 = -9, then -9 + 16 = 7, so -10 + 7 = -3 ✓
            int256 range = high - low + 1;
            int256 offset = value % range;
            if (offset < 0) {
                offset += range; // Convert negative remainder to positive equivalent
            }
            ans = low + offset;
        }

        // Optional logging: Record when values were actually clamped
        if (enableLogs) {
            logClamp(value, ans);
        }

        return ans;
    }

    /**
     * @dev Clamps unsigned integer to be less than specified value with optional logging.
     */
    function clampLt(uint256 a, uint256 b, bool enableLogs) public returns (uint256) {
        require(b > 0, "HelperClamp: clampLt requires b > 0");
        return clamp(a, 0, b - 1, enableLogs);
    }

    /**
     * @dev Clamps signed integer to be less than specified value with optional logging.
     */
    function clampLt(int256 a, int256 b, bool enableLogs) public returns (int256) {
        require(b > type(int256).min, "HelperClamp: clampLt would underflow");
        return clamp(a, type(int256).min, b - 1, enableLogs);
    }

    /**
     * @dev Clamps unsigned integer to be less than or equal to specified value with optional logging.
     */
    function clampLte(uint256 a, uint256 b, bool enableLogs) public returns (uint256) {
        return clamp(a, 0, b, enableLogs);
    }

    /**
     * @dev Clamps signed integer to be less than or equal to specified value with optional logging.
     */
    function clampLte(int256 a, int256 b, bool enableLogs) public returns (int256) {
        return clamp(a, type(int256).min, b, enableLogs);
    }

    /**
     * @dev Clamps unsigned integer to be greater than specified value with optional logging.
     */
    function clampGt(uint256 a, uint256 b, bool enableLogs) public returns (uint256) {
        require(b < type(uint256).max, "HelperClamp: clampGt would overflow");
        return clamp(a, b + 1, type(uint256).max, enableLogs);
    }

    /**
     * @dev Clamps signed integer to be greater than specified value with optional logging.
     */
    function clampGt(int256 a, int256 b, bool enableLogs) public returns (int256) {
        require(b < type(int256).max, "HelperClamp: clampGt would overflow");
        return clamp(a, b + 1, type(int256).max, enableLogs);
    }

    /**
     * @dev Clamps unsigned integer to be greater than or equal to specified value with optional logging.
     */
    function clampGte(uint256 a, uint256 b, bool enableLogs) public returns (uint256) {
        return clamp(a, b, type(uint256).max, enableLogs);
    }

    /**
     * @dev Clamps signed integer to be greater than or equal to specified value with optional logging.
     */
    function clampGte(int256 a, int256 b, bool enableLogs) public returns (int256) {
        return clamp(a, b, type(int256).max, enableLogs);
    }

    /*
     **************************************************************************
     * Private Helper Functions
     **************************************************************************
     */

    function logClamp(uint256 value, uint256 ans) private {
        emit Clamped(
            string(
                abi.encodePacked("Clamping value ", FuzzLibString.toString(value), " to ", FuzzLibString.toString(ans))
            )
        );
    }

    function logClamp(int256 value, int256 ans) private {
        emit Clamped(
            string(
                abi.encodePacked("Clamping value ", FuzzLibString.toString(value), " to ", FuzzLibString.toString(ans))
            )
        );
    }
}
