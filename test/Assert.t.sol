// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "src/FuzzLibString.sol";

import {HelperAssert} from "../src/helpers/HelperAssert.sol";
import {PlatformTest} from "./util/PlatformTest.sol";

contract TestAsserts is Test, HelperAssert {

    function setUp() public {
        setPlatform(address(new PlatformTest()));
    }

    function test_HelperAssert_t_true() public {
        string memory reason = "example message"; 
        t(true, reason); 
    }

    function test_HelperAssert_t_false() public {
        string memory reason = "example message";
        vm.expectEmit(true, false, false, true);
        emit AssertFail(reason); 
        vm.expectRevert(PlatformTest.TestAssertFail.selector);        
        t(false, reason); 
    }

    function test_HelperAssert_eq_x_x_concrete() public {
        uint256 x = 1;
        eq(x, x, "eq does not revert with equal values");
    }

    function testFuzz_HelperAssert_eq_x_x_fuzz(uint256 x) public {
        eq(x, x, "eq does not revert with the fuzz values");
    }

    function test_HelperAssert_eq_x_y_concrete() public {
        uint256 x = 2;
        uint256 y = 4;

        string memory reason = "eq reverts with different values.";
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                "!=",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
        ));
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        eq(x, y, reason);
    }

    function testFuzz_HelperAssert_eq_x_y_fuzz(uint256 x, uint256 y) public {
        vm.assume(x != y);
        string memory reason = "eq reverts with fuzz values.";

        vm.expectEmit(true, false, false, true);
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                "!=",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
            ));
        emit AssertEqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        eq(x, y, reason);
    }
}