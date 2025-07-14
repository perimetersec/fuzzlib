// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "./HelperBase.sol";

import "../FuzzLibString.sol";

/**
 * @dev Assertion utilities for fuzzing operations.
 * @author Perimeter <info@perimetersec.io>
 * Based on Crytic PropertiesHelper (https://github.com/crytic/properties/blob/main/contracts/util/PropertiesHelper.sol)
 */
abstract contract HelperAssert is HelperBase {
    event AssertFail(string);
    event AssertEqFail(string);
    event AssertNeqFail(string);
    event AssertGteFail(string);
    event AssertGtFail(string);
    event AssertLteFail(string);
    event AssertLtFail(string);

    /**
     * @dev Asserts that a boolean condition is true.
     */
    function t(bool b, string memory reason) public {
        if (!b) {
            emit AssertFail(reason);
            platform.assertFail();
        }
    }

    /**
     * @dev Asserts that two unsigned integers are equal.
     */
    function eq(uint256 a, uint256 b, string memory reason) public {
        if (a != b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "!=", reason);
            emit AssertEqFail(assertMsg);
            platform.assertFail();
        }
    }

    /**
     * @dev Asserts that two signed integers are equal.
     */
    function eq(int256 a, int256 b, string memory reason) public {
        if (a != b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "!=", reason);
            emit AssertEqFail(assertMsg);
            platform.assertFail();
        }
    }

    /**
     * @dev Asserts that two booleans are equal.
     */
    function eq(bool a, bool b, string memory reason) public {
        if (a != b) {
            string memory aStr = a ? "true" : "false";
            string memory bStr = b ? "true" : "false";
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "!=", reason);
            emit AssertEqFail(assertMsg);
            platform.assertFail();
        }
    }

    /**
     * @dev Asserts that two addresses are equal.
     */
    function eq(address a, address b, string memory reason) public {
        if (a != b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "!=", reason);
            emit AssertEqFail(assertMsg);
            platform.assertFail();
        }
    }

    /**
     * @dev Asserts that two bytes4 values are equal.
     */
    function eq(bytes4 a, bytes4 b, string memory reason) public {
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

    /**
     * @dev Asserts that two unsigned integers are not equal.
     */
    function neq(uint256 a, uint256 b, string memory reason) public {
        if (a == b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "==", reason);
            emit AssertNeqFail(assertMsg);
            platform.assertFail();
        }
    }

    /**
     * @dev Asserts that two signed integers are not equal.
     */
    function neq(int256 a, int256 b, string memory reason) public {
        if (a == b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "==", reason);
            emit AssertNeqFail(assertMsg);
            platform.assertFail();
        }
    }

    /**
     * @dev Asserts that first unsigned integer is greater than or equal to second.
     */
    function gte(uint256 a, uint256 b, string memory reason) public {
        if (!(a >= b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "<", reason);
            emit AssertGteFail(assertMsg);
            platform.assertFail();
        }
    }

    /**
     * @dev Asserts that first signed integer is greater than or equal to second.
     */
    function gte(int256 a, int256 b, string memory reason) public {
        if (!(a >= b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "<", reason);
            emit AssertGteFail(assertMsg);
            platform.assertFail();
        }
    }

    /**
     * @dev Asserts that first unsigned integer is greater than second.
     */
    function gt(uint256 a, uint256 b, string memory reason) public {
        if (!(a > b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "<=", reason);
            emit AssertGtFail(assertMsg);
            platform.assertFail();
        }
    }

    /**
     * @dev Asserts that first signed integer is greater than second.
     */
    function gt(int256 a, int256 b, string memory reason) public {
        if (!(a > b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, "<=", reason);
            emit AssertGtFail(assertMsg);
            platform.assertFail();
        }
    }

    /**
     * @dev Asserts that first unsigned integer is less than or equal to second.
     */
    function lte(uint256 a, uint256 b, string memory reason) public {
        if (!(a <= b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, ">", reason);
            emit AssertLteFail(assertMsg);
            platform.assertFail();
        }
    }

    /**
     * @dev Asserts that first signed integer is less than or equal to second.
     */
    function lte(int256 a, int256 b, string memory reason) public {
        if (!(a <= b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, ">", reason);
            emit AssertLteFail(assertMsg);
            platform.assertFail();
        }
    }

    /**
     * @dev Asserts that first unsigned integer is less than second.
     */
    function lt(uint256 a, uint256 b, string memory reason) public {
        if (!(a < b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, ">=", reason);
            emit AssertLtFail(assertMsg);
            platform.assertFail();
        }
    }

    /**
     * @dev Asserts that first signed integer is less than second.
     */
    function lt(int256 a, int256 b, string memory reason) public {
        if (!(a < b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            string memory assertMsg = createAssertFailMessage(aStr, bStr, ">=", reason);
            emit AssertLtFail(assertMsg);
            platform.assertFail();
        }
    }

    /**
     * @dev Asserts that revert reason is not equal to expected reason.
     */
    function assertRevertReasonNotEqual(bytes memory returnData, string memory reason) public {
        bool isEqual = FuzzLibString.isRevertReasonEqual(returnData, reason);
        t(!isEqual, reason);
    }

    /**
     * @dev Asserts that revert reason equals expected reason.
     */
    function assertRevertReasonEqual(bytes memory returnData, string memory reason) public {
        bool isEqual = FuzzLibString.isRevertReasonEqual(returnData, reason);
        t(isEqual, reason);
    }

    /**
     * @dev Asserts that revert reason equals one of two expected reasons.
     */
    function assertRevertReasonEqual(bytes memory returnData, string memory reason1, string memory reason2) public {
        bool isEqual = FuzzLibString.isRevertReasonEqual(returnData, reason1)
            || FuzzLibString.isRevertReasonEqual(returnData, reason2);
        string memory assertMsg = string(abi.encodePacked(reason1, " OR ", reason2));
        t(isEqual, assertMsg);
    }

    /**
     * @dev Asserts that revert reason equals one of three expected reasons.
     */
    function assertRevertReasonEqual(
        bytes memory returnData,
        string memory reason1,
        string memory reason2,
        string memory reason3
    ) public {
        bool isEqual = FuzzLibString.isRevertReasonEqual(returnData, reason1)
            || FuzzLibString.isRevertReasonEqual(returnData, reason2)
            || FuzzLibString.isRevertReasonEqual(returnData, reason3);
        string memory assertMsg = string(abi.encodePacked(reason1, " OR ", reason2, " OR ", reason3));
        t(isEqual, assertMsg);
    }

    /**
     * @dev Asserts that revert reason equals one of four expected reasons.
     */
    function assertRevertReasonEqual(
        bytes memory returnData,
        string memory reason1,
        string memory reason2,
        string memory reason3,
        string memory reason4
    ) public {
        bool isEqual = FuzzLibString.isRevertReasonEqual(returnData, reason1)
            || FuzzLibString.isRevertReasonEqual(returnData, reason2)
            || FuzzLibString.isRevertReasonEqual(returnData, reason3)
            || FuzzLibString.isRevertReasonEqual(returnData, reason4);
        string memory assertMsg = string(abi.encodePacked(reason1, " OR ", reason2, " OR ", reason3, " OR ", reason4));
        t(isEqual, assertMsg);
    }

    /**
     * @dev Creates a formatted assertion failure message.
     */
    function createAssertFailMessage(
        string memory aStr,
        string memory bStr,
        string memory operator,
        string memory reason
    ) internal pure returns (string memory) {
        return string(abi.encodePacked("Invalid: ", aStr, operator, bStr, ", reason: ", reason));
    }

    /**
     * @dev Allows only specified custom errors by checking the error selector.
     * @param errorSelector The 4-byte selector of the custom error that occurred
     * @param allowedErrors Array of allowed custom error selectors
     * @param message Context message for assertion failure
     */
    function errAllow(bytes4 errorSelector, bytes4[] memory allowedErrors, string memory message) public {
        bool allowed = false;
        for (uint256 i = 0; i < allowedErrors.length; i++) {
            if (errorSelector == allowedErrors[i]) {
                allowed = true;
                break;
            }
        }
        t(allowed, message);
    }
    /**
     * @dev Allows only specified require failure messages by extracting and comparing error strings.
     * @param errorData Raw error data from failed function call
     * @param allowedRequireErrorMessages Array of allowed require failure message strings
     * @param errorContext Context message for assertion failure
     */

    function errAllow(bytes memory errorData, string[] memory allowedRequireErrorMessages, string memory errorContext)
        public
    {
        // space for error message without selector (4 bytes)
        bytes memory strippedData = new bytes(errorData.length - 4);
        assembly {
            // calculate the memory position of strippedData
            let strippedDataPtr := add(strippedData, 32)
            // calculate the memory position of errorData (4 bytes for selector)
            let errorDataPtr := add(add(errorData, 32), 4)
            // calculate the data length
            let dataLength := sub(mload(errorData), 4)
            // copy the data
            // strippedDataPtr: memory position of where to copy the data
            // errorDataPtr: memory position of what to copy
            // dataLength: length of the data to copy
            mcopy(strippedDataPtr, errorDataPtr, dataLength)

            // now "strippedData" is the error message (string) without selector
        }

        // extract the string from the remaining data
        string memory decodedString = abi.decode(strippedData, (string));

        // compare with allowedRequireErrorMessages
        bool allowed = false;
        for (uint256 i = 0; i < allowedRequireErrorMessages.length; i++) {
            if (keccak256(abi.encode(decodedString)) == keccak256(abi.encode(allowedRequireErrorMessages[i]))) {
                allowed = true;
                break;
            }
        }

        t(allowed, errorContext);
    }

    /**
     * @dev Allows specified require failures and custom errors by automatically detecting error type.
     * @param errorData Raw error data from failed function call
     * @param allowedRequireErrorMessages Array of allowed require failure message strings
     * @param allowedCustomErrors Array of allowed custom error selectors
     * @param errorContext Context message for assertion failure
     */
    function errAllow(
        bytes memory errorData,
        string[] memory allowedRequireErrorMessages,
        bytes4[] memory allowedCustomErrors,
        string memory errorContext
    ) public {
        bytes4 selector = bytes4(errorData);

        if (_isErrorString(selector)) {
            // 1. require failure case (ex: require(false, "error message"))
            errAllow(errorData, allowedRequireErrorMessages, errorContext);
        } else {
            // 2. custom error case (ex: MyCustomError())
            errAllow(selector, allowedCustomErrors, errorContext);
        }
    }

    /**
     * @dev Checks whether the selector is a require failure.
     */
    function _isErrorString(bytes4 selector) internal pure returns (bool) {
        // 0x08c379a0 is the selector for "Error(string)" which is the error type for require(...) failure
        return selector == 0x08c379a0;
    }
}
