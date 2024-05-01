// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Platform} from "../../src/platform/Platform.sol";

contract PlatformTest is Platform {
    error BrokenInvariant();

    function breakInvariant() pure public override {
        revert BrokenInvariant();
    }
}
