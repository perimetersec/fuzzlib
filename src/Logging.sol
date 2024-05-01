// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibLogging} from "./libraries/LibLogging.sol";

abstract contract Logging {
    function log(string memory message) internal {
        LibLogging.log(message);
    }

    function log(string memory message, string memory data) internal {
        LibLogging.log(message, data);
    }

    function log(string memory message, bytes memory data) internal {
        LibLogging.log(message, data);
    }

    function log(string memory message, uint256 data) internal {
        LibLogging.log(message, data);
    }

    function log(string memory message, int256 data) internal {
        LibLogging.log(message, data);
    }

    function log(string memory message, address data) internal {
        LibLogging.log(message, data);
    }

    function log(string memory message, bool data) internal {
        LibLogging.log(message, data);
    }

    function logFail() internal {
        LibLogging.logFail();
    }

    function logFail(string memory message) internal {
        LibLogging.logFail(message);
    }

    function logFail(string memory message, string memory data) internal {
        LibLogging.logFail(message, data);
    }

    function logFail(string memory message, bytes memory data) internal {
        LibLogging.logFail(message, data);
    }

    function logFail(string memory message, uint256 data) internal {
        LibLogging.logFail(message, data);
    }

    function logFail(string memory message, int256 data) internal {
        LibLogging.logFail(message, data);
    }

    function logFail(string memory message, address data) internal {
        LibLogging.logFail(message, data);
    }

    function logFail(string memory message, bool data) internal {
        LibLogging.logFail(message, data);
    }
}
