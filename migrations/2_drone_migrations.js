const droneToken = artifacts.require("DroneToken");

module.exports = function (deployer) {
    deployer.then(async () => {
        await deployer.deploy(droneToken,"Drone", "DRON");
    });
};