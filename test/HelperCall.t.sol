// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {HelperCall} from "../src/helpers/HelperCall.sol";
import {CallTarget} from "./util/CallTarget.sol";

/**
 * @dev Comprehensive tests for HelperCall functionality including function call utilities,
 * actor management, static calls, and error handling.
 * @author Perimeter <info@perimetersec.io>
 */
contract TestHelperCall is Test, HelperCall {
    CallTarget target;
    address actor1;
    address actor2;

    function setUp() public {
        target = new CallTarget();
        actor1 = address(0x1111);
        actor2 = address(0x2222);
        vm.deal(address(this), 10 ether);
        vm.deal(actor1, 5 ether);
        vm.deal(actor2, 5 ether);
    }

    /**
     * Tests for doFunctionCall(address target, bytes memory callData) - Basic Functionality
     */
    function test_doFunctionCall_with_msg_sender_success() public {
        bytes memory callData = abi.encodeWithSignature("setValue(uint256)", 42);
        (bool success, bytes memory returnData) = this.doFunctionCall(address(target), callData);

        assertTrue(success);
        assertEq(returnData.length, 0); // setValue returns nothing
        assertEq(target.value(), 42);
        assertEq(target.lastCaller(), address(this));
    }

    function test_doFunctionCall_with_msg_sender_with_value() public {
        bytes memory callData = abi.encodeWithSignature("setValue(uint256)", 100);
        (bool success, bytes memory returnData) = this.doFunctionCall{value: 1 ether}(address(target), callData);

        assertTrue(success);
        assertEq(returnData.length, 0);
        assertEq(target.value(), 100);
        assertEq(target.lastCaller(), address(this));
        assertEq(target.lastValue(), 1 ether);
    }

    function test_doFunctionCall_with_msg_sender_return_data() public {
        bytes memory callData = abi.encodeWithSignature("returnMultiple()");
        (bool success, bytes memory returnData) = this.doFunctionCall(address(target), callData);

        assertTrue(success);
        (uint256 num, string memory str) = abi.decode(returnData, (uint256, string));
        assertEq(num, 42);
        assertEq(str, "test");
    }

    function test_doFunctionCall_with_msg_sender_view_function() public {
        // First set a value
        target.setValue(123);

        bytes memory callData = abi.encodeWithSignature("getValue()");
        (bool success, bytes memory returnData) = this.doFunctionCall(address(target), callData);

        assertTrue(success);
        uint256 result = abi.decode(returnData, (uint256));
        assertEq(result, 123);
    }

    /**
     * Tests for doFunctionCall(address target, bytes memory callData, address actor) - Actor Verification
     */
    function test_doFunctionCall_with_actor_success() public {
        bytes memory callData = abi.encodeWithSignature("setValue(uint256)", 77);
        (bool success, bytes memory returnData) = this.doFunctionCall(address(target), callData, actor1);

        assertTrue(success);
        assertEq(returnData.length, 0);
        assertEq(target.value(), 77);
        assertEq(target.lastCaller(), actor1);
    }

    function test_doFunctionCall_with_actor_with_value() public {
        bytes memory callData = abi.encodeWithSignature("setValue(uint256)", 200);
        (bool success, bytes memory returnData) = this.doFunctionCall{value: 2 ether}(address(target), callData, actor2);

        assertTrue(success);
        assertEq(returnData.length, 0);
        assertEq(target.value(), 200);
        assertEq(target.lastCaller(), actor2);
        assertEq(target.lastValue(), 2 ether);
    }

    function test_doFunctionCall_with_different_actors() public {
        bytes memory callData1 = abi.encodeWithSignature("setValue(uint256)", 111);
        bytes memory callData2 = abi.encodeWithSignature("setValue(uint256)", 222);

        // Call with actor1
        (bool success1,) = this.doFunctionCall(address(target), callData1, actor1);
        assertTrue(success1);
        assertEq(target.value(), 111);
        assertEq(target.lastCaller(), actor1);

        // Call with actor2
        (bool success2,) = this.doFunctionCall(address(target), callData2, actor2);
        assertTrue(success2);
        assertEq(target.value(), 222);
        assertEq(target.lastCaller(), actor2);
    }

    function test_doFunctionCall_with_zero_address_actor() public {
        bytes memory callData = abi.encodeWithSignature("setValue(uint256)", 333);
        (bool success, bytes memory returnData) = this.doFunctionCall(address(target), callData, address(0));

        assertTrue(success);
        assertEq(returnData.length, 0);
        assertEq(target.value(), 333);
        assertEq(target.lastCaller(), address(0));
    }

    /**
     * Tests for doFunctionStaticCall(address target, bytes memory callData) - Static Calls
     */
    function test_doFunctionStaticCall_success() public {
        // First set a value using regular call
        target.setValue(456);

        bytes memory callData = abi.encodeWithSignature("getValue()");
        (bool success, bytes memory returnData) = this.doFunctionStaticCall(address(target), callData);

        assertTrue(success);
        uint256 result = abi.decode(returnData, (uint256));
        assertEq(result, 456);
    }

    function test_doFunctionStaticCall_return_multiple() public {
        bytes memory callData = abi.encodeWithSignature("returnMultiple()");
        (bool success, bytes memory returnData) = this.doFunctionStaticCall(address(target), callData);

        assertTrue(success);
        (uint256 num, string memory str) = abi.decode(returnData, (uint256, string));
        assertEq(num, 42);
        assertEq(str, "test");
    }

    function test_doFunctionStaticCall_state_change_fails() public {
        bytes memory callData = abi.encodeWithSignature("setValue(uint256)", 999);
        (bool success,) = this.doFunctionStaticCall(address(target), callData);

        // Should fail because setValue tries to modify state
        assertFalse(success);
        // Original value should be unchanged
        assertEq(target.value(), 0);
    }

    /**
     * Tests for Error Handling
     */
    function test_doFunctionCall_revert_handling() public {
        bytes memory callData = abi.encodeWithSignature("revertingFunction()");
        (bool success, bytes memory returnData) = this.doFunctionCall(address(target), callData);

        assertFalse(success);
        // Should contain revert reason
        assertTrue(returnData.length > 0);
    }

    function test_doFunctionCall_revert_handling_with_actor() public {
        bytes memory callData = abi.encodeWithSignature("revertingFunction()");
        (bool success, bytes memory returnData) = this.doFunctionCall(address(target), callData, actor1);

        assertFalse(success);
        assertTrue(returnData.length > 0);
    }

    function test_doFunctionCall_require_fail_handling() public {
        bytes memory callData = abi.encodeWithSignature("requireFailFunction()");
        (bool success, bytes memory returnData) = this.doFunctionCall(address(target), callData);

        assertFalse(success);
        assertTrue(returnData.length > 0);
    }

    function test_doFunctionStaticCall_revert_handling() public {
        bytes memory callData = abi.encodeWithSignature("revertingFunction()");
        (bool success, bytes memory returnData) = this.doFunctionStaticCall(address(target), callData);

        assertFalse(success);
        assertTrue(returnData.length > 0);
    }

    function test_doFunctionStaticCall_require_fail_handling() public {
        bytes memory callData = abi.encodeWithSignature("requireFailFunction()");
        (bool success, bytes memory returnData) = this.doFunctionStaticCall(address(target), callData);

        assertFalse(success);
        assertTrue(returnData.length > 0);
    }

    /**
     * Tests for Edge Cases & Boundary Conditions
     */
    function test_doFunctionCall_empty_calldata() public {
        bytes memory callData = "";
        (bool success, bytes memory returnData) = this.doFunctionCall(address(target), callData);

        // Should fail because target doesn't have a fallback function
        assertFalse(success);
        assertEq(returnData.length, 0);
    }

    function test_doFunctionCall_invalid_function_signature() public {
        bytes memory callData = abi.encodeWithSignature("nonExistentFunction()");
        (bool success, bytes memory returnData) = this.doFunctionCall(address(target), callData);

        assertFalse(success);
        assertEq(returnData.length, 0);
    }

    function test_doFunctionCall_target_address_zero() public {
        bytes memory callData = abi.encodeWithSignature("setValue(uint256)", 123);
        (bool success, bytes memory returnData) = this.doFunctionCall(address(0), callData);

        // Calls to address(0) actually succeed in EVM but return empty data
        assertTrue(success);
        assertEq(returnData.length, 0);
    }

    function test_doFunctionCall_target_non_contract() public {
        address nonContract = address(0x9999);

        // Verify the address has no code deployed
        uint256 codeSize;
        assembly {
            codeSize := extcodesize(nonContract)
        }
        assertEq(codeSize, 0, "Test address should have no code");

        bytes memory callData = abi.encodeWithSignature("setValue(uint256)", 123);
        (bool success, bytes memory returnData) = this.doFunctionCall(nonContract, callData);

        // Calls to non-contract addresses succeed but return empty data
        assertTrue(success);
        assertEq(returnData.length, 0);
    }

    function test_doFunctionCall_maximum_value() public {
        vm.deal(address(this), type(uint256).max);
        bytes memory callData = abi.encodeWithSignature("setValue(uint256)", 777);

        (bool success,) = this.doFunctionCall{value: type(uint256).max}(address(target), callData);
        assertTrue(success);
        assertEq(target.value(), 777);
        assertEq(target.lastValue(), type(uint256).max);
    }

    function test_doFunctionStaticCall_empty_calldata() public {
        bytes memory callData = "";
        (bool success, bytes memory returnData) = this.doFunctionStaticCall(address(target), callData);

        assertFalse(success);
        assertEq(returnData.length, 0);
    }

    function test_doFunctionStaticCall_target_address_zero() public {
        bytes memory callData = abi.encodeWithSignature("getValue()");
        (bool success, bytes memory returnData) = this.doFunctionStaticCall(address(0), callData);

        // Static calls to address(0) also succeed but return empty data
        assertTrue(success);
        assertEq(returnData.length, 0);
    }

    function test_doFunctionStaticCall_target_non_contract() public {
        address nonContract = address(0x9999);

        // Verify the address has no code deployed
        uint256 codeSize;
        assembly {
            codeSize := extcodesize(nonContract)
        }
        assertEq(codeSize, 0, "Test address should have no code");

        bytes memory callData = abi.encodeWithSignature("getValue()");
        (bool success, bytes memory returnData) = this.doFunctionStaticCall(nonContract, callData);

        assertTrue(success);
        assertEq(returnData.length, 0);
    }

    /**
     * Tests for Return Data Handling
     */
    function test_doFunctionCall_large_return_data() public {
        bytes memory callData = abi.encodeWithSignature("returnLargeData()");
        (bool success, bytes memory returnData) = this.doFunctionCall(address(target), callData);

        assertTrue(success);
        string memory result = abi.decode(returnData, (string));
        assertEq(bytes(result).length, 1000);
    }

    function test_doFunctionCall_empty_return_data() public {
        bytes memory callData = abi.encodeWithSignature("emptyReturn()");
        (bool success, bytes memory returnData) = this.doFunctionCall(address(target), callData);

        assertTrue(success);
        assertEq(returnData.length, 0);
    }

    function test_doFunctionCall_complex_return_data() public {
        bytes memory callData = abi.encodeWithSignature("returnComplexData()");
        (bool success, bytes memory returnData) = this.doFunctionCall(address(target), callData);

        assertTrue(success);
        (uint256[] memory numbers, string[] memory strings, bool flag) =
            abi.decode(returnData, (uint256[], string[], bool));

        assertEq(numbers.length, 3);
        assertEq(numbers[0], 1);
        assertEq(numbers[1], 2);
        assertEq(numbers[2], 3);

        assertEq(strings.length, 2);
        assertEq(strings[0], "hello");
        assertEq(strings[1], "world");

        assertTrue(flag);
    }

    /**
     * Fuzz Tests
     */
    function testFuzz_doFunctionCall_with_random_actors(address actor) public {
        bytes memory callData = abi.encodeWithSignature("setValue(uint256)", 555);
        (bool success, bytes memory returnData) = this.doFunctionCall(address(target), callData, actor);

        assertTrue(success);
        assertEq(returnData.length, 0);
        assertEq(target.value(), 555);
        assertEq(target.lastCaller(), actor);
    }

    function testFuzz_doFunctionCall_with_random_uint_input(uint256 inputValue) public {
        bytes memory callData = abi.encodeWithSignature("setValue(uint256)", inputValue);
        (bool success, bytes memory returnData) = this.doFunctionCall(address(target), callData);

        assertTrue(success);
        assertEq(returnData.length, 0);
        assertEq(target.value(), inputValue);
        assertEq(target.lastCaller(), address(this));
    }

    function testFuzz_doFunctionStaticCall_with_random_values(uint256 setValue) public {
        // First set the value using regular call
        target.setValue(setValue);

        bytes memory callData = abi.encodeWithSignature("getValue()");
        (bool success, bytes memory returnData) = this.doFunctionStaticCall(address(target), callData);

        assertTrue(success);
        uint256 result = abi.decode(returnData, (uint256));
        assertEq(result, setValue);
    }
}
