// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { Script } from "forge-std/Script.sol";
import { IERC20 } from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import { EscrowFactory } from "contracts/EscrowFactory.sol";
import { ERC20True } from "contracts/mocks/ERC20True.sol";

// solhint-disable no-console
import { console } from "forge-std/console.sol";

contract DeployEscrowFactory is Script {
    uint32 public constant RESCUE_DELAY = 691200; // 8 days

    // Chain IDs
    uint256 public constant SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant MONAD_TESTNET_CHAIN_ID = 10143;

    // Sepolia Testnet Addresses
    address public constant FEE_TOKEN_SEPOLIA = 0x7a627931A433A1155459344d99a67A245582390F; // A DAI-like token on Sepolia
    address public constant ACCESS_TOKEN_SEPOLIA = 0xACCe550000159e70908C0499a1119D04e7039C28; // Same on all chains

    function run() external {
        uint256 chainId = block.chainid;
        address deployer = vm.envAddress("DEPLOYER_ADDRESS");
        address lopAddress;

        vm.startBroadcast();

        if (chainId == SEPOLIA_CHAIN_ID) {
            // Sepolia Deployment
            console.log("Deploying to Sepolia (Chain ID %s)...", chainId);
            lopAddress = vm.envAddress("LOP_SEPOLIA");
            require(lopAddress != address(0), "LOP_SEPOLIA environment variable not set");

            EscrowFactory escrowFactory = new EscrowFactory(
                lopAddress,
                IERC20(FEE_TOKEN_SEPOLIA),
                IERC20(ACCESS_TOKEN_SEPOLIA),
                deployer, // feeBankOwner
                RESCUE_DELAY,
                RESCUE_DELAY
            );
            console.log("Escrow Factory deployed to Sepolia at: ", address(escrowFactory));
        } else {
            // Custom Chain Deployment
            console.log("Deploying to custom chain ID:", chainId);

            if (chainId == MONAD_TESTNET_CHAIN_ID) {
                lopAddress = vm.envAddress("LOP_MONAD_TESTNET");
                require(lopAddress != address(0), "LOP_MONAD_TESTNET environment variable not set");
            } else {
                lopAddress = vm.envAddress("LOP_CUSTOM");
                require(lopAddress != address(0), "LOP_CUSTOM environment variable not set");
            }

            ERC20True accessToken = new ERC20True();
            console.log("Mock Access Token deployed at: ", address(accessToken));

            ERC20True feeToken = new ERC20True();
            console.log("Mock Fee Token deployed at: ", address(feeToken));

            EscrowFactory escrowFactory = new EscrowFactory(
                lopAddress,
                IERC20(address(feeToken)),
                IERC20(address(accessToken)),
                deployer, // feeBankOwner
                RESCUE_DELAY,
                RESCUE_DELAY
            );

            console.log("Escrow Factory deployed to custom chain at: ", address(escrowFactory));
        }

        vm.stopBroadcast();
    }
}
// solhint-enable no-console
