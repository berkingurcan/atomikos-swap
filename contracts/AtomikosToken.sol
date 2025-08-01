// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import { ERC20 } from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import { ERC20Permit } from "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol";
import { ERC20Burnable } from "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import { Ownable } from "openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title AtomikosToken
 * @dev ERC20 token with permit, burnable functionality and minting capabilities
 * @dev Total supply: 1,000,000,000 ATOMIKOS (1 billion tokens)
 * @dev Decimals: 18
 */
contract AtomikosToken is ERC20, ERC20Permit, ERC20Burnable, Ownable {
    uint256 public constant TOTAL_SUPPLY = 1_000_000_000 * 10**18; // 1 billion tokens

    /**
     * @dev Constructor that mints the total supply to the deployer
     * @param initialOwner The address that will become the owner of the contract
     */
    constructor(address initialOwner)
        ERC20("ATOMIKOS", "ATOMIKOS")
        ERC20Permit("ATOMIKOS")
        Ownable(initialOwner)
    {
        _mint(initialOwner, TOTAL_SUPPLY);
    }

    /**
     * @dev Allows the owner to mint additional tokens if needed
     * @param to The address to mint tokens to
     * @param amount The amount of tokens to mint
     */
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /**
     * @dev Returns the number of decimals used to get its user representation
     * @return The number of decimals (18)
     */
    function decimals() public pure override returns (uint8) {
        return 18;
    }
}
