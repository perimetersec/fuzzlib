// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Random utility functions for fuzzing operations.
 * @author Perimeter <info@perimetersec.io>
 */
abstract contract HelperRandom {
    /**
     * @dev Shuffles an array in-place using the Fisher-Yates algorithm.
     * Based on https://gist.github.com/scammi/602387a22e04c77beb73c0ebc0f0bc18
     * @param shuffle The array to shuffle in-place
     * @param entropy Random value used as seed for shuffling
     */
    function shuffleArray(
        uint256[] memory shuffle,
        uint256 entropy
    ) public pure {
        for (uint256 i = shuffle.length - 1; i > 0; i--) {
            uint256 swapIndex = entropy % (shuffle.length - i);

            uint256 currentIndex = shuffle[i];
            uint256 indexToSwap = shuffle[swapIndex];

            shuffle[i] = indexToSwap;
            shuffle[swapIndex] = currentIndex;
        }
    }
}
