// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibLog} from "../libraries/LibLog.sol";

/**
 * @dev Logging utilities for fuzzing operations.
 * @author Perimeter <info@perimetersec.io>
 */
abstract contract HelperLog {
    /**
     * @dev Logs a message.
     */
    function log(string memory message) public {
        LibLog.log(message);
    }

    /**
     * @dev Logs a message with string data.
     */
    function log(string memory message, string memory data) public {
        LibLog.log(message, data);
    }

    /**
     * @dev Logs a message with bytes data.
     */
    function log(string memory message, bytes memory data) public {
        LibLog.log(message, data);
    }

    /**
     * @dev Logs a message with uint256 data.
     */
    function log(string memory message, uint256 data) public {
        LibLog.log(message, data);
    }

    /**
     * @dev Logs a message with int256 data.
     */
    function log(string memory message, int256 data) public {
        LibLog.log(message, data);
    }

    /**
     * @dev Logs a message with address data.
     */
    function log(string memory message, address data) public {
        LibLog.log(message, data);
    }

    /**
     * @dev Logs a message with boolean data.
     */
    function log(string memory message, bool data) public {
        LibLog.log(message, data);
    }

    /**
     * @dev Logs a message with bytes32 data.
     */
    function log(string memory message, bytes32 data) public {
        LibLog.log(message, data);
    }

    /**
     * @dev Logs a failure event.
     */
    function logFail() public {
        LibLog.logFail();
    }

    /**
     * @dev Logs a failure event with a message.
     */
    function logFail(string memory message) public {
        LibLog.logFail(message);
    }

    /**
     * @dev Logs a failure event with a message and string data.
     */
    function logFail(string memory message, string memory data) public {
        LibLog.logFail(message, data);
    }

    /**
     * @dev Logs a failure event with a message and bytes data.
     */
    function logFail(string memory message, bytes memory data) public {
        LibLog.logFail(message, data);
    }

    /**
     * @dev Logs a failure event with a message and uint256 data.
     */
    function logFail(string memory message, uint256 data) public {
        LibLog.logFail(message, data);
    }

    /**
     * @dev Logs a failure event with a message and int256 data.
     */
    function logFail(string memory message, int256 data) public {
        LibLog.logFail(message, data);
    }

    /**
     * @dev Logs a failure event with a message and address data.
     */
    function logFail(string memory message, address data) public {
        LibLog.logFail(message, data);
    }

    /**
     * @dev Logs a failure event with a message and boolean data.
     */
    function logFail(string memory message, bool data) public {
        LibLog.logFail(message, data);
    }

    /**
     * @dev Logs a failure event with a message and bytes32 data.
     */
    function logFail(string memory message, bytes32 data) public {
        LibLog.log(message, data);
    }
}
