#!/bin/bash

# Deploy ATOMIKOS token to Monad testnet
# Reads environment variables from .env file

set -e

echo "=== Deploying ATOMIKOS Token to Monad Testnet ==="

# Load environment variables from .env file
if [ -f ".env" ]; then
    echo "Loading environment variables from .env file..."
    export $(grep -v '^#' .env | xargs)
else
    echo "Warning: .env file not found. Make sure to create one from .env.example"
    echo "You can also set environment variables manually."
fi

# Check required environment variables
if [ -z "$DEPLOYER_ADDRESS" ]; then
    echo "Error: DEPLOYER_ADDRESS environment variable is not set"
    echo "Please set it in your .env file or environment"
    exit 1
fi

if [ -z "$DEPLOYER_PRIVATE_KEY" ]; then
    echo "Error: DEPLOYER_PRIVATE_KEY environment variable is not set"
    echo "Please set it in your .env file or environment"
    exit 1
fi

echo "Deployer Address: $DEPLOYER_ADDRESS"
echo "Network: Monad Testnet"
echo "Chain ID: 10143"

# Deploy the contract
forge script script/DeployAtomikosToken.s.sol:DeployAtomikosToken \
    --rpc-url monad_testnet \
    --private-key $DEPLOYER_PRIVATE_KEY \
    --broadcast \
    --legacy \
    -vvvv

echo "=== Deployment to Monad Testnet completed! ==="
echo "Check the output above for the deployed contract address."
echo "Note: Contract verification is not available on Monad testnet yet."
