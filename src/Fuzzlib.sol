// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {HelperBase} from "./helpers/HelperBase.sol";
import {HelperAssert} from "./helpers/HelperAssert.sol";
import {HelperClamp} from "./helpers/HelperClamp.sol";
import {HelperLog} from "./helpers/HelperLog.sol";
import {HelperMath} from "./helpers/HelperMath.sol";
import {HelperRandom} from "./helpers/HelperRandom.sol";
import {HelperCall} from "./helpers/HelperCall.sol";

contract Fuzzlib is
    HelperBase,
    HelperAssert,
    HelperClamp,
    HelperLog,
    HelperMath,
    HelperRandom,
    HelperCall
{}
