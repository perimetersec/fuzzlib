// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract HelperCall {
    // Private temporary vm to remain unopinionated from naming clashes
    IPrank constant private tempvm = IPrank(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    function doFunctionCall(address target, bytes memory callData)
        public
        payable
        returns (bool success, bytes memory returnData)
    {
        (success, returnData) = target.call{value: msg.value}(callData);
    }

    function doFunctionCall(address target, bytes memory callData, address actor)
        public
        payable
        returns (bool success, bytes memory returnData)
    {
        tempvm.prank(actor);
        (success, returnData) = target.call{value: msg.value}(callData);
    }

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
