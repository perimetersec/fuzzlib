// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Logging.sol";
import "./Constants.sol";
import "./AssertWrapper.sol";
import "./ClampWrapper.sol";

abstract contract FuzzBase is AssertWrapper, ClampWrapper, Logging, Constants {}
