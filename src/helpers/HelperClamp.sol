// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../FuzzLibString.sol";
import "./HelperAssert.sol";
import "../FuzzSafeCast.sol";

/**
 * @dev Value clamping and bounds checking utilities for fuzzing operations.
 * @author Perimeter <info@perimetersec.io>
 */
abstract contract HelperClamp is HelperAssert {
    error InvalidRange(uint256 low, uint256 high);
    error InvalidRangeInt128(int128 low, int128 high);
    error UnsupportedClampLtValue(uint256 value);
    error UnsupportedClampGtValue(uint256 value);

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
     * @param value The value to clamp
     * @param low The minimum bound (inclusive)
     * @param high The maximum bound (inclusive)
     * @param enableLogs Whether to emit Clamped events when value is adjusted
     * @return The clamped value, guaranteed to be in range [low, high]
     */
    function clamp(uint256 value, uint256 low, uint256 high, bool enableLogs) public returns (uint256) {
        // Input validation: Ensure low <= high to prevent overflow
        // Without this check, (high - low + 1) could wrap around if low > high
        if (low > high) revert InvalidRange(low, high);

        // Return values already in range without modification.
        // This optimization also handles the full uint256 range [0, type(uint256).max]
        // where every possible value would pass this check
        if (value >= low && value <= high) {
            return value;
        }

        // Wrap out-of-range values using modular arithmetic
        //
        // The formula: ans = low + (value % range_size)
        // Where range_size = (high - low + 1) = total valid values in range
        //
        // Example:
        // clamp(17, 5, 9) with range [5,6,7,8,9] (size=5)
        // → 17 % 5 = 2, so 5 + 2 = 7 ✓ (wraps to position 2 in range)
        uint256 ans = low + (value % (high - low + 1));

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
     * Note: Uses int128 instead of int256 to avoid potential overflow issues in range calculations
     * when computing (high - low + 1). The smaller type provides sufficient range for most fuzzing
     * scenarios while maintaining safe arithmetic operations.
     *
     * @param _value The value to clamp
     * @param _low The minimum bound (inclusive)
     * @param _high The maximum bound (inclusive)
     * @param enableLogs Whether to emit Clamped events when value is adjusted
     * @return The clamped value, guaranteed to be in range [low, high]
     */
    function clamp(int256 _value, int256 _low, int256 _high, bool enableLogs) public returns (int256) {
        // Cast all parameters to int128 using SafeCast for overflow protection
        int128 value = FuzzSafeCast.toInt128(_value);
        int128 low = FuzzSafeCast.toInt128(_low);
        int128 high = FuzzSafeCast.toInt128(_high);

        // Input validation: Ensure low <= high to prevent overflow
        if (low > high) revert InvalidRangeInt128(low, high);

        // Return values already in range without modification.
        if (value >= low && value <= high) {
            return int256(value);
        }

        // Wrap out-of-range values using modular arithmetic. Use int256 internally to
        // handle calculations safely.
        //
        // The formula: ans = low + (offset % range_size)
        // Where range_size = (high - low + 1) = total valid values in range
        //
        // Solidity's % can return negative values for signed integers, so we must
        // convert negative offsets to positive equivalents because we're adding
        // the offset to `low` and need the result to stay within [low, high].
        //
        // Examples:
        // clamp(-50, 10, 20) with range [10,11,12,...,18,19,20] (size=11)
        // → -50 % 11 = -6, then -6 + 11 = 5, so 10 + 5 = 15 ✓
        //
        // clamp(-25, -10, 5) with range [-10,-9,-8,...,3,4,5] (size=16)
        // → -25 % 16 = -9, then -9 + 16 = 7, so -10 + 7 = -3 ✓
        int256 range = int256(high) - int256(low) + 1;
        int256 offset = int256(value) % range;
        if (offset < 0) {
            offset += range;
        }
        int128 ans = int128(int256(low) + offset);

        // Optional logging: Record when values were actually clamped
        if (enableLogs) {
            logClamp(int256(value), int256(ans));
        }

        return int256(ans);
    }
    /**
     * @dev Clamps unsigned integer to be less than specified value with optional logging.
     */

    function clampLt(uint256 a, uint256 b, bool enableLogs) public returns (uint256) {
        if (b == 0) revert UnsupportedClampLtValue(b);
        return clamp(a, 0, b - 1, enableLogs);
    }

    /**
     * @dev Clamps signed integer to be less than specified value with optional logging.
     */
    function clampLt(int256 a, int256 b, bool enableLogs) public returns (int256) {
        if (b <= type(int128).min) revert UnsupportedClampLtValue(uint256(b));
        return clamp(a, int256(type(int128).min), b - 1, enableLogs);
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
        return clamp(a, type(int128).min, b, enableLogs);
    }

    /**
     * @dev Clamps unsigned integer to be greater than specified value with optional logging.
     */
    function clampGt(uint256 a, uint256 b, bool enableLogs) public returns (uint256) {
        if (b == type(uint256).max) revert UnsupportedClampGtValue(b);
        return clamp(a, b + 1, type(uint256).max, enableLogs);
    }

    /**
     * @dev Clamps signed integer to be greater than specified value with optional logging.
     */
    function clampGt(int256 a, int256 b, bool enableLogs) public returns (int256) {
        if (b >= type(int128).max) revert UnsupportedClampGtValue(uint256(b));
        return clamp(a, b + 1, type(int128).max, enableLogs);
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
        return clamp(a, b, type(int128).max, enableLogs);
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
