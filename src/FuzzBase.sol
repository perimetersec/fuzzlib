// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import {Fuzzlib} from "./Fuzzlib.sol";
import {PlatformCrytic} from "./platform/PlatformCrytic.sol";

/**
 * @dev Abstract base contract that users extend for fuzzing harnesses.
 * Automatically sets up Fuzzlib with Crytic platform and provides access through the fl instance.
 * @author Perimeter <info@perimetersec.io>
 */
abstract contract FuzzBase {
    /**
     * @dev Fuzzlib instance providing access to all fuzzing utilities.
     */
    Fuzzlib internal fl = new Fuzzlib();

    /**
     * @dev Sets up the Fuzzlib instance with the Crytic platform.
     */
    constructor() {
        fl.setPlatform(address(new PlatformCrytic()));
    }
}
