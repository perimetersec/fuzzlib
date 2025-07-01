// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Library for emitting log events in fuzzing operations.
 * @author Perimeter <info@perimetersec.io>
 */
library LibLog {
    event Log(string message);
    event LogString(string message, string data);
    event LogBytes(string message, bytes data);
    event LogUint(string message, uint256 data);
    event LogInt(string message, int256 data);
    event LogAddress(string message, address data);
    event LogBool(string message, bool data);
    event LogBytes32(string message, bytes32 data);

    event AssertionFailed();
    event AssertionFailed(string message);
    event AssertionFailed(string message, string data);
    event AssertionFailed(string message, bytes data);
    event AssertionFailed(string message, uint256 data);
    event AssertionFailed(string message, int256 data);
    event AssertionFailed(string message, address data);
    event AssertionFailed(string message, bool data);

    /**
     * @dev Emits a log event with a message.
     */
    function log(string memory message) internal {
        emit Log(message);
    }

    /**
     * @dev Emits a log event with a message and string data.
     */
    function log(string memory message, string memory data) internal {
        emit LogString(message, data);
    }

    /**
     * @dev Emits a log event with a message and bytes data.
     */
    function log(string memory message, bytes memory data) internal {
        emit LogBytes(message, data);
    }

    /**
     * @dev Emits a log event with a message and uint256 data.
     */
    function log(string memory message, uint256 data) internal {
        emit LogUint(message, data);
    }

    /**
     * @dev Emits a log event with a message and int256 data.
     */
    function log(string memory message, int256 data) internal {
        emit LogInt(message, data);
    }

    /**
     * @dev Emits a log event with a message and address data.
     */
    function log(string memory message, address data) internal {
        emit LogAddress(message, data);
    }

    /**
     * @dev Emits a log event with a message and boolean data.
     */
    function log(string memory message, bool data) internal {
        emit LogBool(message, data);
    }

    /**
     * @dev Emits a log event with a message and bytes32 data.
     */
    function log(string memory message, bytes32 data) internal {
        emit LogBytes32(message, data);
    }

    /**
     * @dev Emits an assertion failure event.
     */
    function logFail() internal {
        emit AssertionFailed();
    }

    /**
     * @dev Emits an assertion failure event with a message.
     */
    function logFail(string memory message) internal {
        emit AssertionFailed(message);
    }

    /**
     * @dev Emits an assertion failure event with a message and string data.
     */
    function logFail(string memory message, string memory data) internal {
        emit AssertionFailed(message, data);
    }

    /**
     * @dev Emits an assertion failure event with a message and bytes data.
     */
    function logFail(string memory message, bytes memory data) internal {
        emit AssertionFailed(message, data);
    }

    /**
     * @dev Emits an assertion failure event with a message and uint256 data.
     */
    function logFail(string memory message, uint256 data) internal {
        emit AssertionFailed(message, data);
    }

    /**
     * @dev Emits an assertion failure event with a message and int256 data.
     */
    function logFail(string memory message, int256 data) internal {
        emit AssertionFailed(message, data);
    }

    /**
     * @dev Emits an assertion failure event with a message and address data.
     */
    function logFail(string memory message, address data) internal {
        emit AssertionFailed(message, data);
    }

    /**
     * @dev Emits an assertion failure event with a message and boolean data.
     */
    function logFail(string memory message, bool data) internal {
        emit AssertionFailed(message, data);
    }

    function logFail(string memory message, bytes32 data) internal {
        emit LogBytes32(message, data);
    }
}
