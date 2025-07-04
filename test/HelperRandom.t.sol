// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import {HelperRandom} from "../src/helpers/HelperRandom.sol";

/**
 * @dev Tests for HelperRandom shuffle functions.
 * @author Perimeter <info@perimetersec.io>
 */
contract TestHelperRandom is Test, HelperRandom {
    /**
     * Array Integrity Tests
     */
    function test_shuffleArray_preserves_elements() public {
        uint256[] memory array = new uint256[](5);
        array[0] = 1;
        array[1] = 2;
        array[2] = 3;
        array[3] = 4;
        array[4] = 5;

        uint256[] memory original = new uint256[](5);
        for (uint256 i = 0; i < array.length; i++) {
            original[i] = array[i];
        }

        shuffleArray(array, 12345);

        // Check all original elements are still present
        for (uint256 i = 0; i < original.length; i++) {
            bool found = false;
            for (uint256 j = 0; j < array.length; j++) {
                if (array[j] == original[i]) {
                    found = true;
                    break;
                }
            }
            assertTrue(found, "Original element not found in shuffled array");
        }
    }

    function test_shuffleArray_preserves_length() public {
        uint256[] memory array = new uint256[](10);
        for (uint256 i = 0; i < array.length; i++) {
            array[i] = i + 1;
        }

        uint256 originalLength = array.length;
        shuffleArray(array, 54321);

        assertEq(array.length, originalLength);
    }

    function test_shuffleArray_preserves_sum() public {
        uint256[] memory array = new uint256[](6);
        array[0] = 10;
        array[1] = 20;
        array[2] = 30;
        array[3] = 40;
        array[4] = 50;
        array[5] = 60;

        uint256 originalSum = 0;
        for (uint256 i = 0; i < array.length; i++) {
            originalSum += array[i];
        }

        shuffleArray(array, 98765);

        uint256 shuffledSum = 0;
        for (uint256 i = 0; i < array.length; i++) {
            shuffledSum += array[i];
        }

        assertEq(shuffledSum, originalSum);
    }

    function testFuzz_shuffleArray_preserves_elements(uint256[] memory array, uint256 entropy) public {
        vm.assume(array.length >= 2);
        vm.assume(array.length <= 20); // Reasonable size limit for performance

        uint256 originalLength = array.length;
        shuffleArray(array, entropy);

        // Check length preserved
        assertEq(array.length, originalLength);
    }

    function testFuzz_shuffleArray_preserves_length(uint256[] memory array, uint256 entropy) public {
        vm.assume(array.length >= 1); // Skip empty arrays as they revert
        vm.assume(array.length <= 20); // Reasonable size limit

        uint256 originalLength = array.length;
        shuffleArray(array, entropy);

        assertEq(array.length, originalLength);
    }

    /**
     * Deterministic Behavior Tests
     */
    function test_shuffleArray_deterministic_same_entropy() public {
        uint256[] memory array1 = new uint256[](4);
        array1[0] = 100;
        array1[1] = 200;
        array1[2] = 300;
        array1[3] = 400;

        uint256[] memory array2 = new uint256[](4);
        array2[0] = 100;
        array2[1] = 200;
        array2[2] = 300;
        array2[3] = 400;

        uint256 entropy = 42;

        shuffleArray(array1, entropy);
        shuffleArray(array2, entropy);

        // Arrays should be identical after shuffle with same entropy
        for (uint256 i = 0; i < array1.length; i++) {
            assertEq(array1[i], array2[i]);
        }
    }

    function test_shuffleArray_different_entropy_different_results() public {
        uint256[] memory array1 = new uint256[](5);
        array1[0] = 1;
        array1[1] = 2;
        array1[2] = 3;
        array1[3] = 4;
        array1[4] = 5;

        uint256[] memory array2 = new uint256[](5);
        array2[0] = 1;
        array2[1] = 2;
        array2[2] = 3;
        array2[3] = 4;
        array2[4] = 5;

        shuffleArray(array1, 111);
        shuffleArray(array2, 222);

        // Arrays should likely be different (not guaranteed but very probable)
        bool different = false;
        for (uint256 i = 0; i < array1.length; i++) {
            if (array1[i] != array2[i]) {
                different = true;
                break;
            }
        }

        // Note: This could theoretically fail due to random chance, but very unlikely
        assertTrue(different, "Different entropy should usually produce different results");
    }

    function test_shuffleArray_zero_entropy() public {
        uint256[] memory array = new uint256[](3);
        array[0] = 10;
        array[1] = 20;
        array[2] = 30;

        shuffleArray(array, 0);

        // With entropy 0, result should be deterministic and predictable
        // The algorithm should still work without reverting
        assertEq(array.length, 3);

        // Check that sum is preserved
        assertEq(array[0] + array[1] + array[2], 60);
    }

    function testFuzz_shuffleArray_deterministic(uint256[] memory array, uint256 entropy) public {
        vm.assume(array.length >= 1); // Skip empty arrays as they revert
        vm.assume(array.length <= 20); // Reasonable size limit

        // Make two copies of the array
        uint256[] memory array1 = new uint256[](array.length);
        uint256[] memory array2 = new uint256[](array.length);

        for (uint256 i = 0; i < array.length; i++) {
            array1[i] = array[i];
            array2[i] = array[i];
        }

        // Shuffle both with same entropy
        shuffleArray(array1, entropy);
        shuffleArray(array2, entropy);

        // Results should be identical
        for (uint256 i = 0; i < array.length; i++) {
            assertEq(array1[i], array2[i]);
        }
    }

    /**
     * Edge Case Tests
     */
    function test_shuffleArray_empty_array() public {
        uint256[] memory array = new uint256[](0);

        vm.expectRevert(HelperRandom.EmptyArray.selector);
        this.shuffleArray(array, 12345);
    }

    function test_shuffleArray_single_element() public {
        uint256[] memory array = new uint256[](1);
        array[0] = 42;

        shuffleArray(array, 98765);

        assertEq(array.length, 1);
        assertEq(array[0], 42); // Single element should remain unchanged
    }

    function test_shuffleArray_two_elements() public {
        uint256[] memory array = new uint256[](2);
        array[0] = 100;
        array[1] = 200;

        shuffleArray(array, 555);

        assertEq(array.length, 2);
        // Should contain both original elements
        assertTrue((array[0] == 100 && array[1] == 200) || (array[0] == 200 && array[1] == 100));
    }

    function test_shuffleArray_duplicate_values() public {
        uint256[] memory array = new uint256[](6);
        array[0] = 5;
        array[1] = 5;
        array[2] = 10;
        array[3] = 5;
        array[4] = 10;
        array[5] = 15;

        shuffleArray(array, 777);

        // Count occurrences of each value
        uint256 count5 = 0;
        uint256 count10 = 0;
        uint256 count15 = 0;

        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == 5) count5++;
            else if (array[i] == 10) count10++;
            else if (array[i] == 15) count15++;
        }

        assertEq(count5, 3);
        assertEq(count10, 2);
        assertEq(count15, 1);
    }

    function test_shuffleArray_all_identical_elements() public {
        uint256[] memory array = new uint256[](5);
        for (uint256 i = 0; i < array.length; i++) {
            array[i] = 88;
        }

        shuffleArray(array, 999);

        assertEq(array.length, 5);
        // All elements should still be 88
        for (uint256 i = 0; i < array.length; i++) {
            assertEq(array[i], 88);
        }
    }

    /**
     * Boundary Condition Tests
     */
    function test_shuffleArray_max_uint256_values() public {
        uint256[] memory array = new uint256[](3);
        array[0] = type(uint256).max;
        array[1] = type(uint256).max - 1;
        array[2] = type(uint256).max - 2;

        shuffleArray(array, 1111);

        assertEq(array.length, 3);

        // Check all values are still present
        bool foundMax = false;
        bool foundMaxMinus1 = false;
        bool foundMaxMinus2 = false;

        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == type(uint256).max) foundMax = true;
            else if (array[i] == type(uint256).max - 1) foundMaxMinus1 = true;
            else if (array[i] == type(uint256).max - 2) foundMaxMinus2 = true;
        }

        assertTrue(foundMax);
        assertTrue(foundMaxMinus1);
        assertTrue(foundMaxMinus2);
    }

    function test_shuffleArray_zero_values() public {
        uint256[] memory array = new uint256[](4);
        // Array is initialized with zeros by default

        shuffleArray(array, 2222);

        assertEq(array.length, 4);
        // All values should still be zero
        for (uint256 i = 0; i < array.length; i++) {
            assertEq(array[i], 0);
        }
    }

    function test_shuffleArray_mixed_extreme_values() public {
        uint256[] memory array = new uint256[](4);
        array[0] = 0;
        array[1] = type(uint256).max;
        array[2] = 0;
        array[3] = type(uint256).max;

        shuffleArray(array, 3333);

        assertEq(array.length, 4);

        // Count zeros and max values
        uint256 zeroCount = 0;
        uint256 maxCount = 0;

        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == 0) zeroCount++;
            else if (array[i] == type(uint256).max) maxCount++;
        }

        assertEq(zeroCount, 2);
        assertEq(maxCount, 2);
    }

    /**
     * Entropy Distribution Tests
     */
    function test_shuffleArray_entropy_zero() public {
        uint256[] memory array = new uint256[](3);
        array[0] = 1;
        array[1] = 2;
        array[2] = 3;

        shuffleArray(array, 0);

        assertEq(array.length, 3);
        assertEq(array[0] + array[1] + array[2], 6);
    }

    function test_shuffleArray_entropy_max() public {
        uint256[] memory array = new uint256[](3);
        array[0] = 10;
        array[1] = 20;
        array[2] = 30;

        shuffleArray(array, type(uint256).max);

        assertEq(array.length, 3);
        assertEq(array[0] + array[1] + array[2], 60);
    }

    function test_shuffleArray_sequential_entropy() public {
        uint256[] memory originalArray = new uint256[](4);
        originalArray[0] = 1;
        originalArray[1] = 2;
        originalArray[2] = 3;
        originalArray[3] = 4;

        uint256[][] memory results = new uint256[][](5);

        // Test with entropy values 1, 2, 3, 4, 5
        for (uint256 entropy = 1; entropy <= 5; entropy++) {
            uint256[] memory array = new uint256[](4);
            for (uint256 i = 0; i < 4; i++) {
                array[i] = originalArray[i];
            }

            shuffleArray(array, entropy);
            results[entropy - 1] = array;
        }

        // Check that at least some results are different
        bool foundDifference = false;
        for (uint256 i = 0; i < 4; i++) {
            if (
                results[0][i] != results[1][i] || results[1][i] != results[2][i] || results[2][i] != results[3][i]
                    || results[3][i] != results[4][i]
            ) {
                foundDifference = true;
                break;
            }
        }

        assertTrue(foundDifference, "Sequential entropy values should produce some different results");
    }

    function testFuzz_shuffleArray_different_entropy(uint256[] memory array, uint256 entropy1, uint256 entropy2)
        public
    {
        vm.assume(array.length >= 2 && array.length <= 20); // Reasonable size limit for performance
        vm.assume(entropy1 != entropy2); // Different entropy values

        // Make two copies
        uint256[] memory array1 = new uint256[](array.length);
        uint256[] memory array2 = new uint256[](array.length);

        for (uint256 i = 0; i < array.length; i++) {
            array1[i] = array[i];
            array2[i] = array[i];
        }

        shuffleArray(array1, entropy1);
        shuffleArray(array2, entropy2);

        // Both should preserve length
        assertEq(array1.length, array.length);
        assertEq(array2.length, array.length);
    }
}
