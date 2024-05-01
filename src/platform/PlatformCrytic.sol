
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Platform} from "./Platform.sol";

contract PlatformCrytic is Platform {
    function breakInvariant() pure public override{
        assert(false);
    }
}
