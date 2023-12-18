// SPDX-License-Identifier: MIT
import "./Logging.sol";
import "./Constants.sol";
import "./PropertiesHelper.sol";

abstract contract FuzzBase is PropertiesAsserts, Logging, Constants {
    bytes16 internal constant HEX_DIGITS = "0123456789abcdef";

    /// @notice bytes4 version of assertEq
    function assertEq(
        bytes4 a,
        bytes4 b,
        string memory reason
    ) internal {
        if (a != b) {
            bytes memory aBytes = abi.encodePacked(a);
            bytes memory bBytes = abi.encodePacked(b);
            string memory aStr = toHexString(aBytes);
            string memory bStr = toHexString(bBytes);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                "!=",
                bStr,
                ", reason: ",
                reason
            );
            emit AssertEqFail(string(assertMsg));
            assert(false);
        }
    }

    // todo - test that this never reverts
    //
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
}
