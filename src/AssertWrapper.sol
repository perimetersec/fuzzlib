// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AssertHelper.sol";

abstract contract EchidnaAsserts is AssertHelper {
    function gt(uint256 a, uint256 b, string memory message) internal {
        assertGt(a, b, message);
    }

    function lt(uint256 a, uint256 b, string memory message) internal {
        assertLt(a, b, message);
    }

    function gte(uint256 a, uint256 b, string memory message) internal {
        assertGte(a, b, message);
    }

    function lte(uint256 a, uint256 b, string memory message) internal {
        assertLte(a, b, message);
    }

    function eq(uint256 a, uint256 b, string memory message) internal {
        assertEq(a, b, message);
    }

    function neq(uint256 a, uint256 b, string memory message) internal {
        assertNeq(a, b, message);
    }

    function t(bool a, string memory message) internal {
        assertWithMsg(a, message);
    }
}
