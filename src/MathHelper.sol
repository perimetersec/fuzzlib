// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract MathHelper {
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}
