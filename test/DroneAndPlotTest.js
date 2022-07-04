const DroneToken = artifacts.require("DroneToken");
const PlotToken = artifacts.require("PlotToken");
const assert = require("chai").assert;

contract("Tests", (accounts) => {
    var droneInstance;
    var plotInstance;

    describe('DroneToken', async() => {
        beforeEach(async() => {
            droneInstance = await DroneToken.new("Drone","DRON");
        });

        it('Should be create a drone token', async() => {
            await droneInstance.mint(accounts[0], 10, 50, 15, 1);
            assert.notEqual(await droneInstance.getLastDroneTokenId(), 0, 'The drone id should be not equal than 0');
            assert.equal(await droneInstance.getMinimumHeight(1), 10, 'The minimum hight should be 10');
            assert.equal(await droneInstance.getMaximumHeight(1), 50, 'The maximum hight should be 50');
            assert.equal(await droneInstance.getCost(1), 15, 'The cost should be 15');
            assert.equal(await droneInstance.getPesticide(1), 1, 'The pesticide should be 1');
        });
    });

    describe('PlotToken', async() => {
        beforeEach(async() => {
            plotInstance = await PlotToken.new("Plot","PLOT");
        });

        it('Should be create a plot token ', async() => {
            await plotInstance.mint(accounts[0], 5, 60, 1);
            assert.notEqual(await plotInstance.getLastPlotTokenId(), 0, 'The plot id should be not equal than 0');
            assert.equal(await plotInstance.getMinimumHeightAllowed(1), 5, 'The minimum hight allowed should be 5');
            assert.equal(await plotInstance.getMaximumHeightAllowed(1), 60, 'The maximum hight allowed should be 60');
            assert.equal(await plotInstance.getAcceptedPesticide(1), 1, 'The pesticide accepted should be 1');
        });
    });
});