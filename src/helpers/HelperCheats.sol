// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IHevm} from "../IHevm.sol";
import {IStdCheats} from "../IStdCheats.sol";
import {Constants} from "../Constants.sol";

abstract contract HelperCheats {
    IHevm internal vm = IHevm(Constants.ADDRESS_CHEATS); // echidna
    IStdCheats internal mvm = IStdCheats(Constants.ADDRESS_CHEATS); // medusa

    function warp(uint256 timestamp) public {
        vm.warp(timestamp);
    }

    function roll(uint256 blockNumber) public {
        vm.roll(blockNumber);
    }

    function prank(address sender) public {
        vm.prank(sender);
    }

    function deal(address sender, uint amount) public {
        vm.deal(sender, amount);
    }
}
