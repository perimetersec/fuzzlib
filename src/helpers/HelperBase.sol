// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import {IPlatform} from "../platform/IPlatform.sol";

/**
 * @dev Base contract for platform management and core functionality.
 * @author Perimeter <info@perimetersec.io>
 */
contract HelperBase {
    IPlatform public platform;

    /**
     * @dev Sets the platform implementation for fuzzing operations.
     */
    function setPlatform(address _platform) public {
        platform = IPlatform(_platform);
    }
}
