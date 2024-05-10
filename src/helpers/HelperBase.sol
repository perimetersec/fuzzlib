// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IPlatform} from "../platform/IPlatform.sol";

contract HelperBase {
    IPlatform public platform;

    function setPlatform(address _platform) public {
        platform = IPlatform(_platform);
    }
}
