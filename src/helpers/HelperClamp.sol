// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../FuzzLibString.sol";
import "./HelperAssert.sol";

/// @author Based on Crytic PropertiesHelper (https://github.com/crytic/properties/blob/main/contracts/util/PropertiesHelper.sol)
abstract contract HelperClamp is HelperAssert {
    event Clamped(string);

    /*
     **************************************************************************
     * Clamp functions with logging enabled
     **************************************************************************
     */

    /// @notice Clamps value to be between low and high, both inclusive
    function clamp(
        uint256 value,
        uint256 low,
        uint256 high
    ) public returns (uint256) {
        return clamp(value, low, high, true);
    }

    /// @notice int256 version of clamp
    function clamp(
        int256 value,
        int256 low,
        int256 high
    ) public returns (int256) {
        return clamp(value, low, high, true);
    }

    /// @notice clamps a to be less than b
    function clampLt(uint256 a, uint256 b) public returns (uint256) {
        return clampLt(a, b);
    }

    /// @notice int256 version of clampLt
    function clampLt(int256 a, int256 b) public returns (int256) {
        return clampLt(a, b, true);
    }

    /// @notice clamps a to be less than or equal to b
    function clampLte(uint256 a, uint256 b) public returns (uint256) {
        return clampLte(a, b, true);
    }

    /// @notice int256 version of clampLte
    function clampLte(int256 a, int256 b) public returns (int256) {
        return clampLte(a, b, true);
    }

    /// @notice clamps a to be greater than b
    function clampGt(uint256 a, uint256 b) public returns (uint256) {
        return clampGt(a, b, true);
    }

    /// @notice int256 version of clampGt
    function clampGt(int256 a, int256 b) public returns (int256) {
        return clampGt(a, b, true);
    }

    /// @notice clamps a to be greater than or equal to b
    function clampGte(uint256 a, uint256 b) public returns (uint256) {
        return clampGte(a, b, true);
    }

    /// @notice int256 version of clampGte
    function clampGte(int256 a, int256 b) public returns (int256) {
        return clampGte(a, b, true);
    }

    /*
     **************************************************************************
     * Clamp functions with optional logging
     **************************************************************************
     */

    /// @notice Clamps value to be between low and high, both inclusive
    function clamp(
        uint256 value,
        uint256 low,
        uint256 high,
        bool enableLogs
    ) public returns (uint256) {
        if (value < low || value > high) {
            uint256 ans = low + (value % (high - low + 1));
            if (enableLogs) {
                string memory valueStr = FuzzLibString.toString(value);
                string memory ansStr = FuzzLibString.toString(ans);
                bytes memory message = abi.encodePacked(
                    "Clamping value ",
                    valueStr,
                    " to ",
                    ansStr
                );
                emit Clamped(string(message));
            }
            return ans;
        }
        return value;
    }

    /// @notice int256 version of clamp
    function clamp(
        int256 value,
        int256 low,
        int256 high,
        bool enableLogs
    ) public returns (int256) {
        if (value < low || value > high) {
            int256 range = high - low + 1;
            int256 clamped = (value - low) % (range);
            if (clamped < 0) clamped += range;
            int256 ans = low + clamped;
            if (enableLogs) {
                string memory valueStr = FuzzLibString.toString(value);
                string memory ansStr = FuzzLibString.toString(ans);
                bytes memory message = abi.encodePacked(
                    "Clamping value ",
                    valueStr,
                    " to ",
                    ansStr
                );
                emit Clamped(string(message));
            }
            return ans;
        }
        return value;
    }

    /// @notice clamps a to be less than b
    function clampLt(
        uint256 a,
        uint256 b,
        bool enableLogs
    ) public returns (uint256) {
        if (!(a < b)) {
            neq(
                b,
                0,
                "clampLt cannot clamp value a to be less than zero. Check your inputs/assumptions."
            );
            uint256 value = a % b;
            if (enableLogs) {
                string memory aStr = FuzzLibString.toString(a);
                string memory valueStr = FuzzLibString.toString(value);
                bytes memory message = abi.encodePacked(
                    "Clamping value ",
                    aStr,
                    " to ",
                    valueStr
                );
                emit Clamped(string(message));
            }
            return value;
        }
        return a;
    }

    /// @notice int256 version of clampLt
    function clampLt(
        int256 a,
        int256 b,
        bool enableLogs
    ) public returns (int256) {
        if (!(a < b)) {
            int256 value = b - 1;
            if (enableLogs) {
                string memory aStr = FuzzLibString.toString(a);
                string memory valueStr = FuzzLibString.toString(value);
                bytes memory message = abi.encodePacked(
                    "Clamping value ",
                    aStr,
                    " to ",
                    valueStr
                );
                emit Clamped(string(message));
            }
            return value;
        }
        return a;
    }

    /// @notice clamps a to be less than or equal to b
    function clampLte(
        uint256 a,
        uint256 b,
        bool enableLogs
    ) public returns (uint256) {
        if (!(a <= b)) {
            uint256 value = a % (b + 1);
            if (enableLogs) {
                string memory aStr = FuzzLibString.toString(a);
                string memory valueStr = FuzzLibString.toString(value);
                bytes memory message = abi.encodePacked(
                    "Clamping value ",
                    aStr,
                    " to ",
                    valueStr
                );
                emit Clamped(string(message));
            }
            return value;
        }
        return a;
    }

    /// @notice int256 version of clampLte
    function clampLte(
        int256 a,
        int256 b,
        bool enableLogs
    ) public returns (int256) {
        if (!(a <= b)) {
            int256 value = b;
            if (enableLogs) {
                string memory aStr = FuzzLibString.toString(a);
                string memory valueStr = FuzzLibString.toString(value);
                bytes memory message = abi.encodePacked(
                    "Clamping value ",
                    aStr,
                    " to ",
                    valueStr
                );
                emit Clamped(string(message));
            }
            return value;
        }
        return a;
    }

    /// @notice clamps a to be greater than b
    function clampGt(
        uint256 a,
        uint256 b,
        bool enableLogs
    ) public returns (uint256) {
        if (!(a > b)) {
            neq(
                b,
                type(uint256).max,
                "clampGt cannot clamp value a to be larger than uint256.max. Check your inputs/assumptions."
            );
            uint256 value = b + 1;
            if (enableLogs) {
                string memory aStr = FuzzLibString.toString(a);
                string memory valueStr = FuzzLibString.toString(value);
                bytes memory message = abi.encodePacked(
                    "Clamping value ",
                    aStr,
                    " to ",
                    valueStr
                );
                emit Clamped(string(message));
            }
            return value;
        } else {
            return a;
        }
    }

    /// @notice int256 version of clampGt
    function clampGt(
        int256 a,
        int256 b,
        bool enableLogs
    ) public returns (int256) {
        if (!(a > b)) {
            int256 value = b + 1;
            if (enableLogs) {
                string memory aStr = FuzzLibString.toString(a);
                string memory valueStr = FuzzLibString.toString(value);
                bytes memory message = abi.encodePacked(
                    "Clamping value ",
                    aStr,
                    " to ",
                    valueStr
                );
                emit Clamped(string(message));
            }
            return value;
        } else {
            return a;
        }
    }

    /// @notice clamps a to be greater than or equal to b
    function clampGte(
        uint256 a,
        uint256 b,
        bool enableLogs
    ) public returns (uint256) {
        if (!(a > b)) {
            uint256 value = b;
            if (enableLogs) {
                string memory aStr = FuzzLibString.toString(a);
                string memory valueStr = FuzzLibString.toString(value);
                bytes memory message = abi.encodePacked(
                    "Clamping value ",
                    aStr,
                    " to ",
                    valueStr
                );
                emit Clamped(string(message));
            }
            return value;
        }
        return a;
    }

    /// @notice int256 version of clampGte
    function clampGte(
        int256 a,
        int256 b,
        bool enableLogs
    ) public returns (int256) {
        if (!(a > b)) {
            int256 value = b;
            if (enableLogs) {
                string memory aStr = FuzzLibString.toString(a);
                string memory valueStr = FuzzLibString.toString(value);
                bytes memory message = abi.encodePacked(
                    "Clamping value ",
                    aStr,
                    " to ",
                    valueStr
                );
                emit Clamped(string(message));
            }
            return value;
        }
        return a;
    }
}
