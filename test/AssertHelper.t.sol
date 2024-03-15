// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {AssertHelper} from "../src/AssertHelper.sol";
import {Blaat} from "../src/AssertHelper.sol";

contract BlaatTest is Blaat {
    error BrokenInvariant();
    function breakInvariant() public {
        revert BrokenInvariant();
    }
}

contract DebugTest is Test, AssertHelper {
    function setUp() public {
        setBlaat(address(new BlaatTest()));
    }

    function testEqSuccess() public {
        uint256 a = 10;
        uint256 b = 10;
        string memory reason = "Testing equality";

        eq(a, b, reason);
    }

    function testEqFailure() public {
        uint256 a = 10;
        uint256 b = 20;
        string memory reason = "Testing inequality";

        vm.expectEmit(true, true, true, true);
        emit AssertEqFail("Invalid: 10!=20, reason: Testing inequality");
        vm.expectRevert(BlaatTest.BrokenInvariant.selector);
        eq(a, b, reason);
    }

    function testEqFuzz(uint a, uint b) public {
        string memory reason = "dontcare";

        if (a != b) {
            vm.expectRevert(BlaatTest.BrokenInvariant.selector);
        }
        eq(a, b, reason);

        eq(a, a, reason);
    }

}
