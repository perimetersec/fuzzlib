// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Fuzzlib} from "./Fuzzlib.sol";
import {PlatformCrytic} from "./platform/PlatformCrytic.sol";

abstract contract FuzzBase {
    Fuzzlib internal fl = new Fuzzlib();

    constructor() {
        fl.setPlatform(address(new PlatformCrytic()));
    }
}
