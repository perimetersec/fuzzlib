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

    function test_eq_x_x() public {
        uint256 x = 1;
        eq(x, x, "eq does not revert with equal values");
    }

    function testFuzz_eq_x_x(uint256 x) public {
        eq(x, x, "eq does not revert with the fuzz values");
    }

    function test_eq_x_y() public {
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

    function testFuzz_eq_x_y(uint256 x, uint256 y) public {
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

    /// @notice bool version of eq tests
    function test_eq_bool_x_x() public {
        bool x = true;
        eq(x, x, "eq does not revert with equal values");
    }

    function testFuzz_eq_bool_x_x(bool x) public {
        eq(x, x, "eq does not revert with equal values");
    }

    function test_eq_bool_x_y() public {
        bool x = true;
        bool y = false;

        string memory reason = "eq reverts with different values.";
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                x ? "true" : "false",
                "!=",
                y ? "true" : "false",
                ", reason: ",
                reason
        ));
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        eq(x, y, reason);
    }
    function testFuzz_eq_bool_x_y(bool x, bool y) public {
        vm.assume(x != y);
        string memory reason = "eq reverts with fuzz values.";

        vm.expectEmit(true, false, false, true);
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                x ? "true" : "false",
                "!=",
                y ? "true" : "false",
                ", reason: ",
                reason
        ));
        emit AssertEqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        eq(x, y, reason);
    }
    
    /// @notice int256 version of eq test
    function test_eq_int_x_x() public {
        int256 x = 2;
        eq(x, x, "eq does not revert with equal values");
    }

    function testFuzz_eq_bool_x_x(int256 x) public {
        eq(x, x, "eq does not revert with equal values");
    }

    function test_eq_int_x_y() public {
        int256 x = 2;
        int256 y = 4;

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
    function testFuzz_eq_int_x_y(int256 x, int256 y) public {
        vm.assume(x > type(int256).min / 2 && x < type(int256).max / 2);
        vm.assume(y > type(int256).min / 2 && y < type(int256).max / 2);
        vm.assume(x != y);

        string memory reason = "eq reverts with fuzz values.";

        vm.expectEmit(true, false, false, false);
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
     /// @notice bytes4 version of eq
    function test_eq_bytes_x_x() public {
        bytes4 x = "s";
        eq(x, x, "eq does not revert with equal values");
    } 
    function testFuzz_eq_bytes_x_x(bytes4 x) public {
        eq(x, x, "eq does not revert with equal values");
    }

    function test_eq_bytes_x_y() public {
        bytes4 x = "s";
        bytes4 y = "a";

        bytes memory xBytes = abi.encodePacked(x); 
        bytes memory yBytes = abi.encodePacked(y); 
        string memory xStr = FuzzLibString.toHexString(xBytes);
        string memory yStr = FuzzLibString.toHexString(yBytes);

        string memory reason = "eq reverts with different values.";
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                xStr,
                "!=",
                yStr,
                ", reason: ",
                reason
        ));
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        eq(x, y, reason);
    }

        function testFuzz_eq_int_x_y(bytes4 x, bytes4 y) public {
        vm.assume(x != y);

        bytes memory xBytes = abi.encodePacked(x); 
        bytes memory yBytes = abi.encodePacked(y); 
        string memory xStr = FuzzLibString.toHexString(xBytes);
        string memory yStr = FuzzLibString.toHexString(yBytes);

        string memory reason = "eq reverts with equal values.";
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                xStr,
                "!=",
                yStr,
                ", reason: ",
                reason
        ));

        emit AssertEqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        eq(x, y, reason);
    } 

    /// @notice asserts that a is not equal to b.
