// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IPlatform} from "../../src/platform/IPlatform.sol";

contract PlatformTest is IPlatform {
    error TestAssertFail();

    function assertFail() pure public override {
        revert TestAssertFail();
    }
}
