
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IPlatform} from "./IPlatform.sol";

contract PlatformCrytic is IPlatform {
    function assertFail() pure public override{
        assert(false);
    }
}
