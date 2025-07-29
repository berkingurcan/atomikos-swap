#!/bin/bash
# scripts/deploy-all.sh

# This script deploys the EscrowFactory to both a custom chain (e.g., Monad)
# and the Ethereum Sepolia testnet using the same deployer account.

# --- Configuration ---
# Ensure these environment variables are set in your shell or a .env file:
# Load environment variables from .env file
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "❌ Error: .env file not found. Please create one with the required variables."
  exit 1
fi

# --- Script ---
echo "▶️  Starting deployments..."

# Validate that necessary variables are set
if [[ -z "$CUSTOM_RPC_URL" || -z "$SEPOLIA_RPC_URL" || -z "$DEPLOYER_PRIVATE_KEY" || -z "$DEPLOYER_ADDRESS" ]]; then
  echo "❌ Error: Please set all required environment variables: CUSTOM_RPC_URL, SEPOLIA_RPC_URL, DEPLOYER_PRIVATE_KEY, DEPLOYER_ADDRESS."
  exit 1
fi

echo "-----------------------------------"
echo "🚀 Deploying to Custom Chain..."
echo "-----------------------------------"
forge script script/DeployEscrowFactory.s.sol:DeployEscrowFactory --rpc-url $CUSTOM_RPC_URL --private-key $DEPLOYER_PRIVATE_KEY --broadcast -vvvv
if [ $? -ne 0 ]; then
    echo "❌ Deployment to custom chain failed."
    exit 1
fi
echo "✅ Deployment to custom chain successful."


echo "-----------------------------------"
echo "🚀 Deploying to Sepolia Testnet..."
echo "-----------------------------------"
forge script script/DeployEscrowFactory.s.sol:DeployEscrowFactory --rpc-url $SEPOLIA_RPC_URL --private-key $DEPLOYER_PRIVATE_KEY --broadcast --verify -vvvv
if [ $? -ne 0 ]; then
    echo "❌ Deployment to Sepolia failed."
    exit 1
fi
echo "✅ Deployment to Sepolia successful."


echo "-----------------------------------"
echo "🎉 All deployments completed!"
echo "-----------------------------------"
