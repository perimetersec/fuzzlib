// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract HelperLog {
    event Log(string debugString);
    event LogString(string description, string data);
    event LogString(string prefix, string description, string data);
    event LogBytes(string description, bytes data);
    event LogBytes(string prefix, string description, bytes data);
    event LogUint(string description, uint256 data);
    event LogUint(string prefix, string description, uint256 data);
    event LogInt(string description, int256 data);
    event LogInt(string prefix, string description, int256 data);
    event LogAddress(string description, address data);
    event LogAddress(string prefix, string description, address data);
    event LogBool(string description, bool data);
    event LogBool(string prefix, string description, bool data);
    
    event AssertionFailed();
    event AssertionFailed(string description);
    event AssertionFailed(string description, string data);
    event AssertionFailed(string prefix, string description, string data);
    event AssertionFailed(string description, bytes data);
    event AssertionFailed(string prefix, string description, bytes data);
    event AssertionFailed(string description, uint256 data);
    event AssertionFailed(string prefix, string description, uint256 data);
    event AssertionFailed(string description, int256 data);
    event AssertionFailed(string prefix, string description, int256 data);
    event AssertionFailed(string description, address data);
    event AssertionFailed(string prefix, string description, address data);
    event AssertionFailed(string description, bool data);
    event AssertionFailed(string prefix, string description, bool data);

    function log(string memory debugString) public {
        emit Log(debugString);
    }

    function log(string memory description, string memory data) public {
        emit LogString(description, data);
    }

    function log(
        string memory prefix,
        string memory description,
        string memory data
    ) public {
        emit LogString(prefix, description, data);
    }

    function log(string memory description, bytes memory data) public {
        emit LogBytes(description, data);
    }

    function log(
        string memory prefix,
        string memory description,
        bytes memory data
    ) public {
        emit LogBytes(prefix, description, data);
    }

    function log(string memory description, uint256 data) public {
        emit LogUint(description, data);
    }

    function log(
        string memory prefix,
        string memory description,
        uint256 data
    ) public {
        emit LogUint(prefix, description, data);
    }

    function log(string memory description, int256 data) public {
        emit LogInt(description, data);
    }

    function log(
        string memory prefix,
        string memory description,
        int256 data
    ) public {
        emit LogInt(prefix, description, data);
    }

    function log(string memory description, address data) public {
        emit LogAddress(description, data);
    }

    function log(
        string memory prefix,
        string memory description,
        address data
    ) public {
        emit LogAddress(prefix, description, data);
    }

    function log(string memory description, bool data) public {
        emit LogBool(description, data);
    }

    function log(
        string memory prefix,
        string memory description,
        bool data
    ) public {
        emit LogBool(prefix, description, data);
    }

    function logFail() public {
        emit AssertionFailed();
    }

    function logFail(string memory debugString) public {
        emit AssertionFailed(debugString);
    }

    function logFail(string memory description, string memory data) public {
        emit AssertionFailed(description, data);
    }

    function logFail(
        string memory prefix,
        string memory description,
        string memory data
    ) public {
        emit AssertionFailed(prefix, description, data);
    }

    function logFail(string memory description, bytes memory data) public {
        emit AssertionFailed(description, data);
    }

    function logFail(
        string memory prefix,
        string memory description,
        bytes memory data
    ) public {
        emit AssertionFailed(prefix, description, data);
    }

    function logFail(string memory description, uint256 data) public {
        emit AssertionFailed(description, data);
    }

    function logFail(
        string memory prefix,
        string memory description,
        uint256 data
    ) public {
        emit AssertionFailed(prefix, description, data);
    }

    function logFail(string memory description, int256 data) public {
        emit AssertionFailed(description, data);
    }

    function logFail(
        string memory prefix,
        string memory description,
        int256 data
    ) public {
        emit AssertionFailed(prefix, description, data);
    }

    function logFail(string memory description, address data) public {
        emit AssertionFailed(description, data);
    }

    function logFail(
        string memory prefix,
        string memory description,
        address data
    ) public {
        emit AssertionFailed(prefix, description, data);
    }

    function logFail(string memory description, bool data) public {
        emit AssertionFailed(description, data);
    }

    function logFail(
        string memory prefix,
        string memory description,
        bool data
    ) public {
        emit AssertionFailed(prefix, description, data);
    }
}
