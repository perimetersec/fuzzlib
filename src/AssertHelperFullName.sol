// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AssertHelper.sol";

/// @author Based on Crytic PropertiesHelper (https://github.com/crytic/properties/blob/main/contracts/util/PropertiesHelper.sol)
/// @notice This contract can be used for compatibility with the Crytic PropertiesHelper API
abstract contract AssertHelperFullName is AssertHelper {
    function assertWithMsg(bool b, string memory reason) internal {
        t(b, reason);
    }

    function assertEq(uint256 a, uint256 b, string memory reason) internal {
        eq(a, b, reason);
    }

    function assertEq(int256 a, int256 b, string memory reason) internal {
        eq(a, b, reason);
    }

    function assertEq(bytes4 a, bytes4 b, string memory reason) internal {
        eq(a, b, reason);
    }

    function assertNeq(uint256 a, uint256 b, string memory reason) internal {
        neq(a, b, reason);
    }

    function assertNeq(int256 a, int256 b, string memory reason) internal {
        neq(a, b, reason);
    }

    function assertGt(uint256 a, uint256 b, string memory reason) internal {
        gt(a, b, reason);
    }

    function assertGt(int256 a, int256 b, string memory reason) internal {
        gt(a, b, reason);
    }

    function assertGte(uint256 a, uint256 b, string memory reason) internal {
        gte(a, b, reason);
    }

    function assertGte(int256 a, int256 b, string memory reason) internal {
        gte(a, b, reason);
    }

    function assertLt(uint256 a, uint256 b, string memory reason) internal {
        lt(a, b, reason);
    }

    function assertLt(int256 a, int256 b, string memory reason) internal {
        lt(a, b, reason);
    }

    function assertLte(uint256 a, uint256 b, string memory reason) internal {
        lte(a, b, reason);
    }

    function assertLte(int256 a, int256 b, string memory reason) internal {
        lte(a, b, reason);
    }

    function assertErrorsAllowed(
        bytes4 errorSelector,
        bytes4[] memory allowedErrors,
        string memory message
    ) internal {
        errAllow(errorSelector, allowedErrors, message);
    }

    function assertErrorsAllowedMultiMsg(
        bytes4 errorSelector,
        bytes4[] memory allowedErrors,
        string[] memory message
    ) internal {
        errsAllow(errorSelector, allowedErrors, message);
    }
}
