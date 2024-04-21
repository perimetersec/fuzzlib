// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IHevm} from "./IHevm.sol";
import {IUSDC} from "./interfaces/IUSDC.sol";
import {IUSDT} from "./interfaces/IUSDT.sol";

enum Token {
    USDC,
    USDT
}

contract Onchain {
    error InvalidToken();

    IHevm internal constant vm = IHevm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    address constant USDC_MAINNET = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant USDC_ARBITRUM = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;

    address constant USDT_MAINNET = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address constant USDT_ARBITRUM = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9;

    mapping(uint256 => mapping(Token => address)) chainIdToTokenToAddress;

    constructor() {
        chainIdToTokenToAddress[1][Token.USDC] = USDC_MAINNET;
        chainIdToTokenToAddress[1][Token.USDT] = USDT_MAINNET;
        chainIdToTokenToAddress[42161][Token.USDC] = USDC_ARBITRUM;
        chainIdToTokenToAddress[42161][Token.USDT] = USDT_ARBITRUM;
    }

    function deal(Token token, address to, uint256 give) public {
        if (token == Token.USDC) {
            address tokenAddress = chainIdToTokenToAddress[block.chainid][token];
            address masterMinter = IUSDC(tokenAddress).masterMinter();
            vm.prank(masterMinter);
            IUSDC(tokenAddress).configureMinter(address(this), give);
            vm.prank(masterMinter);
            IUSDC(tokenAddress).mint(to, give);
        } else if (token == Token.USDT) {
            address tokenAddress = chainIdToTokenToAddress[block.chainid][token];
            address owner = IUSDT(tokenAddress).getOwner();
            vm.prank(owner);
            IUSDT(tokenAddress).issue(give);
            vm.prank(owner);
            IUSDT(tokenAddress).transfer(to, give);
        }
        else {
            revert InvalidToken();
        }
    }
}
