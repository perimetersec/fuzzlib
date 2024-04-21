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
    IHevm internal constant vm = IHevm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    address constant USDC_MAINNET = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant USDC_ARBITRUM = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;

    address constant USDT_MAINNET = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address constant USDT_ARBITRUM = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9;

    mapping(Token => mapping(uint256 => address)) internal tokenToChainIdToAddress;

    constructor() {
        tokenToChainIdToAddress[Token.USDC][1] = USDC_MAINNET;
        tokenToChainIdToAddress[Token.USDT][1] = USDT_MAINNET;
        tokenToChainIdToAddress[Token.USDC][42161] = USDC_ARBITRUM;
        tokenToChainIdToAddress[Token.USDT][42161] = USDT_ARBITRUM;
    }

    function deal(Token token, address to, uint256 give) public {
        address tokenAddress = tokenToChainIdToAddress[token][block.chainid];
        if (token == Token.USDC) {
            address masterMinter = IUSDC(tokenAddress).masterMinter();
            vm.prank(masterMinter);
            IUSDC(tokenAddress).configureMinter(address(this), give);
            IUSDC(tokenAddress).mint(to, give);
        } else if (token == Token.USDT) {
            address owner = IUSDT(tokenAddress).getOwner();
            vm.prank(owner);
            IUSDT(tokenAddress).issue(give);
            vm.prank(owner);
            IUSDT(tokenAddress).transfer(to, give);
        }
    }
}
