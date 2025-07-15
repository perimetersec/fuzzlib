// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

/**
 * @dev Comprehensive test target contract for HelperCall testing.
 * @author Perimeter <info@perimetersec.io>
 */
contract CallTarget {
    uint256 public value;
    address public lastCaller;
    uint256 public lastValue;

    function setValue(uint256 _value) external payable {
        value = _value;
        lastCaller = msg.sender;
        lastValue = msg.value;
    }

    function getValue() external view returns (uint256) {
        return value;
    }

    function revertingFunction() external pure {
        revert("test revert");
    }

    function requireFailFunction() external pure {
        require(false, "require fail");
    }

    function returnMultiple() external pure returns (uint256, string memory) {
        return (42, "test");
    }

    function returnLargeData() external pure returns (string memory) {
        string memory result = "";
        for (uint256 i = 0; i < 1000; i++) {
            result = string(abi.encodePacked(result, "a"));
        }
        return result;
    }

    function emptyReturn() external pure {
        // Function with no return value
    }

    function returnComplexData() external pure returns (uint256[] memory, string[] memory, bool) {
        uint256[] memory numbers = new uint256[](3);
        numbers[0] = 1;
        numbers[1] = 2;
        numbers[2] = 3;

        string[] memory strings = new string[](2);
        strings[0] = "hello";
        strings[1] = "world";

        return (numbers, strings, true);
    }
}
