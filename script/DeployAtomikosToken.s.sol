// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { Script } from "forge-std/Script.sol";
import { AtomikosToken } from "contracts/AtomikosToken.sol";

// solhint-disable no-console
import { console } from "forge-std/console.sol";

/**
 * @title DeployAtomikosToken
 * @dev Deployment script for ATOMIKOS token supporting multiple networks
 * @dev Supports Sepolia testnet and Monad testnet deployments
 */
contract DeployAtomikosToken is Script {
    // Chain IDs
    uint256 public constant SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant MONAD_TESTNET_CHAIN_ID = 10143;

    /**
     * @dev Main deployment function
     * @dev Deploys ATOMIKOS token to the current network
     * @dev Uses DEPLOYER_ADDRESS environment variable as the initial owner
     */
    function run() external {
        uint256 chainId = block.chainid;
        address deployer = vm.envAddress("DEPLOYER_ADDRESS");

        console.log("=== ATOMIKOS Token Deployment ===");
        console.log("Chain ID: %s", chainId);
        console.log("Deployer Address: %s", deployer);

        vm.startBroadcast();

        // Deploy ATOMIKOS token with deployer as initial owner
        AtomikosToken atomikosToken = new AtomikosToken(deployer);

        vm.stopBroadcast();

        // Log deployment details
        console.log("=== Deployment Successful ===");
        console.log("ATOMIKOS Token deployed at: %s", address(atomikosToken));
        console.log("Token Name: %s", atomikosToken.name());
        console.log("Token Symbol: %s", atomikosToken.symbol());
        console.log("Token Decimals: %s", atomikosToken.decimals());
        console.log("Total Supply: %s", atomikosToken.totalSupply());
        console.log("Owner: %s", atomikosToken.owner());
        console.log("Balance of owner: %s", atomikosToken.balanceOf(deployer));

        // Network-specific logging
        if (chainId == SEPOLIA_CHAIN_ID) {
            console.log("Network: Sepolia Testnet");
        } else if (chainId == MONAD_TESTNET_CHAIN_ID) {
            console.log("Network: Monad Testnet");
        } else {
            console.log("Network: Custom Chain (ID: %s)", chainId);
        }

        console.log("=== Deployment Complete ===");
    }

    /**
     * @dev Helper function to get network name by chain ID
     * @param chainId The chain ID to get the name for
     * @return The network name
     */
    function getNetworkName(uint256 chainId) public pure returns (string memory) {
        if (chainId == SEPOLIA_CHAIN_ID) {
            return "Sepolia";
        } else if (chainId == MONAD_TESTNET_CHAIN_ID) {
            return "Monad Testnet";
        } else {
            return "Unknown";
        }
    }
}
// solhint-enable no-console
