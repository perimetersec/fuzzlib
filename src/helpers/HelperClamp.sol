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
        return clampLt(a, b);
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
     * @dev Clamps unsigned integer value to be between low and high bounds (inclusive) with optional logging.
     * @param value The value to clamp
     * @param low The minimum bound (inclusive)
     * @param high The maximum bound (inclusive)
     * @param enableLogs Whether to emit Clamped events
     * @return The clamped value
     */
    function clamp(uint256 value, uint256 low, uint256 high, bool enableLogs) public returns (uint256) {
        if (value < low || value > high) {
            uint256 ans = low + (value % (high - low + 1));
            if (enableLogs) logClamp(value, ans);
            return ans;
        }
        return value;
    }

    /**
     * @dev Clamps signed integer value to be between low and high bounds (inclusive) with optional logging.
     * @param value The value to clamp
     * @param low The minimum bound (inclusive)
     * @param high The maximum bound (inclusive)
     * @param enableLogs Whether to emit Clamped events
     * @return The clamped value
     */
    function clamp(int256 value, int256 low, int256 high, bool enableLogs) public returns (int256) {
        if (value < low || value > high) {
            int256 range = high - low + 1;
            int256 clamped = (value - low) % (range);
            if (clamped < 0) clamped += range;
            int256 ans = low + clamped;
            if (enableLogs) logClamp(value, ans);
            return ans;
        }
        return value;
    }

    /**
     * @dev Clamps unsigned integer to be less than specified value with optional logging.
     */
    function clampLt(uint256 a, uint256 b, bool enableLogs) public returns (uint256) {
        if (!(a < b)) {
            neq(b, 0, "clampLt cannot clamp value a to be less than zero. Check your inputs/assumptions.");
            uint256 value = a % b;
            if (enableLogs) logClamp(a, value);
            return value;
        }
        return a;
    }

    /**
     * @dev Clamps signed integer to be less than specified value with optional logging.
     */
    function clampLt(int256 a, int256 b, bool enableLogs) public returns (int256) {
        if (!(a < b)) {
            int256 value = b - 1;
            if (enableLogs) logClamp(a, value);
            return value;
        }
        return a;
    }

    /**
     * @dev Clamps unsigned integer to be less than or equal to specified value with optional logging.
     */
    function clampLte(uint256 a, uint256 b, bool enableLogs) public returns (uint256) {
        if (!(a <= b)) {
            uint256 value = a % (b + 1);
            if (enableLogs) logClamp(a, value);
            return value;
        }
        return a;
    }

    /**
     * @dev Clamps signed integer to be less than or equal to specified value with optional logging.
     */
    function clampLte(int256 a, int256 b, bool enableLogs) public returns (int256) {
        if (!(a <= b)) {
            int256 value = b;
            if (enableLogs) logClamp(a, value);
            return value;
        }
        return a;
    }

    /**
     * @dev Clamps unsigned integer to be greater than specified value with optional logging.
     */
    function clampGt(uint256 a, uint256 b, bool enableLogs) public returns (uint256) {
        if (!(a > b)) {
            neq(
                b,
                type(uint256).max,
                "clampGt cannot clamp value a to be larger than uint256.max. Check your inputs/assumptions."
            );
            uint256 value = b + 1;
            if (enableLogs) logClamp(a, value);
            return value;
        } else {
            return a;
        }
    }

    /**
     * @dev Clamps signed integer to be greater than specified value with optional logging.
     */
    function clampGt(int256 a, int256 b, bool enableLogs) public returns (int256) {
        if (!(a > b)) {
            int256 value = b + 1;
            if (enableLogs) logClamp(a, value);
            return value;
        } else {
            return a;
        }
    }

    /**
     * @dev Clamps unsigned integer to be greater than or equal to specified value with optional logging.
     */
    function clampGte(uint256 a, uint256 b, bool enableLogs) public returns (uint256) {
        if (!(a > b)) {
            uint256 value = b;
            if (enableLogs) logClamp(a, value);
            return value;
        }
        return a;
    }

    /**
     * @dev Clamps signed integer to be greater than or equal to specified value with optional logging.
     */
    function clampGte(int256 a, int256 b, bool enableLogs) public returns (int256) {
        if (!(a > b)) {
            int256 value = b;
            if (enableLogs) logClamp(a, value);
            return value;
        }
        return a;
    }

    /*
     **************************************************************************
     * Private Helper Functions
     **************************************************************************
     */

    function logClamp(
        uint256 value,
        uint256 ans
    ) private {
        emit Clamped(string(abi.encodePacked(
            "Clamping value ",
            FuzzLibString.toString(value),
            " to ",
            FuzzLibString.toString(ans)
        )));
    }

    function logClamp(
        int256 value,
        int256 ans
    ) private {
        emit Clamped(string(abi.encodePacked(
            "Clamping value ",
            FuzzLibString.toString(value),
            " to ",
            FuzzLibString.toString(ans)
        )));
    }
}
