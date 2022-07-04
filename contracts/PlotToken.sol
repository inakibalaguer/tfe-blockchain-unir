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
/// @notice ERC721 Token Plot Smart Contract
///
contract PlotToken is ERC721, ERC721Enumerable, Ownable{ 

    struct attributesPlot {   
        uint256 minimumHeightAllowed;
        uint256 maximumHeightAllowed;
        uint256 acceptedPesticide;
    }
    
    uint256 private lastPlotTokenId = 1;
    mapping(uint256 => attributesPlot) public plotList;
 
    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) Ownable() {

    }

    ///
    /// @notice Create a new plot
    ///
    event mintPlote (uint256 plotId, address to, address me);
    function mint(address _owner, uint256 _minimumHeightAllowed, uint256 _maximumHeightAllowed, uint256 _acceptedPesticide)  public returns (uint256 result)     {
        uint256 plotId = getLastPlotTokenId();

        plotList[plotId].minimumHeightAllowed = _minimumHeightAllowed;
        plotList[plotId].maximumHeightAllowed = _maximumHeightAllowed;
        plotList[plotId].acceptedPesticide = _acceptedPesticide;

        emit mintPlote(plotId, _owner, msg.sender); 
        super._mint(_owner, plotId);             
        setLastPlotTokenId(); 

        return plotId;
    }

    ///
    /// @notice Additional functions
    ///
    function setLastPlotTokenId() public {
       lastPlotTokenId = lastPlotTokenId + 1;
    }

    function getLastPlotTokenId() public view returns (uint256) {
        return lastPlotTokenId;
    }

    function getMinimumHeightAllowed(uint256 plotId) public view returns (uint256) {
        return (plotList[plotId].minimumHeightAllowed);
    }

    function getMaximumHeightAllowed(uint256 plotId) public view returns (uint256) {
        return (plotList[plotId].maximumHeightAllowed);
    }

    function getAcceptedPesticide(uint256 plotId) public view returns (uint256 acceptedPesticide) {
        return (plotList[plotId].acceptedPesticide);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable){ 
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}