/*      function test_neq_x_x() public {
        uint256 x = 1;
        uint256 x = 2;
        neq(x, x, "eq does not revert with equal values");
    }

    function testFuzz_neq_x_x(uint256 x) public {
        neq(x, x, "eq does not revert with the fuzz values");
    } */

    function test_neq_x_y() public {
        uint256 x = 2;
        uint256 y = 2;

        string memory reason = "eq reverts with equal values.";
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                "==",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
        ));
        vm.expectEmit(true, false, false, true);
        emit AssertNeqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        neq(x, y, reason);
    }

    function testFuzz_neq_x_y(uint256 x, uint256 y) public {
        vm.assume(x == y);
        string memory reason = "eq reverts with fuzz values.";

        vm.expectEmit(true, false, false, false);
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                "!=",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
            ));
        emit AssertNeqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        neq(x, y, reason);
    } 
    
    /// @notice int256 version of neq
    /*      function test_neq_x_x() public {
        uint256 x = 1;
        uint256 x = 2;
        neq(x, x, "eq does not revert with equal values");
    }

    function testFuzz_neq_x_x(uint256 x) public {
        neq(x, x, "eq does not revert with the fuzz values");
    } */

    function test_neq_int_x_y() public {
        int256 x = 2;
        int256 y = 2;

        string memory reason = "eq reverts with equal values.";
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                "==",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
        ));
        vm.expectEmit(true, false, false, true);
        emit AssertNeqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        neq(x, y, reason);
    }

    function testFuzz_neq_int_x_y(int256 x, int256 y) public {
        vm.assume(x > type(int256).min / 2 && x < type(int256).max / 2);
        vm.assume(y > type(int256).min / 2 && y < type(int256).max / 2);
        vm.assume(x == y);
        string memory reason = "eq reverts with fuzz values.";

        vm.expectEmit(true, false, false, false);
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                "!=",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
            ));
        emit AssertNeqFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        neq(x, y, reason);
    }
    /// @notice asserts that a is greater than or equal to b.
    function test_gte_x_x() public {
        uint256 x = 1;
        gte(x, x, "eq does not revert with less values");
    }

    function testFuzz_gte_x_x(uint256 x) public {
        gte(x, x, "eq does not revert with the fuzz values");
    } 

    function test_gte_x_y() public {
        uint256 x = 4;
        uint256 y = 5;

        string memory reason = "eq reverts with less values.";
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                ">=",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
        ));

        vm.expectEmit(true, false, false, false);    

        emit AssertGteFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        gte(x, y, reason);
    }

    function testFuzz_gte_x_y(uint256 x, uint256 y) public {
        vm.assume(x < y);
        string memory reason = "eq reverts with fuzz values.";

        vm.expectEmit(true, true, false, false);
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                ">=",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
            ));
        emit AssertGteFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        gte(x, y, reason);
    }

   /// @notice int256 version of gte.
    function test_gte_int_x_x() public {
        int256 x = 1;
        gte(x, x, "eq does not revert with less values");
    }

    function testFuzz_gte_int_x_x(int256 x) public {
        gte(x, x, "eq does not revert with the fuzz values");
    } 

    function test_gte_int_x_y() public {
        int256 x = 4;
        int256 y = 5;

        string memory reason = "eq reverts with less values.";
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                ">=",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
        ));

        vm.expectEmit(true, false, false, false);
 
        emit AssertGteFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        gte(x, y, reason);
    }

    function testFuzz_gte_int_x_y(int256 x, int256 y) public {
        vm.assume(x > type(int256).min / 2 && x < type(int256).max / 2);
        vm.assume(y > type(int256).min / 2 && y < type(int256).max / 2);
        vm.assume(x < y);
        string memory reason = "eq reverts with fuzz values.";

        vm.expectEmit(true, true, false, false);
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                ">=",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
            ));
        emit AssertGteFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        gte(x, y, reason);
    }

    /// @notice asserts that a is greater than b.    
    /*function test_gt_x_x() public {
        uint256 x = 1;
        gt(x, x, "eq does not revert with less or equal values");
    }

    function testFuzz_gt_x_x(uint256 x) public {
        gt(x, x, "eq does not revert with the fuzz values");
    }*/ 

    function test_gt_x_y() public {
        uint256 x = 4;
        uint256 y = 5;

        string memory reason = "eq reverts with less or equal values.";
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                ">",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
        ));

        vm.expectEmit(true, false, true, false);
       
        emit AssertGtFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        gt(x, y, reason);
    }

    function testFuzz_gt_x_y(uint256 x, uint256 y) public {
        vm.assume(x <= y);
        string memory reason = "eq reverts with fuzz values.";

        vm.expectEmit(true, true, false, false);
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                ">",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
            ));
        emit AssertGtFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        gt(x, y, reason);
    }
    /// @notice int256 version of gt test.    
    /*function test_gt_x_x() public {
        uint256 x = 1;
        gt(x, x, "eq does not revert with less or equal values");
    }

    function testFuzz_gt_x_x(uint256 x) public {
        gt(x, x, "eq does not revert with the fuzz values");
    }*/ 

    function test_gt_int_x_y() public {
        int256 x = 4;
        int256 y = 5;

        string memory reason = "eq reverts with less or equal values.";
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                ">",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
        ));

        vm.expectEmit(true, false, true, false);

        emit AssertGtFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        gt(x, y, reason);
    }

    function testFuzz_gt_x_y(int256 x, int256 y) public {
        vm.assume(x > type(int256).min / 2 && x < type(int256).max / 2);
        vm.assume(y > type(int256).min / 2 && y < type(int256).max / 2);
        vm.assume(x <= y);
        string memory reason = "eq reverts with fuzz values.";

        vm.expectEmit(true, true, false, false);
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                ">",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
            ));
        emit AssertGtFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        gt(x, y, reason);
    }

    /// @notice asserts that a is less than or equal to b.
    function test_lte_x_x() public {
        uint256 x = 1;
        lte(x, x, "eq does not revert with less values");
    }

    function testFuzz_lte_x_x(uint256 x) public {
        lte(x, x, "eq does not revert with the fuzz values");
    } 

    function test_lte_x_y() public {
        uint256 x = 5;
        uint256 y = 4;

        string memory reason = "eq reverts with less values.";
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                "<=",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
        ));

        vm.expectEmit(true, false, false, false);

       

        emit AssertLteFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        lte(x, y, reason);
    }

    function testFuzz_lte_x_y(uint256 x, uint256 y) public {
        vm.assume(x > y);
        string memory reason = "eq reverts with fuzz values.";

        vm.expectEmit(true, true, false, false);
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                "<=",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
            ));
        emit AssertLteFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        lte(x, y, reason);
    }

   /// @notice int256 version of gte.
    function test_lte_int_x_x() public {
        int256 x = 1;
        lte(x, x, "eq does not revert with less values");
    }

    function testFuzz_lte_int_x_x(int256 x) public {
        lte(x, x, "eq does not revert with the fuzz values");
    } 

    function test_lte_int_x_y() public {
        int256 x = 5;
        int256 y = 4;

        string memory reason = "eq reverts with less values.";
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                ">",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
        ));

        emit AssertGteFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        lte(x, y, reason);
    }

    function testFuzz_lte_int_x_y(int256 x, int256 y) public {
        vm.assume(x > type(int256).min / 2 && x < type(int256).max / 2);
        vm.assume(y > type(int256).min / 2 && y < type(int256).max / 2);
        vm.assume(x > y);
        string memory reason = "eq reverts with fuzz values.";

        vm.expectEmit(true, true, false, false);
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                ">",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
            ));
        emit AssertLteFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        lte(x, y, reason);
    }

        /// @notice asserts that a is less than b.    
    /*function test_gt_x_x() public {
        uint256 x = 1;
        gt(x, x, "eq does not revert with less or equal values");
    }

    function testFuzz_gt_x_x(uint256 x) public {
        gt(x, x, "eq does not revert with the fuzz values");
    }*/ 

    function test_lt_x_y() public {
        uint256 x = 5;
        uint256 y = 4;

        string memory reason = "eq reverts with less or equal values.";
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                "<",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
        ));

        vm.expectEmit(true, false, true, false);

        emit AssertLtFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        lt(x, y, reason);
    }

    function testFuzz_lt_x_y(uint256 x, uint256 y) public {
        vm.assume(x >= y);
        string memory reason = "eq reverts with fuzz values.";

        vm.expectEmit(true, true, false, false);
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                ">",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
            ));
        emit AssertLtFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        lt(x, y, reason);
    }
    /// @notice int256 version of lt test.    
    /*function test_gt_x_x() public {
        uint256 x = 1;
        gt(x, x, "eq does not revert with less or equal values");
    }

    function testFuzz_gt_x_x(uint256 x) public {
        gt(x, x, "eq does not revert with the fuzz values");
    }*/ 

    function test_lt_int_x_y() public {
        int256 x = 5;
        int256 y = 4;

        string memory reason = "eq reverts with less or equal values.";
        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                ">",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
        ));

        vm.expectEmit(true, false, true, false);

       

        emit AssertLtFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        lt(x, y, reason);
    }

    function testFuzz_lt_x_y(int256 x, int256 y) public {
        vm.assume(x > type(int256).min / 2 && x < type(int256).max / 2);
        vm.assume(y > type(int256).min / 2 && y < type(int256).max / 2);
        vm.assume(x >= y);
        string memory reason = "eq reverts with fuzz values.";

        string memory failReason = string(abi.encodePacked(
                "Invalid: ",
                FuzzLibString.toString(x),
                ">",
                FuzzLibString.toString(y),
                ", reason: ",
                reason
            ));
        emit AssertGtFail(failReason);

        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        lt(x, y, reason);
    } 
}