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
     * "errAllow" test
     */

    // errAllow() use case 1: allowing only require failure with message
    function test_errAllow_only_require_failure_with_message() public {
        // set require failure related
        string[] memory allowedRequireErrors = new string[](2);
        allowedRequireErrors[0] = "require failure message 1";
        allowedRequireErrors[1] = "require failure message 2";
        
        // #1: Test with require failure: Error(string) selector (0x08c379a0)
        (bool success1, bytes memory requireFailureData) = address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success1, "should fail");
        // This should pass
        errAllow(requireFailureData, allowedRequireErrors, "BAL-01");
        
        // #2: Test with non-matching message (should fail)
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        vm.expectEmit(false, false, false, true);
        // expected error message via event
        emit AssertFail("BAL-02");
        bytes memory nonMatchingRequireFailData = abi.encodeWithSelector(bytes4(0x08c379a0), "error message");
        // This should fail: since the failure message ("this should fail") is not in the allowedRequireErrors list.
        errAllow(nonMatchingRequireFailData, allowedRequireErrors, "BAL-02");
    }

    // errAllow() use case 2: allowing only custom error
    function test_errAllow_only_custom_error() public {
        // set custom error related
        bytes4 customErrorSelector1 = bytes4(DummyContract.DummyCustomError1.selector);
        bytes4 customErrorSelector2 = bytes4(DummyContract.DummyCustomError2.selector);
        bytes4[] memory allowedCustomErrors = new bytes4[](2);
        allowedCustomErrors[0] = customErrorSelector1;
        allowedCustomErrors[1] = customErrorSelector2;
        string memory errorContext = "BAL-03";

        // #1: Test with custom error selector
        (bool success1, bytes memory customErrorData1) = address(dummy).call(abi.encodeWithSignature("revertWithCustomErrorWithMessage()"));
        require(!success1, "should fail");
        // This should pass
        errAllow(bytes4(customErrorData1), allowedCustomErrors, errorContext);

        // #2: Test with non-matching error (should fail)
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        vm.expectEmit(true, false, false, true);
        // expected error message via event
        emit AssertFail(errorContext);
        // This should fail: since the 0x08c379a0 is not in the allowedCustomErrors
        bytes memory randomErrorData = abi.encodeWithSelector(bytes4(0x08c379a0), "this should fail");   
        errAllow(bytes4(randomErrorData), allowedCustomErrors, errorContext);

        // #3: Test with non-matching error (should fail)
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        vm.expectEmit(true, false, false, true);
        // expected error message via event
        emit AssertFail(errorContext);
        bytes memory unexpectedErrorData = abi.encodeWithSelector(bytes4(0x12345678), "some message");
        // This should fail: allowedCustomErrors is empty array. But given unexpectedErrorData has a custom error. Therefore it will throw an error.
        errAllow(bytes4(unexpectedErrorData), new bytes4[](0), errorContext);
    }

    // errAllow() use case 3: allowing require failure AND custom error at the same time
    function test_errAllow_require_failure_and_custom_error() public {
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
        string memory errorContext = "BAL-03";

        // #1: Test with require failure with message
        (bool success1, bytes memory requireFailureData) = address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success1, "should fail");
        // This should pass: testing require failure
        errAllow(requireFailureData, allowedRequireErrors, allowedCustomErrors, errorContext);

        // #2: Test with custom error without message
        (bool success2, bytes memory customErrorData1) = address(dummy).call(abi.encodeWithSignature("revertWithCustomErrorWithoutMessage()"));
        require(!success2, "should fail");
        // This should pass: testing custom error without message
        errAllow(customErrorData1, allowedRequireErrors, allowedCustomErrors, errorContext);

        // #3: Test with custom error with message
        (bool success3, bytes memory customErrorData2) = address(dummy).call(abi.encodeWithSignature("revertWithCustomErrorWithMessage()"));
        require(!success3, "should fail");
        // This should pass: testing custom error with message
        errAllow(customErrorData2, allowedRequireErrors, allowedCustomErrors, errorContext);

        // #4: Test with non-matching error (should fail)
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        vm.expectEmit(true, false, false, true);
        // expected error message via event
        emit AssertFail(errorContext);

        bytes memory nonMatchingRequireFailData = abi.encodeWithSelector(bytes4(0x08c379a0), "this should fail");
        // This should fail: since the selector is require failure e.g.: Error(string). So nothing to do with allowedCustomErrors & errorContext.
        errAllow(nonMatchingRequireFailData, new string[](0), allowedCustomErrors, errorContext);

        // #5: Test with non-matching error (should fail)
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        vm.expectEmit(true, false, false, true);
        // expected error message via event
        emit AssertFail(errorContext);
        bytes memory unexpectedErrorData = abi.encodeWithSelector(bytes4(0x12345678), "some message");
        // This should fail: It will be treated as custom error but the third param is empty array. So it will throw an error.
        errAllow(unexpectedErrorData, allowedRequireErrors, new bytes4[](0), errorContext);

        // #6: Test with non-matching custom error (should fail): checking whether errorContext is emitted or not
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        vm.expectEmit(true, false, false, true);
        // expected error message via event
        emit AssertFail(errorContext);
    
        bytes memory nonMatchingCustomErrorData = abi.encodeWithSelector(bytes4(0x12345678), "some message");
        // This should fail and emit AssertFail with errorContext. "some message" will be ignored.
        errAllow(nonMatchingCustomErrorData, new string[](0), allowedCustomErrors, errorContext);
    }

    // errAllow() use case 4: with zero selector test
    // note: this test is for when "errorSelector" is an empty data (0x00000000). This can happen from require(false) or revert() or address(0xdead).call().
    // This is not an usual case but it proves that errAllow() can handle this case.
    function test_errAllow_zero_selector() public {
        // #1: Test with zero selector
        // emptyRequireFailureData will be an empty data since require(false); returns an empty data
        (bool success, bytes memory emptyRequireFailureData) = address(dummy).call(abi.encodeWithSignature("requireFailWithoutMessage()"));
        require(!success, "should fail");

        bytes4[] memory allowedErrors = new bytes4[](1);
        allowedErrors[0] = bytes4(0);
        string memory message = "zero selector test";
        
        // emptyRequireFailureData is 0x00000000
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
}