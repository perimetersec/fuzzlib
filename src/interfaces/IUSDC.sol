// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IUSDC {
    function masterMinter() external view returns (address);
    function configureMinter(address minter, uint256 minterAllowedAmount) external;
    function mint(address to, uint256 amount) external;
}
