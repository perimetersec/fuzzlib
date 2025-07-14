// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "src/FuzzLibString.sol";

import {HelperAssert} from "../src/helpers/HelperAssert.sol";
import {PlatformTest} from "./util/PlatformTest.sol";
import {DummyContract} from "./util/DummyContract.sol";
import {ErrAllowTestHelper} from "./util/ErrAllowTestHelper.sol";

/**
 * @dev Comprehensive tests for HelperAssert functionality including assertion utilities,
 * error handling with errAllow functions, and platform-specific behavior.
 * @author Perimeter <info@perimetersec.io>
 */
contract TestHelperAssert is Test, HelperAssert, ErrAllowTestHelper {
    DummyContract dummy;

    function setUp() public {
        setPlatform(address(new PlatformTest()));
        dummy = new DummyContract();
    }

    /**
     * Tests for t(bool, string)
     */
    function test_t_true() public {
        t(true, "example message");
    }

    function test_t_false() public {
        vm.expectEmit(true, false, false, true);
        emit AssertFail("example message");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        t(false, "example message");
    }

    function testFuzz_t_true(string memory reason) public {
        t(true, reason);
    }

    function testFuzz_t_false(string memory reason) public {
        vm.expectEmit(true, false, false, true);
        emit AssertFail(reason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        t(false, reason);
    }

    /**
     * Tests for eq(uint256, uint256, string)
     */
    function test_eq_uint256_equal() public {
        eq(uint256(5), uint256(5), "example message");
    }

    function test_eq_uint256_not_equal() public {
        string memory reason = "example message";
        string memory failReason = createAssertFailMessage(
            FuzzLibString.toString(uint256(2)), FuzzLibString.toString(uint256(4)), "!=", reason
        );
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        eq(uint256(2), uint256(4), reason);
    }

    function test_eq_uint256_zero() public {
        eq(uint256(0), uint256(0), "zero test");
    }

    function test_eq_uint256_max_values() public {
        eq(type(uint256).max, type(uint256).max, "max values test");
    }

    function testFuzz_eq_uint256_equal(uint256 x) public {
        eq(x, x, "fuzz equal test");
    }

    function testFuzz_eq_uint256_not_equal(uint256 x, uint256 y) public {
        vm.assume(x != y);
        string memory reason = "fuzz not equal test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(x), FuzzLibString.toString(y), "!=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        eq(x, y, reason);
    }

    /**
     * Tests for eq(bool, bool, string)
     */
    function test_eq_bool_equal() public {
        eq(true, true, "bool equal test");
        eq(false, false, "bool equal test");
    }

    function test_eq_bool_not_equal() public {
        string memory reason = "bool not equal test";
        string memory failReason = createAssertFailMessage("true", "false", "!=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        eq(true, false, reason);
    }

    function testFuzz_eq_bool_equal(bool x) public {
        eq(x, x, "fuzz bool equal test");
    }

    function testFuzz_eq_bool_not_equal(bool x, bool y) public {
        vm.assume(x != y);
        string memory reason = "fuzz bool not equal test";
        string memory failReason = createAssertFailMessage(x ? "true" : "false", y ? "true" : "false", "!=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        eq(x, y, reason);
    }

    /**
     * Tests for eq(address, address, string)
     */
    function test_eq_address_equal() public {
        address addr = address(0x1234567890123456789012345678901234567890);
        eq(addr, addr, "address equal test");
    }

    function test_eq_address_not_equal() public {
        address addr1 = address(0x1234567890123456789012345678901234567890);
        address addr2 = address(0x0987654321098765432109876543210987654321);
        string memory reason = "address not equal test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(addr1), FuzzLibString.toString(addr2), "!=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        eq(addr1, addr2, reason);
    }

    function test_eq_address_zero() public {
        eq(address(0), address(0), "zero address test");
    }

    function test_eq_address_max_value() public {
        address maxAddr = address(type(uint160).max);
        eq(maxAddr, maxAddr, "max address test");
    }

    function testFuzz_eq_address_equal(address x) public {
        eq(x, x, "fuzz address equal test");
    }

    function testFuzz_eq_address_not_equal(address x, address y) public {
        vm.assume(x != y);
        string memory reason = "fuzz address not equal test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(x), FuzzLibString.toString(y), "!=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        eq(x, y, reason);
    }

    /**
     * Tests for eq(bytes4, bytes4, string)
     */
    function test_eq_bytes4_equal() public {
        bytes4 value = bytes4(0x12345678);
        eq(value, value, "bytes4 equal test");
    }

    function test_eq_bytes4_not_equal() public {
        bytes4 value1 = bytes4(0x12345678);
        bytes4 value2 = bytes4(0x87654321);
        string memory reason = "bytes4 not equal test";
        bytes memory aBytes = abi.encodePacked(value1);
        bytes memory bBytes = abi.encodePacked(value2);
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toHexString(aBytes), FuzzLibString.toHexString(bBytes), "!=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        eq(value1, value2, reason);
    }

    function test_eq_bytes4_zero() public {
        eq(bytes4(0), bytes4(0), "zero bytes4 test");
    }

    function test_eq_bytes4_max_value() public {
        bytes4 maxValue = bytes4(type(uint32).max);
        eq(maxValue, maxValue, "max bytes4 test");
    }

    function testFuzz_eq_bytes4_equal(bytes4 x) public {
        eq(x, x, "fuzz bytes4 equal test");
    }

    function testFuzz_eq_bytes4_not_equal(bytes4 x, bytes4 y) public {
        vm.assume(x != y);
        string memory reason = "fuzz bytes4 not equal test";
        bytes memory aBytes = abi.encodePacked(x);
        bytes memory bBytes = abi.encodePacked(y);
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toHexString(aBytes), FuzzLibString.toHexString(bBytes), "!=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        eq(x, y, reason);
    }

    /**
     * Tests for eq(int256, int256, string)
     */
    function test_eq_int256_equal() public {
        eq(int256(5), int256(5), "int256 equal test");
    }

    function test_eq_int256_not_equal() public {
        string memory reason = "int256 not equal test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(int256(2)), FuzzLibString.toString(int256(4)), "!=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        eq(int256(2), int256(4), reason);
    }

    function test_eq_int256_zero() public {
        eq(int256(0), int256(0), "zero int256 test");
    }

    function test_eq_int256_negative() public {
        eq(int256(-5), int256(-5), "negative int256 test");
    }

    function test_eq_int256_mixed_signs() public {
        string memory reason = "mixed signs test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(int256(-5)), FuzzLibString.toString(int256(5)), "!=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        eq(int256(-5), int256(5), reason);
    }

    function test_eq_int256_extreme_values() public {
        eq(type(int256).max, type(int256).max, "max int256 test");
        eq(type(int256).min, type(int256).min, "min int256 test");
    }

    function testFuzz_eq_int256_equal(int256 x) public {
        eq(x, x, "fuzz int256 equal test");
    }

    function testFuzz_eq_int256_not_equal(int256 x, int256 y) public {
        vm.assume(x != y);
        string memory reason = "fuzz int256 not equal test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(x), FuzzLibString.toString(y), "!=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertEqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        eq(x, y, reason);
    }

    /**
     * Tests for neq(uint256, uint256, string)
     */
    function test_neq_uint256_not_equal() public {
        neq(uint256(1), uint256(2), "neq test");
    }

    function test_neq_uint256_equal() public {
        string memory reason = "should not be equal";
        string memory failReason = createAssertFailMessage(
            FuzzLibString.toString(uint256(5)), FuzzLibString.toString(uint256(5)), "==", reason
        );
        vm.expectEmit(true, false, false, true);
        emit AssertNeqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        neq(uint256(5), uint256(5), reason);
    }

    function test_neq_uint256_zero() public {
        neq(uint256(0), uint256(1), "zero neq test");
    }

    function test_neq_uint256_max_values() public {
        neq(type(uint256).max, type(uint256).max - 1, "max values neq test");
    }

    function testFuzz_neq_uint256_not_equal(uint256 x, uint256 y) public {
        vm.assume(x != y);
        neq(x, y, "fuzz neq test");
    }

    function testFuzz_neq_uint256_equal(uint256 x) public {
        string memory reason = "fuzz equal failure test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(x), FuzzLibString.toString(x), "==", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertNeqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        neq(x, x, reason);
    }

    /**
     * Tests for neq(int256, int256, string)
     */
    function test_neq_int256_not_equal() public {
        neq(int256(1), int256(2), "int256 neq test");
    }

    function test_neq_int256_equal() public {
        string memory reason = "int256 should not be equal";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(int256(7)), FuzzLibString.toString(int256(7)), "==", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertNeqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        neq(int256(7), int256(7), reason);
    }

    function test_neq_int256_negative() public {
        neq(int256(-5), int256(-10), "negative neq test");
    }

    function test_neq_int256_mixed_signs() public {
        neq(int256(-5), int256(5), "mixed signs neq test");
    }

    function test_neq_int256_extreme_values() public {
        neq(type(int256).max, type(int256).min, "extreme values neq test");
    }

    function testFuzz_neq_int256_not_equal(int256 x, int256 y) public {
        vm.assume(x != y);
        neq(x, y, "fuzz int256 neq test");
    }

    function testFuzz_neq_int256_equal(int256 x) public {
        string memory reason = "fuzz int256 equal failure test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(x), FuzzLibString.toString(x), "==", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertNeqFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        neq(x, x, reason);
    }

    /**
     * Tests for gte(uint256, uint256, string)
     */
    function test_gte_uint256_greater() public {
        gte(uint256(10), uint256(5), "gte greater test");
    }

    function test_gte_uint256_equal() public {
        gte(uint256(5), uint256(5), "gte equal test");
    }

    function test_gte_uint256_less() public {
        string memory reason = "gte less test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(uint256(3)), FuzzLibString.toString(uint256(7)), "<", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertGteFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        gte(uint256(3), uint256(7), reason);
    }

    function test_gte_uint256_zero() public {
        gte(uint256(0), uint256(0), "gte zero test");
        gte(uint256(1), uint256(0), "gte from zero test");
    }

    function test_gte_uint256_max_values() public {
        gte(type(uint256).max, type(uint256).max, "gte max values test");
        gte(type(uint256).max, type(uint256).max - 1, "gte max vs max-1 test");
    }

    function testFuzz_gte_uint256_valid(uint256 a, uint256 b) public {
        vm.assume(a >= b);
        gte(a, b, "fuzz gte valid test");
    }

    function testFuzz_gte_uint256_invalid(uint256 a, uint256 b) public {
        vm.assume(a < b);
        string memory reason = "fuzz gte invalid test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(a), FuzzLibString.toString(b), "<", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertGteFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        gte(a, b, reason);
    }

    /**
     * Tests for gte(int256, int256, string)
     */
    function test_gte_int256_greater() public {
        gte(int256(10), int256(5), "gte int256 greater test");
    }

    function test_gte_int256_equal() public {
        gte(int256(5), int256(5), "gte int256 equal test");
    }

    function test_gte_int256_less() public {
        string memory reason = "gte int256 less test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(int256(3)), FuzzLibString.toString(int256(7)), "<", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertGteFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        gte(int256(3), int256(7), reason);
    }

    function test_gte_int256_negative() public {
        gte(int256(-5), int256(-10), "gte negative test");
    }

    function test_gte_int256_mixed_signs() public {
        gte(int256(5), int256(-5), "gte mixed signs test");
    }

    function test_gte_int256_extreme_values() public {
        gte(type(int256).max, type(int256).min, "gte extreme values test");
        gte(type(int256).max, type(int256).max, "gte max values test");
    }

    function testFuzz_gte_int256_valid(int256 a, int256 b) public {
        vm.assume(a >= b);
        gte(a, b, "fuzz gte int256 valid test");
    }

    function testFuzz_gte_int256_invalid(int256 a, int256 b) public {
        vm.assume(a < b);
        string memory reason = "fuzz gte int256 invalid test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(a), FuzzLibString.toString(b), "<", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertGteFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        gte(a, b, reason);
    }

    /**
     * Tests for gt(uint256, uint256, string)
     */
    function test_gt_uint256_greater() public {
        gt(uint256(10), uint256(5), "gt greater test");
    }

    function test_gt_uint256_equal() public {
        string memory reason = "gt equal test";
        string memory failReason = createAssertFailMessage(
            FuzzLibString.toString(uint256(5)), FuzzLibString.toString(uint256(5)), "<=", reason
        );
        vm.expectEmit(true, false, false, true);
        emit AssertGtFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        gt(uint256(5), uint256(5), reason);
    }

    function test_gt_uint256_less() public {
        string memory reason = "gt less test";
        string memory failReason = createAssertFailMessage(
            FuzzLibString.toString(uint256(3)), FuzzLibString.toString(uint256(7)), "<=", reason
        );
        vm.expectEmit(true, false, false, true);
        emit AssertGtFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        gt(uint256(3), uint256(7), reason);
    }

    function test_gt_uint256_max_values() public {
        gt(type(uint256).max, type(uint256).max - 1, "gt max values test");
    }

    function testFuzz_gt_uint256_valid(uint256 a, uint256 b) public {
        vm.assume(a > b);
        gt(a, b, "fuzz gt valid test");
    }

    function testFuzz_gt_uint256_invalid(uint256 a, uint256 b) public {
        vm.assume(a <= b);
        string memory reason = "fuzz gt invalid test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(a), FuzzLibString.toString(b), "<=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertGtFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        gt(a, b, reason);
    }

    /**
     * Tests for gt(int256, int256, string)
     */
    function test_gt_int256_greater() public {
        gt(int256(10), int256(5), "gt int256 greater test");
    }

    function test_gt_int256_equal() public {
        string memory reason = "gt int256 equal test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(int256(5)), FuzzLibString.toString(int256(5)), "<=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertGtFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        gt(int256(5), int256(5), reason);
    }

    function test_gt_int256_less() public {
        string memory reason = "gt int256 less test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(int256(3)), FuzzLibString.toString(int256(7)), "<=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertGtFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        gt(int256(3), int256(7), reason);
    }

    function test_gt_int256_negative() public {
        gt(int256(-5), int256(-10), "gt negative test");
    }

    function test_gt_int256_mixed_signs() public {
        gt(int256(5), int256(-5), "gt mixed signs test");
    }

    function test_gt_int256_extreme_values() public {
        gt(type(int256).max, type(int256).min, "gt extreme values test");
    }

    function testFuzz_gt_int256_valid(int256 a, int256 b) public {
        vm.assume(a > b);
        gt(a, b, "fuzz gt int256 valid test");
    }

    function testFuzz_gt_int256_invalid(int256 a, int256 b) public {
        vm.assume(a <= b);
        string memory reason = "fuzz gt int256 invalid test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(a), FuzzLibString.toString(b), "<=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertGtFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        gt(a, b, reason);
    }

    /**
     * Tests for lte(uint256, uint256, string)
     */
    function test_lte_uint256_less() public {
        lte(uint256(5), uint256(10), "lte less test");
    }

    function test_lte_uint256_equal() public {
        lte(uint256(5), uint256(5), "lte equal test");
    }

    function test_lte_uint256_greater() public {
        string memory reason = "lte greater test";
        string memory failReason = createAssertFailMessage(
            FuzzLibString.toString(uint256(10)), FuzzLibString.toString(uint256(5)), ">", reason
        );
        vm.expectEmit(true, false, false, true);
        emit AssertLteFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        lte(uint256(10), uint256(5), reason);
    }

    function test_lte_uint256_zero() public {
        lte(uint256(0), uint256(0), "lte zero test");
        lte(uint256(0), uint256(1), "lte to one test");
    }

    function test_lte_uint256_max_values() public {
        lte(type(uint256).max - 1, type(uint256).max, "lte max values test");
        lte(type(uint256).max, type(uint256).max, "lte max equal test");
    }

    function testFuzz_lte_uint256_valid(uint256 a, uint256 b) public {
        vm.assume(a <= b);
        lte(a, b, "fuzz lte valid test");
    }

    function testFuzz_lte_uint256_invalid(uint256 a, uint256 b) public {
        vm.assume(a > b);
        string memory reason = "fuzz lte invalid test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(a), FuzzLibString.toString(b), ">", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertLteFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        lte(a, b, reason);
    }

    /**
     * Tests for lte(int256, int256, string)
     */
    function test_lte_int256_less() public {
        lte(int256(5), int256(10), "lte int256 less test");
    }

    function test_lte_int256_equal() public {
        lte(int256(5), int256(5), "lte int256 equal test");
    }

    function test_lte_int256_greater() public {
        string memory reason = "lte int256 greater test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(int256(10)), FuzzLibString.toString(int256(5)), ">", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertLteFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        lte(int256(10), int256(5), reason);
    }

    function test_lte_int256_negative() public {
        lte(int256(-10), int256(-5), "lte negative test");
    }

    function test_lte_int256_mixed_signs() public {
        lte(int256(-5), int256(5), "lte mixed signs test");
    }

    function test_lte_int256_extreme_values() public {
        lte(type(int256).min, type(int256).max, "lte extreme values test");
        lte(type(int256).min, type(int256).min, "lte min equal test");
    }

    function testFuzz_lte_int256_valid(int256 a, int256 b) public {
        vm.assume(a <= b);
        lte(a, b, "fuzz lte int256 valid test");
    }

    function testFuzz_lte_int256_invalid(int256 a, int256 b) public {
        vm.assume(a > b);
        string memory reason = "fuzz lte int256 invalid test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(a), FuzzLibString.toString(b), ">", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertLteFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        lte(a, b, reason);
    }

    /**
     * Tests for lt(uint256, uint256, string)
     */
    function test_lt_uint256_less() public {
        lt(uint256(5), uint256(10), "lt less test");
    }

    function test_lt_uint256_equal() public {
        string memory reason = "lt equal test";
        string memory failReason = createAssertFailMessage(
            FuzzLibString.toString(uint256(5)), FuzzLibString.toString(uint256(5)), ">=", reason
        );
        vm.expectEmit(true, false, false, true);
        emit AssertLtFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        lt(uint256(5), uint256(5), reason);
    }

    function test_lt_uint256_greater() public {
        string memory reason = "lt greater test";
        string memory failReason = createAssertFailMessage(
            FuzzLibString.toString(uint256(10)), FuzzLibString.toString(uint256(5)), ">=", reason
        );
        vm.expectEmit(true, false, false, true);
        emit AssertLtFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        lt(uint256(10), uint256(5), reason);
    }

    function test_lt_uint256_zero() public {
        lt(uint256(0), uint256(1), "lt from zero test");
    }

    function test_lt_uint256_max_values() public {
        lt(type(uint256).max - 1, type(uint256).max, "lt max values test");
    }

    function testFuzz_lt_uint256_valid(uint256 a, uint256 b) public {
        vm.assume(a < b);
        lt(a, b, "fuzz lt valid test");
    }

    function testFuzz_lt_uint256_invalid(uint256 a, uint256 b) public {
        vm.assume(a >= b);
        string memory reason = "fuzz lt invalid test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(a), FuzzLibString.toString(b), ">=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertLtFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        lt(a, b, reason);
    }

    /**
     * Tests for lt(int256, int256, string)
     */
    function test_lt_int256_less() public {
        lt(int256(5), int256(10), "lt int256 less test");
    }

    function test_lt_int256_equal() public {
        string memory reason = "lt int256 equal test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(int256(5)), FuzzLibString.toString(int256(5)), ">=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertLtFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        lt(int256(5), int256(5), reason);
    }

    function test_lt_int256_greater() public {
        string memory reason = "lt int256 greater test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(int256(10)), FuzzLibString.toString(int256(5)), ">=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertLtFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        lt(int256(10), int256(5), reason);
    }

    function test_lt_int256_negative() public {
        lt(int256(-10), int256(-5), "lt negative test");
    }

    function test_lt_int256_mixed_signs() public {
        lt(int256(-5), int256(5), "lt mixed signs test");
    }

    function test_lt_int256_extreme_values() public {
        lt(type(int256).min, type(int256).max, "lt extreme values test");
    }

    function testFuzz_lt_int256_valid(int256 a, int256 b) public {
        vm.assume(a < b);
        lt(a, b, "fuzz lt int256 valid test");
    }

    function testFuzz_lt_int256_invalid(int256 a, int256 b) public {
        vm.assume(a >= b);
        string memory reason = "fuzz lt int256 invalid test";
        string memory failReason =
            createAssertFailMessage(FuzzLibString.toString(a), FuzzLibString.toString(b), ">=", reason);
        vm.expectEmit(true, false, false, true);
        emit AssertLtFail(failReason);
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        lt(a, b, reason);
    }

    /**
     * Cross-boundary edge case tests
     */
    function test_cross_boundary_uint256_max_vs_zero() public {
        gte(type(uint256).max, uint256(0), "max >= 0");
        gt(type(uint256).max, uint256(0), "max > 0");
        lte(uint256(0), type(uint256).max, "0 <= max");
        lt(uint256(0), type(uint256).max, "0 < max");
    }

    function test_cross_boundary_int256_extremes() public {
        gte(type(int256).max, type(int256).min, "max >= min");
        gt(type(int256).max, type(int256).min, "max > min");
        lte(type(int256).min, type(int256).max, "min <= max");
        lt(type(int256).min, type(int256).max, "min < max");
    }

    function test_cross_boundary_int256_vs_zero() public {
        gte(type(int256).max, int256(0), "max >= 0");
        gt(type(int256).max, int256(0), "max > 0");
        lte(type(int256).min, int256(0), "min <= 0");
        lt(type(int256).min, int256(0), "min < 0");

        gte(int256(0), type(int256).min, "0 >= min");
        gt(int256(0), type(int256).min, "0 > min");
        lte(int256(0), type(int256).max, "0 <= max");
        lt(int256(0), type(int256).max, "0 < max");
    }

    /**
     * Sequential boundary tests
     */
    function test_sequential_boundary_uint256_zero_one() public {
        // Test the boundary between 0 and 1
        gt(uint256(1), uint256(0), "1 > 0");
        gte(uint256(1), uint256(0), "1 >= 0");
        gte(uint256(0), uint256(0), "0 >= 0");

        lt(uint256(0), uint256(1), "0 < 1");
        lte(uint256(0), uint256(1), "0 <= 1");
        lte(uint256(0), uint256(0), "0 <= 0");

        neq(uint256(1), uint256(0), "1 != 0");
        eq(uint256(0), uint256(0), "0 == 0");
    }

    function test_sequential_boundary_uint256_max() public {
        // Test boundary around max value
        gt(type(uint256).max, type(uint256).max - 1, "max > max-1");
        gte(type(uint256).max, type(uint256).max - 1, "max >= max-1");
        gte(type(uint256).max, type(uint256).max, "max >= max");

        lt(type(uint256).max - 1, type(uint256).max, "max-1 < max");
        lte(type(uint256).max - 1, type(uint256).max, "max-1 <= max");
        lte(type(uint256).max, type(uint256).max, "max <= max");

        neq(type(uint256).max, type(uint256).max - 1, "max != max-1");
        eq(type(uint256).max, type(uint256).max, "max == max");
    }

    function test_sequential_boundary_int256_around_zero() public {
        // Test boundary around zero
        gt(int256(1), int256(0), "1 > 0");
        gt(int256(0), int256(-1), "0 > -1");
        gt(int256(1), int256(-1), "1 > -1");

        gte(int256(1), int256(0), "1 >= 0");
        gte(int256(0), int256(-1), "0 >= -1");
        gte(int256(0), int256(0), "0 >= 0");

        lt(int256(-1), int256(0), "-1 < 0");
        lt(int256(0), int256(1), "0 < 1");
        lt(int256(-1), int256(1), "-1 < 1");

        lte(int256(-1), int256(0), "-1 <= 0");
        lte(int256(0), int256(1), "0 <= 1");
        lte(int256(0), int256(0), "0 <= 0");
    }

    function test_sequential_boundary_int256_max() public {
        // Test boundary around max value
        gt(type(int256).max, type(int256).max - 1, "max > max-1");
        gte(type(int256).max, type(int256).max - 1, "max >= max-1");
        gte(type(int256).max, type(int256).max, "max >= max");

        lt(type(int256).max - 1, type(int256).max, "max-1 < max");
        lte(type(int256).max - 1, type(int256).max, "max-1 <= max");
        lte(type(int256).max, type(int256).max, "max <= max");

        neq(type(int256).max, type(int256).max - 1, "max != max-1");
        eq(type(int256).max, type(int256).max, "max == max");
    }

    function test_sequential_boundary_int256_min() public {
        // Test boundary around min value
        gt(type(int256).min + 1, type(int256).min, "min+1 > min");
        gte(type(int256).min + 1, type(int256).min, "min+1 >= min");
        gte(type(int256).min, type(int256).min, "min >= min");

        lt(type(int256).min, type(int256).min + 1, "min < min+1");
        lte(type(int256).min, type(int256).min + 1, "min <= min+1");
        lte(type(int256).min, type(int256).min, "min <= min");

        neq(type(int256).min, type(int256).min + 1, "min != min+1");
        eq(type(int256).min, type(int256).min, "min == min");
    }

    /**
     * Comprehensive int256 edge combinations
     */
    function test_int256_edge_min_plus_one_combinations() public {
        // Test min+1 in various combinations
        gte(type(int256).min + 1, type(int256).min, "min+1 >= min");
        gt(type(int256).min + 1, type(int256).min, "min+1 > min");
        gte(type(int256).min + 2, type(int256).min + 1, "min+2 >= min+1");
        gt(type(int256).min + 2, type(int256).min + 1, "min+2 > min+1");

        lte(type(int256).min, type(int256).min + 1, "min <= min+1");
        lt(type(int256).min, type(int256).min + 1, "min < min+1");
        lte(type(int256).min + 1, type(int256).min + 2, "min+1 <= min+2");
        lt(type(int256).min + 1, type(int256).min + 2, "min+1 < min+2");

        neq(type(int256).min, type(int256).min + 1, "min != min+1");
        neq(type(int256).min + 1, type(int256).min + 2, "min+1 != min+2");
    }

    function test_int256_edge_max_minus_one_combinations() public {
        // Test max-1 in various combinations
        gte(type(int256).max, type(int256).max - 1, "max >= max-1");
        gt(type(int256).max, type(int256).max - 1, "max > max-1");
        gte(type(int256).max - 1, type(int256).max - 2, "max-1 >= max-2");
        gt(type(int256).max - 1, type(int256).max - 2, "max-1 > max-2");

        lte(type(int256).max - 1, type(int256).max, "max-1 <= max");
        lt(type(int256).max - 1, type(int256).max, "max-1 < max");
        lte(type(int256).max - 2, type(int256).max - 1, "max-2 <= max-1");
        lt(type(int256).max - 2, type(int256).max - 1, "max-2 < max-1");

        neq(type(int256).max, type(int256).max - 1, "max != max-1");
        neq(type(int256).max - 1, type(int256).max - 2, "max-1 != max-2");
    }

    function test_int256_edge_extreme_vs_near_zero() public {
        // Test extreme values against values near zero
        gt(type(int256).max, int256(1), "max > 1");
        gt(type(int256).max, int256(-1), "max > -1");
        gte(type(int256).max, int256(1), "max >= 1");
        gte(type(int256).max, int256(-1), "max >= -1");

        lt(type(int256).min, int256(-1), "min < -1");
        lt(type(int256).min, int256(1), "min < 1");
        lte(type(int256).min, int256(-1), "min <= -1");
        lte(type(int256).min, int256(1), "min <= 1");

        gt(int256(1), type(int256).min, "1 > min");
        gt(int256(-1), type(int256).min, "-1 > min");
        gte(int256(1), type(int256).min, "1 >= min");
        gte(int256(-1), type(int256).min, "-1 >= min");

        lt(int256(1), type(int256).max, "1 < max");
        lt(int256(-1), type(int256).max, "-1 < max");
        lte(int256(1), type(int256).max, "1 <= max");
        lte(int256(-1), type(int256).max, "-1 <= max");

        neq(type(int256).max, int256(1), "max != 1");
        neq(type(int256).max, int256(-1), "max != -1");
        neq(type(int256).min, int256(1), "min != 1");
        neq(type(int256).min, int256(-1), "min != -1");
    }

    function test_int256_edge_boundary_crossings() public {
        // Test boundary crossings around critical points
        gt(int256(1), int256(0), "1 > 0 (pos/zero boundary)");
        lt(int256(-1), int256(0), "-1 < 0 (neg/zero boundary)");
        gt(int256(0), int256(-1), "0 > -1 (zero/neg boundary)");

        gte(type(int256).max, int256(0), "max >= 0 (max/zero)");
        lte(type(int256).min, int256(0), "min <= 0 (min/zero)");

        // Test largest positive vs smallest magnitude negative
        gt(type(int256).max, int256(-1), "max > -1");
        lt(int256(-1), type(int256).max, "-1 < max");

        // Test smallest magnitude positive vs largest negative
        gt(int256(1), type(int256).min, "1 > min");
        lt(type(int256).min, int256(1), "min < 1");

        neq(type(int256).max, type(int256).min, "max != min (extreme boundary)");
    }

    /**
     * Tests for errAllow(bytes memory, string[], string) - require error handling
     */
    function test_errAllow_require_error_allowed_message() public {
        string[] memory allowedRequireErrors = setup_errAllow_require_error();

        // Test with require failure using Error(string) selector (0x08c379a0)
        (bool success, bytes memory requireFailureData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");

        // Should pass since the error message is in the allowedRequireErrors list
        errAllow(requireFailureData, allowedRequireErrors, "require error allowed test");
    }

    function test_errAllow_require_error_disallowed_message() public {
        string[] memory allowedRequireErrors = setup_errAllow_require_error();

        vm.expectEmit(false, false, false, true);
        emit AssertFail("require error disallowed test");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        // Create error data with message not in allowedRequireErrors list
        bytes memory nonMatchingRequireFailData = abi.encodeWithSelector(bytes4(0x08c379a0), "unallowed error message");
        errAllow(nonMatchingRequireFailData, allowedRequireErrors, "require error disallowed test");
    }

    function test_errAllow_require_error_empty_list() public {
        string[] memory emptyRequireErrors = new string[](0);

        (bool success, bytes memory requireFailureData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");

        vm.expectEmit(false, false, false, true);
        emit AssertFail("empty require list test");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        errAllow(requireFailureData, emptyRequireErrors, "empty require list test");
    }

    /**
     * Tests for errAllow(bytes4, bytes4[], string) - custom error selector handling
     */
    function test_errAllow_custom_error_allowed_selector() public {
        bytes4[] memory allowedCustomErrors = setup_errAllow_custom_error();

        // Test with custom error selector
        (bool success, bytes memory customErrorData) =
            address(dummy).call(abi.encodeWithSignature("revertWithCustomErrorWithMessage()"));
        require(!success, "should fail");

        // Should pass since the error selector is in allowedCustomErrors list
        errAllow(bytes4(customErrorData), allowedCustomErrors, "custom error allowed test");
    }

    function test_errAllow_custom_error_disallowed_selector() public {
        bytes4[] memory allowedCustomErrors = setup_errAllow_custom_error();

        vm.expectEmit(false, false, false, true);
        emit AssertFail("custom error disallowed test");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        // Error(string) selector 0x08c379a0 is not a custom error, should fail
        bytes memory requireErrorData = abi.encodeWithSelector(bytes4(0x08c379a0), "some message");
        errAllow(bytes4(requireErrorData), allowedCustomErrors, "custom error disallowed test");
    }

    function test_errAllow_custom_error_empty_list() public {
        bytes4[] memory emptyCustomErrors = new bytes4[](0);

        vm.expectEmit(false, false, false, true);
        emit AssertFail("empty custom list test");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        // Should fail since allowedCustomErrors is empty array
        bytes memory customErrorData = abi.encodeWithSelector(bytes4(0x12345678), "some message");
        errAllow(bytes4(customErrorData), emptyCustomErrors, "empty custom list test");
    }

    function test_errAllow_custom_error_unknown_selector() public {
        bytes4[] memory allowedCustomErrors = setup_errAllow_custom_error();

        vm.expectEmit(false, false, false, true);
        emit AssertFail("unknown selector test");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        // Use unknown selector not in allowedCustomErrors list
        bytes memory unknownErrorData = abi.encodeWithSelector(bytes4(0x87654321), "some message");
        errAllow(bytes4(unknownErrorData), allowedCustomErrors, "unknown selector test");
    }

    /**
     * Tests for errAllow(bytes memory, string[], bytes4[], string) - combined error handling
     */
    function test_errAllow_combined_require_success() public {
        string[] memory allowedRequireErrors = setup_errAllow_require_error();
        bytes4[] memory allowedCustomErrors = setup_errAllow_custom_error();

        (bool success, bytes memory requireFailureData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");

        // Should pass - testing require failure with both lists provided
        errAllow(requireFailureData, allowedRequireErrors, allowedCustomErrors, "combined require success test");
    }

    function test_errAllow_combined_custom_success() public {
        string[] memory allowedRequireErrors = setup_errAllow_require_error();
        bytes4[] memory allowedCustomErrors = setup_errAllow_custom_error();

        (bool success, bytes memory customErrorData) =
            address(dummy).call(abi.encodeWithSignature("revertWithCustomErrorWithoutMessage()"));
        require(!success, "should fail");

        // Should pass - testing custom error without message with both lists provided
        errAllow(customErrorData, allowedRequireErrors, allowedCustomErrors, "combined custom success test");
    }

    function test_errAllow_combined_custom_with_message_success() public {
        string[] memory allowedRequireErrors = setup_errAllow_require_error();
        bytes4[] memory allowedCustomErrors = setup_errAllow_custom_error();

        (bool success, bytes memory customErrorData) =
            address(dummy).call(abi.encodeWithSignature("revertWithCustomErrorWithMessage()"));
        require(!success, "should fail");

        // Should pass - testing custom error with message with both lists provided
        errAllow(customErrorData, allowedRequireErrors, allowedCustomErrors, "combined custom with message test");
    }

    function test_errAllow_combined_require_failure() public {
        bytes4[] memory allowedCustomErrors = setup_errAllow_custom_error();

        vm.expectEmit(false, false, false, true);
        emit AssertFail("combined require failure test");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        // Should fail - require error but empty require list provided
        bytes memory requireFailureData = abi.encodeWithSelector(bytes4(0x08c379a0), "unallowed message");
        errAllow(requireFailureData, new string[](0), allowedCustomErrors, "combined require failure test");
    }

    function test_errAllow_combined_custom_failure() public {
        string[] memory allowedRequireErrors = setup_errAllow_require_error();

        vm.expectEmit(false, false, false, true);
        emit AssertFail("combined custom failure test");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        // Should fail - custom error but empty custom list provided
        bytes memory customErrorData = abi.encodeWithSelector(bytes4(0x12345678), "some message");
        errAllow(customErrorData, allowedRequireErrors, new bytes4[](0), "combined custom failure test");
    }

    function test_errAllow_combined_unknown_custom_failure() public {
        bytes4[] memory allowedCustomErrors = setup_errAllow_custom_error();

        vm.expectEmit(false, false, false, true);
        emit AssertFail("unknown custom failure test");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        // Should fail - unknown custom error selector not in allowedCustomErrors
        bytes memory unknownCustomErrorData = abi.encodeWithSelector(bytes4(0x87654321), "some message");
        errAllow(unknownCustomErrorData, new string[](0), allowedCustomErrors, "unknown custom failure test");
    }

    /**
     * Tests for zero selector edge cases
     */
    function test_errAllow_zero_selector_allowed() public {
        // Test zero selector (0x00000000) which can happen from require(false) or revert()
        (bool success, bytes memory emptyRequireFailureData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithoutMessage()"));
        require(!success, "should fail");

        bytes4[] memory allowedErrors = new bytes4[](1);
        allowedErrors[0] = bytes4(0);

        // Should pass since zero selector is in allowedErrors
        errAllow(bytes4(emptyRequireFailureData), allowedErrors, "zero selector allowed test");
    }

    function test_errAllow_zero_selector_disallowed() public {
        (bool success, bytes memory emptyRequireFailureData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithoutMessage()"));
        require(!success, "should fail");

        bytes4[] memory allowedErrors = new bytes4[](1);
        allowedErrors[0] = bytes4(0x12345678); // Different selector

        vm.expectEmit(false, false, false, true);
        emit AssertFail("zero selector disallowed test");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        // Should fail since zero selector is not in allowedErrors
        errAllow(bytes4(emptyRequireFailureData), allowedErrors, "zero selector disallowed test");
    }

    /**
     * Tests for edge cases and boundary conditions
     */
    function test_errAllow_multiple_allowed_selectors() public {
        bytes4[] memory multipleAllowedErrors = new bytes4[](3);
        multipleAllowedErrors[0] = bytes4(0x11111111);
        multipleAllowedErrors[1] = bytes4(0x22222222);
        multipleAllowedErrors[2] = bytes4(0x33333333);

        // Test first selector
        errAllow(bytes4(0x11111111), multipleAllowedErrors, "first selector test");

        // Test middle selector
        errAllow(bytes4(0x22222222), multipleAllowedErrors, "middle selector test");

        // Test last selector
        errAllow(bytes4(0x33333333), multipleAllowedErrors, "last selector test");
    }

    function test_errAllow_multiple_allowed_selectors_failure() public {
        bytes4[] memory multipleAllowedErrors = new bytes4[](3);
        multipleAllowedErrors[0] = bytes4(0x11111111);
        multipleAllowedErrors[1] = bytes4(0x22222222);
        multipleAllowedErrors[2] = bytes4(0x33333333);

        vm.expectEmit(false, false, false, true);
        emit AssertFail("multiple selectors failure test");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        // Should fail with selector not in list
        errAllow(bytes4(0x44444444), multipleAllowedErrors, "multiple selectors failure test");
    }

    function test_errAllow_multiple_allowed_require_messages() public {
        string[] memory multipleRequireErrors = new string[](3);
        multipleRequireErrors[0] = "message one";
        multipleRequireErrors[1] = "message two";
        multipleRequireErrors[2] = "message three";

        // Test each allowed message
        bytes memory errorData1 = abi.encodeWithSelector(bytes4(0x08c379a0), "message one");
        errAllow(errorData1, multipleRequireErrors, "first message test");

        bytes memory errorData2 = abi.encodeWithSelector(bytes4(0x08c379a0), "message two");
        errAllow(errorData2, multipleRequireErrors, "second message test");

        bytes memory errorData3 = abi.encodeWithSelector(bytes4(0x08c379a0), "message three");
        errAllow(errorData3, multipleRequireErrors, "third message test");
    }

    function test_errAllow_multiple_allowed_require_messages_failure() public {
        string[] memory multipleRequireErrors = new string[](3);
        multipleRequireErrors[0] = "message one";
        multipleRequireErrors[1] = "message two";
        multipleRequireErrors[2] = "message three";

        vm.expectEmit(false, false, false, true);
        emit AssertFail("multiple messages failure test");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);

        // Should fail with message not in list
        bytes memory errorData = abi.encodeWithSelector(bytes4(0x08c379a0), "message four");
        errAllow(errorData, multipleRequireErrors, "multiple messages failure test");
    }

    /**
     * Fuzz tests for errAllow functions
     */
    function testFuzz_errAllow_empty_arrays_with_random_input(bytes4 selector, string memory message) public {
        // Test behavior with empty arrays and random inputs
        bytes4[] memory emptyCustomErrors = new bytes4[](0);
        string[] memory emptyRequireErrors = new string[](0);

        // Test custom error with empty array - should always fail
        vm.expectEmit(false, false, false, true);
        emit AssertFail("fuzz empty custom array test");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        errAllow(selector, emptyCustomErrors, "fuzz empty custom array test");

        // Test require error with empty array - should always fail
        bytes memory errorData = abi.encodeWithSelector(bytes4(0x08c379a0), message);
        vm.expectEmit(false, false, false, true);
        emit AssertFail("fuzz empty require array test");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        errAllow(errorData, emptyRequireErrors, "fuzz empty require array test");
    }

    /**
     * Tests for assertRevertReasonEqual functions
     */
    function test_assertRevertReasonEqual_single_reason_match() public {
        // Call function that reverts with "require failure message 1"
        (bool success, bytes memory errorData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");

        // Should pass since the message matches
        assertRevertReasonEqual(errorData, "require failure message 1");
    }

    function test_assertRevertReasonEqual_single_reason_no_match() public {
        // Call function that reverts with "require failure message 1"
        (bool success, bytes memory errorData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");

        vm.expectEmit(false, false, false, true);
        emit AssertFail("different message");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        assertRevertReasonEqual(errorData, "different message");
    }

    function test_assertRevertReasonEqual_two_reasons_first_match() public {
        // Call function that reverts with "require failure message 1"
        (bool success, bytes memory errorData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");

        // Should pass since first message matches
        assertRevertReasonEqual(errorData, "require failure message 1", "other message");
    }

    function test_assertRevertReasonEqual_two_reasons_second_match() public {
        // Call function that reverts with "require failure message 1"
        (bool success, bytes memory errorData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");

        // Should pass since second message matches
        assertRevertReasonEqual(errorData, "other message", "require failure message 1");
    }

    function test_assertRevertReasonEqual_two_reasons_no_match() public {
        // Call function that reverts with "require failure message 1"
        (bool success, bytes memory errorData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");

        vm.expectEmit(false, false, false, true);
        emit AssertFail("msg1 OR msg2");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        assertRevertReasonEqual(errorData, "msg1", "msg2");
    }

    function test_assertRevertReasonEqual_three_reasons_match() public {
        // Call function that reverts with "require failure message 1"
        (bool success, bytes memory errorData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");

        // Should pass since second message matches
        assertRevertReasonEqual(errorData, "msg1", "require failure message 1", "msg3");
    }

    function test_assertRevertReasonEqual_three_reasons_no_match() public {
        // Call function that reverts with "require failure message 1"
        (bool success, bytes memory errorData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");

        vm.expectEmit(false, false, false, true);
        emit AssertFail("msg1 OR msg2 OR msg3");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        assertRevertReasonEqual(errorData, "msg1", "msg2", "msg3");
    }

    function test_assertRevertReasonEqual_four_reasons_match() public {
        // Call function that reverts with "require failure message 1"
        (bool success, bytes memory errorData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");

        // Should pass since third message matches
        assertRevertReasonEqual(errorData, "msg1", "msg2", "require failure message 1", "msg4");
    }

    function test_assertRevertReasonEqual_four_reasons_no_match() public {
        // Call function that reverts with "require failure message 1"
        (bool success, bytes memory errorData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");

        vm.expectEmit(false, false, false, true);
        emit AssertFail("msg1 OR msg2 OR msg3 OR msg4");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        assertRevertReasonEqual(errorData, "msg1", "msg2", "msg3", "msg4");
    }

    /**
     * Tests for assertRevertReasonNotEqual function
     */
    function test_assertRevertReasonNotEqual_different_message() public {
        // Call function that reverts with "require failure message 1"
        (bool success, bytes memory errorData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");

        // Should pass since messages are different
        assertRevertReasonNotEqual(errorData, "different message");
    }

    function test_assertRevertReasonNotEqual_same_message() public {
        // Call function that reverts with "require failure message 1"
        (bool success, bytes memory errorData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");

        vm.expectEmit(false, false, false, true);
        emit AssertFail("require failure message 1");
        vm.expectRevert(PlatformTest.TestAssertFail.selector);
        assertRevertReasonNotEqual(errorData, "require failure message 1");
    }

    /**
     * Tests for createAssertFailMessage function
     */
    function test_createAssertFailMessage_basic() public {
        string memory result = createAssertFailMessage("5", "10", "!=", "test reason");
        string memory expected = "Invalid: 5!=10, reason: test reason";

        // Compare using keccak256 since we can't directly compare strings
        assertEq(keccak256(bytes(result)), keccak256(bytes(expected)), "message format incorrect");
    }

    function test_createAssertFailMessage_different_operators() public {
        string memory result1 = createAssertFailMessage("1", "2", "==", "equal test");
        string memory expected1 = "Invalid: 1==2, reason: equal test";
        assertEq(keccak256(bytes(result1)), keccak256(bytes(expected1)), "equal operator format incorrect");

        string memory result2 = createAssertFailMessage("10", "5", ">", "greater test");
        string memory expected2 = "Invalid: 10>5, reason: greater test";
        assertEq(keccak256(bytes(result2)), keccak256(bytes(expected2)), "greater operator format incorrect");
    }

    function test_createAssertFailMessage_empty_strings() public {
        string memory result = createAssertFailMessage("", "", "!=", "");
        string memory expected = "Invalid: !=, reason: ";
        assertEq(keccak256(bytes(result)), keccak256(bytes(expected)), "empty strings format incorrect");
    }

    /**
     * Tests for _isErrorString helper function
     */
    function test_isErrorString() public {
        // Test with Error(string) selector
        (bool success, bytes memory errorData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithMessage()"));
        require(!success, "should fail");
        assertTrue(_isErrorString(bytes4(errorData)), "should be Error(string) type");

        // Test with custom error
        (bool success2, bytes memory customErrorData) =
            address(dummy).call(abi.encodeWithSignature("revertWithCustomErrorWithoutMessage()"));
        require(!success2, "should fail");
        assertFalse(_isErrorString(bytes4(customErrorData)), "should not be Error(string) type");

        // Test with empty error (require(false))
        (bool success3, bytes memory emptyErrorData) =
            address(dummy).call(abi.encodeWithSignature("requireFailWithoutMessage()"));
        require(!success3, "should fail");
        assertFalse(_isErrorString(bytes4(emptyErrorData)), "empty error should not be Error(string) type");
    }
}
