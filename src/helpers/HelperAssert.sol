// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./HelperBase.sol";

import "../FuzzLibString.sol";

/// @author Based on Crytic PropertiesHelper (https://github.com/crytic/properties/blob/main/contracts/util/PropertiesHelper.sol)
abstract contract HelperAssert is HelperBase {
    event AssertFail(string);
    event AssertEqFail(string);
    event AssertNeqFail(string);
    event AssertGteFail(string);
    event AssertGtFail(string);
    event AssertLteFail(string);
    event AssertLtFail(string);

    function t(bool b, string memory reason) public {
        if (!b) {
            emit AssertFail(reason);
            platform.assertFail();
        }
    }

    /// @notice asserts that a is equal to b. Violations are logged using reason.
    function eq(
        uint256 a,
        uint256 b,
        string memory reason
    ) public {
        if (a != b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "!=", reason);
            emit AssertEqFail(assertMsg);
            platform.assertFail();
        }
    }

    /// @notice int256 version of eq
    function eq(
        int256 a,
        int256 b,
        string memory reason
    ) public {
        if (a != b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "!=", reason);
           emit AssertEqFail(assertMsg);
            platform.assertFail();
        }
    }

    /// @notice bool version of eq
    function eq(
        bool a,
        bool b,
        string memory reason
    ) public {
        if (a != b) {
            string memory aStr = a ? "true" : "false";
            string memory bStr = b ? "true" : "false";
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "!=", reason);
            emit AssertEqFail(assertMsg);
            platform.assertFail();
        }
    }

    /// @notice address version of eq
    function eq(
        address a,
        address b,
        string memory reason
    ) public {
        if (a != b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "!=", reason);
            emit AssertEqFail(assertMsg);
            platform.assertFail();
        }
    }

    /// @notice bytes4 version of eq
    function eq(
        bytes4 a,
        bytes4 b,
        string memory reason
    ) public {
        if (a != b) {
            bytes memory aBytes = abi.encodePacked(a);
            bytes memory bBytes = abi.encodePacked(b);
            string memory aStr = FuzzLibString.toHexString(aBytes);
            string memory bStr = FuzzLibString.toHexString(bBytes);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "!=", reason);
            emit AssertEqFail(assertMsg);
            platform.assertFail();
        }
    }

    /// @notice asserts that a is not equal to b. Violations are logged using reason.
    function neq(
        uint256 a,
        uint256 b,
        string memory reason
    ) public {
        if (a == b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "==", reason);
            emit AssertNeqFail(assertMsg);
            platform.assertFail();
        }
    }

    /// @notice int256 version of neq
    function neq(
        int256 a,
        int256 b,
        string memory reason
    ) public {
        if (a == b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "==", reason);
            emit AssertNeqFail(assertMsg);
            platform.assertFail();
        }
    }

    /// @notice asserts that a is greater than or equal to b. Violations are logged using reason.
    function gte(
        uint256 a,
        uint256 b,
        string memory reason
    ) public {
        if (!(a >= b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "<", reason);
            emit AssertGteFail(assertMsg);
            platform.assertFail();
        }
    }

    /// @notice int256 version of gte
    function gte(
        int256 a,
        int256 b,
        string memory reason
    ) public {
        if (!(a >= b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "<", reason);
            emit AssertGteFail(assertMsg);
            platform.assertFail();
        }
    }

    /// @notice asserts that a is greater than b. Violations are logged using reason.
    function gt(
        uint256 a,
        uint256 b,
        string memory reason
    ) public {
        if (!(a > b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "<=", reason);
            emit AssertGtFail(assertMsg);
            platform.assertFail();
        }
    }

    /// @notice int256 version of gt
    function gt(
        int256 a,
        int256 b,
        string memory reason
    ) public {
        if (!(a > b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "<=", reason);
            emit AssertGtFail(assertMsg);
            platform.assertFail();
        }
    }

    /// @notice asserts that a is less than or equal to b. Violations are logged using reason.
    function lte(
        uint256 a,
        uint256 b,
        string memory reason
    ) public {
        if (!(a <= b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, ">", reason);
            emit AssertLteFail(assertMsg);
            platform.assertFail();
        }
    }

    /// @notice int256 version of lte
    function lte(
        int256 a,
        int256 b,
        string memory reason
    ) public {
        if (!(a <= b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, ">", reason);
            emit AssertLteFail(assertMsg);
            platform.assertFail();
        }
    }

    /// @notice asserts that a is less than b. Violations are logged using reason.
    function lt(
        uint256 a,
        uint256 b,
        string memory reason
    ) public {
        if (!(a < b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, ">=", reason);
            emit AssertLtFail(assertMsg);
            platform.assertFail();
        }
    }

    /// @notice int256 version of lt
    function lt(
        int256 a,
        int256 b,
        string memory reason
    ) public {
        if (!(a < b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, ">=", reason);
            emit AssertLtFail(assertMsg);
            platform.assertFail();
        }
    }

    function assertRevertReasonNotEqual(
        bytes memory returnData,
        string memory reason
    ) public {
        bool isEqual = FuzzLibString.isRevertReasonEqual(returnData, reason);
        t(!isEqual, reason);
    }

    function assertRevertReasonEqual(
        bytes memory returnData,
        string memory reason
    ) public {
        bool isEqual = FuzzLibString.isRevertReasonEqual(returnData, reason);
        t(isEqual, reason);
    }

    function assertRevertReasonEqual(
        bytes memory returnData,
        string memory reason1,
        string memory reason2
    ) public {
        bool isEqual = FuzzLibString.isRevertReasonEqual(returnData, reason1) ||
            FuzzLibString.isRevertReasonEqual(returnData, reason2);
        string memory assertMsg = string(
            abi.encodePacked(reason1, " OR ", reason2)
        );
        t(isEqual, assertMsg);
    }

    function assertRevertReasonEqual(
        bytes memory returnData,
        string memory reason1,
        string memory reason2,
        string memory reason3
    ) public {
        bool isEqual = FuzzLibString.isRevertReasonEqual(returnData, reason1) ||
            FuzzLibString.isRevertReasonEqual(returnData, reason2) ||
            FuzzLibString.isRevertReasonEqual(returnData, reason3);
        string memory assertMsg = string(
            abi.encodePacked(reason1, " OR ", reason2, " OR ", reason3)
        );
        t(isEqual, assertMsg);
    }

    function assertRevertReasonEqual(
        bytes memory returnData,
        string memory reason1,
        string memory reason2,
        string memory reason3,
        string memory reason4
    ) public {
        bool isEqual = FuzzLibString.isRevertReasonEqual(returnData, reason1) ||
            FuzzLibString.isRevertReasonEqual(returnData, reason2) ||
            FuzzLibString.isRevertReasonEqual(returnData, reason3) ||
            FuzzLibString.isRevertReasonEqual(returnData, reason4);
        string memory assertMsg = string(
            abi.encodePacked(
                reason1,
                " OR ",
                reason2,
                " OR ",
                reason3,
                " OR ",
                reason4
            )
        );
        t(isEqual, assertMsg);
    }

    function errAllow(
        bytes4 errorSelector,
        bytes4[] memory allowedErrors,
        string memory message
    ) public {
        bool allowed = false;
        for (uint256 i = 0; i < allowedErrors.length; i++) {
            if (errorSelector == allowedErrors[i]) {
                allowed = true;
                break;
            }
        }
        t(allowed, message);
    }

    function errsAllow(
        bytes4 errorSelector,
        bytes4[] memory allowedErrors,
        string[] memory messages
    ) public {
        bool allowed = false;
        uint256 passIndex = 0;
        for (uint256 i = 0; i < allowedErrors.length; i++) {
            if (errorSelector == allowedErrors[i]) {
                allowed = true;
                passIndex = i;
                break;
            }
        }
        t(allowed, messages[passIndex]);
    }

    function createAssertFailMessage(string memory aStr, string memory bStr, string memory operator, string memory reason)internal pure returns (string memory) {
        return string(abi.encodePacked("Invalid: ", aStr, operator, bStr, ", reason: ", reason));
    }

    function allowErrors(  
        bytes memory errorData,
        string[] memory allowedRequireErrorMessages
    ) public {
        allowErrors(errorData, allowedRequireErrorMessages, new bytes4[](0), "", false);
    }
    
    function allowErrors(  
        bytes memory errorData,
        bytes4[] memory allowedCustomErrors,
        string memory errorContext
    ) public {
        allowErrors(errorData, new string[](0), allowedCustomErrors, errorContext, false);
    }
    
    function allowErrors(  
        bytes memory errorData,
        string[] memory allowedRequireErrorMessages,
        bytes4[] memory allowedCustomErrors,
        string memory errorContext
    ) public {
        allowErrors(errorData, allowedRequireErrorMessages, allowedCustomErrors, errorContext, false);
    }
    
    /**
     * Allow require failure & custom errors
     * @param errorData: return data from a function call. In this case, it's a failure data
     * @param allowedRequireErrorMessages: allowed require failure messages. It's a string array
     * @param allowedCustomErrors: allowed custom errors. It can be just 4 bytes function selector or it could be longer
     * @param errorContext: error context: A message to describe the error
     * @param allowEmptyError: allow require failure without message
     */
    function allowErrors(  
        bytes memory errorData,
        string[] memory allowedRequireErrorMessages,
        bytes4[] memory allowedCustomErrors,
        string memory errorContext,
        bool allowEmptyError
    ) public {
        if (allowEmptyError && errorData.length == 0) {
            // 1. empty error case (ex: require(false)) <= useful when there is no error message, errorData is empty
            // NOTE: Becareful! It could be "require" or "revert" failure without message BUT also it could be something else such as 
            // calling non-existing address (ex: address(0xdead).call(...)). The root-cause could be various. Please check the 
            // code and the context before use allowEmptyError = true.
            _handleEmptyError(allowEmptyError);
            return;
        }
    
        if (errorData.length < 4) {
            t(false, "unexpected error data length during allowErrors()");
            return;
        }
    
        bytes4 selector = bytes4(errorData);
        
        if (_isErrorString(selector)) {
            // 2. require failure case (ex: require(false, "error message"))
            _allowRequireFailure(errorData, allowedRequireErrorMessages);
        } else if (allowedCustomErrors.length > 0) {
            // 3. custom error case (ex: MyCustomError())
            errAllow(selector, allowedCustomErrors, errorContext);
        } else {
            t(false, "unexpected error type during allowErrors()");
        }
    }
    
    // Check whether the selector is a require failure e.g.: require(false, "error message");
    function _isErrorString(bytes4 selector) internal pure returns (bool) {
        // 0x08c379a0 is the selector for "Error(string)" which is the error type for require(...) failure
        return selector == 0x08c379a0;
    }
    
    function _handleEmptyError(bool allowEmptyError) internal {
        t(allowEmptyError, "Becareful! It could be require or revert failure without message but also it could be something else such as calling non-existing address address(0xdead). The root-cause could be various. Please check the code and the context.");
    }
    
    // check whether the errorData is an expected failure by checking the error message
    function _allowRequireFailure(
        bytes memory errorData,
        string[] memory allowedRequireErrorMessages
    ) internal {
        // remove the first 4 bytes which is the selector of the error
        bytes memory strippedData = new bytes(errorData.length - 4);
        
        for (uint i = 0; i < errorData.length - 4; i++) {
            strippedData[i] = errorData[i + 4];
        }
    
        bool allowed = false;
    
        for (uint256 i = 0; i < allowedRequireErrorMessages.length; i++) {
            if (keccak256(strippedData) == keccak256(abi.encode(allowedRequireErrorMessages[i]))) {
                allowed = true;
                break;
            }
        }
    
        string memory errorMsg = _convertToErrorMessage(strippedData);
        t(allowed, errorMsg);
    }
    
    function _convertToErrorMessage(bytes memory strippedData) internal pure returns (string memory) {
        if (strippedData.length == 0) {
            return "unknown error";
        }
        
        return abi.decode(strippedData, (string));
    }
}
