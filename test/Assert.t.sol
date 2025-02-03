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

    /**
     * "t" test
     */
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

    /**
     * "eq" test
     */
    function test_eq_x_x() public {
        uint256 x = 1;
        eq(x, x, "example message");
    }

    function testFuzz_eq_x_x(uint256 x) public {
        eq(x, x, "example message");
    }

    function test_eq_x_y() public {
        uint256 x = 2;
        uint256 y = 4;

        string memory reason = "example message";
        string memory failReason = createAssertFailMessage(
                FuzzLibString.toString(x),
                FuzzLibString.toString(y),
                "!=",
                reason
        );
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        eq(x, y, reason);
    }

    function testFuzz_eq_x_y(uint256 x, uint256 y) public {
        vm.assume(x != y);
        string memory reason = "example message";

        vm.expectEmit(true, false, false, true);
        string memory failReason = createAssertFailMessage(
                FuzzLibString.toString(x),
                FuzzLibString.toString(y),
                "!=",
                reason
        );
        emit AssertEqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        eq(x, y, reason);
    }

    /// @notice bool version of eq tests
    function test_eq_bool_x_x() public {
        bool x = true;
        eq(x, x, "example message");
    }

    function testFuzz_eq_bool_x_x(bool x) public {
        eq(x, x, "example message");
    }

    function test_eq_bool_x_y() public {
        bool x = true;
        bool y = false;

        string memory reason = "example message";
        string memory failReason = createAssertFailMessage(
                x ? "true" : "false",
                y ? "true" : "false",
                "!=",
                reason
        );
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        eq(x, y, reason);
    }

    function testFuzz_eq_bool_x_y(bool x, bool y) public {
        vm.assume(x != y);
        string memory reason = "example message";

        vm.expectEmit(true, false, false, true);
        string memory failReason = createAssertFailMessage(
                x ? "true" : "false",
                y ? "true" : "false",
                "!=",
                reason
        );
        emit AssertEqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        eq(x, y, reason);
    } 

    /**
     * "neq" test
     */
    function test_neq_x_y() public {
        uint256 x = 1;
        uint256 y = 2;
        neq(x, y, "example message");
    }

    function testFuzz_neq_x_y(uint256 x, uint256 y) public {
        vm.assume(x != y);
        neq(x, y, "example message");
    }

    // neq: unhappy path
    function test_neq_x_y_unhappy_path() public {
        uint256 x = 1;
        uint256 y = 1;

        string memory reason = "x and y should not be the same";
        string memory failReason = createAssertFailMessage(
            FuzzLibString.toString(x),
            FuzzLibString.toString(y),
            "==",
            reason
        );
        vm.expectEmit(true, false, false, true);
        emit AssertNeqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        neq(x, y, reason);
    }

    // note that params are int instead of uint
    function test_neq_x_y_int256_param() public {
        int256 x = 1;
        int256 y = 2;
        neq(x, y, "example message");
    }

     function testFuzz_neq_x_y_int256_param(int256 x, int256 y) public {
        vm.assume(x != y);
        neq(x, y, "example message");
    }

    // neq: unhappy path
    function test_neq_x_y_unhappy_path_int256_param() public {
        int256 x = 1;
        int256 y = 1;

        string memory reason = "x and y should not be the same";
        string memory failReason = createAssertFailMessage(
            FuzzLibString.toString(x),
            FuzzLibString.toString(y),
            "==",
            reason
        );
        vm.expectEmit(true, false, false, true);
        emit AssertNeqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        neq(x, y, reason);
    }
}