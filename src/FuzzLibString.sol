// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice Efficient library for creating string representations of integers.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/LibString.sol)
/// @author Modified from Solady (https://github.com/Vectorized/solady/blob/main/src/utils/LibString.sol)
/// @author Modified from Crytic Properties (https://github.com/crytic/properties/blob/main/contracts/util/PropertiesHelper.sol)
library FuzzLibString {
    bytes16 internal constant HEX_DIGITS = "0123456789abcdef";

    function toString(int256 value) internal pure returns (string memory str) {
        uint256 absValue = value >= 0 ? uint256(value) : uint256(-value);
        str = toString(absValue);

        if (value < 0) {
            str = string(abi.encodePacked("-", str));
        }
    }

    function toString(uint256 value) internal pure returns (string memory str) {
        /// @solidity memory-safe-assembly
        assembly {
            // The maximum value of a uint256 contains 78 digits (1 byte per digit), but we allocate 160 bytes
            // to keep the free memory pointer word aligned. We'll need 1 word for the length, 1 word for the
            // trailing zeros padding, and 3 other words for a max of 78 digits. In total: 5 * 32 = 160 bytes.
            let newFreeMemoryPointer := add(mload(0x40), 160)

            // Update the free memory pointer to avoid overriding our string.
            mstore(0x40, newFreeMemoryPointer)

            // Assign str to the end of the zone of newly allocated memory.
            str := sub(newFreeMemoryPointer, 32)

            // Clean the last word of memory it may not be overwritten.
            mstore(str, 0)

            // Cache the end of the memory to calculate the length later.
            let end := str

            // We write the string from rightmost digit to leftmost digit.
            // The following is essentially a do-while loop that also handles the zero case.
            // prettier-ignore
            for { let temp := value } 1 {} {
                // Move the pointer 1 byte to the left.
                str := sub(str, 1)

                // Write the character to the pointer.
                // The ASCII index of the '0' character is 48.
                mstore8(str, add(48, mod(temp, 10)))

                // Keep dividing temp until zero.
                temp := div(temp, 10)

                 // prettier-ignore
                if iszero(temp) { break }
            }

            // Compute and cache the final total length of the string.
            let length := sub(end, str)

            // Move the pointer 32 bytes leftwards to make room for the length.
            str := sub(str, 32)

            // Store the string's length at the start of memory allocated for our string.
            mstore(str, length)
        }
    }

    function toString(address value) internal pure returns (string memory str) {
        bytes memory s = new bytes(40);
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b = bytes1(
                uint8(uint256(uint160(value)) / (2**(8 * (19 - i))))
            );
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2 * i] = char(hi);
            s[2 * i + 1] = char(lo);
        }
        return string(s);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }

    // based on OZ's toHexString
    // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
    function toHexString(bytes memory value)
        internal
        pure
        returns (string memory)
    {
        bytes memory buffer = new bytes(2 * value.length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 0; i < value.length; i++) {
            uint8 valueByte = uint8(value[i]);
            buffer[2 * i + 2] = HEX_DIGITS[valueByte >> 4];
            buffer[2 * i + 3] = HEX_DIGITS[valueByte & 0xf];
        }
        return string(buffer);
    }

    // https://ethereum.stackexchange.com/a/83577
    function getRevertMsg(bytes memory returnData)
        internal
        pure
        returns (string memory)
    {
        // Check that the data has the right size: 4 bytes for signature + 32 bytes for panic code
        if (returnData.length == 4 + 32) {
            // Check that the data starts with the Panic signature
            bytes4 panicSignature = bytes4(keccak256(bytes("Panic(uint256)")));
            for (uint256 i = 0; i < 4; i++) {
                if (returnData[i] != panicSignature[i])
                    return "Undefined signature";
            }

            uint256 panicCode;
            for (uint256 i = 4; i < 36; i++) {
                panicCode = panicCode << 8;
                panicCode |= uint8(returnData[i]);
            }

            // Now convert the panic code into its string representation
            if (panicCode == 17) {
                return "Panic(17)";
            }

            // Add other panic codes as needed or return a generic "Unknown panic"
            return "Undefined panic code";
        }

        // If the returnData length is less than 68, then the transaction failed silently (without a revert message)
        if (returnData.length < 68) return "Transaction reverted silently";

        assembly {
            // Slice the sighash.
            returnData := add(returnData, 0x04)
        }
        return abi.decode(returnData, (string)); // All that remains is the revert string
    }

    function isRevertReasonEqual(bytes memory returnData, string memory reason)
        internal
        pure
        returns (bool)
    {
        return (keccak256(abi.encodePacked(getRevertMsg(returnData))) ==
            keccak256(abi.encodePacked(reason)));
    }
}
