// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "src/FuzzLibString.sol";

import {HelperAssert} from "../src/helpers/HelperAssert.sol";
import {PlatformTest} from "./util/PlatformTest.sol";
import {DummyContract} from "./util/DummyContract.sol";

contract TestAsserts is Test, HelperAssert {
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
        string memory failReason = createAssertFailMessage(
                FuzzLibString.toString(x),
                FuzzLibString.toString(y),
                "!=",
                reason
        );
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        eq(x, y, reason);
    }

    function testFuzz_eq_x_y(uint256 x, uint256 y) public {
        vm.assume(x != y);
        string memory reason = "example message";

        vm.expectEmit(true, false, false, true);
        string memory failReason = createAssertFailMessage(
                FuzzLibString.toString(x),
                FuzzLibString.toString(y),
                "!=",
                reason
        );
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
        string memory failReason = createAssertFailMessage(
                x ? "true" : "false",
                y ? "true" : "false",
                "!=",
                reason
        );
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        eq(x, y, reason);
    }

    function testFuzz_eq_bool_x_y(bool x, bool y) public {
        vm.assume(x != y);
        string memory reason = "example message";

        vm.expectEmit(true, false, false, true);
        string memory failReason = createAssertFailMessage(
                x ? "true" : "false",
                y ? "true" : "false",
                "!=",
                reason
        );
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
        string memory failReason = createAssertFailMessage(
            FuzzLibString.toString(x),
            FuzzLibString.toString(y),
            "==",
            reason
        );
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
        string memory failReason = createAssertFailMessage(
            FuzzLibString.toString(x),
            FuzzLibString.toString(y),
            "==",
            reason
        );
        vm.expectEmit(true, false, false, true);
        emit AssertNeqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        neq(x, y, reason);
        }

    /**
     * "allowErrors" test
     */

    // allowErrors() use case 1: allowing only require failure with message
    function test_allowErrors_only_require_failure_with_message() public {
        // set require failure related
        string[] memory allowedRequireErrors = new string[](2);
        allowedRequireErrors[0] = "require failure message 1";
        allowedRequireErrors[1] = "require failure message 2";
        
        // #1: Test with require failure: Error(string) selector (0x08c379a0)
        (bool success1, bytes memory requireFailureData) = address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success1, "should fail");
        // This should pass
        allowErrors(requireFailureData, allowedRequireErrors);
        
        // #2: Test with non-matching message (should fail)
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        vm.expectEmit(true, false, false, true);
        // expected error message via event
        emit AssertFail("this should fail");
        bytes memory nonMatchingRequireFailData = abi.encodeWithSelector(bytes4(0x08c379a0), "this should fail");
        // This should fail: since the failure message ("this should fail") is not in the allowedRequireErrors list.
        allowErrors(nonMatchingRequireFailData, allowedRequireErrors);
    }

    // allowErrors() use case 2: allowing only custom error
    function test_allowErrors_only_custom_error() public {
        // set custom error related
        bytes4 customErrorSelector1 = bytes4(DummyContract.DummyCustomError1.selector);
        bytes4 customErrorSelector2 = bytes4(DummyContract.DummyCustomError2.selector);
        bytes4[] memory allowedCustomErrors = new bytes4[](2);
        allowedCustomErrors[0] = customErrorSelector1;
        allowedCustomErrors[1] = customErrorSelector2;
        string memory customErrorContext = "custom error test failed. here is the context";

        // #1: Test with custom error selector (with message)
        (bool success1, bytes memory customErrorData1) = address(dummy).call(abi.encodeWithSignature("revertWithCustomErrorWithMessage()"));
        require(!success1, "should fail");
        // This should pass
        allowErrors(customErrorData1, allowedCustomErrors, customErrorContext);

        // #2: Test with custom error selector (without message)
        (bool success2, bytes memory customErrorData2) = address(dummy).call(abi.encodeWithSignature("revertWithCustomErrorWithoutMessage()"));
        require(!success2, "should fail");
        // This should pass
        allowErrors(customErrorData2, allowedCustomErrors, customErrorContext);

        // #3: Test with non-matching error (should fail)
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        vm.expectEmit(true, false, false, true);
        // expected error message via event
        emit AssertFail("this should fail");
        // This should fail: since the require failure with message, it should emit AssertFail with the message.
        bytes memory randomErrorData = abi.encodeWithSelector(bytes4(0x08c379a0), "this should fail");   
        allowErrors(randomErrorData, allowedCustomErrors, customErrorContext);

        // #4: Test with non-matching error (should fail)
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        vm.expectEmit(true, false, false, true);
        // expected error message via event
        emit AssertFail(customErrorContext);
        // this should fail: since the custom error is not in the allowedCustomErrors, it should emit AssertFail with customErrorContext. "some message" will be ignored.
        bytes memory nonMatchingCustomErrorData = abi.encodeWithSelector(bytes4(0x12345678), "some message");
        allowErrors(nonMatchingCustomErrorData, allowedCustomErrors, customErrorContext);
    }

    // allowErrors() use case 3: allowing require failure AND custom error at the same time
    function test_allowErrors_require_failure_and_custom_error() public {
        // set require failure related
        string[] memory allowedRequireErrors = new string[](2);
        allowedRequireErrors[0] = "require failure message 1";
        allowedRequireErrors[1] = "require failure message 2";

        // set custom error related
        bytes4 customErrorSelector1 = bytes4(DummyContract.DummyCustomError1.selector);
        bytes4 customErrorSelector2 = bytes4(DummyContract.DummyCustomError2.selector);
        bytes4[] memory allowedCustomErrors = new bytes4[](2);
        allowedCustomErrors[0] = customErrorSelector1;
        allowedCustomErrors[1] = customErrorSelector2;
        string memory customErrorContext = "custom error test failed. here is the context";

        // #1: Test with require failure with message
        (bool success1, bytes memory requireFailureData) = address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success1, "should fail");
        // This should pass: testing require failure
        allowErrors(requireFailureData, allowedRequireErrors, allowedCustomErrors, customErrorContext);

        // #2: Test with custom error without message
        (bool success2, bytes memory customErrorData1) = address(dummy).call(abi.encodeWithSignature("revertWithCustomErrorWithoutMessage()"));
        require(!success2, "should fail");
        // This should pass: testing custom error without message
        allowErrors(customErrorData1, allowedRequireErrors, allowedCustomErrors, customErrorContext);

        // #3: Test with custom error with message
        (bool success3, bytes memory customErrorData2) = address(dummy).call(abi.encodeWithSignature("revertWithCustomErrorWithMessage()"));
        require(!success3, "should fail");
        // This should pass: testing custom error with message
        allowErrors(customErrorData2, allowedRequireErrors, allowedCustomErrors, customErrorContext);

        // #4: Test with non-matching error (should fail)
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        vm.expectEmit(true, false, false, true);
        // expected error message via event
        emit AssertFail("this should fail");

        bytes memory nonMatchingRequireFailData = abi.encodeWithSelector(bytes4(0x08c379a0), "this should fail");
        // This should fail: since the selector is require failure e.g.: Error(string). So nothing to do with allowedCustomErrors & customErrorContext.
        allowErrors(nonMatchingRequireFailData, new string[](0), allowedCustomErrors, customErrorContext);

        // #5: Test with non-matching error (should fail)
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        bytes memory unexpectedErrorData = abi.encodeWithSelector(bytes4(0x12345678), "some message");
        // This should fail: It will be treated as custom error but the third param is empty array. So it will throw an error.
        allowErrors(unexpectedErrorData, allowedRequireErrors, new bytes4[](0), customErrorContext);

        // #6: Test with non-matching custom error (should fail): checking whether customErrorContext is emitted or not
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        vm.expectEmit(true, false, false, true);
        // expected error message via event
        emit AssertFail(customErrorContext);
    
        bytes memory nonMatchingCustomErrorData = abi.encodeWithSelector(bytes4(0x12345678), "some message");
        // This should fail and emit AssertFail with customErrorContext before reverting
        allowErrors(nonMatchingCustomErrorData, new string[](0), allowedCustomErrors, customErrorContext);
    }

    function test_isErrorString() public {
        // Test with Error(string) selector
        (bool success, bytes memory errorData) = address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");
        assertTrue(_isErrorString(bytes4(errorData)), "should be Error(string) type");

        // Test with custom error
        (bool success2, bytes memory customErrorData) = address(dummy).call(abi.encodeWithSignature("revertWithCustomErrorWithoutMessage()"));
        require(!success2, "should fail");
        assertFalse(_isErrorString(bytes4(customErrorData)), "should not be Error(string) type");

        // Test with empty error (require(false))
        (bool success3, bytes memory emptyErrorData) = address(dummy).call(abi.encodeWithSignature("requireFailWithoutMessage()"));
        require(!success3, "should fail");
        assertFalse(_isErrorString(bytes4(emptyErrorData)), "empty error should not be Error(string) type");
    }

    function test_allowRequireFailure() public {
        // Test with matching require failure message
        (bool success, bytes memory errorData) = address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");
        
        string[] memory allowedRequireErrors = new string[](1);
        allowedRequireErrors[0] = "require failure message 1";
        
        // Test with matching message
        _allowRequireFailure(errorData, allowedRequireErrors); // should not revert
        
        // Test with non-matching message
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        string[] memory nonMatchingErrors = new string[](1);
        nonMatchingErrors[0] = "different message";
        _allowRequireFailure(errorData, nonMatchingErrors); // should revert
    }

    function test_convertToErrorMessage() public {
        // Test with require failure message
        (bool success, bytes memory errorData) = address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");
        
        bytes memory strippedData = new bytes(errorData.length - 4);
        // remove the first 4 bytes which is the selector of the error
        for (uint i = 0; i < errorData.length - 4; i++) {
            strippedData[i] = errorData[i + 4];
        }
        string memory decodedMessage = _convertToErrorMessage(strippedData);
        assertEq(decodedMessage, "require failure message 1", "should extract correct error message");

        // Test with custom error message
        (bool success2, bytes memory customErrorData) = address(dummy).call(abi.encodeWithSignature("revertWithCustomErrorWithMessage()"));
        require(!success2, "should fail");
        bytes memory strippedCustomData = new bytes(customErrorData.length - 4);
        for (uint i = 0; i < customErrorData.length - 4; i++) {
            strippedCustomData[i] = customErrorData[i + 4];
        }
        string memory customMessage = _convertToErrorMessage(strippedCustomData);
        assertEq(customMessage, "custom error message", "should extract correct custom error message");

        // Test with empty error data
        string memory emptyMessage = _convertToErrorMessage(new bytes(0));
        assertEq(emptyMessage, "unknown error", "should return unknown error for empty data");
    }

    /**
     * "errAllow" test
     */

    // note: this test is for when "errorSelector" is an empty data. This can happen when require(false) or revert() or address(0xdead).call() is called.
    // This is not an usual case but it proves that errAllow() can handle this case.
    function test_errAllow_zero_selector() public {
        // #1: Test with zero selector
        // emptyRequireFailureData will be an empty data since require(false); returns an empty data
        (bool success, bytes memory emptyRequireFailureData) = address(dummy).call(abi.encodeWithSignature("requireFailWithoutMessage()"));
        require(!success, "should fail");

        bytes4[] memory allowedErrors = new bytes4[](1);
        allowedErrors[0] = bytes4(0);
        string memory message = "zero selector test";
        
        // This should pass since errorSelector (bytes4(0)) is in allowedErrors
        errAllow(bytes4(emptyRequireFailureData), allowedErrors, message);

        // #2: Test with different selector
        (bool success2, bytes memory emptyRequireFailureData2) = address(dummy).call(abi.encodeWithSignature("requireFailWithoutMessage()"));
        require(!success2, "should fail");

        bytes4[] memory allowedErrors2 = new bytes4[](1);
        allowedErrors2[0] = bytes4(0x12345678); // Different selector
        string memory message2 = "zero selector test should fail";
        
        // This should fail since errorSelector (bytes4(0)) is not in allowedErrors
        vm.expectEmit(true, false, false, true);
        emit AssertFail(message2);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        
        errAllow(bytes4(emptyRequireFailureData2), allowedErrors2, message2);
    }
}