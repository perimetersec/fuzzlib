// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import {DummyContract} from "./DummyContract.sol";

/**
 * @dev Helper contract for errAllow testing functionality.
 * @author Perimeter <info@perimetersec.io>
 */
contract ErrAllowTestHelper {
    function setup_errAllow_require_error() internal pure returns (string[] memory) {
        // set require failure related
        string[] memory allowedRequireErrors = new string[](2);
        allowedRequireErrors[0] = "require failure message 1";
        allowedRequireErrors[1] = "require failure message 2";

        return allowedRequireErrors;
    }

    function setup_errAllow_custom_error() internal pure returns (bytes4[] memory) {
        // set custom error related
        bytes4 customErrorSelector1 = bytes4(DummyContract.DummyCustomError1.selector);
        bytes4 customErrorSelector2 = bytes4(DummyContract.DummyCustomError2.selector);
        bytes4[] memory allowedCustomErrors = new bytes4[](2);
        allowedCustomErrors[0] = customErrorSelector1;
        allowedCustomErrors[1] = customErrorSelector2;

        return allowedCustomErrors;
    }
}
