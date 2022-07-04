///
/// @title TFE Blockchain
/// @author Iñaki Balaguer Bañeras
/// @notice Blockchain-based drone plot fumigation system
///

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

///
/// @notice Ownable Smart Contract
///
contract Ownable {
    address public owner;

    constructor()  {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender == owner)
            _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0),"Incorrect address!");
        owner = newOwner;
    }
}