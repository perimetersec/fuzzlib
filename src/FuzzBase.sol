// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Logging.sol";
import "./Constants.sol";
import "./AssertHelper.sol";
import "./ClampHelper.sol";

abstract contract FuzzBase is AssertHelper, ClampHelper, Logging, Constants {}
