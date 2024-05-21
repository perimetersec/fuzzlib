// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {HelperAssert} from "../src/helpers/HelperAssert.sol";
import {PlatformTest} from "./util/PlatformTest.sol";

contract TestAsserts is Test, HelperAssert {
    function setUp() public {
        setPlatform(address(new PlatformTest()));
    }

    function test_TFail() public {
        string memory reason = "Testing assertion";

        vm.expectEmit(true, true, true, true);
        emit AssertFail("Testing assertion");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        t(false, reason);
    }

    function test_TSuccess() public {
        string memory reason = "Testing assertion";
        t(true, reason);
    }

    function test_HelperAssert_Ttrue() public {
        //vm.expectRevert();
        t(true, "t reverts for true"); 
    }

    function test_HelperAssert_Tfalse() public {
        //emit AssertEqFail("Testing assertion");
        vm.expectRevert();
        t(false, "t does not revert for true"); 
    }

    function test_HelperAssert_eq_x_x_concrete(uint256 x) public {
        assertEq(x, x,"eq reverts with the concrete values");
    }

    function test_HelperAssert_eq_x_x_fuzz(uint256 x) public {
        assertEq(x, x, "eq does not revert with the fuzz values");
    }

   function test_HelperAssert_eq_x_y_concrete(uint256 x, uint256 y) public {
        vm.assume(x == y);
        assertEq(x, y,"eq reverts with the concrete values");
    } 

    function test_HelperAssert_eq_x_y_fuzz(uint256 x, uint256 y) public {
        vm.assume(x != y);
        vm.expectRevert();
        eq(x,y, "eq does not revert with the fuzz values");
    }
}