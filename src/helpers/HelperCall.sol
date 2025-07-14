// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

/**
 * @dev Function call utilities for fuzzing operations.
 * @author Perimeter <info@perimetersec.io>
 */
abstract contract HelperCall {
    // Private temporary vm to remain unopinionated from naming clashes
    IPrank private constant tempvm = IPrank(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    /**
     * @dev Executes a function call with msg.sender as the caller.
     */
    function doFunctionCall(address target, bytes memory callData)
        public
        payable
        returns (bool success, bytes memory returnData)
    {
        tempvm.prank(msg.sender);
        (success, returnData) = target.call{value: msg.value}(callData);
    }

    /**
     * @dev Executes a function call with a specified actor as the caller.
     */
    function doFunctionCall(address target, bytes memory callData, address actor)
        public
        payable
        returns (bool success, bytes memory returnData)
    {
        tempvm.prank(actor);
        (success, returnData) = target.call{value: msg.value}(callData);
    }

    /**
     * @dev Executes a read-only function call without state changes.
     */
    function doFunctionStaticCall(address target, bytes memory callData)
        public
        view
        returns (bool success, bytes memory returnData)
    {
        (success, returnData) = target.staticcall(callData);
    }
}

interface IPrank {
    function prank(address actor) external;
}
