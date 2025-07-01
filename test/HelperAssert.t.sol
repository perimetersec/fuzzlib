// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "src/FuzzLibString.sol";

import {HelperAssert} from "../src/helpers/HelperAssert.sol";
import {PlatformTest} from "./util/PlatformTest.sol";
import {DummyContract} from "./util/DummyContract.sol";
import {ErrAllowTestHelper} from "./util/ErrAllowTestHelper.sol";

/**
 * @dev Comprehensive tests for HelperAssert functionality including assertion utilities,
 * error handling with errAllow functions, and platform-specific behavior.
 * @author Perimeter <info@perimetersec.io>
 */
contract TestHelperAssert is Test, HelperAssert, ErrAllowTestHelper {
    DummyContract dummy;

    function setUp() public {
        setPlatform(address(new PlatformTest()));
        dummy = new DummyContract();
    }

    /**
     * Tests for t(bool, string)
     */
    function test_t_true() public {
        t(true, "example message");
    }

    function test_t_false() public {
        vm.expectEmit(true, false, false, true);
        emit AssertFail("example message");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        t(false, "example message");
    }

    function testFuzz_t_true(string memory reason) public {
        t(true, reason);
    }

    function testFuzz_t_false(string memory reason) public {
        vm.expectEmit(true, false, false, true);
        emit AssertFail(reason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        t(false, reason);
    }

    /**
     * Tests for eq(uint256, uint256, string)
     */
    function test_eq_uint256_equal() public {
        eq(uint256(5), uint256(5), "example message");
    }

    function test_eq_uint256_not_equal() public {
        string memory reason = "example message";
        string memory failReason = createAssertFailMessage(
            FuzzLibString.toString(uint256(2)), FuzzLibString.toString(uint256(4)), "!=", reason
        );
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        eq(uint256(2), uint256(4), reason);
    }

    function test_eq_uint256_zero() public {
        eq(uint256(0), uint256(0), "zero test");
    }

    function test_eq_uint256_max_values() public {
        eq(type(uint256).max, type(uint256).max, "max values test");
    }

    function testFuzz_eq_uint256_equal(uint256 x) public {
        eq(x, x, "fuzz equal test");
    }

    function testFuzz_eq_uint256_not_equal(uint256 x, uint256 y) public {
        vm.assume(x != y);
        string memory reason = "fuzz not equal test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(x), FuzzLibString.toString(y), "!=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        eq(x, y, reason);
    }

    /**
     * Tests for eq(bool, bool, string)
     */
    function test_eq_bool_equal() public {
        eq(true, true, "bool equal test");
        eq(false, false, "bool equal test");
    }

    function test_eq_bool_not_equal() public {
        string memory reason = "bool not equal test";
        string memory failReason = createAssertFailMessage("true", "false", "!=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        eq(true, false, reason);
    }

    function testFuzz_eq_bool_equal(bool x) public {
        eq(x, x, "fuzz bool equal test");
    }

    function testFuzz_eq_bool_not_equal(bool x, bool y) public {
        vm.assume(x != y);
        string memory reason = "fuzz bool not equal test";
        string memory failReason = createAssertFailMessage(x ? "true" : "false", y ? "true" : "false", "!=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        eq(x, y, reason);
    }

    /**
     * Tests for neq(uint256, uint256, string)
     */
    function test_neq_uint256_not_equal() public {
        neq(uint256(1), uint256(2), "neq test");
    }

    function test_neq_uint256_equal() public {
        string memory reason = "should not be equal";
        string memory failReason = createAssertFailMessage(
            FuzzLibString.toString(uint256(5)), FuzzLibString.toString(uint256(5)), "==", reason
        );
        vm.expectEmit(true, false, false, true);
        emit AssertNeqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        neq(uint256(5), uint256(5), reason);
    }

    function test_neq_uint256_zero() public {
        neq(uint256(0), uint256(1), "zero neq test");
    }

    function test_neq_uint256_max_values() public {
        neq(type(uint256).max, type(uint256).max - 1, "max values neq test");
    }

    function testFuzz_neq_uint256_not_equal(uint256 x, uint256 y) public {
        vm.assume(x != y);
        neq(x, y, "fuzz neq test");
    }

    function testFuzz_neq_uint256_equal(uint256 x) public {
        string memory reason = "fuzz equal failure test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(x), FuzzLibString.toString(x), "==", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertNeqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        neq(x, x, reason);
    }

    /**
     * Tests for neq(int256, int256, string)
     */
    function test_neq_int256_not_equal() public {
        neq(int256(1), int256(2), "int256 neq test");
    }

    function test_neq_int256_equal() public {
        string memory reason = "int256 should not be equal";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(int256(7)), FuzzLibString.toString(int256(7)), "==", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertNeqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        neq(int256(7), int256(7), reason);
    }

    function test_neq_int256_negative() public {
        neq(int256(-5), int256(-10), "negative neq test");
    }

    function test_neq_int256_mixed_signs() public {
        neq(int256(-5), int256(5), "mixed signs neq test");
    }

    function test_neq_int256_extreme_values() public {
        neq(type(int256).max, type(int256).min, "extreme values neq test");
    }

    function testFuzz_neq_int256_not_equal(int256 x, int256 y) public {
        vm.assume(x != y);
        neq(x, y, "fuzz int256 neq test");
    }

    function testFuzz_neq_int256_equal(int256 x) public {
        // Avoid type(int256).min which can cause overflow in toString
        vm.assume(x != type(int256).min);
        string memory reason = "fuzz int256 equal failure test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(x), FuzzLibString.toString(x), "==", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertNeqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        neq(x, x, reason);
    }

    /**
     * "errAllow" test
     */

    // errAllow() use case 1-1: allowing only require failure with message
    function test_errAllow_only_require_failure_happy_path() public {
        // set require failure related
        string[] memory allowedRequireErrors = setup_errAllow_require_error();

        // Test with require failure: Error(string) selector (0x08c379a0)
        (bool success, bytes memory requireFailureData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");
        // This should pass since the error message is in the allowedRequireErrors list.
        errAllow(requireFailureData, allowedRequireErrors, "ERR_ALLOW_01");
    }

    // errAllow() use case 1-2: allowing only require failure with message
    function test_errAllow_only_require_failure_unhappy_path() public {
        // set require failure related
        string[] memory allowedRequireErrors = setup_errAllow_require_error();

        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        vm.expectEmit(false, false, false, true);
        // expected error message via event
        emit AssertFail("ERR_ALLOW_02");
        bytes memory nonMatchingRequireFailData = abi.encodeWithSelector(bytes4(0x08c379a0), "error message");
        // This should fail: since the failure message ("this should fail") is not in the allowedRequireErrors list.
        errAllow(nonMatchingRequireFailData, allowedRequireErrors, "ERR_ALLOW_02");
    }

    // errAllow() use case 2-1: allowing only custom error
    function test_errAllow_only_custom_error_happy_path() public {
        bytes4[] memory allowedCustomErrors = setup_errAllow_custom_error();

        // Test with custom error selector
        (bool success, bytes memory customErrorData) =
            address(dummy).call(abi.encodeWithSignature("revertWithCustomErrorWithMessage()"));
        require(!success, "This test supposes to fail");
        // Nothing should happen since the error is in the allowedCustomErrors list.
        errAllow(bytes4(customErrorData), allowedCustomErrors, "ERR_ALLOW_03");
    }

    // errAllow() use case 2-2: allowing only custom error
    function test_errAllow_only_custom_error_unhappy_path_1() public {
        bytes4[] memory allowedCustomErrors = setup_errAllow_custom_error();

        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        vm.expectEmit(false, false, false, true);
        // expected error message via event
        emit AssertFail("ERR_ALLOW_04");
        // This should fail: since the 0x08c379a0 is not in the allowedCustomErrors
        // 0x08c379a0 is Error(string) which is not a custom error but a require failure.
        bytes memory randomErrorData = abi.encodeWithSelector(bytes4(0x08c379a0), "this should fail");
        errAllow(bytes4(randomErrorData), allowedCustomErrors, "ERR_ALLOW_04");
    }

    // errAllow() use case 2-3: allowing only custom error
    function test_errAllow_only_custom_error_unhappy_path_2() public {
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        vm.expectEmit(false, false, false, true);
        // expected error message via event
        emit AssertFail("ERR_ALLOW_05");
        bytes memory unexpectedErrorData = abi.encodeWithSelector(bytes4(0x12345678), "some message");
        // This should fail: allowedCustomErrors is empty array. But given unexpectedErrorData has a custom error. Therefore it will throw an error.
        errAllow(bytes4(unexpectedErrorData), new bytes4[](0), "ERR_ALLOW_05");
    }

    // errAllow() use case 3-1: allowing require failure AND custom error at the same time
    function test_errAllow_require_failure_and_custom_error_happy_path_1() public {
        // set require failure related
        string[] memory allowedRequireErrors = setup_errAllow_require_error();
        // set custom error related
        bytes4[] memory allowedCustomErrors = setup_errAllow_custom_error();

        (bool success, bytes memory requireFailureData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "This test supposes to fail");
        // This should pass: testing require failure
        errAllow(requireFailureData, allowedRequireErrors, allowedCustomErrors, "ERR_ALLOW_06");
    }

    // errAllow() use case 3-2: allowing require failure AND custom error at the same time
    function test_errAllow_require_failure_and_custom_error_happy_path_2() public {
        // set require failure related
        string[] memory allowedRequireErrors = setup_errAllow_require_error();
        // set custom error related
        bytes4[] memory allowedCustomErrors = setup_errAllow_custom_error();

        (bool success, bytes memory customErrorData) =
            address(dummy).call(abi.encodeWithSignature("revertWithCustomErrorWithoutMessage()"));
        require(!success, "This test supposes to fail");
        // This should pass: testing custom error without message
        errAllow(customErrorData, allowedRequireErrors, allowedCustomErrors, "ERR_ALLOW_07");
    }

    // errAllow() use case 3-3: allowing require failure AND custom error at the same time
    function test_errAllow_require_failure_and_custom_error_happy_path_3() public {
        // set require failure related
        string[] memory allowedRequireErrors = setup_errAllow_require_error();
        // set custom error related
        bytes4[] memory allowedCustomErrors = setup_errAllow_custom_error();

        (bool success, bytes memory customErrorData) =
            address(dummy).call(abi.encodeWithSignature("revertWithCustomErrorWithMessage()"));
        require(!success, "This test supposes to fail");
        // This should pass: testing custom error with message
        errAllow(customErrorData, allowedRequireErrors, allowedCustomErrors, "ERR_ALLOW_08");
    }

    // errAllow() use case 3-4: allowing require failure AND custom error at the same time
    function test_errAllow_require_failure_and_custom_error_unhappy_path_1() public {
        // set custom error related
        bytes4[] memory allowedCustomErrors = setup_errAllow_custom_error();

        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        vm.expectEmit(false, false, false, true);
        // expected error message via event
        emit AssertFail("ERR_ALLOW_09");

        bytes memory nonMatchingRequireFailData = abi.encodeWithSelector(bytes4(0x08c379a0), "this should fail");
        // This should fail: since the selector is require failure e.g.: Error(string). So nothing to do with allowedCustomErrors & errorContext.
        errAllow(nonMatchingRequireFailData, new string[](0), allowedCustomErrors, "ERR_ALLOW_09");
    }

    // errAllow() use case 3-5: allowing require failure AND custom error at the same time
    function test_errAllow_require_failure_and_custom_error_unhappy_path_2() public {
        // set require failure related
        string[] memory allowedRequireErrors = setup_errAllow_require_error();

        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        vm.expectEmit(false, false, false, true);
        // expected error message via event
        emit AssertFail("ERR_ALLOW_10");
        bytes memory unexpectedErrorData = abi.encodeWithSelector(bytes4(0x12345678), "some message");
        // This should fail: It will be treated as custom error but the third param is empty array. So it will throw an error.
        errAllow(unexpectedErrorData, allowedRequireErrors, new bytes4[](0), "ERR_ALLOW_10");
    }

    // errAllow() use case 3-6: allowing require failure AND custom error at the same time
    function test_errAllow_require_failure_and_custom_error_unhappy_path_3() public {
        // set custom error related
        bytes4[] memory allowedCustomErrors = setup_errAllow_custom_error();

        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        vm.expectEmit(false, false, false, true);
        // expected error message via event
        emit AssertFail("ERR_ALLOW_11");

        bytes memory nonMatchingCustomErrorData = abi.encodeWithSelector(bytes4(0x12345678), "some message");
        // This should fail and emit AssertFail with errorContext. "some message" will be ignored.
        errAllow(nonMatchingCustomErrorData, new string[](0), allowedCustomErrors, "ERR_ALLOW_11");
    }

    // errAllow() use case 4-1: with zero selector test
    // note: this test is for when "errorSelector" is an empty data (0x00000000). This can happen from require(false) or revert() or address(0xdead).call().
    // This is not an usual case but it proves that errAllow() can handle this case.
    function test_errAllow_zero_selector_happy_path() public {
        // #1: Test with zero selector
        // emptyRequireFailureData will be an empty data since require(false); returns an empty data
        (bool success, bytes memory emptyRequireFailureData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithoutMessage()"));
        require(!success, "should fail");

        bytes4[] memory allowedErrors = new bytes4[](1);
        allowedErrors[0] = bytes4(0);

        // emptyRequireFailureData is 0x00000000
        // This should pass since errorSelector (bytes4(0)) is in allowedErrors
        errAllow(bytes4(emptyRequireFailureData), allowedErrors, "ERR_ALLOW_12");
    }

    // errAllow() use case 4-2: with zero selector test
    // note: this test is for when "errorSelector" is an empty data (0x00000000). This can happen from require(false) or revert() or address(0xdead).call().
    // This is not an usual case but it proves that errAllow() can handle this case.
    function test_errAllow_zero_selector_unhappy_path() public {
        (bool success, bytes memory emptyRequireFailureData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithoutMessage()"));
        require(!success, "should fail");

        bytes4[] memory allowedErrors = new bytes4[](1);
        allowedErrors[0] = bytes4(0x12345678); // Different selector

        // This should fail since errorSelector (bytes4(0)) is not in allowedErrors
        vm.expectEmit(false, false, false, true);
        emit AssertFail("ERR_ALLOW_13");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        // This should fail since errorSelector (bytes4(0)) is not in allowedErrors.
        errAllow(bytes4(emptyRequireFailureData), allowedErrors, "ERR_ALLOW_13");
    }

    function test_isErrorString() public {
        // Test with Error(string) selector
        (bool success, bytes memory errorData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");
        assertTrue(_isErrorString(bytes4(errorData)), "should be Error(string) type");

        // Test with custom error
        (bool success2, bytes memory customErrorData) =
            address(dummy).call(abi.encodeWithSignature("revertWithCustomErrorWithoutMessage()"));
        require(!success2, "should fail");
        assertFalse(_isErrorString(bytes4(customErrorData)), "should not be Error(string) type");

        // Test with empty error (require(false))
        (bool success3, bytes memory emptyErrorData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithoutMessage()"));
        require(!success3, "should fail");
        assertFalse(_isErrorString(bytes4(emptyErrorData)), "empty error should not be Error(string) type");
    }
}
