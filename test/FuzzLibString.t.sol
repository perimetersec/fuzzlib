// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {FuzzLibString} from "../src/FuzzLibString.sol";

/**
 * @dev Tests for FuzzLibString library functions.
 * @author Perimeter <info@perimetersec.io>
 */
contract FuzzLibStringTest is Test {
    using FuzzLibString for uint256;
    using FuzzLibString for int256;
    using FuzzLibString for address;
    using FuzzLibString for bytes;

    /**
     * Tests for toString(int256)
     */
    function test_toString_int256_zero() public {
        assertEq(FuzzLibString.toString(int256(0)), "0");
    }

    function test_toString_int256_positive() public {
        assertEq(FuzzLibString.toString(int256(42)), "42");
        assertEq(FuzzLibString.toString(int256(1)), "1");
        assertEq(FuzzLibString.toString(int256(123_456_789)), "123456789");
    }

    function test_toString_int256_negative() public {
        assertEq(FuzzLibString.toString(int256(-1)), "-1");
        assertEq(FuzzLibString.toString(int256(-42)), "-42");
        assertEq(FuzzLibString.toString(int256(-123_456_789)), "-123456789");
    }

    function test_toString_int256_max() public {
        assertEq(
            FuzzLibString.toString(type(int256).max),
            "57896044618658097711785492504343953926634992332820282019728792003956564819967"
        );
    }

    function test_toString_int256_min() public {
        assertEq(
            FuzzLibString.toString(type(int256).min),
            "-57896044618658097711785492504343953926634992332820282019728792003956564819968"
        );
    }

    function test_toString_int256_edge_cases() public {
        assertEq(FuzzLibString.toString(int256(-1)), "-1");
        assertEq(FuzzLibString.toString(int256(1)), "1");

        int256 largePositive = type(int256).max - 1;
        string memory result = FuzzLibString.toString(largePositive);
        assertTrue(bytes(result).length > 0);

        int256 largeNegative = type(int256).min + 1;
        result = FuzzLibString.toString(largeNegative);
        assertTrue(bytes(result).length > 0);
        assertEq(bytes(result)[0], bytes1("-"));
    }

    function testFuzz_toString_int256(int256 value) public {
        string memory result = FuzzLibString.toString(value);
        assertTrue(bytes(result).length > 0);

        if (value < 0) {
            assertEq(bytes(result)[0], bytes1("-"));
        } else {
            assertTrue(bytes(result)[0] >= bytes1("0") && bytes(result)[0] <= bytes1("9"));
        }
    }

    /**
     * Tests for toString(uint256)
     */
    function test_toString_uint256_zero() public {
        assertEq(FuzzLibString.toString(uint256(0)), "0");
    }

    function test_toString_uint256_single_digit() public {
        assertEq(FuzzLibString.toString(uint256(1)), "1");
        assertEq(FuzzLibString.toString(uint256(5)), "5");
        assertEq(FuzzLibString.toString(uint256(9)), "9");
    }

    function test_toString_uint256_multi_digit() public {
        assertEq(FuzzLibString.toString(uint256(42)), "42");
        assertEq(FuzzLibString.toString(uint256(123)), "123");
        assertEq(FuzzLibString.toString(uint256(123_456_789)), "123456789");
    }

    function test_toString_uint256_max() public {
        assertEq(
            FuzzLibString.toString(type(uint256).max),
            "115792089237316195423570985008687907853269984665640564039457584007913129639935"
        );
        assertEq(
            FuzzLibString.toString(type(uint256).max - 1),
            "115792089237316195423570985008687907853269984665640564039457584007913129639934"
        );
    }

    function test_toString_uint256_powers_of_ten() public {
        assertEq(FuzzLibString.toString(uint256(10)), "10");
        assertEq(FuzzLibString.toString(uint256(100)), "100");
        assertEq(FuzzLibString.toString(uint256(1000)), "1000");
        assertEq(FuzzLibString.toString(uint256(10_000)), "10000");
    }

    function testFuzz_toString_uint256(uint256 value) public {
        string memory result = FuzzLibString.toString(value);
        assertTrue(bytes(result).length > 0);

        bytes memory resultBytes = bytes(result);
        for (uint256 i = 0; i < resultBytes.length; i++) {
            assertTrue(resultBytes[i] >= bytes1("0") && resultBytes[i] <= bytes1("9"));
        }
    }

    /**
     * Tests for toString(address)
     */
    function test_toString_address_zero() public {
        assertEq(FuzzLibString.toString(address(0)), "0000000000000000000000000000000000000000");
    }

    function test_toString_address_max() public {
        assertEq(FuzzLibString.toString(address(type(uint160).max)), "ffffffffffffffffffffffffffffffffffffffff");
    }

    function test_toString_address_specific() public {
        assertEq(
            FuzzLibString.toString(address(0x1234567890AbcdEF1234567890aBcdef12345678)),
            "1234567890abcdef1234567890abcdef12345678"
        );
    }

    function test_toString_address_length() public {
        string memory result = FuzzLibString.toString(address(0x1234567890AbcdEF1234567890aBcdef12345678));
        assertEq(bytes(result).length, 40);
    }

    function testFuzz_toString_address(address value) public {
        string memory result = FuzzLibString.toString(value);
        assertEq(bytes(result).length, 40);

        bytes memory resultBytes = bytes(result);
        for (uint256 i = 0; i < resultBytes.length; i++) {
            assertTrue(
                (resultBytes[i] >= bytes1("0") && resultBytes[i] <= bytes1("9"))
                    || (resultBytes[i] >= bytes1("a") && resultBytes[i] <= bytes1("f"))
            );
        }
    }

    /**
     * Tests for char(bytes1)
     */
    function test_char_digits() public {
        assertEq(FuzzLibString.char(bytes1(uint8(0))), bytes1("0"));
        assertEq(FuzzLibString.char(bytes1(uint8(1))), bytes1("1"));
        assertEq(FuzzLibString.char(bytes1(uint8(9))), bytes1("9"));
    }

    function test_char_hex_letters() public {
        assertEq(FuzzLibString.char(bytes1(uint8(10))), bytes1("a"));
        assertEq(FuzzLibString.char(bytes1(uint8(11))), bytes1("b"));
        assertEq(FuzzLibString.char(bytes1(uint8(15))), bytes1("f"));
    }

    function testFuzz_char(uint8 value) public {
        vm.assume(value < 16); // Only test valid hex digits (0-15)
        bytes1 result = FuzzLibString.char(bytes1(value));

        if (value < 10) {
            // Digits 0-9 should map to ASCII '0'-'9' (add 0x30)
            assertEq(result, bytes1(uint8(value) + 0x30));
        } else {
            // Values 10-15 should map to ASCII 'a'-'f' (add 0x57)
            assertEq(result, bytes1(uint8(value) + 0x57));
        }
    }

    /**
     * Tests for toHexString(bytes)
     */
    function test_toHexString_empty() public {
        assertEq(FuzzLibString.toHexString(bytes("")), "0x");
    }

    function test_toHexString_single_byte() public {
        assertEq(FuzzLibString.toHexString(bytes(hex"00")), "0x00");
        assertEq(FuzzLibString.toHexString(bytes(hex"ff")), "0xff");
        assertEq(FuzzLibString.toHexString(bytes(hex"42")), "0x42");
    }

    function test_toHexString_multi_byte() public {
        assertEq(FuzzLibString.toHexString(bytes(hex"deadbeef")), "0xdeadbeef");
        assertEq(FuzzLibString.toHexString(bytes(hex"1234567890abcdef")), "0x1234567890abcdef");
    }

    function test_toHexString_all_zeros() public {
        assertEq(FuzzLibString.toHexString(bytes(hex"0000")), "0x0000");
        assertEq(FuzzLibString.toHexString(bytes(hex"000000")), "0x000000");
    }

    function test_toHexString_all_ones() public {
        assertEq(FuzzLibString.toHexString(bytes(hex"ffff")), "0xffff");
        assertEq(FuzzLibString.toHexString(bytes(hex"ffffff")), "0xffffff");
    }

    function test_toHexString_max_bytes() public {
        bytes memory maxBytes = new bytes(32);
        for (uint256 i = 0; i < 32; i++) {
            maxBytes[i] = bytes1(uint8(255));
        }
        string memory result = FuzzLibString.toHexString(maxBytes);
        assertEq(result, "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }

    function testFuzz_toHexString(bytes memory value) public {
        string memory result = FuzzLibString.toHexString(value);

        // Result must always start with "0x"
        assertTrue(bytes(result).length >= 2);
        assertEq(bytes(result)[0], bytes1("0"));
        assertEq(bytes(result)[1], bytes1("x"));

        // Length should be 2 (for "0x") + 2 chars per input byte
        assertEq(bytes(result).length, 2 + 2 * value.length);

        // All characters after "0x" must be valid hex digits (0-9, a-f)
        for (uint256 i = 2; i < bytes(result).length; i++) {
            assertTrue(
                (bytes(result)[i] >= bytes1("0") && bytes(result)[i] <= bytes1("9"))
                    || (bytes(result)[i] >= bytes1("a") && bytes(result)[i] <= bytes1("f"))
            );
        }
    }

    /**
     * Tests for getRevertMsg(bytes)
     */
    function test_getRevertMsg_short_data() public {
        assertEq(FuzzLibString.getRevertMsg(bytes("")), "Transaction reverted silently");
        assertEq(FuzzLibString.getRevertMsg(bytes("short")), "Transaction reverted silently");
    }

    function test_getRevertMsg_panic_code_17() public {
        bytes4 panicSignature = bytes4(keccak256(bytes("Panic(uint256)")));
        bytes memory panicData = abi.encodePacked(panicSignature, uint256(17));
        assertEq(FuzzLibString.getRevertMsg(panicData), "Panic(17)");
    }

    function test_getRevertMsg_unknown_panic_code() public {
        bytes4 panicSignature = bytes4(keccak256(bytes("Panic(uint256)")));
        bytes memory panicData = abi.encodePacked(panicSignature, uint256(42));
        assertEq(FuzzLibString.getRevertMsg(panicData), "Undefined panic code");
    }

    function test_getRevertMsg_undefined_signature() public {
        bytes4 wrongSignature = bytes4(keccak256(bytes("WrongSignature(uint256)")));
        bytes memory wrongData = abi.encodePacked(wrongSignature, uint256(17));
        assertEq(FuzzLibString.getRevertMsg(wrongData), "Undefined signature");
    }

    function test_getRevertMsg_regular_revert() public {
        string memory revertMessage = "Custom revert message";
        bytes memory revertData = abi.encodeWithSignature("Error(string)", revertMessage);
        assertEq(FuzzLibString.getRevertMsg(revertData), revertMessage);
    }

    function test_getRevertMsg_empty_string() public {
        bytes memory revertData = abi.encodeWithSignature("Error(string)", "");
        assertEq(FuzzLibString.getRevertMsg(revertData), "");
    }

    function testFuzz_getRevertMsg_regular_revert(string memory message) public {
        bytes memory revertData = abi.encodeWithSignature("Error(string)", message);
        assertEq(FuzzLibString.getRevertMsg(revertData), message);
    }

    /**
     * Tests for isRevertReasonEqual(bytes, string)
     */
    function test_isRevertReasonEqual_matching() public {
        string memory revertMessage = "Custom revert message";
        bytes memory revertData = abi.encodeWithSignature("Error(string)", revertMessage);
        assertTrue(FuzzLibString.isRevertReasonEqual(revertData, revertMessage));
    }

    function test_isRevertReasonEqual_not_matching() public {
        string memory revertMessage = "Custom revert message";
        bytes memory revertData = abi.encodeWithSignature("Error(string)", revertMessage);
        assertFalse(FuzzLibString.isRevertReasonEqual(revertData, "Different message"));
    }

    function test_isRevertReasonEqual_empty_strings() public {
        bytes memory revertData = abi.encodeWithSignature("Error(string)", "");
        assertTrue(FuzzLibString.isRevertReasonEqual(revertData, ""));
    }

    function test_isRevertReasonEqual_panic_code() public {
        bytes4 panicSignature = bytes4(keccak256(bytes("Panic(uint256)")));
        bytes memory panicData = abi.encodePacked(panicSignature, uint256(17));
        assertTrue(FuzzLibString.isRevertReasonEqual(panicData, "Panic(17)"));
        assertFalse(FuzzLibString.isRevertReasonEqual(panicData, "Panic(16)"));
    }

    function test_isRevertReasonEqual_silent_revert() public {
        bytes memory shortData = bytes("short");
        assertTrue(FuzzLibString.isRevertReasonEqual(shortData, "Transaction reverted silently"));
        assertFalse(FuzzLibString.isRevertReasonEqual(shortData, "Different message"));
    }

    function testFuzz_isRevertReasonEqual(string memory message) public {
        bytes memory revertData = abi.encodeWithSignature("Error(string)", message);
        assertTrue(FuzzLibString.isRevertReasonEqual(revertData, message));

        if (bytes(message).length > 0) {
            vm.assume(keccak256(bytes(message)) != keccak256(bytes("Different message")));
            assertFalse(FuzzLibString.isRevertReasonEqual(revertData, "Different message"));
        }
    }
}
