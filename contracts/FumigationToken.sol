///
/// @title TFE Blockchain
/// @author Iñaki Balaguer Bañeras
/// @notice Blockchain-based drone plot fumigation system
///

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

///
/// @notice ERC20 Token Fumigation Smart Contract
///
contract FumigationToken is ERC20{ 

    constructor() ERC20("FumigationToken", "FUMI") {
        _mint(msg.sender, 10000000000000000000000000000000000);
    }
}
