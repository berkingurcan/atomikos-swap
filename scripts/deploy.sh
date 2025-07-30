#!/bin/zsh

set -e # exit on error

# Source the .env file to load the variables
if [ -f .env ]; then
    source .env
else
    echo "Error: .env file not found"
    exit 1
fi

# Define the chain configurations
typeset -A chains
chains["mainnet"]="$MAINNET_RPC_URL"
chains["bsc"]="$BSC_RPC_URL"
chains["sepolia"]="$SEPOLIA_RPC_URL"
chains["monad"]="$MONAD_RPC_URL"
chains["monad-testnet"]="$MONAD_TESTNET_RPC_URL"

rpc_url="${chains["$1"]}"
if [ -z "$rpc_url" ]; then
    echo "Chain not found"
    exit 1
fi

# Check for LOP address based on the chain
chain_name=$(echo "$1" | tr '[:lower:]' '[:upper:]' | sed 's/-/_/g')
lop_address_var="LOP_${chain_name}"
if [ -z "${!lop_address_var}" ]; then
    echo "Error: LOP address for chain $1 not set. Please set ${lop_address_var} in your .env file."
    exit 1
fi

echo "Provided chain: $1"
echo "RPC URL: $rpc_url"
echo "LOP Address variable: $lop_address_var"


keystore="$HOME/.foundry/keystores/$2"
echo "Keystore: $keystore"
if [ -e "$keystore" ]; then
    echo "Keystore provided"
else
    echo "Keystore not provided"
    exit 1
fi

if [ "$1" = "zksync" ]; then
    forge script script/DeployEscrowFactoryZkSync.s.sol --zksync --fork-url $rpc_url --keystore $keystore --broadcast -vvvv
else
    forge script script/DeployEscrowFactory.s.sol --fork-url $rpc_url --keystore $keystore --broadcast -vvvv
fi
