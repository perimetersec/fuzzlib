// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import {Constants} from "./Constants.sol";

/**
 * @dev Available cheat codes for Medusa.
 * Documentation: https://github.com/crytic/medusa/tree/dev/mdbook/docs/src/cheatcodes
 * Usage: https://github.com/crytic/medusa/blob/dev/mdbook/docs/src/cheatcodes_overview.md
 * @author Perimeter <info@perimetersec.io>
 */
interface IStdCheats {
    /**
     * @dev Set block.timestamp
     */
    function warp(uint256 x) external;

    /**
     * @dev Set block.number
     */
    function roll(uint256 x) external;

    /**
     * @dev Set block.basefee
     */
    function fee(uint256 x) external;

    /**
     * @dev Set block.difficulty and block.prevrandao
     */
    function difficulty(uint256 x) external;

    /**
     * @dev Set block.chainid
     */
    function chainId(uint256 x) external;

    /**
     * @dev Sets the block.coinbase
     */
    function coinbase(address x) external;

    /**
     * @dev Loads a storage slot from an address
     */
    function load(address account, bytes32 slot) external returns (bytes32);

    /**
     * @dev Stores a value to an address' storage slot
     */
    function store(address account, bytes32 slot, bytes32 value) external;

    /**
     * @dev Sets the *next* call's msg.sender to be the input address
     */
    function prank(address sender) external;

    /**
     * @dev Set msg.sender to the input address until the current call exits
     */
    function prankHere(address sender) external;

    /**
     * @dev Sets an address' balance
     */
    function deal(address who, uint256 newBalance) external;

    /**
     * @dev Sets an address' code
     */
    function etch(address who, bytes calldata code) external;

    /**
     * @dev Signs data
     */
    function sign(uint256 privateKey, bytes32 digest) external returns (uint8 v, bytes32 r, bytes32 s);

    /**
     * @dev Computes address for a given private key
     */
    function addr(uint256 privateKey) external returns (address);

    /**
     * @dev Gets the nonce of an account
     */
    function getNonce(address account) external returns (uint64);

    /**
     * @dev Sets the nonce of an account
     * The new nonce must be higher than the current nonce of the account
     */
    function setNonce(address account, uint64 nonce) external;

    /**
     * @dev Performs a foreign function call via terminal
     */
    function ffi(string[] calldata) external returns (bytes memory);

    /**
     * @dev Convert Solidity types to strings
     */
    function toString(address) external returns (string memory);
    function toString(bytes calldata) external returns (string memory);
    function toString(bytes32) external returns (string memory);
    function toString(bool) external returns (string memory);
    function toString(uint256) external returns (string memory);
    function toString(int256) external returns (string memory);

    /**
     * @dev Convert strings into Solidity types
     */
    function parseBytes(string memory) external returns (bytes memory);
    function parseBytes32(string memory) external returns (bytes32);
    function parseAddress(string memory) external returns (address);
    function parseUint(string memory) external returns (uint256);
    function parseInt(string memory) external returns (int256);
    function parseBool(string memory) external returns (bool);
}

// Don't use Constants.ADDRESS_CHEATS to support older Solidity versions
IStdCheats constant vm = IStdCheats(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
