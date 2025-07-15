// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

/**
 * @dev Interface defining platform-specific operations for fuzzing tools.
 * @author Perimeter <info@perimetersec.io>
 */
interface IPlatform {
    /**
     * @dev Triggers an assertion failure in the fuzzing platform.
     */
    function assertFail() external pure;
}
