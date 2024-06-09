// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract HelperMath {
    function min(uint256 a, uint256 b) public pure returns (uint256) {
        return a < b ? a : b;
    }

    function max(uint256 a, uint256 b) public pure returns (uint256) {
        return a > b ? a : b;
    }

    // Forked from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.0/contracts/utils/math/SignedMath.sol
    function max(int256 a, int256 b) public pure returns (int256) {
        return a > b ? a : b;
    }

    // Forked with modifications from https://ethereum.stackexchange.com/a/84391
    function abs(int128 n) public pure returns (int128) {
        return n >= 0 ? n : -n;
    }

    function abs(int256 n) public pure returns (uint256) {
        return n >= 0 ? uint256(n) : uint256(-n);
    }

    function diff(int256 a, int256 b) public pure returns (uint256) {
        return a >= b ? uint256(a - b) : uint256(b - a);
    }

    function diff(uint256 a, uint256 b) public pure returns (uint256) {
        return a >= b ? a - b : b - a;
    }
}
