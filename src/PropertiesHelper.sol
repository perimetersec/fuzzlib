pragma solidity ^0.8.0;

import "./FuzzLibString.sol";

abstract contract PropertiesAsserts {
    event LogUint256(string, uint256);
    event LogAddress(string, address);
    event LogString(string);

    event AssertFail(string);
    event AssertEqFail(string);
    event AssertNeqFail(string);
    event AssertGteFail(string);
    event AssertGtFail(string);
    event AssertLteFail(string);
    event AssertLtFail(string);

    function assertWithMsg(bool b, string memory reason) internal {
        if (!b) {
            emit AssertFail(reason);
            assert(false);
        }
    }

    /// @notice asserts that a is equal to b. Violations are logged using reason.
    function assertEq(
        uint256 a,
        uint256 b,
        string memory reason
    ) internal {
        if (a != b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
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

    /// @notice int256 version of assertEq
    function assertEq(
        int256 a,
        int256 b,
        string memory reason
    ) internal {
        if (a != b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
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

    /// @notice asserts that a is not equal to b. Violations are logged using reason.
    function assertNeq(
        uint256 a,
        uint256 b,
        string memory reason
    ) internal {
        if (a == b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                "==",
                bStr,
                ", reason: ",
                reason
            );
            emit AssertNeqFail(string(assertMsg));
            assert(false);
        }
    }

    /// @notice int256 version of assertNeq
    function assertNeq(
        int256 a,
        int256 b,
        string memory reason
    ) internal {
        if (a == b) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                "==",
                bStr,
                ", reason: ",
                reason
            );
            emit AssertNeqFail(string(assertMsg));
            assert(false);
        }
    }

    /// @notice asserts that a is greater than or equal to b. Violations are logged using reason.
    function assertGte(
        uint256 a,
        uint256 b,
        string memory reason
    ) internal {
        if (!(a >= b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                "<",
                bStr,
                " failed, reason: ",
                reason
            );
            emit AssertGteFail(string(assertMsg));
            assert(false);
        }
    }

    /// @notice int256 version of assertGte
    function assertGte(
        int256 a,
        int256 b,
        string memory reason
    ) internal {
        if (!(a >= b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                "<",
                bStr,
                " failed, reason: ",
                reason
            );
            emit AssertGteFail(string(assertMsg));
            assert(false);
        }
    }

    /// @notice asserts that a is greater than b. Violations are logged using reason.
    function assertGt(
        uint256 a,
        uint256 b,
        string memory reason
    ) internal {
        if (!(a > b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                "<=",
                bStr,
                " failed, reason: ",
                reason
            );
            emit AssertGtFail(string(assertMsg));
            assert(false);
        }
    }

    /// @notice int256 version of assertGt
    function assertGt(
        int256 a,
        int256 b,
        string memory reason
    ) internal {
        if (!(a > b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                "<=",
                bStr,
                " failed, reason: ",
                reason
            );
            emit AssertGtFail(string(assertMsg));
            assert(false);
        }
    }

    /// @notice asserts that a is less than or equal to b. Violations are logged using reason.
    function assertLte(
        uint256 a,
        uint256 b,
        string memory reason
    ) internal {
        if (!(a <= b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                ">",
                bStr,
                " failed, reason: ",
                reason
            );
            emit AssertLteFail(string(assertMsg));
            assert(false);
        }
    }

    /// @notice int256 version of assertLte
    function assertLte(
        int256 a,
        int256 b,
        string memory reason
    ) internal {
        if (!(a <= b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                ">",
                bStr,
                " failed, reason: ",
                reason
            );
            emit AssertLteFail(string(assertMsg));
            assert(false);
        }
    }

    /// @notice asserts that a is less than b. Violations are logged using reason.
    function assertLt(
        uint256 a,
        uint256 b,
        string memory reason
    ) internal {
        if (!(a < b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                ">=",
                bStr,
                " failed, reason: ",
                reason
            );
            emit AssertLtFail(string(assertMsg));
            assert(false);
        }
    }

    /// @notice int256 version of assertLt
    function assertLt(
        int256 a,
        int256 b,
        string memory reason
    ) internal {
        if (!(a < b)) {
            string memory aStr = FuzzLibString.toString(a);
            string memory bStr = FuzzLibString.toString(b);
            bytes memory assertMsg = abi.encodePacked(
                "Invalid: ",
                aStr,
                ">=",
                bStr,
                " failed, reason: ",
                reason
            );
            emit AssertLtFail(string(assertMsg));
            assert(false);
        }
    }

    /// @notice Clamps value to be between low and high, both inclusive
    function clampBetween(
        uint256 value,
        uint256 low,
        uint256 high
    ) internal returns (uint256) {
        if (value < low || value > high) {
            uint256 ans = low + (value % (high - low + 1));
            string memory valueStr = FuzzLibString.toString(value);
            string memory ansStr = FuzzLibString.toString(ans);
            bytes memory message = abi.encodePacked(
                "Clamping value ",
                valueStr,
                " to ",
                ansStr
            );
            emit LogString(string(message));
            return ans;
        }
        return value;
    }

    /// @notice int256 version of clampBetween
    function clampBetween(
        int256 value,
        int256 low,
        int256 high
    ) internal returns (int256) {
        if (value < low || value > high) {
            int256 range = high - low + 1;
            int256 clamped = (value - low) % (range);
            if (clamped < 0) clamped += range;
            int256 ans = low + clamped;
            string memory valueStr = FuzzLibString.toString(value);
            string memory ansStr = FuzzLibString.toString(ans);
            bytes memory message = abi.encodePacked(
                "Clamping value ",
                valueStr,
                " to ",
                ansStr
            );
            emit LogString(string(message));
            return ans;
        }
        return value;
    }

    /// @notice clamps a to be less than b
    function clampLt(uint256 a, uint256 b) internal returns (uint256) {
        if (!(a < b)) {
            assertNeq(
                b,
                0,
                "clampLt cannot clamp value a to be less than zero. Check your inputs/assumptions."
            );
            uint256 value = a % b;
            string memory aStr = FuzzLibString.toString(a);
            string memory valueStr = FuzzLibString.toString(value);
            bytes memory message = abi.encodePacked(
                "Clamping value ",
                aStr,
                " to ",
                valueStr
            );
            emit LogString(string(message));
            return value;
        }
        return a;
    }

    /// @notice int256 version of clampLt
    function clampLt(int256 a, int256 b) internal returns (int256) {
        if (!(a < b)) {
            int256 value = b - 1;
            string memory aStr = FuzzLibString.toString(a);
            string memory valueStr = FuzzLibString.toString(value);
            bytes memory message = abi.encodePacked(
                "Clamping value ",
                aStr,
                " to ",
                valueStr
            );
            emit LogString(string(message));
            return value;
        }
        return a;
    }

    /// @notice clamps a to be less than or equal to b
    function clampLte(uint256 a, uint256 b) internal returns (uint256) {
        if (!(a <= b)) {
            uint256 value = a % (b + 1);
            string memory aStr = FuzzLibString.toString(a);
            string memory valueStr = FuzzLibString.toString(value);
            bytes memory message = abi.encodePacked(
                "Clamping value ",
                aStr,
                " to ",
                valueStr
            );
            emit LogString(string(message));
            return value;
        }
        return a;
    }

    /// @notice int256 version of clampLte
    function clampLte(int256 a, int256 b) internal returns (int256) {
        if (!(a <= b)) {
            int256 value = b;
            string memory aStr = FuzzLibString.toString(a);
            string memory valueStr = FuzzLibString.toString(value);
            bytes memory message = abi.encodePacked(
                "Clamping value ",
                aStr,
                " to ",
                valueStr
            );
            emit LogString(string(message));
            return value;
        }
        return a;
    }

    /// @notice clamps a to be greater than b
    function clampGt(uint256 a, uint256 b) internal returns (uint256) {
        if (!(a > b)) {
            assertNeq(
                b,
                type(uint256).max,
                "clampGt cannot clamp value a to be larger than uint256.max. Check your inputs/assumptions."
            );
            uint256 value = b + 1;
            string memory aStr = FuzzLibString.toString(a);
            string memory valueStr = FuzzLibString.toString(value);
            bytes memory message = abi.encodePacked(
                "Clamping value ",
                aStr,
                " to ",
                valueStr
            );
            emit LogString(string(message));
            return value;
        } else {
            return a;
        }
    }

    /// @notice int256 version of clampGt
    function clampGt(int256 a, int256 b) internal returns (int256) {
        if (!(a > b)) {
            int256 value = b + 1;
            string memory aStr = FuzzLibString.toString(a);
            string memory valueStr = FuzzLibString.toString(value);
            bytes memory message = abi.encodePacked(
                "Clamping value ",
                aStr,
                " to ",
                valueStr
            );
            emit LogString(string(message));
            return value;
        } else {
            return a;
        }
    }

    /// @notice clamps a to be greater than or equal to b
    function clampGte(uint256 a, uint256 b) internal returns (uint256) {
        if (!(a > b)) {
            uint256 value = b;
            string memory aStr = FuzzLibString.toString(a);
            string memory valueStr = FuzzLibString.toString(value);
            bytes memory message = abi.encodePacked(
                "Clamping value ",
                aStr,
                " to ",
                valueStr
            );
            emit LogString(string(message));
            return value;
        }
        return a;
    }

    /// @notice int256 version of clampGte
    function clampGte(int256 a, int256 b) internal returns (int256) {
        if (!(a > b)) {
            int256 value = b;
            string memory aStr = FuzzLibString.toString(a);
            string memory valueStr = FuzzLibString.toString(value);
            bytes memory message = abi.encodePacked(
                "Clamping value ",
                aStr,
                " to ",
                valueStr
            );
            emit LogString(string(message));
            return value;
        }
        return a;
    }
}
