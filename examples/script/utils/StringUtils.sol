// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

library StringUtils {
    function isEqualTo(string memory str1, string memory str2) internal pure returns (bool) {
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }

    function contains(string memory str, string memory substr) internal pure returns (bool) {
        bytes memory strBytes = bytes(str);
        bytes memory substrBytes = bytes(substr);
        if (strBytes.length < substrBytes.length || strBytes.length == 0) {
            return false;
        }

        for (uint256 i = 0; i <= strBytes.length - substrBytes.length; i++) {
            bool isEqual = true;
            for (uint256 j = 0; j < substrBytes.length; j++) {
                if (strBytes[i + j] != substrBytes[j]) {
                    isEqual = false;
                    break;
                }
            }
            if (isEqual) return true;
        }
        return false;
    }
}