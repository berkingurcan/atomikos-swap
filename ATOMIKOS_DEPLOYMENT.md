# ATOMIKOS Token Deployment Guide

This guide explains how to deploy the ATOMIKOS token to both Sepolia testnet and Monad testnet.

## Token Details

- **Name**: ATOMIKOS
- **Symbol**: ATOMIKOS
- **Decimals**: 18
- **Total Supply**: 1,000,000,000 ATOMIKOS (1 billion tokens)
- **Features**: 
  - ERC20 standard compliance
  - ERC20Permit (gasless approvals)
  - Burnable functionality
  - Mintable by owner
  - Ownable (initial owner receives all tokens)

## Prerequisites

1. **Foundry installed**: Make sure you have Foundry installed on your system
2. **Private Key**: Have your deployer private key ready
3. **Environment Variables**: Set up the required environment variables

## Environment Variables Setup

### Method 1: Using .env file (Recommended)

1. **Copy the example file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit the .env file with your actual values:**
   ```bash
   # Required for all deployments
   DEPLOYER_ADDRESS=0x...      # Your deployer wallet address
   DEPLOYER_PRIVATE_KEY=...    # Your private key (without 0x prefix)
   ```

### Method 2: Manual environment variables
```bash
export DEPLOYER_ADDRESS="0x..."      # Your deployer wallet address
export DEPLOYER_PRIVATE_KEY="..."    # Your private key (without 0x prefix)
```

## Deployment Instructions

### Option 1: Using Shell Scripts with .env file (Recommended)

1. **Set up your environment:**
   ```bash
   cp .env.example .env
   # Edit .env with your actual values
   ```

2. **Deploy to Sepolia Testnet:**
   ```bash
   ./scripts/deploy-atomikos-sepolia.sh
   ```

3. **Deploy to Monad Testnet:**
   ```bash
   ./scripts/deploy-atomikos-monad.sh
   ```

The scripts will automatically load variables from your `.env` file.

### Option 2: Using Forge Commands Directly

#### Deploy to Sepolia:
```bash
forge script script/DeployAtomikosToken.s.sol:DeployAtomikosToken \
    --rpc-url sepolia \
    --private-key $DEPLOYER_PRIVATE_KEY \
    --broadcast \
    -vvvv
```

#### Deploy to Monad Testnet:
```bash
forge script script/DeployAtomikosToken.s.sol:DeployAtomikosToken \
    --rpc-url monad_testnet \
    --private-key $DEPLOYER_PRIVATE_KEY \
    --broadcast \
    --legacy \
    -vvvv
```

## Network Information

### Sepolia Testnet
- **Chain ID**: 11155111
- **RPC URL**: https://ethereum-sepolia-rpc.publicnode.com (public RPC)
- **Block Explorer**: https://sepolia.etherscan.io/
- **Faucet**: https://sepoliafaucet.com/

### Monad Testnet
- **Chain ID**: 10143
- **RPC URL**: https://testnet1.monad.xyz
- **Explorer**: Not available yet
- **Faucet**: Check Monad documentation

## After Deployment

1. **Save the Contract Address**: The deployment script will output the deployed contract address
2. **Test the Token**: 
   - Check balance of deployer address
   - Test basic ERC20 functions
   - Verify permit functionality if needed
3. **Block Explorer**: You can view your deployed contract on the respective network's block explorer

## Troubleshooting

### Common Issues:

1. **"DEPLOYER_ADDRESS environment variable is not set"**
   - Make sure you've set DEPLOYER_ADDRESS in your `.env` file
   - Or export the variable manually: `export DEPLOYER_ADDRESS="0x..."`

2. **"DEPLOYER_PRIVATE_KEY environment variable is not set"**
   - Set your private key in the `.env` file (without 0x prefix)
   - Be careful with security - never commit your actual `.env` file!

3. **".env file not found" warning**
   - Copy `.env.example` to `.env`: `cp .env.example .env`
   - Fill in your actual values in the `.env` file

4. **"insufficient funds for gas"**
   - Make sure your deployer address has enough ETH for gas fees

5. **RPC connection issues**
   - The scripts use public RPC endpoints by default
   - If you experience issues, try setting custom RPC URLs in your `.env` file
   - Verify network connectivity

6. **Need to verify contract manually**
   - Use the respective block explorer's verification interface
   - Make sure to use the correct compiler version (0.8.23) and optimization settings

## Security Notes

- **Never share your private key**
- **Use `.env` file for environment variables, never hardcode keys**
- **Never commit your actual `.env` file to version control** (it's in `.gitignore`)
- **Test on testnets before mainnet deployment**
- **Keep your `.env` file secure and backed up safely**

## Contract Interaction

After deployment, you can interact with the contract using:

```javascript
// Basic ERC20 functions
balanceOf(address)
transfer(address, uint256)
approve(address, uint256)
transferFrom(address, address, uint256)

// Additional functions
mint(address, uint256)  // Only owner
burn(uint256)           // Token holder can burn their tokens
permit(...)             // Gasless approvals
```

## Support

If you encounter issues:
1. Check the Foundry documentation
2. Review the contract source code
3. Verify all environment variables are set correctly
4. Check network status and gas prices
