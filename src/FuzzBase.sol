// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Logging.sol";
import "./Constants.sol";
import "./AssertWrapper.sol";
import "./ClampHelper.sol";

abstract contract FuzzBase is AssertWrapper, ClampHelper, Logging, Constants {}
