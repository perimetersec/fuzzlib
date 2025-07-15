// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import {HelperLog} from "../src/helpers/HelperLog.sol";
import {LibLog} from "../src/libraries/LibLog.sol";
import {HelperLogImplementation} from "./util/HelperLogImplementation.sol";

/**
 * @dev Tests for HelperLog logging functions.
 * @author Perimeter <info@perimetersec.io>
 */
contract TestHelperLog is Test {
    HelperLog private helperLog;

    function setUp() public {
        helperLog = new HelperLogImplementation();
    }

    // Helper functions to call overloaded log functions with explicit selectors
    function callLogString(string memory message) internal {
        (bool success,) = address(helperLog).call(abi.encodeWithSelector(bytes4(keccak256("log(string)")), message));
        assertTrue(success);
    }

    function callLogStringString(string memory message, string memory data) internal {
        (bool success,) =
            address(helperLog).call(abi.encodeWithSelector(bytes4(keccak256("log(string,string)")), message, data));
        assertTrue(success);
    }

    function callLogStringBytes(string memory message, bytes memory data) internal {
        (bool success,) =
            address(helperLog).call(abi.encodeWithSelector(bytes4(keccak256("log(string,bytes)")), message, data));
        assertTrue(success);
    }

    function callLogStringUint256(string memory message, uint256 data) internal {
        (bool success,) =
            address(helperLog).call(abi.encodeWithSelector(bytes4(keccak256("log(string,uint256)")), message, data));
        assertTrue(success);
    }

    function callLogStringInt256(string memory message, int256 data) internal {
        (bool success,) =
            address(helperLog).call(abi.encodeWithSelector(bytes4(keccak256("log(string,int256)")), message, data));
        assertTrue(success);
    }

    function callLogStringAddress(string memory message, address data) internal {
        (bool success,) =
            address(helperLog).call(abi.encodeWithSelector(bytes4(keccak256("log(string,address)")), message, data));
        assertTrue(success);
    }

    function callLogStringBool(string memory message, bool data) internal {
        (bool success,) =
            address(helperLog).call(abi.encodeWithSelector(bytes4(keccak256("log(string,bool)")), message, data));
        assertTrue(success);
    }

    function callLogStringBytes32(string memory message, bytes32 data) internal {
        (bool success,) =
            address(helperLog).call(abi.encodeWithSelector(bytes4(keccak256("log(string,bytes32)")), message, data));
        assertTrue(success);
    }

    function callLogFail() internal {
        (bool success,) = address(helperLog).call(abi.encodeWithSelector(bytes4(keccak256("logFail()"))));
        assertTrue(success);
    }

    function callLogFailString(string memory message) internal {
        (bool success,) = address(helperLog).call(abi.encodeWithSelector(bytes4(keccak256("logFail(string)")), message));
        assertTrue(success);
    }

    function callLogFailStringString(string memory message, string memory data) internal {
        (bool success,) =
            address(helperLog).call(abi.encodeWithSelector(bytes4(keccak256("logFail(string,string)")), message, data));
        assertTrue(success);
    }

    function callLogFailStringBytes(string memory message, bytes memory data) internal {
        (bool success,) =
            address(helperLog).call(abi.encodeWithSelector(bytes4(keccak256("logFail(string,bytes)")), message, data));
        assertTrue(success);
    }

    function callLogFailStringUint256(string memory message, uint256 data) internal {
        (bool success,) =
            address(helperLog).call(abi.encodeWithSelector(bytes4(keccak256("logFail(string,uint256)")), message, data));
        assertTrue(success);
    }

    function callLogFailStringInt256(string memory message, int256 data) internal {
        (bool success,) =
            address(helperLog).call(abi.encodeWithSelector(bytes4(keccak256("logFail(string,int256)")), message, data));
        assertTrue(success);
    }

    function callLogFailStringAddress(string memory message, address data) internal {
        (bool success,) =
            address(helperLog).call(abi.encodeWithSelector(bytes4(keccak256("logFail(string,address)")), message, data));
        assertTrue(success);
    }

    function callLogFailStringBool(string memory message, bool data) internal {
        (bool success,) =
            address(helperLog).call(abi.encodeWithSelector(bytes4(keccak256("logFail(string,bool)")), message, data));
        assertTrue(success);
    }

    function callLogFailStringBytes32(string memory message, bytes32 data) internal {
        (bool success,) =
            address(helperLog).call(abi.encodeWithSelector(bytes4(keccak256("logFail(string,bytes32)")), message, data));
        assertTrue(success);
    }

    /**
     * Tests for log(string)
     */
    function test_log_string_basic() public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.Log("Test message");
        callLogString("Test message");
    }

    function test_log_string_empty() public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.Log("");
        callLogString("");
    }

    function test_log_string_unicode() public {
        string memory unicodeMsg = unicode"Unicode test: 🚀 ⭐ 💎";
        vm.expectEmit(true, true, true, true);
        emit LibLog.Log(unicodeMsg);
        callLogString(unicodeMsg);
    }

    function testFuzz_log_string(string memory message) public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.Log(message);
        callLogString(message);
    }

    /**
     * Tests for log(string, string)
     */
    function test_log_string_string_basic() public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogString("Message", "Data");
        callLogStringString("Message", "Data");
    }

    function test_log_string_string_empty() public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogString("", "");
        callLogStringString("", "");
    }

    function testFuzz_log_string_string(string memory message, string memory data) public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogString(message, data);
        callLogStringString(message, data);
    }

    /**
     * Tests for log(string, bytes)
     */
    function test_log_string_bytes_basic() public {
        bytes memory data = hex"deadbeef";
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogBytes("Hex data", data);
        callLogStringBytes("Hex data", data);
    }

    function test_log_string_bytes_empty() public {
        bytes memory data = "";
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogBytes("Empty bytes", data);
        callLogStringBytes("Empty bytes", data);
    }

    function testFuzz_log_string_bytes(string memory message, bytes memory data) public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogBytes(message, data);
        callLogStringBytes(message, data);
    }

    /**
     * Tests for log(string, uint256)
     */
    function test_log_string_uint256_basic() public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogUint("Value", 42);
        callLogStringUint256("Value", 42);
    }

    function test_log_string_uint256_max() public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogUint("Max value", type(uint256).max);
        callLogStringUint256("Max value", type(uint256).max);
    }

    function testFuzz_log_string_uint256(string memory message, uint256 data) public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogUint(message, data);
        callLogStringUint256(message, data);
    }

    /**
     * Tests for log(string, int256)
     */
    function test_log_string_int256_positive() public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogInt("Positive", 42);
        callLogStringInt256("Positive", int256(42));
    }

    function test_log_string_int256_negative() public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogInt("Negative", -42);
        callLogStringInt256("Negative", int256(-42));
    }

    function test_log_string_int256_extremes() public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogInt("Max", type(int256).max);
        callLogStringInt256("Max", type(int256).max);

        vm.expectEmit(true, true, true, true);
        emit LibLog.LogInt("Min", type(int256).min);
        callLogStringInt256("Min", type(int256).min);
    }

    function testFuzz_log_string_int256(string memory message, int256 data) public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogInt(message, data);
        callLogStringInt256(message, data);
    }

    /**
     * Tests for log(string, address)
     */
    function test_log_string_address_basic() public {
        address addr = address(0x1234567890123456789012345678901234567890);
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogAddress("Address", addr);
        callLogStringAddress("Address", addr);
    }

    function test_log_string_address_zero() public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogAddress("Zero address", address(0));
        callLogStringAddress("Zero address", address(0));
    }

    function testFuzz_log_string_address(string memory message, address data) public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogAddress(message, data);
        callLogStringAddress(message, data);
    }

    /**
     * Tests for log(string, bool)
     */
    function test_log_string_bool_basic() public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogBool("True", true);
        callLogStringBool("True", true);

        vm.expectEmit(true, true, true, true);
        emit LibLog.LogBool("False", false);
        callLogStringBool("False", false);
    }

    function testFuzz_log_string_bool(string memory message, bool data) public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogBool(message, data);
        callLogStringBool(message, data);
    }

    /**
     * Tests for log(string, bytes32)
     */
    function test_log_string_bytes32_basic() public {
        bytes32 data = 0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef;
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogBytes32("Bytes32", data);
        callLogStringBytes32("Bytes32", data);
    }

    function test_log_string_bytes32_zero() public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogBytes32("Zero", bytes32(0));
        callLogStringBytes32("Zero", bytes32(0));
    }

    function testFuzz_log_string_bytes32(string memory message, bytes32 data) public {
        vm.expectEmit(true, true, true, true);
        emit LibLog.LogBytes32(message, data);
        callLogStringBytes32(message, data);
    }

    /**
     * Tests for logFail()
     */
    function test_logFail_basic() public {
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed();
        callLogFail();
    }

    /**
     * Tests for logFail(string)
     */
    function test_logFail_string_basic() public {
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed("Test failure");
        callLogFailString("Test failure");
    }

    function test_logFail_string_empty() public {
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed("");
        callLogFailString("");
    }

    function testFuzz_logFail_string(string memory message) public {
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed(message);
        callLogFailString(message);
    }

    /**
     * Tests for logFail(string, string)
     */
    function test_logFail_string_string_basic() public {
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed("Failure", string("Data"));
        callLogFailStringString("Failure", "Data");
    }

    function testFuzz_logFail_string_string(string memory message, string memory data) public {
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed(message, string(data));
        callLogFailStringString(message, data);
    }

    /**
     * Tests for logFail(string, bytes)
     */
    function test_logFail_string_bytes_basic() public {
        bytes memory data = hex"deadbeef";
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed("Bytes failure", bytes(data));
        callLogFailStringBytes("Bytes failure", data);
    }

    function testFuzz_logFail_string_bytes(string memory message, bytes memory data) public {
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed(message, bytes(data));
        callLogFailStringBytes(message, data);
    }

    /**
     * Tests for logFail(string, uint256)
     */
    function test_logFail_string_uint256_basic() public {
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed("Uint failure", uint256(42));
        callLogFailStringUint256("Uint failure", 42);
    }

    function testFuzz_logFail_string_uint256(string memory message, uint256 data) public {
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed(message, uint256(data));
        callLogFailStringUint256(message, data);
    }

    /**
     * Tests for logFail(string, int256)
     */
    function test_logFail_string_int256_basic() public {
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed("Int failure", int256(-42));
        callLogFailStringInt256("Int failure", int256(-42));
    }

    function testFuzz_logFail_string_int256(string memory message, int256 data) public {
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed(message, int256(data));
        callLogFailStringInt256(message, data);
    }

    /**
     * Tests for logFail(string, address)
     */
    function test_logFail_string_address_basic() public {
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed("Address failure", address(address(0)));
        callLogFailStringAddress("Address failure", address(0));
    }

    function testFuzz_logFail_string_address(string memory message, address data) public {
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed(message, address(data));
        callLogFailStringAddress(message, data);
    }

    /**
     * Tests for logFail(string, bool)
     */
    function test_logFail_string_bool_basic() public {
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed("Bool failure", bool(true));
        callLogFailStringBool("Bool failure", true);
    }

    function testFuzz_logFail_string_bool(string memory message, bool data) public {
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed(message, bool(data));
        callLogFailStringBool(message, data);
    }

    /**
     * Tests for logFail(string, bytes32)
     */
    function test_logFail_string_bytes32_basic() public {
        bytes32 data = 0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef;
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed("Bytes32 failure", bytes32(data));
        callLogFailStringBytes32("Bytes32 failure", data);
    }

    function testFuzz_logFail_string_bytes32(string memory message, bytes32 data) public {
        vm.expectEmit(true, true, true, true, address(helperLog));
        emit LibLog.AssertionFailed(message, bytes32(data));
        callLogFailStringBytes32(message, data);
    }
}
