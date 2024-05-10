// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Constants {
    // https://docs.soliditylang.org/en/latest/control-structures.html#panic-via-assert-and-error-via-require
    // 0x00: Used for generic compiler inserted panics.
    // 0x01: If you call assert with an argument that evaluates to false.
    // 0x11: If an arithmetic operation results in underflow or overflow outside of an unchecked { ... } block.
    // 0x12; If you divide or modulo by zero (e.g. 5 / 0 or 23 % 0).
    // 0x21: If you convert a value that is too big or negative into an enum type.
    // 0x22: If you access a storage byte array that is incorrectly encoded.
    // 0x31: If you call .pop() on an empty array.
    // 0x32: If you access an array, bytesN or an array slice at an out-of-bounds or negative index (i.e. x[i] where i >= x.length or i < 0).
    // 0x41: If you allocate too much memory or create an array that is too large.
    // 0x51: If you call a zero-initialized variable of internal function type.
    uint256 public constant PANIC_GENERAL = 0x00;
    uint256 public constant PANIC_ASSERT = 0x01;
    uint256 public constant PANIC_ARITHMETIC = 0x11;
    uint256 public constant PANIC_DIVISION_BY_ZERO = 0x12;
    uint256 public constant PANIC_ENUM_OUT_OF_BOUNDS = 0x21;
    uint256 public constant PANIC_STORAGE_BYTES_ARRAY_ENCODING = 0x22;
    uint256 public constant PANIC_POP_EMPTY_ARRAY = 0x31;
    uint256 public constant PANIC_ARRAY_OUT_OF_BOUNDS = 0x32;
    uint256 public constant PANIC_ALLOC_TOO_MUCH_MEMORY = 0x41;
    uint256 public constant PANIC_ZERO_INIT_INTERNAL_FUNCTION = 0x51;

    address public constant ADDRESS_CHEATS =
        0x7109709ECfa91a80626fF3989D68f67F5b1DD12D;
}
