// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Dummy target contract for Echidna E2E testing.
 * Provides essential functions for testing HelperCall functionality.
 * @author Perimeter <info@perimetersec.io>
 */
contract DummyTarget {
    uint256 internal storedValue;
    string internal storedString;
    bool internal storedBool;
    address internal lastMsgSender;

    /**
     * @dev Simple getter function that returns stored value.
     */
    function getValue() public view returns (uint256) {
        return storedValue;
    }

    /**
     * @dev Setter function that updates stored value.
     */
    function setValue(uint256 newValue) public {
        storedValue = newValue;
        lastMsgSender = msg.sender;
    }

    /**
     * @dev Function that returns multiple values.
     */
    function getMultipleValues() public view returns (uint256, string memory, bool) {
        return (storedValue, storedString, storedBool);
    }

    /**
     * @dev Function that sets multiple values.
     */
    function setMultipleValues(uint256 _value, string memory _str, bool _flag) public {
        storedValue = _value;
        storedString = _str;
        storedBool = _flag;
        lastMsgSender = msg.sender;
    }

    /**
     * @dev Returns the last message sender.
     */
    function getLastMsgSender() public view returns (address) {
        return lastMsgSender;
    }
}