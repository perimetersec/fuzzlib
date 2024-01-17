// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Logging.sol";
import "./Constants.sol";
import "./AssertHelper.sol";
import "./ClampWrapper.sol";

abstract contract FuzzBase is AssertHelper, ClampWrapper, Logging, Constants {}
