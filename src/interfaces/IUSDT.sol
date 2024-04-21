// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IUSDT {
    function getOwner() external returns (address);
    function issue(uint256 amount) external;
    function transfer(address _recipient, uint256 _amount) external;
}
