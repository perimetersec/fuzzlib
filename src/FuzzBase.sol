// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AssertWrapper.sol";
import "./ClampWrapper.sol";
import "./MathHelper.sol";
import "./RandomHelper.sol";
import "./Logging.sol";
import "./Constants.sol";
import "./IHevm.sol";
import "./IStdCheats.sol";

abstract contract FuzzBase is
    AssertWrapper,
    ClampWrapper,
    MathHelper,
    RandomHelper,
    Logging,
    Constants
{
    IHevm internal vm = IHevm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D); // for echidna
    IStdCheats internal mvm = IStdCheats(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D); // for medusa
}
