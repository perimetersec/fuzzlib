// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Logging {
    event Log(string debugString);
    event Log(string description, string data);
    event Log(string prefix, string description, string data);
    event Log(string description, bytes32 data);
    event Log(string prefix, string description, bytes32 data);
    event Log(string description, uint256 data);
    event Log(string prefix, string description, uint256 data);
    event Log(string description, int256 data);
    event Log(string prefix, string description, int256 data);
    event Log(string description, address data);
    event Log(string prefix, string description, address data);
    event Log(string description, bool data);
    event Log(string prefix, string description, bool data);

    function log(string memory debugString) internal {
        emit Log(debugString);
    }

    function log(string memory description, string memory data) internal {
        emit Log(description, data);
    }

    function log(
        string memory prefix,
        string memory description,
        string memory data
    ) internal {
        emit Log(prefix, description, data);
    }

    function log(string memory description, bytes32 data) internal {
        emit Log(description, data);
    }

    function log(
        string memory prefix,
        string memory description,
        bytes32 data
    ) internal {
        emit Log(prefix, description, data);
    }

    function log(string memory description, uint256 data) internal {
        emit Log(description, data);
    }

    function log(
        string memory prefix,
        string memory description,
        uint256 data
    ) internal {
        emit Log(prefix, description, data);
    }

    function log(string memory description, int256 data) internal {
        emit Log(description, data);
    }

    function log(
        string memory prefix,
        string memory description,
        int256 data
    ) internal {
        emit Log(prefix, description, data);
    }

    function log(string memory description, address data) internal {
        emit Log(description, data);
    }

    function log(
        string memory prefix,
        string memory description,
        address data
    ) internal {
        emit Log(prefix, description, data);
    }

    function log(string memory description, bool data) internal {
        emit Log(description, data);
    }

    function log(
        string memory prefix,
        string memory description,
        bool data
    ) internal {
        emit Log(prefix, description, data);
    }
}
