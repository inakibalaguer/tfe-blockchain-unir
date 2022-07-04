///
/// @title TFE Blockchain
/// @author Iñaki Balaguer Bañeras
/// @notice Blockchain-based drone plot fumigation system
///

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

///
/// @notice ERC721 Token Drone Smart Contract
///
contract DroneToken is ERC721, ERC721Enumerable, Ownable{ 

    struct attibutesDrone{
        uint256 minimumHeight;
        uint256 maximumHeight;
        uint256 cost;
        uint256 pesticide;
    }

    uint256 private lastDroneTokenId = 1;
    mapping(uint256 => attibutesDrone) public droneList;

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) Ownable(){

    }

    ///
    /// @notice Create a new drone
    ///
    event mintDrone (uint256 droneId, address to, address me);
    function mint(address _owner, uint256 _minimumHeight, uint256 _maximumHeight, uint256 _cost, uint256 _pesticide)  public returns (uint256 result)     {
        uint256 droneId = getLastDroneTokenId();

        droneList[droneId].pesticide = _pesticide;
        droneList[droneId].minimumHeight = _minimumHeight;
        droneList[droneId].maximumHeight = _maximumHeight;
        droneList[droneId].cost = _cost;
        
        emit mintDrone(droneId, _owner, msg.sender); 
        super._mint(_owner, droneId);  
        setLastDroneTokenId();           

        return droneId;
    }

    ///
    /// @notice Additional functions
    ///
    function setLastDroneTokenId() public {
       lastDroneTokenId = lastDroneTokenId + 1;
    }

    function getLastDroneTokenId() public view returns (uint256 result) {
        return lastDroneTokenId;
    }

    function getMinimumHeight(uint256 droneId) public view returns (uint256 minimumHeight) {
        return (droneList[droneId].minimumHeight);
    }

    function getMaximumHeight(uint256 droneId) public view returns (uint256 maximumHeight) {
        return (droneList[droneId].maximumHeight);
    }

    function getCost(uint256 droneId) public view returns (uint256 cost) {
        return (droneList[droneId].cost);
    }

    function getPesticide(uint256 droneId) public view returns (uint256 pesticide) {
        return (droneList[droneId].pesticide);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable){
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}