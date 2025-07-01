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
     * "t" test
     */
    function test_HelperAssert_t_true() public {
        string memory reason = "example message";
        t(true, reason);
    }

    function test_HelperAssert_t_false() public {
        string memory reason = "example message";
        vm.expectEmit(true, false, false, true);
        emit AssertFail(reason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        t(false, reason);
    }

    /**
     * "eq" test
     */
    function test_eq_x_x() public {
        uint256 x = 1;
        eq(x, x, "example message");
    }

    function testFuzz_eq_x_x(uint256 x) public {
        eq(x, x, "example message");
    }

    function test_eq_x_y() public {
        uint256 x = 2;
        uint256 y = 4;

        string memory reason = "example message";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(x), FuzzLibString.toString(y), "!=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        eq(x, y, reason);
    }

    function testFuzz_eq_x_y(uint256 x, uint256 y) public {
        vm.assume(x != y);
        string memory reason = "example message";

        vm.expectEmit(true, false, false, true);
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(x), FuzzLibString.toString(y), "!=", reason);
        emit AssertEqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        eq(x, y, reason);
    }

    /// @notice bool version of eq tests
    function test_eq_bool_x_x() public {
        bool x = true;
        eq(x, x, "example message");
    }

    function testFuzz_eq_bool_x_x(bool x) public {
        eq(x, x, "example message");
    }

    function test_eq_bool_x_y() public {
        bool x = true;
        bool y = false;

        string memory reason = "example message";
        string memory failReason = createAssertFailMessage(x ? "true" : "false", y ? "true" : "false", "!=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        eq(x, y, reason);
    }

    function testFuzz_eq_bool_x_y(bool x, bool y) public {
        vm.assume(x != y);
        string memory reason = "example message";

        vm.expectEmit(true, false, false, true);
        string memory failReason = createAssertFailMessage(x ? "true" : "false", y ? "true" : "false", "!=", reason);
        emit AssertEqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        eq(x, y, reason);
    }

    /**
     * "neq" test
     */
    function test_neq_x_y() public {
        uint256 x = 1;
        uint256 y = 2;
        neq(x, y, "example message");
    }

    function testFuzz_neq_x_y(uint256 x, uint256 y) public {
        vm.assume(x != y);
        neq(x, y, "example message");
    }

    // neq: unhappy path
    function test_neq_x_y_unhappy_path() public {
        uint256 x = 1;
        uint256 y = 1;

        string memory reason = "x and y should not be the same";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(x), FuzzLibString.toString(y), "==", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertNeqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        neq(x, y, reason);
    }

    // note that params are int instead of uint
    function test_neq_x_y_int256_param() public {
        int256 x = 1;
        int256 y = 2;
        neq(x, y, "example message");
    }

    function testFuzz_neq_x_y_int256_param(int256 x, int256 y) public {
        vm.assume(x != y);
        neq(x, y, "example message");
    }

    // neq: unhappy path
    function test_neq_x_y_unhappy_path_int256_param() public {
        int256 x = 1;
        int256 y = 1;

        string memory reason = "x and y should not be the same";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(x), FuzzLibString.toString(y), "==", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertNeqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        neq(x, y, reason);
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
