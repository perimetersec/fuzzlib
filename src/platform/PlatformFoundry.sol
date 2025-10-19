// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import {IPlatform} from "./IPlatform.sol";

/**
 * @dev Foundry platform implementation for fuzzing operations.
 * @author Perimeter <info@perimetersec.io>
 */
contract PlatformFoundry is IPlatform {
    /**
     * @dev Triggers an assertion failure using assert(false).
     */
    function assertFail() public pure override {
        assert(false);
    }
}
