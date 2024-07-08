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

}
