// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IPlatform} from "../../src/platform/IPlatform.sol";

/**
 * @dev Test platform implementation for testing purposes.
 * @author Perimeter <info@perimetersec.io>
 */
contract PlatformTest is IPlatform {
    error TestAssertFail();

    function assertFail() public pure override {
        revert TestAssertFail();
    }
}
