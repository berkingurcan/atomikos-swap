#!/bin/bash

# Script to check if .env file is properly configured for ATOMIKOS deployment

set -e

echo "=== ATOMIKOS Deployment Environment Check ==="

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found!"
    echo "Please create one by copying .env.example:"
    echo "   cp .env.example .env"
    echo "Then edit it with your actual values."
    exit 1
fi

echo "✅ .env file found"

# Load environment variables
export $(grep -v '^#' .env | xargs) 2>/dev/null || true

# Check required variables
echo ""
echo "=== Checking Required Variables ==="

# Check DEPLOYER_ADDRESS
if [ -z "$DEPLOYER_ADDRESS" ]; then
    echo "❌ DEPLOYER_ADDRESS is not set in .env"
    MISSING_VARS=true
else
    echo "✅ DEPLOYER_ADDRESS: $DEPLOYER_ADDRESS"
fi

# Check DEPLOYER_PRIVATE_KEY
if [ -z "$DEPLOYER_PRIVATE_KEY" ]; then
    echo "❌ DEPLOYER_PRIVATE_KEY is not set in .env"
    MISSING_VARS=true
else
    echo "✅ DEPLOYER_PRIVATE_KEY: [HIDDEN]"
fi



echo ""
if [ "$MISSING_VARS" = true ]; then
    echo "❌ Some required variables are missing. Please update your .env file."
    exit 1
else
    echo "✅ Environment is ready for deployment!"
    echo ""
    echo "You can now run:"
    echo "  ./scripts/deploy-atomikos-sepolia.sh    # Deploy to Sepolia"
    echo "  ./scripts/deploy-atomikos-monad.sh      # Deploy to Monad testnet"
fi
