// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract MathHelper {
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
    
      // Forked from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.0/contracts/utils/math/SignedMath.sol
    function max(int256 a, int256 b) internal pure returns (int256) {
        return a > b ? a : b;
    }

    // Forked with modifications from https://ethereum.stackexchange.com/a/84391
    function abs(int128 n) internal pure returns (int128) {
        return n >= 0 ? n : -n;
    }
}
