// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * A dummy contract for testing purposes
 */
contract DummyContract {
    error DummyCustomError1();
    error DummyCustomError2(string message);

    function requireFailWithoutMessage() public pure {
        require(false);
    }

    function requireFailWithMessage() public pure {
        require(false, "require failure message 1");
    }

    function revertWithCustomErrorWithoutMessage() public pure {
        revert DummyCustomError1();
    }

    function revertWithCustomErrorWithMessage() public pure {
        revert DummyCustomError2("custom error message");
    }
} 