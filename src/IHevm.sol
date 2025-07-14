// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import {Constants} from "./Constants.sol";

/**
 * @dev Interface for Hevm cheat codes.
 * @author Perimeter <info@perimetersec.io>
 */
interface IHevm {
    /**
     * @dev Set block.timestamp to newTimestamp
     */
    function warp(uint256 newTimestamp) external;

    /**
     * @dev Set block.number to newNumber
     */
    function roll(uint256 newNumber) external;

    /**
     * @dev Add the condition b to the assumption base for the current branch
     * This function is almost identical to require
     */
    function assume(bool b) external;

    /**
     * @dev Sets the eth balance of usr to amt
     */
    function deal(address usr, uint256 amt) external;

    /**
     * @dev Loads a storage slot from an address
     */
    function load(address where, bytes32 slot) external returns (bytes32);

    /**
     * @dev Stores a value to an address' storage slot
     */
    function store(address where, bytes32 slot, bytes32 value) external;

    /**
     * @dev Signs data (privateKey, digest) => (v, r, s)
     */
    function sign(uint256 privateKey, bytes32 digest) external returns (uint8 v, bytes32 r, bytes32 s);

    /**
     * @dev Gets address for a given private key
     */
    function addr(uint256 privateKey) external returns (address addr);

    /**
     * @dev Performs a foreign function call via terminal
     */
    function ffi(string[] calldata inputs) external returns (bytes memory result);

    /**
     * @dev Performs the next smart contract call with specified `msg.sender`
     */
    function prank(address newSender) external;

    /**
     * @dev Creates a new fork with the given endpoint and the latest block and returns the identifier of the fork
     */
    function createFork(string calldata urlOrAlias) external returns (uint256);

    /**
     * @dev Takes a fork identifier created by createFork and sets the corresponding forked state as active
     */
    function selectFork(uint256 forkId) external;

    /**
     * @dev Returns the identifier of the current fork
     */
    function activeFork() external returns (uint256);

    /**
     * @dev Labels the address in traces
     */
    function label(address addr, string calldata label) external;
}

// Don't use Constants.ADDRESS_CHEATS to support older Solidity versions
IHevm constant vm = IHevm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
