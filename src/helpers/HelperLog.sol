// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibLog} from "../libraries/LibLog.sol";

abstract contract HelperLog {
    function log(string memory message) public {
        LibLog.log(message);
    }

    function log(string memory message, string memory data) public {
        LibLog.log(message, data);
    }

    function log(string memory message, bytes memory data) public {
        LibLog.log(message, data);
    }

    function log(string memory message, uint256 data) public {
        LibLog.log(message, data);
    }

    function log(string memory message, int256 data) public {
        LibLog.log(message, data);
    }

    function log(string memory message, address data) public {
        LibLog.log(message, data);
    }

    function log(string memory message, bool data) public {
        LibLog.log(message, data);
    }

    function log(string memory message, bytes32 data) public {
        LibLog.log(message, data);
    }

    function logFail() public {
        LibLog.logFail();
    }

    function logFail(string memory message) public {
        LibLog.logFail(message);
    }

    function logFail(string memory message, string memory data) public {
        LibLog.logFail(message, data);
    }

    function logFail(string memory message, bytes memory data) public {
        LibLog.logFail(message, data);
    }

    function logFail(string memory message, uint256 data) public {
        LibLog.logFail(message, data);
    }

    function logFail(string memory message, int256 data) public {
        LibLog.logFail(message, data);
    }

    function logFail(string memory message, address data) public {
        LibLog.logFail(message, data);
    }

    function logFail(string memory message, bool data) public {
        LibLog.logFail(message, data);
    }

    function logFail(string memory message, bytes32 data) public {
        LibLog.log(message, data);
    }
}
