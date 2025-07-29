// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { Script } from "forge-std/Script.sol";
import { IERC20 } from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import { ICreate3Deployer } from "solidity-utils/contracts/interfaces/ICreate3Deployer.sol";

import { EscrowFactory } from "contracts/EscrowFactory.sol";
import { ERC20True } from "contracts/mocks/ERC20True.sol";

// solhint-disable no-console
import { console } from "forge-std/console.sol";

contract DeployEscrowFactory is Script {
    uint32 public constant RESCUE_DELAY = 691200; // 8 days
    bytes32 public constant CROSSCHAIN_SALT = keccak256("1inch EscrowFactory");

    // Sepolia Testnet Addresses
    address public constant LOP_SEPOLIA = 0x111111125421cA6dc452d289314280a0f8842A65; // Same on all chains
    address public constant FEE_TOKEN_SEPOLIA = 0x7a627931A433A1155459344d99a67A245582390F; // A DAI-like token on Sepolia
    address public constant ACCESS_TOKEN_SEPOLIA = 0xACCe550000159e70908C0499a1119D04e7039C28; // Same on all chains
    ICreate3Deployer public constant CREATE3_DEPLOYER = ICreate3Deployer(0x65B3Db8bAeF0215A1F9B14c506D2a3078b2C84AE); // Same on all chains

    function run() external {
        uint256 chainId = block.chainid;
        address deployer = vm.envAddress("DEPLOYER_ADDRESS");

        vm.startBroadcast();

        if (chainId == 11155111) {
            // Sepolia Deployment
            address escrowFactory = CREATE3_DEPLOYER.deploy(
                CROSSCHAIN_SALT,
                abi.encodePacked(
                    type(EscrowFactory).creationCode,
                    abi.encode(
                        LOP_SEPOLIA,
                        IERC20(FEE_TOKEN_SEPOLIA),
                        IERC20(ACCESS_TOKEN_SEPOLIA),
                        deployer, // feeBankOwner
                        RESCUE_DELAY,
                        RESCUE_DELAY
                    )
                )
            );
            console.log("Escrow Factory deployed to Sepolia at: ", escrowFactory);
        } else {
            // Custom Chain Deployment
            console.log("Deploying to custom chain ID:", chainId);

            ERC20True accessToken = new ERC20True();
            console.log("Mock Access Token deployed at: ", address(accessToken));

            ERC20True feeToken = new ERC20True();
            console.log("Mock Fee Token deployed at: ", address(feeToken));

            address lop_placeholder = deployer;

            EscrowFactory escrowFactory = new EscrowFactory(
                lop_placeholder,
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
