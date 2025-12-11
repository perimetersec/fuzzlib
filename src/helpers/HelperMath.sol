// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

/**
 * @dev Mathematical utility functions for fuzzing operations.
 * @author Perimeter <info@perimetersec.io>
 */
abstract contract HelperMath {
    /**
     * @dev Returns the smallest of two unsigned numbers.
     */
    function min(uint256 a, uint256 b) public pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the largest of two unsigned numbers.
     */
    function max(uint256 a, uint256 b) public pure returns (uint256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the largest of two signed numbers.
     */
    function max(int256 a, int256 b) public pure returns (int256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the absolute value of a signed 128-bit integer.
     */
    function abs(int128 n) public pure returns (int128) {
        return n >= 0 ? n : -n;
    }

    /**
     * @dev Returns the absolute unsigned value of a signed value.
     */
    function abs(int256 n) public pure returns (uint256) {
        return n >= 0 ? uint256(n) : uint256(-n);
    }

    /**
     * @dev Returns the absolute difference between two signed integers.
     * The result is returned as an unsigned integer.
     */
    function diff(int256 a, int256 b) public pure returns (uint256) {
        return a >= b ? uint256(a - b) : uint256(b - a);
    }

    /**
     * @dev Returns the absolute difference between two unsigned integers.
     */
    function diff(uint256 a, uint256 b) public pure returns (uint256) {
        return a >= b ? a - b : b - a;
    }

    /**
     * @dev Scales an amount by the given number of decimals.
     * @param amount The amount to scale
     * @param decimals The number of decimals to scale by
     */
    function scale(uint256 amount, uint256 decimals) public pure returns (uint256) {
        return amount * (10 ** decimals);
    }
}
