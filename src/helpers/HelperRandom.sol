// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract HelperRandom {
    /// @notice Shuffle an array using Fisher-Yates algorithm
    /// @dev Based on https://gist.github.com/scammi/602387a22e04c77beb73c0ebc0f0bc18
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
