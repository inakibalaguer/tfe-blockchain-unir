///
/// @title TFE Blockchain
/// @author Iñaki Balaguer Bañeras
/// @notice Blockchain-based drone plot fumigation system
///

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./FumigationToken.sol";
import "./DroneToken.sol";
import "./PlotToken.sol";
import "./Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

///
/// @notice Fumigation Smart Contract
///
contract Fumigation is Ownable {

    struct atributtesFumigation{
        uint256 droneId;
        uint256 plotId;
    }

    DroneToken drone;
    PlotToken plot;

    uint256 private lastFumigationId = 1;
    mapping(uint256  => atributtesFumigation) public fumigationList;

    constructor(address _addressTokenDrone, address _addressTokenPlot)  {
        
        drone = DroneToken(_addressTokenDrone);
        plot = PlotToken(_addressTokenPlot);

    }

    ///
    /// @notice Create a new drone
    ///
    function newDrone(address _owner, uint256 _minimumHeight, uint256 _maximumHeight, uint256 _cost, uint256 _pesticide) external returns(uint256) {  
        require (drone.owner() == _owner, string(abi.encodePacked("Sender should be the owner of the drone. Owner: ", addressToString(drone.owner()),". Sender: ", addressToString(_owner))));
        require(_minimumHeight < _maximumHeight, "Inconsistend entered height data.");
        uint256 newDroneId = drone.mint(_owner, _minimumHeight, _maximumHeight, _cost, _pesticide);

        return newDroneId;
    }
  
    ///
    /// @notice Create a new plot
    ///
    function newPlot(address _owner, uint256 _minimumHeightAllowed, uint256 _maximumHeightAllowed, uint256 _acceptedPesticide) external returns(uint256 result) {  
        require (plot.owner() == _owner, string(abi.encodePacked("Sender should be the owner of the plot. Owner: ", addressToString(plot.owner()),". Sender: ", addressToString(_owner))));
        //require (_owner == msg.sender, string(abi.encodePacked("Sender should be the owner of the plot. Owner: ", addressToString(_owner),". Sender: ", addressToString(msg.sender))));
        require(_minimumHeightAllowed < _maximumHeightAllowed, "Inconsistent entered allowable height data.");
        uint256 newPlotId = plot.mint(_owner, _minimumHeightAllowed, _maximumHeightAllowed, _acceptedPesticide);

        return newPlotId;
    }

    ///
    /// @notice Create a new fumigation
    ///
    event newFumigationEvent(address owner, uint256  droneId, uint256 plotId);
    function newFumigation (uint256 _droneId, uint256 _plotId) external returns (bool result) {
		bool fumigationAllowed = fumigationValidation(_droneId, _plotId);
        require (fumigationAllowed == true, "Fumigation not validated, check the parameterization of the drone and/or plot.");
        
        uint256 fumigationId = getLastFumigationId();

        fumigationList[fumigationId].droneId = _droneId;
        fumigationList[fumigationId].plotId = _plotId;  
        emit newFumigationEvent(msg.sender, _droneId, _plotId);

        setLastFumigationId();

        return true;
    }

    ///
    /// @notice Drone and plot compatibility validations
    ///
    function fumigationValidation (uint256 _droneId, uint256 _plotId) public view returns (bool result) {
		bool fumigationAllowed = true;

        if (drone.getMinimumHeight(_droneId) < plot.getMinimumHeightAllowed(_plotId)){
			fumigationAllowed = false;
		}
		if (drone.getMaximumHeight(_droneId) > plot.getMaximumHeightAllowed(_plotId)){
			fumigationAllowed = false;
		}

        if (drone.getPesticide(_droneId) != plot.getAcceptedPesticide(_plotId)) {
            fumigationAllowed = false;
        }
            
        return fumigationAllowed;
    }

    ///
    /// @notice Calculate fumigation cost
    ///
    function fumigationCost (uint256 _droneId, uint256 _plotId) external view returns (uint256 result) {
        uint256 flightFactor = (_droneId + _plotId);

        return (drone.getCost(_droneId) * flightFactor);
    }

    ///
    /// @notice Additional functions
    ///
	function infoDrone(uint256 droneId)  external view returns (uint256 _minimumHeight, uint256 _maximumHeight, uint256 _cost, uint256 _pesticide)	{
		return (drone.getMinimumHeight(droneId), drone.getMaximumHeight(droneId), drone.getCost(droneId), drone.getPesticide(droneId));
	}

	function infoPlot(uint256 plotId) external view returns (uint256 _minimumHeightAllowed, uint256 _maximumHeightAllowed, uint256 _acceptedPesticide) {
		return (plot.getMinimumHeightAllowed(plotId), plot.getMaximumHeightAllowed(plotId), plot.getAcceptedPesticide(plotId));
	}

    function getTotalDrones() external view returns(uint256 numTotalDrones)  {
        return (drone.getLastDroneTokenId());
    }

    function getTotalPlots() external view returns(uint256 numTotalPlots)  {
        return (plot.getLastPlotTokenId());
    }

    function setLastFumigationId() public {
       lastFumigationId = lastFumigationId + 1;
    }

    function getLastFumigationId() public view returns (uint256 result) {
        return lastFumigationId;
    }

    function infoFumigation(uint256 fumigationId) external view returns (uint256 _droneId, uint256 _plotId, uint256 _pesticide, uint256 _cost) {
		uint256 droneId = fumigationList[fumigationId].droneId;
        uint256 plotId = fumigationList[fumigationId].plotId;
        uint256 pesticide = drone.getPesticide(droneId);
        uint256 cost = drone.getCost(droneId) * (droneId + plotId);

		return (droneId, plotId, pesticide, cost);
	}

    function addressToString(address _address) internal pure returns(string memory) {
        bytes32 _bytes = bytes32(uint256(uint160(_address)));
        bytes memory HEX = "0123456789abcdef";
        bytes memory _string = new bytes(42);
        _string[0] = '0';
        _string[1] = 'x';
            for(uint i = 0; i < 20; i++) {
                _string[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
                _string[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
            }

        return string(_string);
    }
}