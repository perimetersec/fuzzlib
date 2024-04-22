// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./FuzzLibString.sol";

interface Blaat {
    function breakInvariant() external;
}

/// @author Based on Crytic PropertiesHelper (https://github.com/crytic/properties/blob/main/contracts/util/PropertiesHelper.sol)
abstract contract AssertHelper {
    event AssertFail(string);
    event AssertEqFail(string);
    event AssertNeqFail(string);
    event AssertGteFail(string);
    event AssertGtFail(string);
    event AssertLteFail(string);
    event AssertLtFail(string);

    Blaat blaat;

    function setBlaat(address _blaat) internal {
        blaat = Blaat(_blaat);
    }

    function breakInvariant() internal {
        blaat.breakInvariant();
    }

    /// @notice asserts that a is true. Violations are logged using reason.
    function t(bool a, string memory reason) internal {
        if (!a) {
            emit AssertFail(reason);
            // assert(false);
            breakInvariant();
        }
    }

    /// @notice asserts that a is equal to b. Violations are logged using reason.
    function eq(uint256 a, uint256 b, string memory reason) internal {
        if (a != b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                "!=",
                bStr,
                ", reason: ",
                reason
            );
            emit AssertEqFail(string(assertMsg));
            // assert(false);
            breakInvariant();
        }
    }

    /// @notice int256 version of `eq`
    function eq(int256 a, int256 b, string memory reason) internal {
        if (a != b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                "!=",
                bStr,
                ", reason: ",
                reason
            );
            emit AssertEqFail(string(assertMsg));
            // assert(false);
            breakInvariant();
        }
    }

    /// @notice bytes4 version of `eq`
    function eq(bytes4 a, bytes4 b, string memory reason) internal {
        if (a != b) {
            bytes memory aBytes = abi.encodePacked(a);
            bytes memory bBytes = abi.encodePacked(b);
            string memory aStr = FuzzLibString.toHexString(aBytes);
            string memory bStr = FuzzLibString.toHexString(bBytes);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                "!=",
                bStr,
                ", reason: ",
                reason
            );
            emit AssertEqFail(string(assertMsg));
            // assert(false);
            breakInvariant();
        }
    }

    /// @notice asserts that a is not equal to b. Violations are logged using reason.
    function neq(uint256 a, uint256 b, string memory reason) internal {
        if (a == b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                "==",
                bStr,
                ", reason: ",
                reason
            );
            emit AssertNeqFail(string(assertMsg));
            // assert(false);
            breakInvariant();
        }
    }

    /// @notice int256 version of `neq`
    function neq(int256 a, int256 b, string memory reason) internal {
        if (a == b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                "==",
                bStr,
                ", reason: ",
                reason
            );
            emit AssertNeqFail(string(assertMsg));
            // assert(false);
            breakInvariant();
        }
    }

    /// @notice asserts that a is greater than b. Violations are logged using reason.
    function gt(uint256 a, uint256 b, string memory reason) internal {
        if (!(a > b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                "<=",
                bStr,
                " failed, reason: ",
                reason
            );
            emit AssertGtFail(string(assertMsg));
            // assert(false);
            breakInvariant();
        }
    }

    /// @notice int256 version of `gt`
    function gt(int256 a, int256 b, string memory reason) internal {
        if (!(a > b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                "<=",
                bStr,
                " failed, reason: ",
                reason
            );
            emit AssertGtFail(string(assertMsg));
            // assert(false);
            breakInvariant();
        }
    }

    /// @notice asserts that a is greater than or equal to b. Violations are logged using reason.
    function gte(uint256 a, uint256 b, string memory reason) internal {
        if (!(a >= b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                "<",
                bStr,
                " failed, reason: ",
                reason
            );
            emit AssertGteFail(string(assertMsg));
            // assert(false);
            breakInvariant();
        }
    }

    /// @notice int256 version of assertGte
    function gte(int256 a, int256 b, string memory reason) internal {
        if (!(a >= b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                "<",
                bStr,
                " failed, reason: ",
                reason
            );
            emit AssertGteFail(string(assertMsg));
            // assert(false);
            breakInvariant();
        }
    }

    /// @notice asserts that a is less than b. Violations are logged using reason.
    function lt(uint256 a, uint256 b, string memory reason) internal {
        if (!(a < b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                ">=",
                bStr,
                " failed, reason: ",
                reason
            );
            emit AssertLtFail(string(assertMsg));
            // assert(false);
            breakInvariant();
        }
    }

    /// @notice int256 version of assertLt
    function lt(int256 a, int256 b, string memory reason) internal {
        if (!(a < b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                ">=",
                bStr,
                " failed, reason: ",
                reason
            );
            emit AssertLtFail(string(assertMsg));
            // assert(false);
            breakInvariant();
        }
    }

    /// @notice asserts that a is less than or equal to b. Violations are logged using reason.
    function lte(uint256 a, uint256 b, string memory reason) internal {
        if (!(a <= b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                ">",
                bStr,
                " failed, reason: ",
                reason
            );
            emit AssertLteFail(string(assertMsg));
            // assert(false);
            breakInvariant();
        }
    }

    /// @notice int256 version of assertLte
    function lte(int256 a, int256 b, string memory reason) internal {
        if (!(a <= b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                ">",
                bStr,
                " failed, reason: ",
                reason
            );
            emit AssertLteFail(string(assertMsg));
            // assert(false);
            breakInvariant();
        }
    }

    function assertRevertReasonNotEqual(
        bytes memory returnData,
        string memory reason
    ) internal {
        bool isEqual = FuzzLibString.isRevertReasonEqual(returnData, reason);
        t(!isEqual, reason);
    }

    function assertRevertReasonEqual(
        bytes memory returnData,
        string memory reason
    ) internal {
        bool isEqual = FuzzLibString.isRevertReasonEqual(returnData, reason);
        t(isEqual, reason);
    }

    function assertRevertReasonEqual(
        bytes memory returnData,
        string memory reason1,
        string memory reason2
    ) internal {
        bool isEqual = FuzzLibString.isRevertReasonEqual(returnData, reason1) ||
            FuzzLibString.isRevertReasonEqual(returnData, reason2);
        t(isEqual, string.concat(reason1, " OR ", reason2));
    }

    function assertRevertReasonEqual(
        bytes memory returnData,
        string memory reason1,
        string memory reason2,
        string memory reason3
    ) internal {
        bool isEqual = FuzzLibString.isRevertReasonEqual(returnData, reason1) ||
            FuzzLibString.isRevertReasonEqual(returnData, reason2) ||
            FuzzLibString.isRevertReasonEqual(returnData, reason3);
        t(isEqual, string.concat(reason1, " OR ", reason2, " OR ", reason3));
    }

    function assertRevertReasonEqual(
        bytes memory returnData,
        string memory reason1,
        string memory reason2,
        string memory reason3,
        string memory reason4
    ) internal {
        bool isEqual = FuzzLibString.isRevertReasonEqual(returnData, reason1) ||
            FuzzLibString.isRevertReasonEqual(returnData, reason2) ||
            FuzzLibString.isRevertReasonEqual(returnData, reason3) ||
            FuzzLibString.isRevertReasonEqual(returnData, reason4);
        t(
            isEqual,
            string.concat(
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
        assertWithMsg(isEqual, assertMsg);
    }

    function assertErrorsAllowed(
        bytes4 errorSelector,
        bytes4[] memory allowedErrors,
        string memory message
    ) internal {
        bool allowed = false;
        for (uint256 i = 0; i < allowedErrors.length; i++) {
            if (errorSelector == allowedErrors[i]) {
                allowed = true;
                break;
            }
        }
        assertWithMsg(allowed, message);
    }

    function assertErrorsAllowedMultiMsg(
        bytes4 errorSelector,
        bytes4[] memory allowedErrors,
        string[] memory messages
    ) internal {
        bool allowed = false;
        uint256 passIndex = 0;
        for (uint256 i = 0; i < allowedErrors.length; i++) {
            if (errorSelector == allowedErrors[i]) {
                allowed = true;
                passIndex = i;
                break;
            }
        }
        assertWithMsg(allowed, messages[passIndex]);
    }
}
