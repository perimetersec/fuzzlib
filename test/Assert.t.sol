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
}
